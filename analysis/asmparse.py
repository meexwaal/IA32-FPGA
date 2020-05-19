# Some details pulled from the very helpful www.c-jump.com/CIS77/CPU/x86/
import asm

class UnknownOpcode(Exception):
    pass

# ISR 2-5
modrm16_base = ["%bx,%si","%bx,%di","%bp,%si","%bp,%di","%si","%di","%bp","%bx"]

# ISR 2-6
r8 = ["%al","%cl","%dl","%bl","%ah","%ch","%dh","%bh"]
r16 = ["%ax","%cx","%dx","%bx","%sp","%bp","%si","%di"]
r32 = ["%eax","%ecx","%edx","%ebx","%esp","%ebp","%esi","%edi"]

# ISR B-4
segs = ["%es","%cs","%ss","%ds","%fs","%gs", None, None]

# Opcodes that use the "standard" 2-argument, 6-bit form
# The two args are encoded by the mod R/M byte
# The two bits omitted are {direction, size}
standard_2arg_6b = {
    0x00:"add",
    0x10:"adc",
    0x18:"sbb",
    0x28:"sub",
}

# Opcodes that use the "standard" 5-bit form
# The lower three bits are used to encode the target 32-bit register
standard_5b = {
    0x50:"push",
}

# Opcodes that use the "standard" 2-argument, 7-bit form
# The two args are encoded by the mod R/M byte
# The one bits omitted is {size}
standard_2arg_7b = {
    0x86:"xchg",
}

# Opcodes that take no arguments
standard_0arg = {
    0xFA:"cli",
    0xCF:"iret",
}

# Opcodes that take a 32-bit immediate value
standard_imm32 = {
    0x68:"push", # note: 6a is 8-bit
}

# Get the value of a little endian series of bytes
def little_endian(bs):
    acc = 0
    for i in range(len(bs)):
        acc += (256 ** i) * bs[i]

    # TODO negative
    hi_limit = 256**len(bs)
    intmax = hi_limit // 2 - 1
    if acc > intmax:
        acc -= hi_limit

    return hex(acc)

# Turn a series of bytes into their string constant representation
# e.g. $0x0
def constant(bs):
    return "$" + little_endian(bs)

def safe_idx(arr, idx):
    if idx < len(arr):
        return arr[idx]
    else:
        return None

# Parse everything following the opcode
# Returns a dictionary
def parse_modrm(bs, flags):
    ret = {}

    if len(bs) == 0:
        return None

    RM_START = 0
    RM_LEN = 3
    REG_START = 3
    REG_LEN = 3
    MOD_START = 6
    MOD_LEN = 2

    modrm = bs[0]

    rm = (modrm >> RM_START) & (2 ** RM_LEN - 1)
    reg = (modrm >> REG_START) & (2 ** REG_LEN - 1)
    mod = (modrm >> MOD_START) & (2 ** MOD_LEN - 1)

    ret['rm_bits'] = rm
    ret['reg_bits'] = reg
    ret['mod_bits'] = mod

    ret['digit'] = reg

    ret['plain_reg32'] = r32[reg]
    ret['plain_reg16'] = r16[reg]
    ret['plain_reg8'] = r8[reg]

    # TODO in all: handle [--][--] etc

    addr_regs = (r16 if flags["16b_addr"] else r32)

    if mod == 0b00:
        if flags["16b_addr"]:
            pass
        else:
            if rm == 0b101:
                # disp32
                ret['len'] = 5
                if len(bs) < ret['len']:
                    return None
                disp32 = little_endian(bs[1:1+4])
                ret['rm_name'] = f"{disp32}"
            elif rm == 0b100:
                # [--][--]
                pass
            else:
                # (reg)
                ret['len'] = 1
                if len(bs) < ret['len']:
                    return None
                base_reg = addr_regs[rm]
                ret['rm_name'] = f"({base_reg})"

    elif mod == 0b01:
        # disp8(reg)
        ret['len'] = 2
        if len(bs) < ret['len']:
            return None
        disp8 = little_endian(bs[1:1+1])

        if flags["16b_addr"]:
            base_reg = modrm16_base[rm]
        else:
            base_reg = addr_regs[rm]

        ret['rm_name'] = f"{disp8}({base_reg})"

    elif mod == 0b10:
        if flags["16b_addr"]:
            pass
        else:
            # disp32(reg)
            ret['len'] = 5
            if len(bs) < ret['len']:
                return None
            # TODO negative
            disp32 = little_endian(bs[1:1+4])
            base_reg = addr_regs[rm]
            ret['rm_name'] = f"{disp32}({base_reg})"

    elif mod == 0b11:
        # reg
        ret['len'] = 1
        if len(bs) < ret['len']:
            return None

        ret['rm_name'] = addr_regs[rm]
        ret['rm_name16'] = r16[rm]
        ret['rm_name8'] = r8[rm]

    else:
        exit("Bad mod")

    if 'rm_name8' not in ret:
        ret['rm_name8'] = ret['rm_name']
    if 'rm_name16' not in ret:
        ret['rm_name16'] = ret['rm_name']

    return ret

# Parse an encoding for a prefix
# Returns (prefix_string, flags, remainder), where:
# prefix_string is the string which should be prepended to the result
# flags is a dictionary of flags used for further parsing
# remainder is the encoding with any prefixes stripped off
def parse_prefix(enc):
    strs = []
    flags = {"16b_addr":False}

    for i in range(len(enc)):
        b = enc[i]

        # Decode prefix
        if b == 0xF0:
            strs.append("lock")
            continue
        elif b == 0xF2:
            strs.append("repnz")
            continue
        elif b == 0xF3:
            # TODO REP/REPE?
            continue
        elif b in [0x2E, 0x36, 0x3E, 0x26, 0x64, 0x65]:
            # TODO segment override
            continue
        elif b == 0x66:
            # TODO Operand override
            continue
        elif b == 0x67:
            # Address override
            assert(not flags["16b_addr"])
            flags["16b_addr"] = True

            continue
        else:
            ret = " ".join(strs)
            return (ret, flags, enc[i:len(enc)])

# Parse an instruction encoded by an array of bytes
# Returns a string representation of the parsed instruction
def parse(enc):
    (prefix, flags, inst) = parse_prefix(enc)
    if len(prefix) > 0:
        prefixstr = prefix + " "
    else:
        prefixstr = ""


    op = safe_idx(inst, 0)
    if op != 0x0F:
        # One-byte op-code

        pargs = parse_modrm(inst[1:len(inst)], flags)
        # 0 for 8-bit, 1 for 32-/16-bit
        s = bool(op & 0x01)
        # For some, the size is in bit 3
        s3 = bool(op & 0x08)

        # 0 = dest is r/m
        # 1 = dest is reg
        d = bool(op & 0x02)

        op7b = op & 0xFE
        op6b = op & 0xFC
        op5b = op & 0xF8

        opreg = op & 0x7

        opstr = ""
        args = ""

        # Opcode and ensuing translation
        if op6b in standard_2arg_6b:
            opstr = standard_2arg_6b[op6b]

            plain_reg = pargs['plain_reg32' if s else 'plain_reg8']
            rm_name = pargs['rm_name' if s else 'rm_name8']

            dst = (plain_reg if d else rm_name)
            src = (rm_name if d else plain_reg)
            args = f"{src},{dst}"

        elif op7b in standard_2arg_7b:
            opstr = standard_2arg_7b[op7b]

            dst = pargs['plain_reg32' if s else 'plain_reg8']
            src = pargs['rm_name' if s else 'rm_name8']

            args = f"{src},{dst}"

        elif op6b == 0x80:
            digit = pargs['digit']
            if digit == 0:
                opstr = "add"
            elif digit == 5:
                opstr = "sub"
            else:
                raise Exception("bad digit")

            rm_name = pargs['rm_name' if s else 'rm_name8']

            # Is the size 32? Kind of a weird way to encode it here
            imm_size32 = (s != bool(op & 0x02))
            imm_bytes = 4 if imm_size32 else 1
            imm_start = 1 + pargs['len']
            imm = constant(inst[imm_start:imm_start+imm_bytes])

            args = f"{imm},{rm_name}"

        elif op7b == 0xFE:
            digit = pargs['digit']
            # Inc/dec, based on /digit
            if digit == 0:
                opstr = "inc"
            elif digit == 1:
                opstr = "dec"
            else:
                raise Exception("bad digit")

            opstr += "l" if s else "b"
            args = pargs['rm_name' if s else 'rm_name8']

        elif op7b == 0xE4:
            opstr = "in"
            imm8 = constant(inst[1:1+1])
            rd = (r32 if s else r8)[0]
            args = f"{imm8},{rd}"

        elif op == 0xE8:
            opstr = "call"
            imm32 = constant(inst[1:1+4]) # + 1 + 4 + PC
            args = f"{imm32}"

        elif op == 0xEB:
            opstr = "jmp"
            imm8 = constant(inst[1:1+1]) # + 1 + 1 + PC
            args = f"{imm8}"

        elif op7b == 0x2C:
            opstr = "sub"
            rd = (r32 if s else r8)[0] # eax
            imm_bytes = 4 if s else 1
            imm = constant(inst[1:imm_bytes+1])
            args = f"{imm},{rd}"

        elif op6b == 0x88:
            opstr = "mov"

            plain_reg = pargs['plain_reg32' if s else 'plain_reg8']
            rm_name = pargs['rm_name' if s else 'rm_name8']

            dst = (plain_reg if d else rm_name)
            src = (rm_name if d else plain_reg)
            args = f"{src},{dst}"

        elif op == 0x8C or op == 0x8E:
            opstr = "mov" # to/from segment register

            # TODO should always be 16b
            sreg = segs[pargs['reg_bits']]
            rm_name = pargs['rm_name']

            dst = (sreg if d else rm_name)
            src = (rm_name if d else sreg)
            args = f"{src},{dst}"

        elif op5b == 0xB8:
            # Mov imm to reg in lower 3 of op
            opstr = "mov"

            imm32 = constant(inst[1:1+4])
            rd = (r32 if s3 else r8)[opreg]
            args = f"{imm32},{rd}"

        elif op5b in standard_5b:
            opstr = standard_5b[op5b]
            reg = r32[opreg]
            args = f"{reg}"

        elif op in standard_0arg:
            opstr = standard_0arg[op]
            args = ""

        elif op in standard_imm32:
            opstr = standard_imm32[op]
            imm32 = constant(inst[1:1+4])
            args = f"{imm32}"

        elif op == 0x8D:
            opstr = "lea"

            dst = pargs['plain_reg32' if s else 'plain_reg8']
            src = pargs['rm_name' if s else 'rm_name8']

            args = f"{src},{dst}"

        else:
            raise UnknownOpcode(f"{hex(op)}")

    else: # op == 0x0F
        # Two-byte op-code

        op2 = safe_idx(inst, 1)
        pargs = parse_modrm(inst[2:len(inst)], flags)

        if op2 == 0x00:
            digit = pargs['digit']
            if digit == 3:
                opstr = "ltr"
            else:
                raise Exception("bad digit")

            src = pargs['rm_name16']
            args = f"{src}"

        else:
            raise UnknownOpcode(f"{hex(op)}")

    return f"{prefixstr}{opstr} {args}"

# Parse an instruction encoded by a string of space-separated hex bytes
# Returns a string representation of the parsed instruction
def strparse(str_enc):
    bs = str_enc.split(' ')
    assert(all([len(b) == 2 for b in bs]))

    es = [int(b,16) for b in bs]
    return parse(es)

def test_dec():
    for i in range(len(asm.instrs)):
        # Some instructions are a little wack; skip them
        if i in {20}:
            continue

        inst = asm.instrs[i]

        # More wack stuff
        if inst['enc'][0:2] in {'e8','eb'}:
            continue

        real_enc = f"{inst['name']} {inst['args']}"
        try:
            enc = strparse(inst["enc"])
        except UnknownOpcode as e:
            print(f"Unknown opcode {e} at index {i}")
            print(inst)
            return
        except:
            print(inst)
            raise
        else:
            if enc.strip() != real_enc.strip():
                print(f"Got {enc} instead of {real_enc} at index {i}")
                print(inst)
                return

    print("All correct")

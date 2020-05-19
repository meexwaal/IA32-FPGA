import re

fname = "k.dump"
instr_re = "^\s+([0-9a-f]+):\t(([0-9a-f]{2} ??)+) \s+\t(\w+)\s+(.*)$"

instrs = []
with open(fname, "r") as f:
    cur_fn = None
    for line in f:
        if (len(line) == 1 or   # newline
            line == "\t...\n"): # zeroes omitted
            continue

        # Change function name
        fnname = re.match("^[0-9a-f]+ <(.*)>:", line)
        if fnname:
            cur_fn = fnname.groups()[0]
            continue

        instr = re.match(instr_re, line)
        if instr:
            ig = instr.groups()
            instrs.append({"fn"   : cur_fn,
                           "addr" : ig[0],
                           "enc"  : ig[1],
                           "name" : ig[3],
                           "args" : ig[4]})


names = set([i["name"] for i in instrs])
# print(len(names))
# print(names)

# Longest common prefix
# strs : string list
def lcp(strs):
    if len(strs) == 0:
        return ""

    s0 = strs[0]

    for end_idx in range(0, len(s0)):
        c = s0[end_idx]
        if c == " ":
            continue

        if not all([end_idx < len(s) and s[end_idx] == c for s in strs]):
            return s0[0:end_idx]

    return s0

# for n in names:
#     print(n)
#     ins = [i for i in instrs if i["name"] == n]
#     print(len(ins))
#     print(lcp([i["enc"] for i in ins]))

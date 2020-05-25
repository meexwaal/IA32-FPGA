IA-32 FPGA

The goal of this project is to design enough of the hardware of an
IA-32 processor to run a simple operating system, with the intent of
eventually running on an FPGA. This project is the moral extension of
the work done in CMU's OS class, Operating System Design and
Implementation (15-605). For that class, we implemented a kernel for
the IA-32 architecture. This project explores the hardware
implementation of the architectural features we relied on to implement
our operating system. This processor, like our operating system, is
intended to be more of an educational experience than a useful
creation. This is an exercise in design, hardware implementation, and
supporting a complex specification (the x86 ISA). That being said,
this processor, like our operating system, is intended to be
well-featured and usable, though there are likely other options that
are better suited to practical purposes.

This project has several defined goals, of which none are "implement
a fully-featured IA-32 processor". Many simplifications will be made.
This chart defines the target level of implementation for various
features of the processor, loosely sorted by priority. Future work
could involve reducing the simplifications made, though I have no
plans to do this.
+---------------------------------+---------------------------------+
|              Goal               |            Non-Goal             |
+---------------------------------+---------------------------------+
|Support all x86 instructions used|This will not support every      |
|by our kernel and user programs. |instruction in the x86 ISA, nor  |
|                                 |every form of the instructions   |
|                                 |that are supported. All          |
|                                 |unsupported instructions should  |
|                                 |invoke the undefined opcode      |
|                                 |exception.                       |
+---------------------------------+---------------------------------+
|Support virtual memory (two-level|                                 |
|page table, memory protection,   |                                 |
|optional TLB).                   |                                 |
+---------------------------------+---------------------------------+
|Support exceptions and interrupts|Not all exception or interrupt   |
|changing execution flow and      |triggers will be implemented.    |
|privilege level.                 |                                 |
+---------------------------------+---------------------------------+
|Key hardware structures will be  |                                 |
|implemented. In particular, the  |                                 |
|programmable timer and, once on  |                                 |
|an FPGA, the display buffer, RAM |                                 |
|controller, and keyboard         |                                 |
|interface.                       |                                 |
+---------------------------------+---------------------------------+
|Support privilege checking on    |Most segment-related             |
|segment registers.               |functionality will not be        |
|                                 |implemented, especially bounds   |
|                                 |checking or a non-zero segment   |
|                                 |start.                           |
+---------------------------------+---------------------------------+
|Execution will ideally start at  |Significant simplifications will |
|the same address a real processor|be made to the boot process. If  |
|would begin at.                  |starting at the correct address  |
|                                 |causes problems, execution may   |
|                                 |begin at kernel_main() and some  |
|                                 |configuration will be hard-coded.|
+---------------------------------+---------------------------------+
|Synthesize the processor onto an |                                 |
|FPGA with video output, keyboard |                                 |
|input, and access to on-board    |                                 |
|RAM.                             |                                 |
+---------------------------------+---------------------------------+
|Reasonable performance will be   |Performance is generally not the |
|achieved once on the FPGA. For   |purpose of this project. The     |
|testing our OS we used the Simics|processor will be designed with  |
|full-system simulator; achieving |performance in mind, but the     |
|better performance than          |performance analysis and         |
|simulation is ideal.             |simulation that would go into    |
|                                 |designing performant hardware    |
|                                 |will generally be omitted from   |
|                                 |this project.                    |
+---------------------------------+---------------------------------+


Language

The hardware is primarily written in VHDL, largely as a way to learn
the language. My past experience is entirely in SystemVerilog, so if
my VHDL style is non-standard, I apologize.

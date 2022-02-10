# PIC16 Development Resources

1. *Makefile* - Generic xc8-cc makefile for PICs
    - Step 1: Compile to p-code(.p1) without linking: `xc8-cc -mcpu=<devID> -c <src.c>`
    - Step 2: Link p-code files into final binary(.elf): `xc8-cc -mcpu=<devID> <src.p1>`<br>
        Note: You can call the linker directly with: `hlink`


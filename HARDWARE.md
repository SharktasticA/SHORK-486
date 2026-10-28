# Hardware supported by SHORK 486 & 586

## CPUs

SHORK 486/586 CPU support depends on the target architecture selected when running the Build Configurator, of which there are five options based on their respective Linux kernel configuration symbols. Any given choice also supports the CPUs of the options listed below it, though lacking optimisation. If in doubt, selecting "486SX" is the safe, universal choice.

* SHORK 486
    * `486SX`
        * For 486s without an FPU. This is the only option that includes x87 math emulation support.
        * Supports at least Intel 486SX/SX-S/SX2; AMD Am486SX/SX2; Cyrix Cx486DLC, Cx486DRx2, Cx486S, Cx486SLC/SLC2, Cx486SRx2; IBM 486BL/BL2/BL3, 486SLC/SLC2/SLC3.
    * `486DX`
        * For 486s with an FPU. It sheds x87 math emulation support for a slightly smaller kernel.
        * Supports at least Intel 486DX/DX2/DX4, 486SL, RapidCAD; AMD Am486DE2, Am486DX/DX2/DX4; Cyrix Cx486DX/DX2/DX4; the above when paired with a compatible coprocessor.
* SHORK 586
    * `586`
        * For any TSC-less 586s, TSC-hidden 586s, and 486-586 'in-betweens'. It does not assume the RDTSC instruction is present, useful for CPUs without it or with CPUIDs that don't expose the feature automatically.
        * Supports at least AMD K5; Cyrix 5x86, 6x86/6x86L/6x86MX; IBM 5x86C.
    * `586TSC`
        * For 586s with TSC register and RDTSC instruction.
        * Supports at least Intel Pentium, Pentium OverDrive.
    * `586MMX`
        * For 586s with TSC register, RDTSC instruction and MMX support.
        * Supports at least Intel Pentium MMX, Pentium OverDrive MMX, or newer.

## System architecture & buses

### ISA, VLB & PCI

SHORK 486/586 natively supports the ISA and PCI buses, and works with VLB cards.

### MCA

SHORK 486/586 does not explicitly support the MCA bus, though it can still technically run on MCA-based PCs. MCA bus support and MCA-specific drivers were removed in Linux 3.5, and the SHORK project has yet to restore these (though it is an eventual goal). Any display card with at least a VGA-compatible core, and any storage controller that presents a standard ATA/IDE interface (including McIDE), should work. However, MCA ESDI, SCSI, networking, and sound cards are not supported at this time.

### PCMCIA

SHORK 486/586 can support 16-bit PC Card or 32-bit CardBus, but it requires loading one of the available bridge drivers (see [DRIVERS.md](DRIVERS.md)).

## Graphics

MDA, CGA, EGA, VGA and compatible display cards for the ISA, MCA, VLB or PCI buses are supported for simple text console usage. SHORK 486/586 can be built with two framebuffer drivers that have specific needs:

* `vga16fb`
    * Intended for an EGA-/VGA-compatible ISA, MCA, VLB or PCI display card.
    * Enabled with the "force vga16fb" option in `shorkset` -> Drivers -> Framebuffers.
* `vesafb`
    * Requires a VBE2+ PCI display card
    * Enable by selecting a VBE-style resolution in `shorkset` -> Display resolution.

## Networking

SHORK 486/586 supports various ISA, PCI and PCMCIA networking cards (see [DRIVERS.md](DRIVERS.md)).

## Sound

SHORK 486/586 supports various ISA and PCI sound cards (see [DRIVERS.md](DRIVERS.md)) and simple PC speaker.

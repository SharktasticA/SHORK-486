# Hardware supported by SHORK 486 & 586

## CPUs

SHORK 486/586 CPU support depends on the target architecture selected when running the Build Configurator, of which there are five options named after the Linux kernel configuration symbols. Any given choice also supports the CPUs of the choices listed under it, though it may not be optimised for them. If in doubt, selecting "486SX" is the safe, universal choice.

* SHORK 486
    * `486SX`: Intel 486SX/SX-S/SX2; AMD Am486SX/SX2; Cyrix Cx486DLC, Cx486DRx2, Cx486S, Cx486SLC/SLC2, Cx486SRx2; IBM 486BL/BL2/BL3, 486SLC/SLC2/SLC3
    * `486DX`: Intel 486DX/DX2/DX4, 486SL, RapidCAD; AMD Am486DE2, Am486/DX/DX2/DX4; Cyrix Cx486DX/DX2/DX4; the above when paired with a compatible coprocessor
* SHORK 586
    * `586`: AMD K5; Cyrix 5x86, 6x86/6x86L/6x86MX; IBM 5x86C
    * `586TSC`: Intel Pentium, Pentium OverDrive
    * `586MMX`: Intel Pentium MMX, Pentium OverDrive MMX

## Graphics

MDA, CGA, EGA, VGA and compatible display cards for the ISA, MCA, VLB or PCI buses are supported for simple text console usage. SHORK 486/586 can be built with two framebuffer drivers that have specific needs:

* `vga16fb`: EGA-/VGA-compatible ISA, MCA, VLB or PCI display cards
* `vesafb`: VBE2+ PCI display cards

## Networking

SHORK 486/586 supports various ISA, PCI and PCMCIA networking cards (see [DRIVERS.md](DRIVERS.md)).

## Sound

SHORK 486/586 supports various ISA and PCI sound cards (see [DRIVERS.md](DRIVERS.md)) and simple PC speaker.

## PCMCIA bridges

SHORK 486/586 supports various PCMCIA bridges (see [DRIVERS.md](DRIVERS.md)).

## Regarding MCA

SHORK 486/586 does not explicitly support the MCA bus, though it can still technically run on MCA-bused PCs. MCA bus support and MCA-specific drivers were removed in Linux 3.5, and the SHORK project has yet to restore these (though it is an eventual goal). Any display adapter with at least a VGA-compatible core, and any storage controller that presents a standard ATA/IDE interface, should work. Networking and sound cards are not supported.

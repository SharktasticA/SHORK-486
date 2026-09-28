# Running SHORK 486

## Real hardware

(Coming soon)

## 86Box

86Box aims to provide accurate emulation and a good selection of old x86 hardware, which may be useful for validating SHORK 486 on certain hardware before you run it on the real versions. However, networking on a Linux host does not presently work. Below is a suggested configuration to try with 86Box VM Manager to get started, though I recommend having some fun experimenting with other options as well.

* Machine
    * **Machine type:** [1994] i486 (Socket 3 PCI)
    * **Machine:** [i420EX] Intel Classic/PCI
    * **CPU type:** any option
    * **Frequency:** any option
    * **FPU:** any option
    * **Memory:** 32MB (covers all variants) or refer to the README or after-build report
* Display
    * **Video:** [ISA] IBM VGA (typical) or [PCI] 3dfx Voodoo3 3000 (trying SHORKGUI)
* Input
    * **Keyboard:** PS/2 Keyboard
    * **Mouse:** PS/2 Mouse
* Sound
    * **Sound card 1:** [ISA16] Sound Blaster 16
* Storage controllers
    * **Floppy disk controller:** Internal device
    * Hard disk controllers
        * **Controller 1:** Internal device
* Hard disks
    * Existing...
        * **Cylinders/Heads/Sectors:** refer to after-build report for CHS geometry
        * **Bus:** IDE
        * **Channel:** 0:0
        * **Model:** any [Generic] should be fine
* Floppy & CD-ROM driver
    * Floppy drives
        * #1
            * **Type:** 3.5" 2.88M

## VMware Workstation

VMware Workstation virtualises more modern hardware, and SHORK 486 always runs far faster than it would on period-correct hardware. However, networking works fine. Below is a suggested configuration to use when creating a virtual machine.

* **Hardware compatibility:** any option
* **Install operating system from:** later
* **Guest Operating System:** Linux (Other Linux 6.x kernel)
* **Number of processers:** 1 (typical) or any (if enabled symmetric multiprocessing)
* **Number of cores per processor:** 1 (typical) or any (if enabled symmetric multiprocessing)
* **Memory:** 32MB (covers all variants) or refer to the README or after-build report
* **Network Connection:** any option (only NAT presently tested though)
* **I/O Controller Types:** BusLogic
* **Virtual Disk Type:** IDE
* **Disk:** Use an existing virtual disk
* Customize Hardware...
    * Add Floppy Drive
        * Untick "Connect at power on" unless testing SHORK DISKETTE

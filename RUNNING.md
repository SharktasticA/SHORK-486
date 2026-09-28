# Running SHORK 486

## Real hardware

(Coming soon)

## 86Box

86Box aims to provide accurate emulation and a good selection of old x86 hardware, which may be useful for validating SHORK 486 on certain hardware before you run it on the real versions. However, networking on a Linux host doesn't work yet. Below is a suggested configuration to try with 86Box VM Manager to get started, though I recommend having some fun experimenting with other options as well.

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
* Floppy & CD-ROM drives
    * Floppy drives
        * #1
            * **Type:** 3.5" 2.88M

## VirtualBox

VirtualBox will run SHORK 486 far faster than period-correct hardware, giving a false impression of its real performance. However, networking works fine. Below is a suggested configuration for creating a virtual machine.

* **OS:** Linux
* **OS Distribution:** Other Linux
* **OS Version:** Other Linux (32-bit)
* **Base Memory:** 32MB (covers all variants) or refer to the README or after-build report
* **Number of CPUs:** 1 (typical) or any (if enabled symmetric multiprocessing)
* Create a Virtual Machine Without a Virtual Disk
* Click "Settings" after the VM is created:
    * Motherboard
        * Pointing Device: PS/2 Mouse
    * Storage
        * Add I82078 Floppy
        * Controller: IDE
            * Add hard disk (select your `.vmdk` image)
    * Audio
        * **Audio Controller:** SoundBlaster 16
    * Network
        * Adapter 1
            * **Attached to:** NAT
            * **Adapter Type:** PCnet-PCI II (Am79C970A)
            * Tick "Virtual Cable Connected"

### Notes

* If during the "New Virtual Machine" process you selected "Use an Existing Virtual Hard Disk File", VirtualBox will create the virtual machine with a SATA controller for the disk. This is only supported by SHORK 486 Max or a custom build with SATA support enabled.
* For networking, load the "AMD PCnet32/PCnet-FAST III (PCI)" network interface driver.

## VMware Workstation

VMware Workstation will run SHORK 486 far faster than period-correct hardware, giving a false impression of its real performance. However, networking works fine. Below is a suggested configuration for creating a virtual machine.

* **Hardware compatibility:** any option
* **Install operating system from:** later
* **Guest Operating System:** Linux (Other Linux 6.x kernel)
* **Number of processers:** 1 (typical) or any (if enabled symmetric multiprocessing)
* **Number of cores per processor:** 1 (typical) or any (if enabled symmetric multiprocessing)
* **Memory:** 32MB (covers all variants) or refer to the README or after-build report
* **Network Connection:** any option (only NAT presently tested though)
* **I/O Controller Types:** BusLogic
* **Virtual Disk Type:** IDE
* **Disk:** Use an existing virtual disk (select your `.vmdk` image)
* Customize Hardware:
    * Add Floppy Drive
        * Untick "Connect at power on" unless testing SHORK DISKETTE

### Notes

* For networking, load the "AMD PCnet32/PCnet-FAST III (PCI)" network interface driver.
* The Ensoniq AudioPCI ES1371 is the default emulated audio device. This is supported by SHORK 486 built with sound support, but you can edit the VM's `.vmx` file to change it to a Sound Blaster 16 (`sound.virtualDev = "sb16"`) if you wish.

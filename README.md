# SHORK 486

Member of the SHORK family: **SHORK 486** | [SHORK DISKETTE](https://github.com/SharktasticA/SHORK-DISKETTE)

-----

SHORK 486 is an operating system for 486 and Pentium (P5) era vintage PCs. The aim is to produce a Linux distribution that is very lean and functional but still capable on such PCs, often with my '90s IBM ThinkPads in mind. A default SHORK 486 system aims to work with at least 16MiB system memory and take up no more than ~72MiB on the disk. Despite those constraints, the default SHORK 486 experience includes Linux kernel 7.0.0, many typical Linux commands, custom SHORK utilities such as shorkdir (TUI file browser) and shorkfetch (*fetch clone), a terminal multiplexer, a C compiler, an FTP, SCP and SSH client, a Git source control client, the ed, Mg (Emacs-style), nano and vi editors, IDE CD-ROM and DVD-ROM support, ISA, PCI and PCMCIA ethernet support, support for most major national keyboard layouts, and a cute ASCII shark welcome screen!

A build configurator is available to alter SHORK 486 to your liking. For example, you can select the "minimal" build type that requires just 8MiB RAM and ~16MiB disk space, whilst still including most typical commands as before, some custom SHORK utilities, and the ed and vi editors.  You can also select the "custom" build type, allowing you pick and choose specific software and features. Some people have expressed support for using SHORK 486 on newer hardware for a minimalist Linux environment - whilst SHORK 486 does not focus on such, options for enabling high memory, SATA, SMP and USB support are available if you so desire!

<p align="center"><img alt="A photo of SHORK 486 running on an IBM ThinkPad 365ED after a cold boot" src="photos/20260223_365ed.jpg" width="512"></p>

See [GALLERY](GALLERY.md) for more photos and screenshots!



## Introduction

### Origin & inspirations

In December 2025, [Action Retro](https://www.youtube.com/@ActionRetro) posted a [video on FLOPPINUX](https://www.youtube.com/watch?v=SiHZbnFrHOY), something that turned out to be a very accessible means for me to learn how to make a working Linux system. It foremost inspired me to chase my dream of building a viable modern Linux system for my old IBM ThinkPads. SHORK Mini (as it was originally known) began as an automated build script based on [FLOPPINUX](https://github.com/w84death/floppinux)'s build instructions, but adapted for producing fixed disk images instead of diskette images. After that, more Linux kernel and BusyBox features were enabled, and other software was compiled to help fulfil that dream. Other inspirations from similar efforts include [Gray386linux](https://github.com/marmolak/gray386linux) and [Ocawesome101's blog post](https://ocawesome101.github.io/486-linux.html) on running Linux on a 486SX. Aspects of Alpine Linux and Tiny Core are also kept in mind. 

### Architecture

SHORK 486 is not GNU/Linux as you may be accustomed to. Its init system and most core utilities are provided by BusyBox, a single-binary application well known for embedded usage. As needed, some util-linux and individual utilities are used to fill 'holes' in BusyBox's suite. The system is compiled with musl instead of glibc, producing smaller binaries that also use fewer resources. The closest well-known Linux distribution to SHORK 486 is Alpine Linux. 

### Goals

Besides being something fun to try on old PCs, SHORK 486 was founded on the belief that old PCs can still be useful to the right people, retrocomputing and gaming usage aside. SHORK 486 can be useful for lightweight desktop usage, SSH terminal usage, distraction-free typewriting, embedded applications, demonstrative use in academia/education, and as a technical demonstration of what old PCs and modern software targeted at them can actually still do! If it can save just one more PC from the landfills, it has done its job! 

### What's special

Depending on configuration, SHORK 486 requires between just 8-24MiB system memory while still packing a lot of functionality for its size. As of 2026, support for 486 in the Linux kernel is to be removed, and 32-bit x86 in general is being dropped by various mainstream distributions. System requirements are ever-increasing - even Micro Core and Tiny Core (otherwise excellent systems) require 26-46MB RAM, putting them out of range of many early 486 systems. Thus, SHORK 486 will try to fill this niche of a ready-to-go Linux distribution for such PCs!



## Capabilities

### BusyBox, util-linux, etc.

ar, arch, ascii, awk, basename, bc, beep, blkid, cal, cat, chmod, chown, chroot, chvt, clear, cp, crontab, cut, date, dc, dd, df, diff, dirname, dmesg, du, ed, eject, expand, expr, false, fdformat, fdisk, find, fold, free, ftpget, ftpput, grep, gzip, halt, head, hexdump, hostname, ifconfig, ip, kill, killall, less, ln, loadkmap, losetup, ls, lsblk, lspci, man, mdev, mkdir, mknod, mount, mountpoint, mv, nice, nohup, nproc, partprobe, partx, paste, patch, ping, pkill, pmap, printf, ps, pstree, pwd, readlink, rev, rm, rmdir, route, sed, seq, setfont, sfdisk, showkey, sleep, stat, strace, stty, swapoff, swapon, sync, tar, taskset, tee, telnet, test, top, touch, tr, traceroute, tree, true, truncate, udhcpc, umount, uname, unexpand, unzip, usleep, vi, volname, wc, wget, whereis, which, whoami, whois, xxd, xz, yes

### Bundled software

#### Default

* [file](https://github.com/file/file) (file identification)
* ftp (FTP client, [tnftp](https://ftp.netbsd.org/pub/NetBSD/misc/tnftp/))
* [git](https://git-scm.com/) (Git source control client)
* [htop](https://github.com/htop-dev) (interactive process viewer)
* [mg](https://github.com/troglobit/mg) (Emacs-style text editor)
* [nano](https://www.nano-editor.org) (text editor)
* scp (SCP client, [Dropbear](https://github.com/mkj/dropbear))
* ssh (SSH client, [Dropbear](https://github.com/mkj/dropbear))
* [tcc](https://bellard.org/tcc/) with [musl](https://musl.libc.org/) (C compiler)
* [tmux](https://github.com/tmux/tmux) (terminal multiplexer)

#### Optional

* [GCC with musl](https://musl.cc/)

    * as (assembler)
    * g++ (C++ compiler)
    * gcc (C compiler)
    * gfortran (Fortran compiler)

### SHORK Utilities (shorkutils)

* **[shorkdir](https://github.com/SharktasticA/shorkdir)** - Lightweight terminal-based file browser.
* **[shorkfetch](https://github.com/SharktasticA/shorkfetch)** - Displays basic system and environment information. Similar to fastfetch, neofetch, etc.
* **[shorkfont](https://github.com/SharktasticA/shorkfont)** - Changes the terminal's PSF font or colour. Takes two arguments (type of change and name); running it without an argument shows how to use and a list of possible colours.
* **[shorkhelp](https://github.com/SharktasticA/shorkhelp)** - Informs of SHORK 486's capabilities and provides guidance.
* **[shorkmap](https://github.com/SharktasticA/shorkmap)** - Changes the system's keyboard layout (keymap). Takes one argument (a keymap name); running it without an argument shows a list of possible keymaps.
* **[shorkoff](https://github.com/SharktasticA/shorkoff)** - A shutdown helper that safely brings the system to a controlled halt before a manual power off.
* **[shorkres](https://github.com/SharktasticA/shokres)** - Changes the system's display resolution (provided the hardware is compatible). Takes one argument (a resolution name); running it without an argument shows a list of possible resolution names.

### SHORK Entertainment (shorktainment)

* **[shorklocomotive](https://github.com/SharktasticA/shorklocomotive)** - A shark-themed take on [sl (Steam Locomotive)](https://github.com/mtoyoda/sl) that kindly pokes fun at making typos when trying to type `ls`. Available as `sl` and `shorklocomotive`.
* **[shorkmatrix](https://github.com/SharktasticA/shorkmatrix)** - A quick, blue-themed take on the [CMatrix](https://github.com/abishekvashok/cmatrix) "digital rain" vertical scrolling text screensaver. Available as `cmatrix` and `shorkmatrix`.
* **[shorksay](https://github.com/SharktasticA/shorksay)** - A shark-themed take on [cowsay](https://github.com/cowsay-org/cowsay), a "simple and silly" program that outputs an ASCII art shark and speech bubble containing a message of your choice. Available as `shorksay` and `cowsay`.



## Hardware requirements

### Processor

An **Intel 486SX or compatible** is the minimum processor requirement. Math emulation is enabled, so a 486DX or a separate FPU is not required, but are still supported and desireable. 

### RAM

**16MiB** and **24MiB** are the respective minimum and recommended system memory for a default SHORK 486 build. SHORK 486 can be built using the "minimal" build type option to reduce the RAM requirement to around 8MiB (extreme minimum) to 10MiB (realistic minimum). To help with such tight memory situations, SHORK 486 can also be built with a 1 to 64MiB swap partition, but note its use may be very slow to use on period-correct hardware.

### Storage

Without GUI enabled, SHORK 486 requires no more than a **~72MiB disk**. Using the "minimal" build type option and not including a swap partition will reduce this requirement to 16MiB. Potential options such as including GCC and SHORKGUI require an extra 215MiB and 46MiB, respectively.

### Graphics

Only a basic **IBM VGA or compatible graphics card** is required for booting, and using SHORK 486 without a GUI. `shorkgui` and `shorkres` require a vesafb-compatible graphics card. 

### SHORK 486 on modern hardware

SHORK 486 _can_ be used on some newer hardware if you so desire, but there are some considerations.

* SHORK 486 can work with newer x86 processors, although a default SHORK 486 build will not recognise more than 1 core/thread. The "smp" configuration option is available to enable symmetric multiprocessing support. Whilst SHORK 486 can work on an x86-64 processor, the system is still limited to supporting 32-bit software.

* A default SHORK 486 system will not recognise more than ~875MiB of memory. The "highmem" configuration option is available to address this, though the minimum system memory requirement is raised to 24MiB/16MiB + 8MiB swap.

* A default SHORK 486 system only supports IDE hard drives. The "sata" configuration option is available to address this, though the recommended system memory amount is raised to 24MiB/16MiB + 8MiB swap.

_The planned SHORK 686 will make these modern system-orientated options obsolete in the future._



## Usage

SHORK 486 does not presently have or produce installation media, it must be compiled. The result are raw hard disk drive images you can write to real hardware or use as-is in emulation or virtualisation software. Building SHORK 486 may require up to 5GiB of disk space. Please read "Notice & disclaimers" at the end of this readme before proceeding. 

### Configuration

Whilst you *can* build SHORK 486 immediately, it is recommended to first run the SHORK 486 Build Configurator (`config.sh`) whilst in the `shork-486` directory to tailor SHORK 486 to your liking.

### Native building

If you are using an Arch, Debian or Fedora-based Linux distribution, run `build.sh` whilst in the `shork-486` directory. If you have not used the configurator, you will be prompted some questions to answer throughout the process. 

### WSL building

If you are using Windows, SHORK 486 can be built under Windows Subsystem for Linux 2 if you install and use Debian as the distribution choice. WSL1 is not supported as it cannot run 32-bit binaries (which is needed as the cross-compiler SHORK 486 uses is 32-bit).

### Dockerised building

If you are using Windows, macOS (x86-64), a Linux distribution that has not been tested with native building, or want some kind of "sandbox" around the build process, you can try Dockerised building instead. It will create a Docker container with a minimal Debian 13 installation that is active for just the lifetime of the build process. You simply run `docker-compose up`.

### After building

Once built, two disk images - `shork-486.img` and `shork-486.vmdk` - and an after-build report (`report.txt`) should be present in the `images` folder.  The former raw disk image can be used as-is with emulation software like 86Box or written to a real drive using (e.g.) `dd`, and the latter VMware virtual machine disk can be used as-is with VMware Workstation or Player. It is recommended to move or copy the images out of this directory before extensive or serious use because they will be replaced if the build process is rerun.

The after-build report is provided to confirm whether the build was completed as intended. It confirms the type of build made, the time it took to create, the minimum system memory requirement, handy disk image statistics, and which programs or features are included or excluded.



## Scripts & configuration

* `build.sh`: Contains the complete download and compilation process that produces a working SHORK 486 system on two disk images.

* `config.sh`: Used to configure SHORK 486 to your liking before building.

* `clean.sh`: Deletes anything that was downloaded, created or generated by `build.sh`.

### Build configuration

When running the SHORK 486 Build Configurator, you will be prompted to select the following:

* Build environment (Arch native, Debian native/Dockerised or Fedora native)
* Build type (default, minimal, maximal or custom)
* Target disk size (size in MiB for the disk image containing SHORK 486)
* Swap partition size (size in MiB for a swap partition)
* If not "Minimal" build type selected:
    * Keyboard layout (keymap)
* Patched EXTLINUX (yes/no)
* If "Custom" build type selected:
    * Ethernet networking support
    * Bundled software
    * Options (all other configuration)

Below are further explanations for options that could not fit into the configurator itself.

#### Build Type

* **Default**: Builds SHORK 486 to the author's recommended configuration, trying to balance features with RAM requirements. It includes all bundled software except GCC. A default build requires 16MiB system memory and ~72MiB disk size.

* **Minimal**: Builds SHORK 486 to its most minimal configuration. All bundled software and additional features are excluded, and networking support and non-US keyboard layout support are disabled. A minimal build requires 8MiB system memory and ~16MiB disk size.

* **Maximal**: Builds SHORK 486 with every bundled software or additional feature option enabled. It is provided as a curiosity for more modern hardware; it is not recommended for 486 and Pentium (P5)-era hardware. A maximal build requires 24MiB system memory and ~480MiB disk size.

* **Custom**: You will later be asked to pick and choose bundled software and additional features. System memory and disk size requirements depend on what you choose.



#### Patched EXTLINUX

Selecting "Yes" here will tell the build script to use [my forked SYSLINUX/EXTLINUX repository](https://github.com/SharktasticA/syslinux) instead of your host Linux distribution's maintained packaged version. This version addresses a memory detection error to resolve the "Booting kernel failed: Invalid argument" or boot menu looping issue that the stock EXTLINUX may encounter with some BIOSes when attempting to boot the kernel with.

* Some people need this, some people do not - see the list below, or try without first, then enable this if this error or something like it occurs.
* Known hardware that need this includes: Chicony NB5 ([derivatives](www.macdat.net/laptops/chicony/nb5.php)), HP OmniBook 800CT, IBM 2625 ThinkPad 365E/ED, IBM 6381 PS/ValuePoint
    * If you discover more hardware that needs this, please get in touch so I can update this list for future users!
* This may significantly increase total build time, but it does not affect system requirements.
* The patch was discovered by akeym - thank you!
* _Note: If enabled, the option to use GRUB 2.x instead of EXTLINUX offered later for custom builds will be ignored._



#### Ethernet Networking Support

Selecting "Yes" here will enable ethernet networking support in SHORK 486. BusyBox will include implementations for the `ftpget`, `ftpput`, `ifconfig`, `ip`, `ping`, `route`, `telnet`, `traceroute`, `udhcpc`, `wget` and `whois` commands. You will be allowed to select bundled software and options that require an internet connection in the subsequent prompts.



#### Bundled Software

* **gcc**: Adds the GNU Assembler, GCC's C, C++ and Fortran compiler and musl C standard library. Using `g++` requires more system memory than usual, hence it is not included by default. RAM requirements are ideally 32MiB if no swap partition, 24MiB with 8MiB swap or 16MiB with 16MiB swap.

* **shorktainment**: Includes the SHORK Entertainment programs bundle: shorklocomotive, shorkmatrix, and shorksay.

#### Options

* **grub**: Uses a GRUB 2.x bootloader instead of EXTLINUX. The build script overrides this if you said "Yes" to using SHORK's patched fork of EXTLINUX.

* **gui**: Includes SHORK 486's graphical environment ("SHORKGUI"). This includes kernel-level framebuffer, VESA and enhanced VGA support, TinyX display server, TWM window manager, various supporting X11 utilities, st terminal emulator, and the `shorkgui` utility.
    * **SHORKGUI is an experimental feature - expect quirks and incompleteness!**
    * As it is subject to big changes, the system requirements are not set in stone. But the following should provide a usable experience for now:
        * IntelDX4 (ideally; 486SX, 486DX, etc. works but are very slow)
        * 24MiB system memory with no swap partition, or 16MiB with 8MiB swap
        * A PCI graphics card supported by `vesafb`

* **highmem**: Adds kernel-level high memory support and declares that non-reserved physical memory starts at 16MiB instead of 1MiB. In general, this is provided in case someone wanted to try SHORK 486 on a more modern system with more than 875MiB RAM. **It is not needed for most '90s hardware**. Its RAM requirements are 24MiB with no swap partition or 16MiB with 8MiB swap.

* **pci.ids**: Includes a database of graphics card PCI vendor and device IDs. It is safe to exclude it, but `shorkfetch` will not be able to identify any installed graphics cards.

* **pcmcia**: Adds kernel-level CardBus/PCMCIA/PC Card support. It is primarily needed to support PCMCIA-based network controllers for laptops or unique desktop PCs like the IBM PS/2 E. For most desktop PCs, it is safe to exclude it.

* **sata**: Adds kernel-level SATA AHCI support. This is provided in case someone wanted to try SHORK 486 on a more modern system with SATA devices, or has installed a PCI-based SATA controller in a '90s system. **It is not needed for most '90s hardware**. Its RAM requirements are 24MiB with no swap partition or 16MiB with 8MiB swap.

* **smp**: Adds kernel-level symmetric multiprocessing (e.g., multi-core) support. This is provided in case someone wanted to try SHORK 486 on a more modern system with a multi-core processor. **It is not needed for any '90s hardware**. It may add ~1-2MiB to idle RAM usage.

* **usb**: Adds kernel-level USB and HID support and enables BusyBox's `lsusb` implementation. This is provided in case someone wanted to try SHORK 486 on a system with USB peripherals and/or mass storage devices.

### Build automation

These build script parameters are provided to help automate its use, especially for successive runs. It is useful if you want to rebuild SHORK 486 when the only differences are changes to sysfiles or the target disk image and swap partition sizes, and not to the kernel, selected bundled programs or features. It is **not recommended** to use the "skip BusyBox" or "skip kernel" parameters when making a build after running the build configurator or pulling any updates from the SHORK 486 GitHub repository, as it results in using stale compilations that do not reflect configuration or repository changes.

* **Always (re)build** (`--always-build`): Used to ensure the kernel is always (re)built. This will skip the prompt that appears if the kernel is already downloaded and built, acting like the user selected the "Reset & clean" option.
    * This does nothing if the "skip kernel" parameter is also used.

* **Is Arch** (`--is-arch`): Used to skip the host Linux distribution selection prompt and the build script will assume it is running on an Arch-based system.

* **Is Debian** (`--is-debian`): Used to skip the host Linux distribution selection prompt and the build script will assume it is running on a Debian-based system.

* **Is Fedora** (`--is-fedora`): Used to skip the host Linux distribution selection prompt and the build script will assume it is running on a Fedora-based system.

* **Skip BusyBox** (`--skip-busybox`): Used to skip recompiling BusyBox.
    * This parameter requires at least one complete build.

* **Skip kernel** (`--skip-kernel`): Used to skip recompiling the kernel.
    * This parameter requires at least one complete build.



## Directories

* `build`: Contains the source code repositories, the root file system and the kernel image downloaded or made by the build process.
    * Created after a build attempt is made.
    * Do not directly modify or add files to this directory, as the directory may be deleted and recreated upon running the build script again.

* `configs`: Contains configuration files used when compiling certain software, most notably SHORK 486's tailored Linux kernel and BusyBox `.config` files.

* `images`: Contains the result raw disk images and an after-build report created by the build process.
    * Created after a build attempt is made.

* `shorkutils`: Contains custom SHORK utilities to be copied to the root file system 

* `sysfiles`: Contains important system files to be copied into the root file system.



## Notice & disclaimers

### Building SHORK 486

Running `build.sh` directly for natively building SHORK 486 will automatically perform several tasks on the host computer and operating system, including enabling 32-bit packages (Debian), installing prerequisite packages, modifying `PATH`, and creating some environment variables. I would advice you review what the script does to ensure it does not conflict with your existing configuration. Consider Dockerised building to minimise impact to your host operating system.

Running `clean.sh` will delete everything `build.sh` has downloaded, created or generated; the `build` and `images` directories and their contents. If you have made any manual changes to anything inside those directories, they will be lost when running this shell script.

### Using SHORK 486

At present, you are always the root user when using SHORK 486. Make sure to act accordingly, and use it considerately and responsibly.


# SHORK Mini

A minimal Linux distribution developed originally from [FLOPPINUX's](https://github.com/w84death/floppinux) instructions. The aim is to make something very lean but functional for my mid-'90s IBM ThinkPads. I'm not necessarily aiming to restrict myself to a floppy diskette's size, so this is already above 1.44MB. FLOPPINUX was a neat basis to start with, though. This repo stores my ideal configurations and largely automates the setup and compilation process.

## Usage

On Arch-based or Debian-based Linux, just run `setup.sh` and then use the `.img` file found in the resultant `build` directory.

## Directories

* `configs`: My kernel and BusyBox `.config` files made from using menuconfig. I've copied them separately so they are safe.

* `predefined`: Files FLOPPINUX originally creates in terminal via `cat`, but predefined and stored.

## Please note

Running `setup.sh` will automatically perform several tasks on the host computer, including enabling 32-bit packages (Debian), installing prerequisite packages, modifying the PATH, and creating some environment variables. If you intend to use this yourself, please note that this is tailored for my personal usage. Please review what the script does to ensure it does not conflict with your existing configuration.

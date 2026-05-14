# SHORK 486 Linux kernel patching

A part of the SHORK 486 project is patching bleeding-edge Linux kernel releases to ensure they operate with the hardware and specifications SHORK 486 is designed to work with. This will include restoring removed build targets for older platforms and removed drivers for older hardware, as well as patching bugs noticed on older hardware. This document will list created patches and their purposes, potential/todo patches, and anything else useful for this project.

Whilst SHORK 486 itself is licensed under GPL 3.0 terms, the contents of the `shork-486/patches` directory are licensed under [GPL 2.0 terms](https://docs.kernel.org/process/license-rules.html) as they are derived from Linux kernel and BusyBox source code.



## Todo & for consideration

### 7.2.x

* Restore 586 support: https://www.phoronix.com/news/AMD-K5-CPUs
* Restore AMD Élan drivers: https://www.phoronix.com/news/AMD-Elan-Linux-Driver-Removal

### 7.1.x

* Review implications of 64-bit `i_ino`: https://www.phoronix.com/news/Linux-7.1-VFS-Kino-32-bit
* Review removed networking drivers: https://www.phoronix.com/news/Linux-7.1-Removes-Old-Net


## 7.1.x



### [7.1.x_restore-pc110pad.patch](shork-486/patches/7.1.x_restore-pc110pad.patch)

* Original kernel: *7.1-rc1*
* Context: https://www.phoronix.com/news/Linux-7.1-PCI

This patch reverts the removal of the `pc110pad` driver in [6f468ea360f0](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6f468ea360f0a6a1e45854afbc3019842ed891a8). This is for the IBM Palm Top PC 110's trackpad. The PC 110 is a 486SX-based device and a target for SHORK 486.



### [7.1.x_restore-no-pci-devices.patch](shork-486/patches/7.1.x_restore-no-pci-devices.patch)

* Original kernel: *7.1-rc1*
* Context: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=40286d6379aacfcc053253ef78dc78b09addffda

This patch reverts the removal of the `no_pci_devices` function in [d79dc408deb6](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d79dc408deb6c192adbad7893ee0c22d50826511) as it is required by the above patch to restore the `pc110pad` driver.



### [7.1.x_restore-pcmcia-hosts.patch](shork-486/patches/7.1.x_restore-pcmcia-hosts.patch)

* Original kernel: *7.1-rc1*
* Context: https://www.phoronix.com/news/Linux-7.1-Drops-Old-PCMCIA-Code

This patch reverts the changes made in [b3c26ea81ccc](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b3c26ea81ccc522e77ed0b1707add61fc9206216) during 7.1-rc1 that restores some legacy PCMCIA host controller drivers and associated infrastructure. The drivers include i82092, i82365 and tcic.



### [7.1.x_restore-M486-M486SX-ELAN.patch](shork-486/patches/7.1.x_restore-M486-M486SX-ELAN.patch)

* Original kernel: *7.1-rc1*
* Context: https://www.phoronix.com/news/Linux-7.1-Begins-Removing-i486

This patch reverts the changes made in [8b793a92d862](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8b793a92d862c89055daa97ffa61a6929cf732f9) during 7.1-rc1 and restores the ability to target and compile the kernel for 486(DX), 486SX and 486-based Élan processors. 



## 7.0.x

### [7.0.x_6.14.11-e820.patch](shork-486/patches/7.0.x_6.14.11-e820.patch), [7.0.x_6.14.11-e820-v2.patch](shork-486/patches/7.0.x_6.14.11-e820-v2.patch)

* Original kernel: 7.0.0
* Context: https://github.com/SharktasticA/SHORK-486/issues/3, https://lore.kernel.org/lkml/20260415003021.1543723-1-david@davidgow.net/

_No longer required as of [7.0.7](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/diff/?id=v7.0.7&id2=v7.0.6&dt=2) and [7.1-rc3](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5772f6535227ebd104065d80afa8ed3478d34c5c)_

This patch fixes an issue introduced in [157266edcc56](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=master&id=157266edcc56715323de1bd60e49194b3b66a174) during 7.0-rc1 that prevented the use of fallbacks when a received e820 map has no/too few entries, in turn preventing booting on certain old BIOSes and usually manifesting as a "Real mode trampoline was not allocated" error.

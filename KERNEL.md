# SHORK 486 Linux kernel patching

A part of the SHORK 486 project is patching bleeding-edge Linux kernel releases to ensure they operate with the hardware and specifications SHORK 486 is designed to work with. This will include restoring removed build targets for older platforms and removed drivers for older hardware, as well as patching bugs noticed on older hardware. This document will list created patches and their purposes, potential/todo patches, and anything else useful for this project.

Whilst SHORK 486 itself is licensed under GPL 3.0 terms, the contents of the `shork-486/patches` directory are licensed under [GPL 2.0 terms](https://docs.kernel.org/process/license-rules.html) as they are derived from Linux kernel and BusyBox source code.



## 7.0.x

#### [7.0.x_6.14.11-e820.patch](shork-486/patches/7.0.x_6.14.11-e820.patch), [7.0.x_6.14.11-e820-v2.patch](shork-486/patches/7.0.x_6.14.11-e820-v2.patch)

* Original kernel: 7.0.0
* Context: https://github.com/SharktasticA/SHORK-486/issues/3, https://lore.kernel.org/lkml/20260415003021.1543723-1-david@davidgow.net/

This patch fixes an issue introduced in [157266edcc56](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=master&id=157266edcc56715323de1bd60e49194b3b66a174) during 7.0-rc1 that prevented the use of fallbacks when a received e820 map has no/too few entries, in turn preventing booting on certain old BIOSes and usually manifesting as a "Real mode trampoline was not allocated" error.

######################################################
## /mnt/ID/boot/syslinux/syslinux.cfg               ##
######################################################
## EXTLINUX bootloader configuration (boot only)    ##
######################################################
## Kali (sharktastica.co.uk)                        ##
######################################################

DEFAULT @ID@

LABEL @ID@
    SAY Starting @DIST@... Will be with you shortly! :)
    KERNEL /boot/bzImage
    APPEND root=/dev/sda1 rootfstype=ext4 rw rootwait init=/sbin/init console=tty1 ip=off tsc=unstable quiet loglevel=3 vga=normal atkbd.extra=1 vdso32=1

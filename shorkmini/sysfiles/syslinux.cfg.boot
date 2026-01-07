######################################################
## Syslinux bootloader configuration (boot only)    ##
######################################################
## Kali (sharktastica.co.uk)                        ##
######################################################

DEFAULT shorkmini

LABEL shorkmini
    SAY Starting @NAME@ @VER@...
    KERNEL /boot/bzImage
    APPEND root=/dev/sda1 rootfstype=ext2 rw rootwait init=/sbin/init console=tty0 ip=off tsc=unstable quiet loglevel=3

######################################################
## /mnt/ID/boot/grub/grub.cfg                       ##
######################################################
## GRUB bootloader configuration (boot only)        ##
######################################################
## Kali (sharktastica.co.uk)                        ##
######################################################

set timeout_style=hidden
set timeout=0
set default=0

menuentry "@DIST@ @VER@" {
    clear
    echo "Starting @DIST@... Will be with you shortly! :)"
    linux16 /boot/bzImage root=/dev/sda1 rootfstype=ext4 rw rootwait init=/sbin/init console=tty1 ip=off tsc=unstable quiet loglevel=3 vga=normal nomodeset=1 atkbd.extra=1 vdso32=1
}

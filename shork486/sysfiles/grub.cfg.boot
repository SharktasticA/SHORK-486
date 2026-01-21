######################################################
## GRUB bootloader configuration (boot only)        ##
######################################################
## Kali (sharktastica.co.uk)                        ##
######################################################

set timeout_style=hidden
set timeout=0
set default=0

menuentry "@NAME@ @VER@" {
    clear
    echo "Starting @NAME@..."
    linux16 /boot/bzImage root=/dev/sda1 rootfstype=ext4 rw rootwait init=/sbin/init console=tty0 ip=off tsc=unstable quiet loglevel=3 vga=normal
}

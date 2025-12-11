#!/bin/bash

# Get common variables and functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"



# Intro message
echo -e "${BLUE}==============================="
echo -e "=== SHORK Mini setup script ==="
echo -e "===============================${RESET}"



# Install needed host packages
isarch=false
echo -e "${YELLOW}Select host Linux distribution:${RESET}"
select host in "Arch based" "Debian based"; do
    case $host in
        "Arch based")
            isarch=true
            echo -e "${GREEN}Install needed host packages...${RESET}"
            sudo pacman -S ncurses bc flex bison syslinux cpio || true
            break ;;
        "Debian based")
            echo -e "${GREEN}Install needed host packages...${RESET}"
            sudo dpkg --add-architecture i386
            sudo apt-get update
            sudo apt-get install -y libncurses-dev bc flex bison syslinux cpio libncurses-dev:i386 dosfstools || true
            export PATH="$PATH:/usr/sbin:/sbin"
            break ;;
        *)
    esac
done



# Download and extract i486 cross-compiler
echo -e "${GREEN}Download and extract i486 cross-compiler...${RESET}"
wget -N https://musl.cc/i486-linux-musl-cross.tgz
[ -d "i486-linux-musl-cross" ] || tar xvf i486-linux-musl-cross.tgz



# Download and make the latest Linux kernel that supports i486
echo -e "${GREEN}Download and make the latest Linux kernel that supports i486...${RESET}"
mkdir -p build
if [ ! -d "linux" ]; then
    git clone --depth=1 --branch v6.14.11 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git || true
    cd linux/
    make ARCH=x86 tinyconfig
    cp ../configs/linux.config .config
else
    echo -e "${YELLOW}The latest Linux kernel has already downloaded. Select action:${RESET}"
    select action in "Proceed with current kernel" "Delete & reclone"; do
        case $action in
            "Proceed with current kernel")
                echo -e "${GREEN}Proceeding with current kernel...${RESET}"
                cd linux/
                break ;;
            "Delete & reclone")
                echo -e "${GREEN}Deleting and recloning...${RESET}"
                sudo rm -r linux
                git clone --depth=1 --branch v6.14.11 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git || true
                cd linux/
                make ARCH=x86 tinyconfig
                cp ../configs/linux.config .config
                break ;;
            *)
        esac
    done
fi

echo -e "${GREEN}If further configuration is required, please run \"make ARCH=x86 menuconfig\"...${RESET}"
await_input



# Compiling Linux kernel
echo -e "${GREEN}Compiling Linux kernel...${RESET}"
make ARCH=x86 bzImage -j$(nproc)
mv arch/x86/boot/bzImage ../build || true
cd ..



# Download and make BusyBox
echo -e "${GREEN}Download and make BusyBox...${RESET}"
wget -N https://github.com/mirror/busybox/archive/refs/tags/1_36_1.tar.gz
[ -d busybox-1_36_1 ] || tar xzvf 1_36_1.tar.gz
cd busybox-1_36_1/
make ARCH=x86 allnoconfig
sed -i 's/main() {}/int main() {}/' scripts/kconfig/lxdialog/check-lxdialog.sh
cp ../configs/busybox.config .config

echo -e "${GREEN}If further configuration is required, please run \"make ARCH=x86 menuconfig\"...${RESET}"
await_input



# Compiling BusyBox
echo -e "${GREEN}Compiling BusyBox...${RESET}"
BASE="$(realpath ..)"
sed -i "s|.*CONFIG_CROSS_COMPILER_PREFIX.*|CONFIG_CROSS_COMPILER_PREFIX=\"${BASE}/i486-linux-musl-cross/bin/i486-linux-musl-\"|" .config
sed -i "s|.*CONFIG_SYSROOT.*|CONFIG_SYSROOT=\"${BASE}/i486-linux-musl-cross\"|" .config
sed -i "s|.*CONFIG_EXTRA_CFLAGS.*|CONFIG_EXTRA_CFLAGS=-I${BASE}/i486-linux-musl-cross/include|" .config
sed -i "s|.*CONFIG_EXTRA_LDFLAGS.*|CONFIG_EXTRA_LDFLAGS=-L${BASE}/i486-linux-musl-cross/lib|" .config
make ARCH=x86 -j$(nproc) && make ARCH=x86 install



# Build the file system
echo -e "${GREEN}Build the file system...${RESET}"
if [ -d "../filesystem" ]; then
    sudo rm -r ../filesystem
fi
mv _install ../filesystem
cd ../filesystem
mkdir -pv {dev,proc,etc/init.d,sys,tmp,home}
sudo mknod dev/console c 5 1
sudo mknod dev/null c 1 3

echo -e "${GREEN}Make needed directories...${RESET}"
mkdir -p etc
mkdir -p etc/init.d/

echo -e "${GREEN}Copy pre-defined files...${RESET}"
cp ../predefined/welcome .
cp ../predefined/inittab etc/
cp ../predefined/rc etc/init.d/

echo -e "${GREEN}Configure permissions...${RESET}"
chmod +x etc/init.d/rc
sudo chown -R root:root .

echo -e "${GREEN}Compress directory into one file...${RESET}"
find . | cpio -H newc -o | xz --check=crc32 --lzma2=dict=512KiB -e > ../build/rootfs.cpio.xz

cd ..
cp predefined/syslinux.cfg build/
cd build/


# Creating and populating an image containg this system
echo -e "${GREEN}Creating and populating an image containg this system...${RESET}"
dd if=/dev/zero of=shorkmini.img bs=1k count=2880
mkdosfs -n SHORKMINI shorkmini.img
syslinux --install shorkmini.img
sudo mount -o loop shorkmini.img /mnt
sudo mkdir /mnt/data
sudo cp bzImage /mnt
sudo cp rootfs.cpio.xz /mnt
sudo cp syslinux.cfg /mnt
sudo umount /mnt

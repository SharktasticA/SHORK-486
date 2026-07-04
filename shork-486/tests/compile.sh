#!/bin/sh

RED='\033[0;31m'
LIGHT_RED='\033[0;91m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

await_input()
{
    echo -e "Press any key to continue..."
    while true; do
        read -rsn1 key
        if [ -n "$key" ]; then
            break
        fi
    done
}

if [ -x /opt/i486-linux-musl-native/bin/as ]; then
    printf "${GREEN}Testing GNU Assembler compilation${RESET}...\n"
    as -32 compile.s -o compile-as.o
    ld -m elf_i386 compile-as.o -o compile-as
    file compile-as
    printf "${YELLOW}"
    ./compile-as
    printf "${RESET}"
    await_input
fi

if [ -x /opt/i486-linux-musl-native/bin/gcc ]; then
    printf "${GREEN}Testing GNU C compilation (dynamically linked)${RESET}...\n"
    gcc compile.c -o compile-gcc-d
    file compile-gcc-d
    printf "${YELLOW}"
    ./compile-gcc-d
    printf "${RESET}"
    await_input

    printf "${GREEN}Testing GNU C compilation (statically linked)${RESET}...\n"
    gcc -static compile.c -o compile-gcc-s
    file compile-gcc-s
    printf "${YELLOW}"
    ./compile-gcc-s
    printf "${RESET}"
    await_input
fi

if [ -x /opt/i486-linux-musl-native/bin/g++ ]; then
    printf "${GREEN}Testing GNU C++ compilation (dynamically linked)${RESET}...\n"
    g++ compile.cpp -o compile-gpp-d
    file compile-gpp-d
    printf "${YELLOW}"
    ./compile-gpp-d
    printf "${RESET}"
    await_input

    printf "${GREEN}Testing GNU C++ compilation (statically linked)${RESET}...\n"
    g++ -static compile.cpp -o compile-gpp-s
    file compile-gpp-s
    printf "${YELLOW}"
    ./compile-gpp-s
    printf "${RESET}"
    await_input
fi

if [ -x /opt/i486-linux-musl-native/bin/gfortran ]; then
    printf "${GREEN}Testing GNU GFortran compilation (dynamically linked)${RESET}...\n"
    gfortran compile.f90 -o compile-gfortran-d
    file compile-gfortran-d
    printf "${YELLOW}"
    ./compile-gfortran-d
    printf "${RESET}"
    await_input

    printf "${GREEN}Testing GNU GFortran compilation (statically linked)${RESET}...\n"
    gfortran -static compile.f90 -o compile-gfortran-s
    file compile-gfortran-s
    printf "${YELLOW}"
    ./compile-gfortran-s
    printf "${RESET}"
    await_input
fi

if [ -x /usr/local/bin/i386-tcc ]; then
    printf "${GREEN}Testing Tiny C compilation (dynamically linked)${RESET}...\n"
    tcc compile.c -o compile-tcc-d
    file compile-tcc-d
    printf "${YELLOW}"
    ./compile-tcc-d
    printf "${RESET}"
    await_input

    printf "${GREEN}Testing Tiny C compilation (statically linked)${RESET}...\n"
    tcc -static compile.c -o compile-tcc-s
    file compile-tcc-s
    printf "${YELLOW}"
    ./compile-tcc-s
    printf "${RESET}"
fi

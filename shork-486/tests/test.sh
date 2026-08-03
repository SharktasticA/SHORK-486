#!/bin/sh

gcc -static -no-pie -fno-pie test.c -o test -lcurl -lssl -lcrypto -lz -lpthread -ldl -latomic

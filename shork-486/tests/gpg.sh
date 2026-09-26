#!/bin/sh

echo "SHORKGPG" > shorkgpg.txt
gpg --no-symkey-cache --symmetric --output shorkgpg.gpg shorkgpg.txt
gpg --no-symkey-cache --decrypt --output shorkgpg.decrypted shorkgpg.gpg
cat shorkgpg.decrypted

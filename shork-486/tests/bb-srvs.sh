#!/bin/sh

# Create some dummy data for our servers
mkdir -p /srv/ftp /srv/tftp
echo "Hello, user! (FTP)" > /srv/ftp/hello.txt
echo "Hello, user! (TFTP)" > /srv/tftp/hello.txt
dd if=/dev/zero of=/srv/ftp/blob.bin  bs=1024 count=100 2>/dev/null
dd if=/dev/zero of=/srv/tftp/blob.bin bs=1024 count=100 2>/dev/null
chmod 777 /srv/ftp /srv/tftp
chmod 666 /srv/ftp/* /srv/tftp/*

# Specify services
cat > /etc/inetd.conf <<'EOF'
21  stream  tcp nowait  root    /usr/sbin/ftpd      ftpd -w /srv/ftp
23  stream  tcp nowait  root    /usr/sbin/telnetd   telnetd -i -l /bin/sh
69  dgram   udp wait    root    /usr/sbin/tftpd     tftpd -c /srv/tftp
EOF

# Start superserver
pkill inetd 2>/dev/null
sleep 1
inetd

# Get the likely local IP address
IP=$(ifconfig eth0 | sed -n 's/.*inet addr:\([0-9.]*\).*/\1/p')

cat <<EOF
Services:
    * FTP       port 21 (/srv/ftp)
    * Telnet    port 23
    * TFTP      port 69 (/srv/tftp)

1. Remote
    * ping -c 3 $IP
    * telnet $IP
    * FTP
        * ftp $IP
        * curl ftp://$IP/
        * curl -O ftp://$IP/hello.txt
        * echo "Hello, SHORK!" > hello-back.txt
        * curl -T hello-back.txt ftp://$IP/hello-back.txt
    * TFTP
        * tftp $IP -m binary -c get hello.txt
        * echo "Hello, SHORK!" > hello-back.txt
        * tftp $IP -m binary -c put hello-back.txt

2. Local
    * ls -l /srv/ftp /srv/tftp
EOF

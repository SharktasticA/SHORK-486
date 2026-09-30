#!/bin/sh

if [ ! -d /sys/class/net/eth0 ] || ! ifconfig eth0 2>/dev/null | grep -q "UP"; then
    echo "ERROR: internet connection required" >&2
    exit 1
fi

SSH_USER=shork
SSH_PASS=shork

# Register login shell
touch /etc/shells
grep -qx /bin/sh /etc/shells || echo /bin/sh >> /etc/shells

# Create SSH user account
if ! id "$SSH_USER" >/dev/null 2>&1; then
    mkdir -p /home
    adduser -D -h "/home/$SSH_USER" -s /bin/sh "$SSH_USER"
fi
echo "$SSH_USER:$SSH_PASS" | chpasswd

# Create host key
mkdir -p /etc/dropbear
[ -f /etc/dropbear/db_ed25519_hk ] ||
    dropbearkey -t ed25519 -f /etc/dropbear/db_ed25519_hk

# Specify service
cat > /etc/inetd.conf <<'EOF'
22  stream  tcp nowait  root    /usr/sbin/dropbear  dropbear -i -r /etc/dropbear/db_ed25519_hk
EOF

# Start superserver
pkill inetd 2>/dev/null
sleep 1
inetd

# Get the likely local IP address
IP=$(ifconfig eth0 | sed -n 's/.*inet addr:\([0-9.]*\).*/\1/p')

cat <<EOF
Services:
    * SSH       port 22 (user: $SSH_USER, password: $SSH_PASS)

1. Remote
    * ping -c 3 $IP
    * ssh $SSH_USER@$IP
    * exit
    * echo "Hello, SHORK!" > hello.txt
    * scp -O hello.txt $SSH_USER@$IP:/home/$SSH_USER/

2. Local
    * ls -l /home/$SSH_USER/
EOF

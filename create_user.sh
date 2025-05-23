#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

# Create user
useradd -m -s /bin/bash csutt0n

# Set password (you'll be prompted to enter it)
passwd csutt0n

# Create .ssh directory
mkdir -p /home/csutt0n/.ssh
chmod 700 /home/csutt0n/.ssh

# Create authorized_keys file
touch /home/csutt0n/.ssh/authorized_keys
chmod 600 /home/csutt0n/.ssh/authorized_keys

# Set ownership
chown -R csutt0n:csutt0n /home/csutt0n/.ssh

# Make user a superuser
usermod -aG sudo,root csutt0n

# Configure sudo to not require password
echo "csutt0n ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/csutt0n
chmod 440 /etc/sudoers.d/csutt0n

# Add user to root group
usermod -g root csutt0n

echo "User csutt0n has been created as a superuser with full root privileges."
echo "Please add your SSH public key to /home/csutt0n/.ssh/authorized_keys"
echo "WARNING: This user has full system access. Use with caution." 
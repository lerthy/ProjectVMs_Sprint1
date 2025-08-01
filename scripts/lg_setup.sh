#!/bin/bash

# Team LG Assignment - Automation Script
# This script creates additional users, groups, and directories for the project

echo "=== Team LG Setup Script ==="
echo "Starting automated user and directory setup..."
echo ""

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root (use sudo)"
    exit 1
fi

# Create additional users
echo "Creating additional users..."
useradd -m -s /bin/bash lg-user1
useradd -m -s /bin/bash lg-user2
useradd -m -s /bin/bash adminuser

# Set passwords for new users (you should change these in production)
echo "Setting default passwords for new users..."
echo "lg-user1:lg-user1" | chpasswd
echo "lg-user2:lg-user2" | chpasswd
echo "adminuser:adminuser" | chpasswd

# Add adminuser to sudo group
echo "Adding adminuser to sudo group..."
usermod -aG sudo adminuser

# Create projectgroup
echo "Creating projectgroup..."
groupadd projectgroup

# Add users to projectgroup
echo "Adding users to projectgroup..."
usermod -aG projectgroup lg-user1
usermod -aG projectgroup lg-user2
usermod -aG projectgroup adminuser

# Create /data/project directory
echo "Creating /data/project directory..."
mkdir -p /data/project

# Set ownership and permissions for project directory
echo "Setting ownership and permissions for /data/project..."
chown adminuser:projectgroup /data/project
chmod 775 /data/project

# Create a sample file in the project directory
echo "Creating sample file in project directory..."
echo "Project file created on $(date)" > /data/project/sample.txt
chown adminuser:projectgroup /data/project/sample.txt

# Verification
echo ""
echo "=== Verification ==="
echo "Created users:"
id lg-user1
id lg-user2
id adminuser

echo ""
echo "Project group members:"
getent group projectgroup

echo ""
echo "Project directory permissions:"
ls -la /data/

echo ""
echo "=== Setup Complete ==="
echo "Users created: lg-user1, lg-user2, adminuser"
echo "Group created: projectgroup"
echo "Directory created: /data/project"
echo "adminuser has sudo privileges"
echo ""
echo "Default passwords (change in production):"
echo "lg-user1: lg-user1"
echo "lg-user2: lg-user2"
echo "adminuser: adminuser" 

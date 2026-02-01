#!/usr/bin/env bash

################################################################################
# VM Configuration Parameters
# Edit these values to customize your VM, then run: ./create-vm.sh
################################################################################

# VM Name - Choose a unique name for your virtual machine
VM_NAME="nixos-vm"

# Memory - Amount of RAM in megabytes (MB)
# Examples: 1024 = 1GB, 2048 = 2GB, 4096 = 4GB, 8192 = 8GB
MEMORY=1024

# vCPUs - Number of virtual CPU cores
# Recommended: 1-4 for most use cases
VCPUS=1

# Disk Size - Virtual hard drive size in gigabytes (GB)
# Examples: 10, 20, 50, 100
DISK_SIZE=10

# ISO Path - Full path to the installation ISO file
# This must be an existing file on your system
ISO_PATH="/home/sean/Downloads/isos/nixos-minimal-25.11.3695.d03088749a11-x86_64-linux.iso"

# OS Variant - Operating system type (helps optimize VM settings)
# Examples: nixos-unknown, ubuntu22.04, debian11, fedora37, win10, generic
# Run 'virt-install --osinfo list' to see all available options
OS_VARIANT="nixos-unknown"

# Graphics - Display type
# Options:
#   spice  - Full graphical interface (default, best for desktop OSes)
#   vnc    - VNC remote display
#   none   - No graphics (headless, for servers)
GRAPHICS="spice"

# Network - Network configuration
# Options:
#   default - NAT networking (VM can access internet, recommended)
#   user    - User-mode networking (simple, no setup needed)
#   none    - No network
NETWORK="default"

# Connection - Libvirt connection URI
# Options:
#   qemu:///session - User-level VMs (recommended for personal use)
#   qemu:///system  - System-level VMs (requires sudo, for production)
CONNECTION="qemu:///session"

# Auto-attach Console - Open console after creation
# Options: true, false
AUTO_CONSOLE=false

################################################################################
# Script execution (no need to edit below this line)
################################################################################

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}  Creating Virtual Machine${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "Configuration:"
echo "  VM Name:     $VM_NAME"
echo "  Memory:      ${MEMORY}MB"
echo "  vCPUs:       $VCPUS"
echo "  Disk Size:   ${DISK_SIZE}GB"
echo "  ISO:         $ISO_PATH"
echo "  OS Variant:  $OS_VARIANT"
echo "  Graphics:    $GRAPHICS"
echo "  Network:     $NETWORK"
echo "  Connection:  $CONNECTION"
echo ""

# Validate ISO exists
if [[ ! -f "$ISO_PATH" ]]; then
    echo -e "${RED}Error: ISO file not found: $ISO_PATH${NC}" >&2
    echo "Please update ISO_PATH in this script to point to a valid ISO file."
    exit 1
fi

# Build virt-install command
VIRT_INSTALL_CMD=(
    virt-install
    --connect "$CONNECTION"
    --name "$VM_NAME"
    --memory "$MEMORY"
    --vcpus "$VCPUS"
    --disk "size=$DISK_SIZE"
    --cdrom "$ISO_PATH"
    --os-variant "$OS_VARIANT"
)

# Add graphics option
if [[ "$GRAPHICS" == "none" ]]; then
    VIRT_INSTALL_CMD+=(--graphics none)
else
    VIRT_INSTALL_CMD+=(--graphics "$GRAPHICS")
fi

# Add network option
if [[ "$NETWORK" != "default" ]]; then
    VIRT_INSTALL_CMD+=(--network "$NETWORK")
fi

# Add console option
if [[ "$AUTO_CONSOLE" == false ]]; then
    VIRT_INSTALL_CMD+=(--noautoconsole)
fi

# Execute
echo -e "${YELLOW}Running: ${VIRT_INSTALL_CMD[*]}${NC}"
echo ""

"${VIRT_INSTALL_CMD[@]}"

echo ""
echo -e "${GREEN}✓ VM '$VM_NAME' created successfully!${NC}"
echo ""
echo "Next steps:"
echo "  # Open VM in virt-manager GUI"
echo "  virt-manager --connect $CONNECTION"
echo ""
echo "  # Or connect to console"
echo "  virsh --connect $CONNECTION console $VM_NAME"
echo ""
echo "Useful commands:"
echo "  # List all VMs"
echo "  virsh --connect $CONNECTION list --all"
echo ""
echo "  # Start VM"
echo "  virsh --connect $CONNECTION start $VM_NAME"
echo ""
echo "  # Shutdown VM"
echo "  virsh --connect $CONNECTION shutdown $VM_NAME"
echo ""
echo "  # Force stop VM"
echo "  virsh --connect $CONNECTION destroy $VM_NAME"
echo ""
echo "  # Delete VM (WARNING: removes all data)"
echo "  virsh --connect $CONNECTION undefine $VM_NAME --remove-all-storage"
echo ""

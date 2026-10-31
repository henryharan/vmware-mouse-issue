#!/bin/bash
# =============================================================================
# Kali Linux VMware Invisible Mouse Cursor Fix
# =============================================================================
# Fixes the common issue where the mouse pointer is invisible inside
# Kali Linux running on VMware (mouse still works, but cursor not shown).
#
# This script forces the use of a software cursor (SWcursor) via Xorg config,
# which resolves the modesetting driver + vmwgfx hardware cursor conflict.
#
# Usage (one-liner):
#   curl -sL https://raw.githubusercontent.com/henryharan/vmware-mouse-issue/main/fix-kali-vmware-cursor.sh | sudo bash
#
# Or run locally:
#   chmod +x fix-kali-vmware-cursor.sh
#   sudo ./fix-kali-vmware-cursor.sh
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Kali Linux VMware Mouse Cursor Fix ===${NC}"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root (use sudo)${NC}"
   exit 1
fi

# Create Xorg config directory if it doesn't exist
CONFIG_DIR="/etc/X11/xorg.conf.d"
CONFIG_FILE="$CONFIG_DIR/20-swcursor.conf"

mkdir -p "$CONFIG_DIR"

# Write the software cursor configuration
cat > "$CONFIG_FILE" << 'EOF'
Section "Device"
    Identifier "Configured Video Device"
    Driver "modesetting"
    Option "SWcursor" "true"
EndSection
EOF

echo -e "${GREEN}[+] Created software cursor config at $CONFIG_FILE${NC}"

# Optionally install open-vm-tools-desktop (recommended)
echo -e "${YELLOW}[*] Installing open-vm-tools-desktop (recommended for better VMware integration)...${NC}"
apt-get update -qq
apt-get install -y open-vm-tools open-vm-tools-desktop >/dev/null 2>&1 || {
    echo -e "${YELLOW}[!] Warning: Could not install open-vm-tools-desktop. Continuing anyway.${NC}"
}

echo -e "${GREEN}[+] Configuration applied successfully.${NC}"
echo -e "${YELLOW}[*] You need to reboot for the changes to take effect.${NC}"
echo ""
read -p "Reboot now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Rebooting...${NC}"
    reboot
else
    echo -e "${YELLOW}Please reboot manually when ready: sudo reboot${NC}"
fi

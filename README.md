# Kali Linux VMware Invisible Mouse Cursor Fix

A simple one-line / script fix for the common issue where the **mouse pointer is invisible** inside Kali Linux running on VMware Workstation / Player (the mouse still works, but the cursor is not shown).

This is especially common after Kali updates or on newer Kali versions with the `modesetting` driver.

## Quick One-Liner

```bash
sudo bash -c 'mkdir -p /etc/X11/xorg.conf.d && cat > /etc/X11/xorg.conf.d/20-swcursor.conf << EOF
Section "Device"
    Identifier "Configured Video Device"
    Driver "modesetting"
    Option "SWcursor" "true"
EndSection
EOF
apt-get update -qq && apt-get install -y open-vm-tools open-vm-tools-desktop >/dev/null 2>&1 || true
echo "Config applied. Rebooting in 5 seconds..."
sleep 5 && reboot'
```

## Using the Script

### Option 1: Download and run

```bash
curl -sL https://raw.githubusercontent.com/henryharan/vmware-mouse-issue/main/fix-kali-vmware-cursor.sh -o fix-kali-vmware-cursor.sh
chmod +x fix-kali-vmware-cursor.sh
sudo ./fix-kali-vmware-cursor.sh
```

### Option 2: Direct pipe (one-liner)

```bash
curl -sL https://raw.githubusercontent.com/henryharan/vmware-mouse-issue/main/fix-kali-vmware-cursor.sh | sudo bash
```

## What it does

1. Creates `/etc/X11/xorg.conf.d/20-swcursor.conf` to force **software cursor** (`SWcursor`).
2. Installs `open-vm-tools` and `open-vm-tools-desktop` for better VMware integration.
3. Prompts you to reboot (or reboots automatically in the pure one-liner).

## Alternative Fix (No Script Needed)

If the above doesn’t work, shut down the VM completely and change **Hardware Compatibility** in VMware:

1. Power off the Kali VM.
2. Go to **VM → Manage → Change Hardware Compatibility**.
3. Select **Workstation 17.5.x** or higher.
4. Choose **Alter this virtual machine**.
5. Power on again.

## Notes

- The mouse still works even when the cursor is invisible.
- Press `Ctrl + Alt` to release the mouse from the VM if needed.
- Tested on Kali Linux 2025.x / 2026.x with VMware Workstation.

## License

MIT

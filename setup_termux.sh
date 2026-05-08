#!/data/data/com.termux/files/usr/bin/bash
# ================================================================
#  MDM Provisioner - ONE-TIME SETUP for Termux
#  Paste this ONE command in Termux to set up everything:
#
#  curl -L https://raw.githubusercontent.com/vishalchhadwa/apk/main/setup_termux.sh | bash
#
# ================================================================

APK_URL="https://raw.githubusercontent.com/vishalchhadwa/apk/main/app-release-fixed.apk"
SCRIPT_URL="https://raw.githubusercontent.com/vishalchhadwa/apk/main/provision_termux.sh"
APK_PATH="$HOME/mdm_app.apk"
PROVISION_SCRIPT="$HOME/provision.sh"
SHORTCUT_DIR="$HOME/.shortcuts"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${YELLOW}================================================${NC}"
echo -e "${YELLOW}   MDM Provisioner - Setting Up...${NC}"
echo -e "${YELLOW}================================================${NC}"
echo ""

# ── Install packages ─────────────────────────────────────────────
echo -e "${CYAN}[1/5] Installing required packages...${NC}"
pkg update -y -o Dpkg::Options::="--force-confnew" 2>/dev/null
pkg install -y android-tools curl 2>/dev/null
echo -e "${GREEN}      Done.${NC}"

# ── Storage permission ───────────────────────────────────────────
echo ""
echo -e "${CYAN}[2/5] Setting up storage access...${NC}"
echo "      → Tap ALLOW on the popup that appears"
termux-setup-storage
sleep 3
echo -e "${GREEN}      Done.${NC}"

# ── Download APK ─────────────────────────────────────────────────
echo ""
echo -e "${CYAN}[3/5] Downloading MDM APK...${NC}"
curl -L --progress-bar -o "$APK_PATH" "$APK_URL"
if [ $? -eq 0 ]; then
    SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo -e "${GREEN}      Downloaded ($SIZE)${NC}"
else
    echo "      Download failed — check internet connection"
    exit 1
fi

# ── Download provisioning script ──────────────────────────────────
echo ""
echo -e "${CYAN}[4/5] Downloading provisioning script...${NC}"
curl -L -o "$PROVISION_SCRIPT" "$SCRIPT_URL"
chmod +x "$PROVISION_SCRIPT"
echo -e "${GREEN}      Done.${NC}"

# ── Create home screen shortcut ───────────────────────────────────
echo ""
echo -e "${CYAN}[5/5] Creating home screen shortcut...${NC}"
mkdir -p "$SHORTCUT_DIR"
cat > "$SHORTCUT_DIR/MDM Provision.sh" << 'SHORTCUT'
#!/data/data/com.termux/files/usr/bin/bash
~/provision.sh
SHORTCUT
chmod +x "$SHORTCUT_DIR/MDM Provision.sh"
echo -e "${GREEN}      Shortcut created.${NC}"

# ── Done ──────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}   SETUP COMPLETE!${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo "  To provision a device, either:"
echo ""
echo "  A) Type in Termux:   ~/provision.sh"
echo ""
echo "  B) Home screen tap (install Termux:Widget app first):"
echo "     1. Install 'Termux:Widget' from F-Droid"
echo "     2. Long-press home screen → Widgets → Termux:Widget"
echo "     3. Tap 'MDM Provision' shortcut to start"
echo ""
echo "  Connect tablet via USB OTG → run → done."
echo ""

#!/bin/bash
# MDM Device Provisioning Script
# Works on Android 14, 15, 16 — any brand (Samsung, Lenovo, etc.)
# Bypasses QR provisioning completely

APK_PATH="$(dirname "$0")/app/release/app-release-fixed.apk"
COMPONENT="com.example.demo_project/.MyDeviceAdminReceiver"

echo "=========================================="
echo " MDM Device Provisioning"
echo "=========================================="

echo ""
echo "[1/5] Waiting for device..."
adb wait-for-device
sleep 2

echo "[2/5] Installing MDM APK..."
adb install -r "$APK_PATH"
if [ $? -ne 0 ]; then
  echo "ERROR: APK install failed"
  exit 1
fi

echo "[3/5] Resetting provisioning state..."
adb shell settings put global device_provisioned 0

echo "[4/5] Setting device owner..."
RESULT=$(adb shell dpm set-device-owner "$COMPONENT" 2>&1)
echo "$RESULT"
if echo "$RESULT" | grep -q "Success"; then
  echo "[5/5] Verifying..."
  adb shell dpm list-owners
  echo ""
  echo "=========================================="
  echo " SUCCESS - Device Owner set!"
  echo "=========================================="
else
  echo "ERROR: Failed to set device owner"
  echo "$RESULT"
  exit 1
fi

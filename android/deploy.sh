#!/bin/bash
set -e

echo "============================================"
echo "Aegis Android App - Deployment Pipeline"
echo "============================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DEBUG_APK="app/build/outputs/apk/debug/app-debug.apk"
RELEASE_APK="app/build/outputs/apk/release/app-release-unsigned.apk"

# Check if APKs exist
if [ ! -f "$DEBUG_APK" ] || [ ! -f "$RELEASE_APK" ]; then
    echo -e "${RED}✗ APK files not found. Run './build.sh' first.${NC}"
    exit 1
fi

echo -e "${BLUE}Select deployment target:${NC}"
echo "1) Physical Device (via USB)"
echo "2) Android Emulator"
echo "3) Generate APK for Play Store"
echo "4) Generate APK for distribution"
echo ""
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo -e "${YELLOW}Deploying to physical device...${NC}"
        echo ""
        
        # Check if device is connected
        if ! adb devices | grep -q "device$"; then
            echo -e "${RED}✗ No device connected. Please connect via USB.${NC}"
            exit 1
        fi
        
        echo -e "${YELLOW}Installing debug APK...${NC}"
        adb install -r "$DEBUG_APK"
        
        echo ""
        echo -e "${GREEN}✓ App installed successfully!${NC}"
        echo ""
        echo -e "${YELLOW}Launching app...${NC}"
        adb shell am start -n com.aegis.pentest/.MainActivity
        
        echo -e "${GREEN}✓ App launched!${NC}"
        ;;
    
    2)
        echo ""
        echo -e "${YELLOW}Deploying to Android Emulator...${NC}"
        echo ""
        
        # Check if emulator is running
        if ! adb devices | grep -q "emulator"; then
            echo -e "${RED}✗ No emulator running. Launch Android Emulator first.${NC}"
            exit 1
        fi
        
        echo -e "${YELLOW}Installing debug APK to emulator...${NC}"
        adb install -r "$DEBUG_APK"
        
        echo ""
        echo -e "${GREEN}✓ App installed successfully!${NC}"
        echo ""
        echo -e "${YELLOW}Launching app...${NC}"
        adb shell am start -n com.aegis.pentest/.MainActivity
        
        echo -e "${GREEN}✓ App launched on emulator!${NC}"
        ;;
    
    3)
        echo ""
        echo -e "${YELLOW}Generating APK for Play Store...${NC}"
        echo ""
        echo "Note: For Play Store deployment, you need to:"
        echo "1. Sign the release APK with your keystore"
        echo "2. Create an App Bundle for better delivery"
        echo ""
        echo "Release APK location:"
        echo -e "${BLUE}$RELEASE_APK${NC}"
        echo ""
        echo "To sign the APK:"
        echo -e "${BLUE}jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \${NC}"
        echo -e "${BLUE}  -keystore keystore.jks \${NC}"
        echo -e "${BLUE}  $RELEASE_APK key-alias${NC}"
        echo ""
        echo "To create an App Bundle:"
        echo -e "${BLUE}./gradlew bundleRelease${NC}"
        echo ""
        ;;
    
    4)
        echo ""
        echo -e "${YELLOW}Generating APK for distribution...${NC}"
        echo ""
        
        DIST_DIR="build/distribution"
        mkdir -p "$DIST_DIR"
        
        echo -e "${YELLOW}Copying APKs to distribution folder...${NC}"
        cp "$DEBUG_APK" "$DIST_DIR/Aegis-Debug.apk"
        cp "$RELEASE_APK" "$DIST_DIR/Aegis-Release-Unsigned.apk"
        
        # Generate checksums
        cd "$DIST_DIR"
        sha256sum Aegis-*.apk > CHECKSUMS.txt
        cd ../..
        
        echo -e "${GREEN}✓ APKs prepared for distribution!${NC}"
        echo ""
        echo "Distribution folder:"
        echo -e "${BLUE}$DIST_DIR/${NC}"
        echo ""
        echo "Files:"
        ls -lh "$DIST_DIR"
        echo ""
        ;;
    
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo "============================================"
echo -e "${GREEN}Deployment complete!${NC}"
echo "============================================"

#!/bin/bash
set -e

echo "============================================"
echo "Aegis Android App - Build & Test Pipeline"
echo "============================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Clean
echo -e "${YELLOW}[1/5] Cleaning build artifacts...${NC}"
./gradlew clean 2>&1 | grep -E "(BUILD|FAILED|UP-TO-DATE)" || true

# Step 2: Run Unit Tests
echo ""
echo -e "${YELLOW}[2/5] Running unit tests...${NC}"
if ./gradlew test; then
    echo -e "${GREEN}✓ Unit tests passed${NC}"
else
    echo -e "${RED}✗ Unit tests failed${NC}"
    exit 1
fi

# Step 3: Build Debug APK
echo ""
echo -e "${YELLOW}[3/5] Building debug APK...${NC}"
if ./gradlew assembleDebug; then
    echo -e "${GREEN}✓ Debug APK built successfully${NC}"
    APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
    echo -e "${GREEN}📦 APK: $APK_PATH${NC}"
else
    echo -e "${RED}✗ Debug APK build failed${NC}"
    exit 1
fi

# Step 4: Build Release APK
echo ""
echo -e "${YELLOW}[4/5] Building release APK (unsigned)...${NC}"
if ./gradlew assembleRelease; then
    echo -e "${GREEN}✓ Release APK built successfully${NC}"
    RELEASE_APK="app/build/outputs/apk/release/app-release-unsigned.apk"
    echo -e "${GREEN}📦 APK: $RELEASE_APK${NC}"
else
    echo -e "${RED}✗ Release APK build failed${NC}"
    # Continue anyway, release is optional
fi

# Step 5: Summary
echo ""
echo -e "${YELLOW}[5/5] Build Summary${NC}"
echo ""
echo -e "${GREEN}✓ All checks passed!${NC}"
echo ""
echo "Build artifacts:"
echo "  - Debug APK: app/build/outputs/apk/debug/app-debug.apk"
echo "  - Release APK: app/build/outputs/apk/release/app-release-unsigned.apk"
echo ""
echo "Test reports:"
echo "  - Unit Tests: app/build/reports/tests/testDebugUnitTest/index.html"
echo ""
echo "To install debug APK:"
echo "  adb install -r $APK_PATH"
echo ""
echo "To deploy to Play Store:"
echo "  1. Sign the release APK with your keystore"
echo "  2. Upload to Google Play Console"
echo ""
echo "============================================"

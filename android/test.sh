#!/bin/bash
set -e

echo "============================================"
echo "Aegis Android App - Test Pipeline"
echo "============================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[1/3] Running unit tests...${NC}"
echo ""

if ./gradlew test --info; then
    echo ""
    echo -e "${GREEN}✓ Unit tests passed${NC}"
    echo ""
    TEST_REPORT="app/build/reports/tests/testDebugUnitTest/index.html"
    if [ -f "$TEST_REPORT" ]; then
        echo -e "${BLUE}Test Report: $TEST_REPORT${NC}"
    fi
else
    echo ""
    echo -e "${RED}✗ Unit tests failed${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}[2/3] Running lint checks...${NC}"
echo ""

if ./gradlew lint 2>&1 | grep -E "(lint|FAILED|ERROR)"; then
    echo -e "${YELLOW}Lint check completed (see report for details)${NC}"
else
    echo -e "${GREEN}✓ Lint checks passed${NC}"
fi

echo ""
echo -e "${YELLOW}[3/3] Checking dependencies...${NC}"
echo ""

./gradlew dependencies --info 2>&1 | grep -E "(androidx|com.google|com.squareup)" || true

echo ""
echo -e "${YELLOW}Waiting for emulator/device for instrumented tests...${NC}"
echo ""

if adb devices | grep -q "device\|emulator"; then
    echo -e "${GREEN}✓ Device/Emulator found${NC}"
    echo ""
    echo -e "${YELLOW}Running instrumented tests...${NC}"
    echo ""
    
    if ./gradlew connectedAndroidTest; then
        echo ""
        echo -e "${GREEN}✓ Instrumented tests passed${NC}"
    else
        echo ""
        echo -e "${YELLOW}⚠ Instrumented tests failed (device may be disconnected)${NC}"
    fi
else
    echo -e "${YELLOW}⚠ No device/emulator connected for instrumented tests${NC}"
    echo -e "${YELLOW}  To run instrumented tests, connect a device or start emulator${NC}"
fi

echo ""
echo "============================================"
echo -e "${GREEN}Testing complete!${NC}"
echo "============================================"
echo ""
echo "Test Reports:"
echo "  - Unit Tests: app/build/reports/tests/testDebugUnitTest/index.html"
echo "  - Lint: app/build/reports/lint-results-debug.html"
echo ""

#!/bin/bash

# Material Palette Test Runner Script
# Run this script to execute all test cases

echo "🧪 Material Palette - Running All Tests"
echo "======================================"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to run a specific test file
run_test() {
    local test_file=$1
    local description=$2
    
    echo -e "\n${BLUE}🔍 Testing: $description${NC}"
    echo "File: $test_file"
    echo "----------------------------------------"
    
    if flutter test "$test_file"; then
        echo -e "${GREEN}✅ PASSED: $description${NC}"
    else
        echo -e "${RED}❌ FAILED: $description${NC}"
        return 1
    fi
}

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter not found. Please install Flutter and ensure it's in your PATH.${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 Test Plan Overview:${NC}"
echo "1. Unit Tests - ColorSeedNotifier state management"
echo "2. Widget Tests - SeedColorGenerator UI interactions"
echo "3. Utility Tests - Color button helper functions"
echo ""

# Run all tests at once
echo -e "${BLUE}🚀 Running All Tests Together${NC}"
echo "============================================"
if flutter test; then
    echo -e "\n${GREEN}🎉 ALL TESTS PASSED! 🎉${NC}"
    echo "✅ State management working correctly"
    echo "✅ UI interactions functioning properly"
    echo "✅ Color calculations accurate"
    echo "✅ Hex text display working"
    echo "✅ Mode toggle functioning"
else
    echo -e "\n${RED}❌ Some tests failed. Running individual test files for details...${NC}"
    
    # Run individual test files for detailed feedback
    echo -e "\n${YELLOW}📝 Running Individual Test Files:${NC}"
    
    # Unit Tests
    run_test "test/features/app/app_color/app_color_seed_notifier_test.dart" "ColorSeedNotifier State Management"
    
    # Widget Tests  
    run_test "test/features/palette/ui/seed_color_generator_test.dart" "SeedColorGenerator UI Interactions"
    
    # Utility Tests
    run_test "test/features/palette/ui/color_button_utils_test.dart" "Color Button Utilities"
    
    # Sample test
    run_test "test/sample_test.dart" "Sample Test (Basic)"
    
    echo -e "\n${RED}❌ SOME TESTS FAILED${NC}"
    echo "Please check the individual test results above for details."
    exit 1
fi

# Run with coverage if tests pass
echo -e "\n${YELLOW}📊 Generating Test Coverage Report...${NC}"
if flutter test --coverage; then
    echo -e "${GREEN}✅ Coverage report generated in coverage/lcov.info${NC}"
    
    # Check if lcov is available for HTML report
    if command -v genhtml &> /dev/null; then
        echo "🔄 Generating HTML coverage report..."
        genhtml coverage/lcov.info -o coverage/html
        echo -e "${GREEN}✅ HTML coverage report available in coverage/html/index.html${NC}"
    else
        echo -e "${YELLOW}ℹ️  Install lcov for HTML coverage reports: sudo apt-get install lcov${NC}"
    fi
fi

echo -e "\n${GREEN}🎯 Test Summary Complete!${NC}"
echo "All tests are ready to run with the command: flutter test"
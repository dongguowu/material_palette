#!/bin/bash

# Flutter Test Diagnostic Script
# Run this if you encounter test issues

echo "🔍 Flutter Test Environment Diagnostic"
echo "====================================="

# Check Flutter installation
echo "📱 Flutter Environment:"
echo "----------------------"
flutter --version
echo ""

# Check project dependencies
echo "📦 Project Dependencies:"
echo "-----------------------"
if [ -f "pubspec.yaml" ]; then
    echo "✅ pubspec.yaml found"
    echo "🔄 Running flutter pub get..."
    flutter pub get
    echo ""
else
    echo "❌ pubspec.yaml not found - run from project root"
    exit 1
fi

# Check test directory structure
echo "📁 Test Directory Structure:"
echo "---------------------------"
if [ -d "test" ]; then
    echo "✅ test/ directory found"
    find test -name "*.dart" -type f | head -10
    echo ""
else
    echo "❌ test/ directory not found"
    exit 1
fi

# Check for common issues
echo "🚨 Common Issue Checks:"
echo "----------------------"

# Check for analysis issues
echo "🔍 Running flutter analyze..."
if flutter analyze; then
    echo "✅ No analysis issues found"
else
    echo "⚠️ Analysis issues detected - fix these first"
fi

# Check if tests can be discovered
echo ""
echo "🧪 Test Discovery:"
echo "-----------------"
flutter test --help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Flutter test command available"
    
    # List available tests
    echo "📋 Available test files:"
    find test -name "*_test.dart" -type f
else
    echo "❌ Flutter test command not working"
fi

echo ""
echo "🎯 Ready to run tests!"
echo "====================="
echo "Run: flutter test"
echo "Or:  ./run_tests.sh"
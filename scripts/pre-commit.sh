#!/bin/bash

# Pre-commit hook script for lint checking

set -e

echo "🔍 Running pre-commit lint checks..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Run Flutter analyze
echo "📊 Running Flutter analyze..."
flutter analyze

# Check Dart format
echo "🎨 Checking Dart format..."
dart format --set-exit-if-changed .

# Run tests
echo "🧪 Running tests..."
flutter test

# Check if we're in a Flutter project with Android
if [ -d "android" ]; then
    echo "🤖 Running Android lint checks..."
    cd android
    if [ -f "gradlew" ]; then
        ./gradlew ktlintCheck
    fi
    cd ..
fi

# Check example project if it exists
if [ -d "example" ]; then
    echo "📱 Running example project lint checks..."
    cd example
    flutter analyze
    dart format --set-exit-if-changed .
    
    if [ -d "android" ]; then
        cd android
        if [ -f "gradlew" ]; then
            ./gradlew ktlintCheck
        fi
        cd ..
    fi
    cd ..
fi

echo "✅ All lint checks passed!" 
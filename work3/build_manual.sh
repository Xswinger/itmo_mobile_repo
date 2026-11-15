#!/bin/zsh

set -euo pipefail

PROJECT_DIR="${0:A:h}"
BUILD_DIR="$PROJECT_DIR/.manual-build"
CONFIGURATION="${CONFIGURATION:-debug}"

if [[ -z "${DEVELOPER_DIR:-}" && -d /Applications/Xcode.app/Contents/Developer ]]; then
    export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
fi

case "$CONFIGURATION" in
    debug)
        OPTIMIZATION_FLAGS=(-Onone -g)
        ;;
    release)
        OPTIMIZATION_FLAGS=(-O)
        ;;
    *)
        print -u2 "CONFIGURATION должна быть debug или release"
        exit 2
        ;;
esac

mkdir -p "$BUILD_DIR/module-cache"

COMMON_FLAGS=(
    -swift-version 6
    -warnings-as-errors
    -module-cache-path "$BUILD_DIR/module-cache"
)

# Этап 1: библиотека ZooKit и импортируемый Swift-модуль
xcrun swiftc \
    "$PROJECT_DIR/Sources/ZooKit/Animal.swift" \
    "$PROJECT_DIR/Sources/ZooKit/Zoo.swift" \
    -parse-as-library \
    -emit-library \
    -emit-module \
    -module-name ZooKit \
    -emit-module-path "$BUILD_DIR/ZooKit.swiftmodule" \
    -o "$BUILD_DIR/libZooKit.dylib" \
    "${COMMON_FLAGS[@]}" \
    "${OPTIMIZATION_FLAGS[@]}" \
    -Xlinker -install_name \
    -Xlinker @rpath/libZooKit.dylib

# Этап 2: executable, который импортирует и линкует ZooKit
xcrun swiftc \
    "$PROJECT_DIR/Sources/ZooLab/main.swift" \
    -I "$BUILD_DIR" \
    -L "$BUILD_DIR" \
    -lZooKit \
    -o "$BUILD_DIR/ZooLab" \
    "${COMMON_FLAGS[@]}" \
    "${OPTIMIZATION_FLAGS[@]}" \
    -Xlinker -rpath \
    -Xlinker @executable_path

print "Собрано: $BUILD_DIR/ZooLab"
"$BUILD_DIR/ZooLab"

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

# Этап 1: библиотека DecimalKit + импортируемый Swift-модуль
xcrun swiftc \
    "$PROJECT_DIR/Sources/DecimalKit/DecimalTools.swift" \
    -parse-as-library \
    -emit-library \
    -emit-module \
    -module-name DecimalKit \
    -emit-module-path "$BUILD_DIR/DecimalKit.swiftmodule" \
    -o "$BUILD_DIR/libDecimalKit.dylib" \
    "${COMMON_FLAGS[@]}" \
    "${OPTIMIZATION_FLAGS[@]}" \
    -Xlinker -install_name \
    -Xlinker @rpath/libDecimalKit.dylib

# Этап 2: executable, который импортирует и линкует DecimalKit
xcrun swiftc \
    "$PROJECT_DIR/Sources/DecimalLab/main.swift" \
    -I "$BUILD_DIR" \
    -L "$BUILD_DIR" \
    -lDecimalKit \
    -o "$BUILD_DIR/DecimalLab" \
    "${COMMON_FLAGS[@]}" \
    "${OPTIMIZATION_FLAGS[@]}" \
    -Xlinker -rpath \
    -Xlinker @executable_path

print "Собрано: $BUILD_DIR/DecimalLab"
"$BUILD_DIR/DecimalLab"

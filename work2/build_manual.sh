#!/bin/zsh

set -euo pipefail

PROJECT_DIR="${0:A:h}"
BUILD_DIR="$PROJECT_DIR/.manual-build"
CONFIGURATION="${CONFIGURATION:-debug}"

# Используем согласованные compiler + SDK из Xcode, если он установлен.
# Явно заданный DEVELOPER_DIR имеет приоритет.
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

mkdir -p "$BUILD_DIR/module-cache" "$BUILD_DIR/tmp"
# Все временные файлы сборки остаются внутри проекта.
export TMPDIR="$BUILD_DIR/tmp/"

COMMON_FLAGS=(
    -swift-version 6
    -warnings-as-errors
    -module-cache-path "$BUILD_DIR/module-cache"
)

xcrun swiftc \
    "$PROJECT_DIR/main.swift" \
    -o "$BUILD_DIR/SwiftBasicsLab" \
    "${COMMON_FLAGS[@]}" \
    "${OPTIMIZATION_FLAGS[@]}"

print "Собрано: $BUILD_DIR/SwiftBasicsLab"
"$BUILD_DIR/SwiftBasicsLab" "$@"

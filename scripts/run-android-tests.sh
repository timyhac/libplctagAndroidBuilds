#!/usr/bin/env bash
# Runs libplctag core's simulator test suite with every client executing on the attached
# Android device/emulator and every server (ab_server, modbus_server) on the host.
#
# Usage: run-android-tests.sh <android-bin-dir> <host-bin-dir> <core-src-dir> <log-dir> [extra runner args...]
set -euo pipefail
android_bin="$(cd "$1" && pwd)"
host_bin="$(cd "$2" && pwd)"
core="$(cd "$3" && pwd)"
logs="$4"; shift 4
here="$(cd "$(dirname "$0")" && pwd)"
export DEVICE_DIR=/data/local/tmp/plctag

echo "Device: API $(adb shell getprop ro.build.version.sdk | tr -d '\r'), ABI $(adb shell getprop ro.product.cpu.abi | tr -d '\r')"
adb shell rm -rf "$DEVICE_DIR"
adb push "$android_bin" "$DEVICE_DIR" >/dev/null
adb shell "chmod 755 $DEVICE_DIR/*"

mkdir -p "$logs"
python3 "$core/src/tests/scripts/run_simulator_tests_parallel.py" "$host_bin" "$logs" \
  --client-wrapper "bash $here/adb-client-wrapper.sh" \
  "$@"

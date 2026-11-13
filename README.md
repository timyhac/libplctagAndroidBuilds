# libplctagAndroidBuilds

This repository provides Android builds of [libplctag](https://github.com/libplctag/libplctag) via GitHub Actions.

## What the workflow does

- **build**: cross-compiles libplctag core with the Android NDK (r28c, min API 24) for
  `arm64-v8a`, `x86_64`, `armeabi-v7a` and `x86`. Each `libplctag.so` is stripped, and the 64-bit
  ones are checked for 16 KB page alignment, which Google Play requires. The output is
  `libplctag_<version>_android_<abi>.zip`, with the same layout as the core release zips.
- **test**: boots an x86_64 Android emulator at API 24 and API 35, and runs core's own simulator test suite
  (`src/tests/scripts/run_simulator_tests_parallel.py`) with every test *client* executing on the
  emulator and every *server* (`ab_server`, `modbus_server`) on the runner.
  [`scripts/adb-client-wrapper.sh`](scripts/adb-client-wrapper.sh) is passed as the runner's
  `--client-wrapper`; it runs each client with `adb shell` and tunnels the device's `127.0.0.1:<port>`
  to the runner with `adb reverse`, so test command lines are identical to core CI.
- **release** (manual runs with `RELEASE` ticked): publishes the zips as release `v<version>`.

ARM ABIs are build-verified only; GitHub's x86_64 runners can't run ARM emulator images at useful speed.

## Patches

[`patches/`](patches) holds fixes needed to build core v2.7.2 for Android. They are skipped
automatically once they are already present upstream:

1. `cmake_toolchains/android.cmake` doesn't set `PLATFORM_SHIM_PATH` (configure fails).
2. `src/utils/random_utils.c` uses `getrandom()`, which Bionic only has from API 28. On Android it now uses `arc4random_buf`.
3. Same as 2, for `src/tools/ab_server/utils.c`.
4. `test_omron_destroy` hardcodes `/tmp` for its server pid and log files. Android 7 (API 24) has no `/tmp`,
   so it now honours `$TMPDIR`, which the adb wrapper sets on the device. This is a test-only change.

## License

The code in this repository is licensed as MIT.
The binaries are licensed separately by libplctag - see https://github.com/libplctag/libplctag for details.

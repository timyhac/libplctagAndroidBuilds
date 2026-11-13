# libplctagAndroidBuilds

Android builds of [libplctag](https://github.com/libplctag/libplctag) (`arm64-v8a`, `x86_64`, `armeabi-v7a`, `x86`), built with GitHub Actions.

Each build runs core's simulator test suite on x86_64 emulators (API 24 and 35). Run the workflow with `RELEASE` ticked to publish the zips.

[`patches/`](patches) holds fixes core needs to build for Android. A patch is skipped once it's in upstream core.

The code in this repository is MIT licensed. The binaries are licensed by libplctag; see https://github.com/libplctag/libplctag.

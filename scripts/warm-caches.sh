#!/bin/sh

# Build a throwaway app so that the Gradle distribution, the Android Gradle
# Plugin, Kotlin and other build dependencies, and the template's pub packages
# are downloaded into the image.  This only helps projects on the same
# Gradle/AGP/Kotlin versions as the current Flutter template.

PATH="/usr/local/flutter/bin:$PATH"

cd /tmp || exit 1
flutter create warmup || exit 1
cd warmup || exit 1

flutter build apk --debug || exit 1
flutter build apk --release || exit 1
flutter build appbundle --release || exit 1

./android/gradlew -p android --stop || exit 1

cd / || exit 1
rm -rf /tmp/warmup || exit 1

# The build cache only holds outputs for the throwaway app, which won't be
# reused by real projects.
rm -rf /root/.gradle/caches/build-cache-1 || exit 1
rm -rf /root/.gradle/daemon /root/.gradle/.tmp || exit 1

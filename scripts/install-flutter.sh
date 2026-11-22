#!/bin/sh

curl -L -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz || exit 1
tar -xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz || exit 1
mv flutter /usr/local/flutter || exit 1
rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz || exit 1

# The archive preserves the uploader's uid, which makes git refuse to operate on
# the Flutter checkout ("dubious ownership").
chown -R root:root /usr/local/flutter || exit 1

PATH="/usr/local/flutter/bin:$PATH"

flutter --disable-analytics || exit 1
flutter config --android-sdk ${ANDROID_HOME} || exit 1
flutter config --no-enable-web --no-enable-linux-desktop || exit 1
flutter precache --android || exit 1

# flutter doctor always exits 0, so check the Android toolchain result explicitly.
flutter doctor -v | tee /tmp/flutter-doctor.txt
grep -q '\[✓\] Android toolchain' /tmp/flutter-doctor.txt || exit 1
rm /tmp/flutter-doctor.txt

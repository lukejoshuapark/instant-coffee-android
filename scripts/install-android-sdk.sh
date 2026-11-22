#!/bin/sh

curl -L -O https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip || exit 1
unzip -q commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip || exit 1
mkdir -p ${ANDROID_HOME}/cmdline-tools || exit 1
mv cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest || exit 1
rm commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip || exit 1

SDKMANAGER="${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager"

yes | ${SDKMANAGER} --licenses > /dev/null || exit 1
${SDKMANAGER} --install \
	"platform-tools" \
	"platforms;android-${ANDROID_PLATFORM_VERSION}" \
	"build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
	"ndk;${ANDROID_NDK_VERSION}" || exit 1

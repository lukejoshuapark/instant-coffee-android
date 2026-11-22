# Start with instant-coffee.
ARG INSTANT_COFFEE_VERSION=0.12.0
FROM ghcr.io/lukejoshuapark/instant-coffee:${INSTANT_COFFEE_VERSION} AS build
ARG TARGETARCH

ARG JDK_VERSION=21
ARG ANDROID_CMDLINE_TOOLS_VERSION=16111833
ARG ANDROID_PLATFORM_VERSION=36
ARG ANDROID_BUILD_TOOLS_VERSION=36.0.0
ARG ANDROID_NDK_VERSION=28.2.13676358
ARG FLUTTER_VERSION=3.50.1

ENV ANDROID_HOME="/opt/android-sdk"
ENV JAVA_HOME="/usr/lib/jvm/java-${JDK_VERSION}-openjdk-${TARGETARCH}"

# Install the JDK.
COPY ./scripts/install-jdk.sh ./
RUN chmod u+x ./install-jdk.sh && ./install-jdk.sh && rm ./install-jdk.sh

# Install the Android SDK.
COPY ./scripts/install-android-sdk.sh ./
RUN chmod u+x ./install-android-sdk.sh && ./install-android-sdk.sh && rm ./install-android-sdk.sh

# Install Flutter.
COPY ./scripts/install-flutter.sh ./
RUN chmod u+x ./install-flutter.sh && ./install-flutter.sh && rm ./install-flutter.sh

# Configure Gradle and pre-populate the Gradle and pub caches.
COPY ./scripts/gradle.properties /root/.gradle/gradle.properties
COPY ./scripts/warm-caches.sh ./
RUN chmod u+x ./warm-caches.sh && ./warm-caches.sh && rm ./warm-caches.sh

# Squash everything together.
FROM scratch
ARG TARGETARCH
ARG JDK_VERSION=21
COPY --from=build / /
ENV HOME="/root"
ENV ANDROID_HOME="/opt/android-sdk"
ENV ANDROID_SDK_ROOT="/opt/android-sdk"
ENV JAVA_HOME="/usr/lib/jvm/java-${JDK_VERSION}-openjdk-${TARGETARCH}"
ENV PATH="/usr/local/flutter/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/root/.local/bin:/root/.cargo/bin:/root/go/bin:/usr/local/go/bin:/usr/local/node/bin:$PATH"
ENV GOROOT="/usr/local/go"
ENV GOPATH="/root/go"

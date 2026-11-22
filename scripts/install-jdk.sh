#!/bin/sh

apt-get update || exit 1
apt-get install -y openjdk-${JDK_VERSION}-jdk-headless || exit 1
apt-get clean || exit 1
rm -rf /var/lib/apt/lists/* || exit 1

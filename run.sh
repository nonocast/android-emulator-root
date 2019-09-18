#!/bin/zsh

AVD_NAME=$1

help() {
  echo "Usage: $0 avd-name"
}

if [ -z $AVD_NAME ]; then
  help
  exit 1
fi

if [ -z $ANDROID_HOME ]; then
  echo 'missing ANDROID_HOME'
  exit 1
fi

echo "ANDROID_HOME: $ANDROID_HOME"
EMULATOR="$ANDROID_HOME/emulator/emulator"

$EMULATOR -avd $AVD_NAME -writable-system -selinux disabled &

sleep 10

adb root
adb remount
adb push ./supersu/recovery/x86/su.pie /system/bin/su
adb push ./supersu/recovery/x86/su.pie /system/xbin/su
adb push ./supersu/recovery/x86/su.pie /system/sbin/su

adb shell chmod 06755 /system/bin/su
adb shell chmod 06755 /system/xbin/su
adb shell chmod 06755 /system/sbin/su

adb shell su --install
adb shell su --daemon&
adb shell setenforce 0
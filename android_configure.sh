# use ". android_configure.sh" to run this

# NOTE: This was a temporary method to generate Makefiles
#       This requires to download a separate NDK
#       Not required except if you want to run tests

TARGETARCH=`get_build_var TARGET_ARCH`

echo TARGETARCH=$TARGETARCH
PREVIOUS_ANDROID_TOOLCHAIN=$ANDROID_TOOLCHAIN

export SYSROOT=`pwd`/ndkbuild
echo SYSROOT=$SYSROOT
mkdir -p $SYSROOT

# http://dl.google.com/android/ndk/android-ndk32-r10-linux-x86.tar.bz2
export ANDROID_NDK=/repos/ndks/android-ndk-r10
echo ANDROID_NDK=$ANDROID_NDK

export ANDROID_TOOLCHAIN=$SYSROOT

export targetgccversion=4.8
toolchain=$TARGETARCH-eabi

if [ ! -e "$SYSROOT/COPYING" ] ; then

$ANDROID_NDK/build/tools/make-standalone-toolchain.sh \
 --install-dir=$SYSROOT \
 --verbose \
 --platform=android-9 \
 --install-dir=$ANDROID_TOOLCHAIN \
 --system=`uname | tr '[A-Z]' '[a-z]'`-x86 \
 --toolchain=$toolchain-$targetgccversion

fi

export TARGETDIR=/data/local/perl

export DEVICE=4df587c3 # execute 'adb devices' to know your Device ID

./Configure -des -Dusedevel -Dusecrosscompile -Dtargetrun=adb \
    -Dcc=$toolchain-gcc \
    -Dsysroot=$SYSROOT/sysroot \
    -Dtargetdir=$TARGETDIR \
    -Dtargethost=$DEVICE




# use ". android_configure.sh" to run this

# NOTE: This was a temporary method to generate Makefiles
#       This requires to download a separate NDK
#       Not required except if you want to run tests

TARGETARCH=`get_build_var TARGET_ARCH`

echo TARGETARCH=$TARGETARCH
PREVIOUS_ANDROID_TOOLCHAIN=$ANDROID_TOOLCHAIN

export NDKROOT=`pwd`/ndkbuild
echo NDKROOT=$NDKROOT
mkdir -p $NDKROOT

# http://dl.google.com/android/ndk/android-ndk32-r10-linux-x86.tar.bz2
export ANDROID_NDK=/repos/ndks/android-ndk-r10
echo ANDROID_NDK=$ANDROID_NDK

export ANDROID_TOOLCHAIN=$NDKROOT

export targetgccversion=4.8
toolchain=arm-linux-androideabi
# or mipsel-linux-android
# or x86

if [ ! -e "$NDKROOT/COPYING" ] ; then

$ANDROID_NDK/build/tools/make-standalone-toolchain.sh \
 --verbose \
 --platform=android-14 \
 --install-dir=$NDKROOT \
 --system=`uname | tr '[A-Z]' '[a-z]'`-x86 \
 --toolchain=$toolchain-$targetgccversion

fi

export SYSROOT=$NDKROOT/sysroot

prefix=/data/local
export TARGETDIR=$prefix/perl

export DEVICE=`adb devices | grep -v "^List" | head -n 1 | cut -f 1`

rm -f config.sh

USER=`git config user.username`
email=$USER@github

./Configure -des -Dusedevel -Dusecrosscompile -Dtargetrun=adb \
 -Dcc=$toolchain-gcc \
 -Dsysroot=$SYSROOT \
 -Dprefix=$prefix \
 -Dtargetdir=$TARGETDIR \
 -Dtargethost=$DEVICE \
 -Dperlpath="$TARGETDIR" \
 -Dcf_by="$USER" -Dcf_mail="$email" -Dperladmin="$email" \
 -Ud_mbstowcs -Ud_wcstombs -Ud_wcscmp -Ud_wcsxfrm \
 -Dstrings="string.h" \
 -Dstartperl="#!/system/bin/env perl" \
 -Dfull_sed='/system/xbin/sed'

# replace hard paths with build vars
SYS_SQ=`echo $SYSROOT | sed 's~\/~\\\/~g'`
sed -i "s/$SYS_SQ/\${SYSROOT}/g" config.sh

TOP_SQ=`echo $ANDROID_BUILD_TOP | sed 's~\/~\\\/~g'`
sed -i "s/$TOP_SQ/\${ANDROID_BUILD_TOP}/g" config.sh

# replace single quotes ' with " for lines with $VARS (assume there is no " inside)
sed -r -i 's/^([^=]+=)'\''(.*\$.*)'\''/\1"\2"/' config.sh


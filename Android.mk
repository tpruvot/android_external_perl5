perl_src := $(call my-dir)

WANT_MICROPERL = 1

# Perl code is not clean !
PERL_WARNINGS = \
  -Wno-error=return-type \
  -Wno-implicit-function-declaration \
  -Wno-return-type -Wno-pointer-sign \
  -Wno-sign-compare -Wno-maybe-uninitialized

PERL_INCLUDES = \
  $(perl_src)/android

PERL_DEFINES = \
  -DUSE_CROSS_COMPILE -DPERL_TARGETARCH=\"$(TARGET_ARCH)\" \
  -include $(perl_src)/android/android.h \

# unable to get basename of current .c "$<" doesn't works
# -D__FILE__='\"$(subst $(LOCAL_PATH)/,,$(abspath $<)) \"'


###############################################################################
# Common source files

perl_c1 = av.c scope.c op.c doop.c doio.c hv.c mg.c reentr.c perl.c
perl_c2 = perly.c pp.c pp_hot.c pp_ctl.c pp_sys.c regcomp.c regexec.c utf8.c sv.c
perl_c3 = taint.c toke.c util.c deb.c run.c pad.c globals.c keywords.c
perl_c4 = perlapi.c numeric.c mathoms.c locale.c pp_pack.c pp_sort.c caretx.c

# These files must be retouched, to set the right filename for __FILE__
# and not the full android path (external/perl5/<file>.c)
perl_f  = perlio.c dump.c gv.c mro.c universal.c

# To check, use LOCAL_GENERATED_SOURCES ?

$(perl_f):
	@sed -e 's/__FILE__/"$@"/' $(perl_src)/$@ > $(perl_src)/.android.$@

perl_files := \
  $(perl_c1) $(perl_c2) $(perl_c3) $(perl_c4) \
  $(addprefix .android., $(perl_f))

###############################################################################
# miniperl

LOCAL_PATH := $(perl_src)
include $(CLEAR_VARS)

LOCAL_ADDITIONAL_DEPENDENCIES := $(perl_f)

LOCAL_MODULE := miniperl
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)

LOCAL_CFLAGS := $(PERL_DEFINES) $(PERL_WARNINGS) \
  -DPERL_CORE -DPERL_IS_MINIPERL -DPERL_EXTERNAL_GLOB

LOCAL_SRC_FILES := $(perl_files) \
  miniperlmain.c

LOCAL_C_INCLUDES := $(perl_src)/android/mini \
  $(PERL_INCLUDES)

LOCAL_SHARED_LIBRARIES := libm

include $(BUILD_EXECUTABLE)

###############################################################################
# microperl (40KB less)

ifeq ($(WANT_MICROPERL),1)

LOCAL_PATH := $(perl_src)
include $(CLEAR_VARS)

LOCAL_ADDITIONAL_DEPENDENCIES := $(perl_f)

LOCAL_MODULE := microperl
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)

LOCAL_CFLAGS := $(PERL_DEFINES) $(PERL_WARNINGS) \
  -DPERL_CORE -DPERL_MICRO -DSTANDARD_C \
  -DPERL_USE_SAFE_PUTENV -DNO_MATHOMS \

LOCAL_SRC_FILES := $(perl_files) \
  miniperlmain.c

LOCAL_C_INCLUDES := \
  $(perl_src)/android/micro \
  $(PERL_INCLUDES)

LOCAL_SHARED_LIBRARIES := libm

include $(BUILD_EXECUTABLE)

endif # WANT_MICROPERL

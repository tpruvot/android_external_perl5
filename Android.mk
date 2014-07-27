perl_src := $(call my-dir)

WANT_MICROPERL = 0

# Perl code is not clean !
PERL_WARNINGS = \
  -Wno-error=return-type \
  -Wno-implicit-function-declaration \
  -Wno-return-type -Wno-pointer-sign \
  -Wno-sign-compare -Wno-maybe-uninitialized

PERL_INCLUDES = \
  $(perl_src)/android

PERL_DEFINES = \

###############################################################################

LOCAL_PATH := $(perl_src)
include $(CLEAR_VARS)

perl_mallocsrc = 

perl_c1 = av.c scope.c op.c doop.c doio.c dump.c gv.c hv.c mg.c reentr.c mro.c perl.c
perl_c2 = perly.c pp.c pp_hot.c pp_ctl.c pp_sys.c regcomp.c regexec.c utf8.c sv.c
perl_c3 = taint.c toke.c util.c deb.c run.c universal.c pad.c globals.c keywords.c
perl_c4 = perlio.c perlapi.c numeric.c mathoms.c locale.c pp_pack.c pp_sort.c caretx.c
perl_c5 = $(perl_mallocsrc)

LOCAL_MODULE := miniperl
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)

LOCAL_CFLAGS := $(PERL_DEFINES) $(PERL_WARNINGS) \
  -DPERL_CORE -DPERL_IS_MINIPERL -DPERL_EXTERNAL_GLOB

LOCAL_SRC_FILES := $(perl_c1) $(perl_c2) $(perl_c3) $(perl_c4) $(perl_c5) \
	miniperlmain.c

LOCAL_C_INCLUDES := $(perl_src)/android/mini $(PERL_INCLUDES)

LOCAL_SHARED_LIBRARIES := libm

include $(BUILD_EXECUTABLE)

###############################################################################

ifeq (WANT_MICROPERL,1)

LOCAL_PATH := $(perl_src)
include $(CLEAR_VARS)

# microperl objects (from Makefile.micro, without u prefix)
perl_uo := av caretx deb doio doop dump \
	globals gv hv mro\
	mg perlmain op reentr \
	pad perl perlio perly pp \
	pp_ctl pp_hot pp_sys pp_pack pp_sort \
	regcomp regexec run \
	scope sv taint toke \
	numeric locale mathoms \
	universal utf8 util perlapi keywords
perl_uo := $(addsuffix .c, $(perl_uo))

LOCAL_MODULE := microperl
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)

LOCAL_CFLAGS := $(PERL_DEFINES) $(PERL_WARNINGS) \
  -DPERL_CORE -DPERL_MICRO -DSTANDARD_C \
  -DPERL_USE_SAFE_PUTENV -DNO_MATHOMS

LOCAL_SRC_FILES := $(perl_uo)

# ??? LOCAL_SRC_FILES += $(perl_src)/DynaLoader.o

LOCAL_C_INCLUDES := \
  $(perl_src)/android/micro \
  $(PERL_INCLUDES)

LOCAL_SHARED_LIBRARIES := libm

include $(BUILD_EXECUTABLE)

endif # WANT_MICROPERL

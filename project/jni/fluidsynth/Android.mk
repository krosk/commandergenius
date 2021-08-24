LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ECHO := $(shell wget -nc https://github.com/FluidSynth/fluidsynth/releases/download/v2.2.2/fluidsynth-2.2.2-android.zip; unzip -n fluidsynth-2.2.2-android.zip *libfluidsynth.so -d $(LOCAL_PATH); )

LOCAL_MODULE := fluidsynth

LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libfluidsynth.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include

LOCAL_SHARED_LIBRARIES := oboe glib-2.0 gthread-2.0 gobject-2.0 sndfile instpatch-1.0

LOCAL_STATIC_LIBRARIES := 

include $(PREBUILT_SHARED_LIBRARY)

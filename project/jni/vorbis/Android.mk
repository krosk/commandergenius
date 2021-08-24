LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ECHO := $(shell wget -nc https://github.com/FluidSynth/fluidsynth/releases/download/v2.2.2/fluidsynth-2.2.2-android.zip; unzip -n fluidsynth-2.2.2-android.zip *libvorbis.so -d $(LOCAL_PATH); )

LOCAL_MODULE := vorbis

LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libvorbis.so

LOCAL_SHARED_LIBRARIES := ogg

include $(PREBUILT_SHARED_LIBRARY)

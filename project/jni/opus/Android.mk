LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ECHO := $(shell wget -nc https://github.com/FluidSynth/fluidsynth/releases/download/v2.2.2/fluidsynth-2.2.2-android.zip; unzip -n fluidsynth-2.2.2-android.zip *libopus.so -d $(LOCAL_PATH); )

LOCAL_MODULE := opus

LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libopus.so

include $(PREBUILT_SHARED_LIBRARY)

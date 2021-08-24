LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ECHO := $(shell wget -nc https://github.com/FluidSynth/fluidsynth/releases/download/v2.2.2/fluidsynth-2.2.2-android.zip; unzip -n fluidsynth-2.2.2-android.zip *libgobject-2.0.so -d $(LOCAL_PATH); )

LOCAL_MODULE := gobject-2.0

LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libgobject-2.0.so

LOCAL_SHARED_LIBRARIES := glib-2.0

include $(PREBUILT_SHARED_LIBRARY)
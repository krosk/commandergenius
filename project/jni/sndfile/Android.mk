LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ECHO := $(shell wget -nc https://github.com/FluidSynth/fluidsynth/releases/download/v2.2.2/fluidsynth-2.2.2-android.zip; unzip -n fluidsynth-2.2.2-android.zip *libsndfile.so -d $(LOCAL_PATH); )

LOCAL_MODULE := sndfile

LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libsndfile.so

LOCAL_SHARED_LIBRARIES := flac ogg vorbis vorbisenc opus

LOCAL_STATIC_LIBRARIES := 

include $(PREBUILT_SHARED_LIBRARY)

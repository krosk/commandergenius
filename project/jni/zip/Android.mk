LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ECHO := $(shell wget -nc https://github.com/krosk/libzip-android/releases/download/CI/libzip-android-all-ci.zip; unzip -n libzip-android-all-ci.zip -d $(LOCAL_PATH); )

LOCAL_MODULE := zip

LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libzip.so

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include

LOCAL_SHARED_LIBRARIES := zip

include $(PREBUILT_SHARED_LIBRARY)
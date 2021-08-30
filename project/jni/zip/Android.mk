LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ECHO := $(shell wget -nc https://github.com/krosk/libzip-android/releases/download/Android-1.2.0/libzip-android-all-1.2.0.zip; unzip -n libzip-android-all-1.2.0.zip -d $(LOCAL_PATH); )

LOCAL_MODULE := zip

LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libzip.so

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include

LOCAL_SHARED_LIBRARIES := zip

include $(PREBUILT_SHARED_LIBRARY)
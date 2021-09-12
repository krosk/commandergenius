LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ECHO := $(shell wget -nc https://github.com/krosk/openssl-android/releases/download/Android-1.1.1j/libopenssl-android-all-1.1.1j.zip && unzip -n libopenssl-android-all-1.1.1j.zip -d $(LOCAL_PATH) )

LOCAL_MODULE := $(notdir $(LOCAL_PATH))

ifneq (openssl,$(LOCAL_MODULE))

LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/lib$(LOCAL_MODULE).so.sdl.1.so

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include

LOCAL_SHARED_LIBRARIES := $(LOCAL_MODULE)

include $(PREBUILT_SHARED_LIBRARY)

endif

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := zzip

APP_SUBDIRS := $(patsubst $(LOCAL_PATH)/%, %, $(shell find $(LOCAL_PATH)/zzip -type d))

LOCAL_C_INCLUDES := $(foreach D, $(APP_SUBDIRS), $(LOCAL_PATH)/$(D)) \
					$(LOCAL_PATH)/include $(LOCAL_PATH)/../sdl-$(SDL_VERSION)/include
LOCAL_CFLAGS := -O3


LOCAL_CPP_EXTENSION := .cpp

LOCAL_SRC_FILES := $(foreach F, $(APP_SUBDIRS), $(addprefix $(F)/,$(notdir $(wildcard $(LOCAL_PATH)/$(F)/*.cpp))))
LOCAL_SRC_FILES += $(foreach F, $(APP_SUBDIRS), $(addprefix $(F)/,$(notdir $(wildcard $(LOCAL_PATH)/$(F)/*.c))))

ifeq ($(SDL_VERSION),2.0)
LOCAL_SHARED_LIBRARIES := SDL2
else
LOCAL_SHARED_LIBRARIES := sdl-$(SDL_VERSION)
endif

LOCAL_STATIC_LIBRARIES := 

LOCAL_LDLIBS := -llog -lz

include $(BUILD_SHARED_LIBRARY)

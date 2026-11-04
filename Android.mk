LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),ef44)
include $(call all-subdir-makefiles,$(LOCAL_PATH))
endif

#
# Copyright (C) 2018 GlobalLogic
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Include only for Renesas ones.
ifneq (,$(filter $(TARGET_PRODUCT), salvator ulcb kingfisher))

LOCAL_PATH:= $(call my-dir)

POWERVR_PREBUILT_LIBS := \
    egl/libEGL_POWERVR_ROGUE.so \
    egl/libGLESv1_CM_POWERVR_ROGUE.so \
    egl/libGLESv2_POWERVR_ROGUE.so \
    hw/gralloc.$(TARGET_BOARD_PLATFORM).so \
    hw/memtrack.$(TARGET_BOARD_PLATFORM).so \
    libPVRScopeServices.so \
    libPVRRS.so \
    libIMGegl.so \
    libsrv_um.so \
    libusc.so \
    libglslcompiler.so

POWERVR_PREBUILT_EXEC := \
    pvrsrvctl \
    rscompiler

ifeq ($(TARGET_BOARD_PLATFORM),r8a7795)
POWERVR_PREBUILT_FW := \
    rgx.fw.4.46.6.62
endif
ifeq ($(TARGET_BOARD_PLATFORM),r8a7796)
POWERVR_PREBUILT_FW := \
    rgx.fw.4.45.2.58
endif
ifeq ($(TARGET_BOARD_PLATFORM),r8a77965)
POWERVR_PREBUILT_FW := \
    rgx.fw.15.5.1.64
endif

POWERVR_PREBUILT_APPHINT := \
    powervr.ini

define _build-powervr-prebuilt-lib
include $$(CLEAR_VARS)
LOCAL_MODULE                := $(notdir $1)
LOCAL_MODULE_CLASS          := SHARED_LIBRARIES
LOCAL_SRC_FILES_arm         := $2/lib/$1
LOCAL_SRC_FILES_arm64       := $2/lib64/$1
LOCAL_MODULE_PATH_32        := $(dir $$(TARGET_OUT_VENDOR)/lib/$1)
LOCAL_MODULE_PATH_64        := $(dir $$(TARGET_OUT_VENDOR)/lib64/$1)
LOCAL_MULTILIB              := both
LOCAL_SHARED_LIBRARIES      := libdrm libion
LOCAL_PROPRIETARY_MODULE    := true
_modules += $$(LOCAL_MODULE)
include $$(BUILD_PREBUILT)
endef

define _build-powervr-prebuilt-exec
include $$(CLEAR_VARS)
LOCAL_MODULE                := $(notdir $1)
LOCAL_MODULE_CLASS          := EXECUTABLES
LOCAL_SRC_FILES             := $$(TARGET_BOARD_PLATFORM)/vendor/bin/$1
LOCAL_MODULE_PATH           := $(dir $$(TARGET_OUT_VENDOR)/bin/$1)
LOCAL_MULTILIB              := 64
LOCAL_PROPRIETARY_MODULE    := true
_modules += $$(LOCAL_MODULE)
include $$(BUILD_PREBUILT)
endef

define _build-powervr-prebuilt-fw
include $$(CLEAR_VARS)
LOCAL_MODULE                := $(notdir $1)
LOCAL_MODULE_CLASS          := ETC
LOCAL_SRC_FILES             := $$(TARGET_BOARD_PLATFORM)/vendor/etc/firmware/$1
LOCAL_MODULE_PATH           := $(dir $$(TARGET_OUT_VENDOR)/etc/firmware/$1)
_modules += $$(LOCAL_MODULE)
include $$(BUILD_PREBUILT)
endef

define _build-powervr-prebuilt-apphint
include $$(CLEAR_VARS)
LOCAL_MODULE                := $(notdir $1)
LOCAL_MODULE_CLASS          := ETC
LOCAL_SRC_FILES             := $$(TARGET_BOARD_PLATFORM)/vendor/etc/$1
LOCAL_MODULE_PATH           := $(dir $$(TARGET_OUT_VENDOR)/etc/$1)
_modules += $$(LOCAL_MODULE)
include $$(BUILD_PREBUILT)
endef

_file :=
_modules :=
powervr_prebuilts:
    $(foreach _file, $(POWERVR_PREBUILT_LIBS), \
        $(eval $(call _build-powervr-prebuilt-lib,$(_file),$(TARGET_BOARD_PLATFORM)/vendor)))
    $(foreach _file, $(POWERVR_PREBUILT_EXEC), \
        $(eval $(call _build-powervr-prebuilt-exec,$(_file))))
    $(foreach _file, $(POWERVR_PREBUILT_FW), \
        $(eval $(call _build-powervr-prebuilt-fw,$(_file))))
    $(foreach _file, $(POWERVR_PREBUILT_APPHINT), \
        $(eval $(call _build-powervr-prebuilt-apphint,$(_file))))

include $(CLEAR_VARS)
LOCAL_MODULE                := powervr_prebuilts
LOCAL_MODULE_TAGS           := optional
LOCAL_REQUIRED_MODULES      := $(_modules)
include $(BUILD_PHONY_PACKAGE)

endif # $(TARGET_PRODUCT) salvator ulcb kingfisher

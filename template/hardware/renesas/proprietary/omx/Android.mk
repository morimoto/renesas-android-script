#
# Copyright (C) 2019 GlobalLogic
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

# Include only for Renesas ones.
ifneq (,$(filter $(TARGET_PRODUCT),salvator ulcb kingfisher))

LOCAL_PATH := $(call my-dir)

define build-omxr-prebuilt-config
include $(CLEAR_VARS)
LOCAL_MODULE := $(1)
LOCAL_MODULE_CLASS := ETC
LOCAL_PROPRIETARY_MODULE := true
LOCAL_SRC_FILES := configs/$(1)
include $(BUILD_PREBUILT)
endef

define build-omxr-prebuilt-lib
include $(CLEAR_VARS)
LOCAL_MODULE := $(1)
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_PROPRIETARY_MODULE := true
LOCAL_CHECK_ELF_FILES := false

ifeq ($(TARGET_32_BIT_MEDIASERVER),true)
LOCAL_MULTILIB := 32
LOCAL_SRC_FILES := prebuilts/lib/$(1)
else
LOCAL_MULTILIB := 64
LOCAL_SRC_FILES := prebuilts/lib64/$(1)
endif

include $(BUILD_PREBUILT)
endef

MY_OMXR_PREBUILT_CONFIGS_COMMON := \
    omxr_config_base.txt \
    omxr_config_vdcmn.txt \
    omxr_config_vecmn.txt

MY_OMXR_PREBUILT_LIBS_COMMON := \
    libomxr_core.so \
    libomxr_mc_cmn.so \
    libomxr_mc_vcmn.so \
    libomxr_mc_vdcmn.so \
    libomxr_mc_vecmn.so \
    libuvcs_dec.so \
    libuvcs_enc.so

MY_OMXR_PREBUILT_LIBS_H263D := \
    libomxr_mc_h263d.so \
    libuvcs_hv3d.so

MY_OMXR_PREBUILT_LIBS_H264D := \
    libomxr_mc_h264d.so \
    libuvcs_avcd.so

MY_OMXR_PREBUILT_LIBS_H265D := \
    libomxr_mc_hevd.so \
    libuvcs_hevd.so

MY_OMXR_PREBUILT_LIBS_MPEG4D := \
    libomxr_mc_m4vd.so \
    libuvcs_m4vd.so

MY_OMXR_PREBUILT_LIBS_VP8D := \
    libomxr_mc_vp8d.so \
    libuvcs_vp8d.so

MY_OMXR_PREBUILT_LIBS_VP9D := \
    libomxr_mc_vp9d.so \
    libuvcs_vp9d.so

MY_OMXR_PREBUILT_LIBS_H264E := \
    libomxr_mc_h264e.so \
    libuvcs_avce.so

MY_OMXR_PREBUILT_LIBS_VP8E := \
    libomxr_mc_vp8e.so \
    libuvcs_vp8e.so

$(foreach config,$(MY_OMXR_PREBUILT_CONFIGS_COMMON) \
        omxr_config_h263d.txt \
        omxr_config_h264d.txt \
        omxr_config_h265d.txt \
        omxr_config_m4vd.txt \
        omxr_config_vp8d.txt \
        omxr_config_vp9d.txt \
        omxr_config_h264e.txt \
        omxr_config_vp8e.txt, \
    $(eval $(call build-omxr-prebuilt-config,$(config))))

$(foreach lib,$(MY_OMXR_PREBUILT_LIBS_COMMON) \
        $(MY_OMXR_PREBUILT_LIBS_H263D) \
        $(MY_OMXR_PREBUILT_LIBS_H264D) \
        $(MY_OMXR_PREBUILT_LIBS_H265D) \
        $(MY_OMXR_PREBUILT_LIBS_MPEG4D) \
        $(MY_OMXR_PREBUILT_LIBS_VP8D) \
        $(MY_OMXR_PREBUILT_LIBS_VP9D) \
        $(MY_OMXR_PREBUILT_LIBS_H264E) \
        $(MY_OMXR_PREBUILT_LIBS_VP8E), \
    $(eval $(call build-omxr-prebuilt-lib,$(lib))))

include $(CLEAR_VARS)
LOCAL_MODULE := omxr_prebuilts_common
LOCAL_REQUIRED_MODULES := \
    $(MY_OMXR_PREBUILT_CONFIGS_COMMON) \
    $(MY_OMXR_PREBUILT_LIBS_COMMON)
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := omxr_prebuilts_h263d
LOCAL_REQUIRED_MODULES := \
    omxr_config_h263d.txt \
    $(MY_OMXR_PREBUILT_LIBS_H263D)
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := omxr_prebuilts_h264d
LOCAL_REQUIRED_MODULES := \
    omxr_config_h264d.txt \
    $(MY_OMXR_PREBUILT_LIBS_H264D)
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := omxr_prebuilts_h265d
LOCAL_REQUIRED_MODULES := \
    omxr_config_h265d.txt \
    $(MY_OMXR_PREBUILT_LIBS_H265D)
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := omxr_prebuilts_mpeg4d
LOCAL_REQUIRED_MODULES := \
    omxr_config_m4vd.txt \
    $(MY_OMXR_PREBUILT_LIBS_MPEG4D)
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := omxr_prebuilts_vp8d
LOCAL_REQUIRED_MODULES := \
    omxr_config_vp8d.txt \
    $(MY_OMXR_PREBUILT_LIBS_VP8D)
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := omxr_prebuilts_vp9d
LOCAL_REQUIRED_MODULES := \
    omxr_config_vp9d.txt \
    $(MY_OMXR_PREBUILT_LIBS_VP9D)
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := omxr_prebuilts_h264e
LOCAL_REQUIRED_MODULES := \
    omxr_config_h264e.txt \
    $(MY_OMXR_PREBUILT_LIBS_H264E)
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := omxr_prebuilts_vp8e
LOCAL_REQUIRED_MODULES := \
    omxr_config_vp8e.txt \
    $(MY_OMXR_PREBUILT_LIBS_VP8E)
include $(BUILD_PHONY_PACKAGE)

endif # $(TARGET_PRODUCT) salvator ulcb kingfisher

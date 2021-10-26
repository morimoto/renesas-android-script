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
    omxr_config_h263d.txt \
    omxr_config_h264d.txt \
    omxr_config_h264e.txt \
    omxr_config_h265d.txt \
    omxr_config_m4vd.txt \
    omxr_config_vdcmn.txt \
    omxr_config_vecmn.txt

MY_OMXR_PREBUILT_CONFIGS_VP8 := \
    omxr_config_vp8d.txt \
    omxr_config_vp8e.txt

MY_OMXR_PREBUILT_CONFIGS_VP9 := \
    omxr_config_vp9d.txt

MY_OMXR_PREBUILT_LIBS_COMMON := \
    libomxr_core.so \
    libomxr_mc_cmn.so \
    libomxr_mc_h263d.so \
    libomxr_mc_h264d.so \
    libomxr_mc_h264e.so \
    libomxr_mc_hevd.so \
    libomxr_mc_m4vd.so \
    libomxr_mc_vcmn.so \
    libomxr_mc_vdcmn.so \
    libomxr_mc_vecmn.so \
    libuvcs_avcd.so \
    libuvcs_avce.so \
    libuvcs_dec.so \
    libuvcs_enc.so \
    libuvcs_hevd.so \
    libuvcs_hv3d.so \
    libuvcs_m4vd.so

MY_OMXR_PREBUILT_LIBS_VP8 := \
    libomxr_mc_vp8d.so \
    libomxr_mc_vp8e.so \
    libuvcs_vp8e.so \
    libuvcs_vp8d.so

MY_OMXR_PREBUILT_LIBS_VP9 := \
    libomxr_mc_vp9d.so \
    libuvcs_vp9d.so

$(foreach config,$(MY_OMXR_PREBUILT_CONFIGS_COMMON) $(MY_OMXR_PREBUILT_CONFIGS_VP8) $(MY_OMXR_PREBUILT_CONFIGS_VP9), \
    $(eval $(call build-omxr-prebuilt-config,$(config))))

$(foreach lib,$(MY_OMXR_PREBUILT_LIBS_COMMON) $(MY_OMXR_PREBUILT_LIBS_VP8) $(MY_OMXR_PREBUILT_LIBS_VP9), \
    $(eval $(call build-omxr-prebuilt-lib,$(lib))))

include $(CLEAR_VARS)
LOCAL_MODULE := omxr_prebuilts_common
LOCAL_REQUIRED_MODULES := \
    $(MY_OMXR_PREBUILT_CONFIGS_COMMON) \
    $(MY_OMXR_PREBUILT_LIBS_COMMON)
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := omxr_prebuilts_vp8
LOCAL_REQUIRED_MODULES := \
    $(MY_OMXR_PREBUILT_CONFIGS_VP8) \
    $(MY_OMXR_PREBUILT_LIBS_VP8)
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := omxr_prebuilts_vp9
LOCAL_REQUIRED_MODULES := \
    $(MY_OMXR_PREBUILT_CONFIGS_VP9) \
    $(MY_OMXR_PREBUILT_LIBS_VP9)
include $(BUILD_PHONY_PACKAGE)

endif # $(TARGET_PRODUCT) salvator ulcb kingfisher

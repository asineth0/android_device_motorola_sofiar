# Copyright (C) 2010 The Android Open Source Project
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
# This file is the build configuration for a full Android
# build for grouper hardware. This cleanly combines a set of
# device-specific aspects (drivers) with a device-agnostic
# product configuration (apps).
#
DEVICE_PATH := device/motorola/sofiar

include $(DEVICE_PATH)/BoardConfigGsi.mk

TARGET_NO_BOOTLOADER := true
TARGET_NO_RECOVERY := false

TARGET_OTA_ASSERT_DEVICE := sofiar

TARGET_BOOTLOADER_BOARD_NAME := trinket
TARGET_BOARD_PLATFORM := trinket
TARGET_BOARD_PLATFORM_GPU := qcom-adreno610

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a9

TARGET_USE_QCOM_BIONIC_OPTIMIZATION := true
TARGET_USES_64_BIT_BINDER := true
TARGET_COMPILE_WITH_MSM_KERNEL := true

BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200,n8 androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 swiotlb=1 earlycon=msm_geni_serial,0x4a90000 loop.max_part=7 cgroup.memory=nokmem,nosocket androidboot.usbcontroller=4e00000.dwc3 printk.devkmsg=on firmware_class.path=/vendor/firmware_mnt/image
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_RAMDISK_OFFSET     := 0x01000000
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
TARGET_KERNEL_SOURCE := kernel/motorola/trinket
TARGET_KERNEL_CONFIG := vendor/sofiar_defconfig
TARGET_KERNEL_ADDITIONAL_FLAGS := \
	DTC=$(shell pwd)/device/motorola/sofiar/dtc/dtc
TARGET_KERNEL_VERSION := 4.14
TARGET_KERNEL_CLANG_COMPILE := true
TARGET_KERNEL_CLANG_VERSION := r328903

BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_BOOT_HEADER_VERSION := 2
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

BOARD_ROOT_EXTRA_FOLDERS += firmware firmware/radio persist bt_firmware
BOARD_ROOT_EXTRA_SYMLINKS += /vendor/lib/dsp:/dsp
BOARD_ROOT_EXTRA_SYMLINKS += /vendor/firmware_mnt/image:/firmware/image
BOARD_ROOT_EXTRA_SYMLINKS += /vendor/firmware_mnt/verinfo:/firmware/verinfo

BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_DTBOIMG_PARTITION_SIZE := 25165824
BOARD_USERDATAIMAGE_PARTITION_SIZE := 116995371008
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 536870912
BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 67108864
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4

BOARD_SUPER_PARTITION_SIZE := 8690597888
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 4341104640
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    product

TARGET_SPECIFIC_HEADER_PATH := $(DEVICE_PATH)/include
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USES_MKE2FS := true

# Generic AOSP image always requires separate vendor.img
TARGET_COPY_OUT_VENDOR := vendor

BOARD_USES_SNAPDRAGONCAMERA_VERSION := 2

BOARD_SUPPRESS_SECURE_ERASE := true

# charger
HEALTHD_USE_BATTERY_INFO := true
BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_CHARGER_DISABLE_INIT_BLANK := true

BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

#include vendor/omni/sepolicy/sepolicy.mk
BOARD_PLAT_PUBLIC_SEPOLICY_DIR += $(DEVICE_PATH)/sepolicy/public
BOARD_PLAT_PRIVATE_SEPOLICY_DIR += $(DEVICE_PATH)/sepolicy/private
BOARD_PLAT_PUBLIC_SEPOLICY_DIR += \
    device/qcom/sepolicy/generic/public \
    device/qcom/sepolicy/qva/public

BOARD_PLAT_PRIVATE_SEPOLICY_DIR += \
    device/qcom/sepolicy/generic/private \
    device/qcom/sepolicy/qva/private

BOARD_SECCOMP_POLICY += $(DEVICE_PATH)/seccomp_policy

PRODUCT_FULL_TREBLE := true
BOARD_VNDK_VERSION := current
BOARD_VNDK_RUNTIME_DISABLE := false
TARGET_NO_KERNEL := false
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_hashtree_disabled_flag
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 2
BOARD_USES_VENDORIMAGE := true

# AVB
# Enable chain partition for system and product
BOARD_AVB_VBMETA_SYSTEM := system product
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

# Init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):libinit_moto_trinket

PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)
PRODUCT_SOONG_NAMESPACES += vendor/motorola/sofiar

TARGET_COPY_OUT_PRODUCT := product
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery_dynamic_partition.fstab

# Split selinux policy
PRODUCT_SEPOLICY_SPLIT := true

# Android generic system image always create metadata partition
BOARD_USES_METADATA_PARTITION := true

BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_PHONY_TARGETS := true

DEXPREOPT_GENERATE_APEX_IMAGE := true
TARGET_FLATTEN_APEX := true
USE_XML_AUDIO_POLICY_CONF := 1


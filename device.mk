# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
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
PRODUCT_PACKAGES += com.android.apex.cts.shim.v1_prebuilt
TARGET_FLATTEN_APEX := false

# Prebuilt
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,device/motorola/sofiar/prebuilt/product,product) \
    $(call find-copy-subdir-files,*,device/motorola/sofiar/prebuilt/root,recovery/root) \
    $(call find-copy-subdir-files,*,device/motorola/sofiar/prebuilt/permissions,product/etc/permissions) \
    $(call find-copy-subdir-files,*,device/motorola/sofiar/prebuilt/system,system) \
    $(call find-copy-subdir-files,*,device/motorola/sofiar/prebuilt/permissions,system/etc/permissions) \
    $(call find-copy-subdir-files,*,device/motorola/sofiar/prebuilt/ramdisk,ramdisk)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.version.all_codenames=$(PLATFORM_VERSION_ALL_CODENAMES) \
    ro.build.version.codename=$(PLATFORM_VERSION_CODENAME) \
    ro.build.version.release=$(PLATFORM_VERSION) \
    ro.build.version.sdk=$(PLATFORM_SDK_VERSION)

AB_OTA_PARTITIONS += \
    boot \
    system \
    vbmeta \
    product

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/copy_ab_partitions \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

PRODUCT_PACKAGES += \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier \
    copy_ab_partitions

PRODUCT_HOST_PACKAGES += \
    brillo_update_payload

# Boot control
PRODUCT_PACKAGES_DEBUG += \
    bootctl

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl.recovery \
    bootctrl.trinket.recovery \
    fastbootd

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

#PRODUCT_PACKAGES += \
#    omni_charger_res_images \
#    animation.txt \
#    font_charger.png

PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

# Live Wallpapers
PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    VisualizationWallpapers \
    librs_jni

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.verified_boot.xml

PRODUCT_AAPT_CONFIG := xxxhdpi
PRODUCT_AAPT_PREF_CONFIG := xxxhdpi
PRODUCT_CHARACTERISTICS := nosdcard

# Camera
PRODUCT_PACKAGES += \
    SnapdragonCamera2

# ANT+
#PRODUCT_PACKAGES += \
#    AntHalService

# QMI
PRODUCT_PACKAGES += \
    libjson

PRODUCT_PACKAGES += \
    ims-ext-common \
    ims_ext_common.xml \
    qti-telephony-hidl-wrapper \
    qti_telephony_hidl_wrapper.xml \
    qti-telephony-utils \
    qti_telephony_utils.xml \
    tcmiface

# Netutils
PRODUCT_PACKAGES += \
    netutils-wrapper-1.0 \
    libandroid_net

PRODUCT_PACKAGES += \
    LineageActions

PRODUCT_PACKAGES += \
    vndk_package

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0

PRODUCT_PACKAGES += \
    vendor.display.config@1.10 \
    libdisplayconfig \
    libqdMetaData.system \
    libqdMetaData

#Nfc
PRODUCT_PACKAGES += \
    android.hardware.nfc@1.0 \
    android.hardware.nfc@1.1 \
    android.hardware.nfc@1.2

# Display
PRODUCT_PACKAGES += \
    libion \
    libtinyxml2

PRODUCT_PACKAGES += \
    libtinyalsa


# TODO(b/78308559): includes vr_hwc into GSI before vr_hwc move to vendor
PRODUCT_PACKAGES += \
    vr_hwc

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/media_codecs_google_video.xml

PRODUCT_PACKAGES += \
    vendor.qti.hardware.wifi@1.0

# Remove unwanted packages
PRODUCT_PACKAGES += \
    RemovePackages

PRODUCT_PACKAGES += \
    MotoRav

# Video seccomp policy files
PRODUCT_COPY_FILES += \
    device/motorola/sofiar/seccomp/codec2.software.ext.policy:$(TARGET_COPY_OUT)/etc/seccomp_policy/codec2.software.ext.policy

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service.trinket

# Temporary handling
#
# Include config.fs get only if legacy device/qcom/<target>/android_filesystem_config.h
# does not exist as they are mutually exclusive.  Once all target's android_filesystem_config.h
# have been removed, TARGET_FS_CONFIG_GEN should be made unconditional.
DEVICE_CONFIG_DIR := $(dir $(firstword $(subst ]],, $(word 2, $(subst [[, ,$(_node_import_context))))))
ifeq ($(wildcard device/motorola/sofiar/android_filesystem_config.h),)
  TARGET_FS_CONFIG_GEN := device/motorola/sofiar/config.fs
else
  $(warning **********)
  $(warning TODO: Need to replace legacy $(DEVICE_CONFIG_DIR)android_filesystem_config.h with config.fs)
  $(warning **********)
endif

$(call inherit-product, build/make/target/product/gsi_keys.mk)

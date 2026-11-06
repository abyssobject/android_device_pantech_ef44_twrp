#
# TWRP 3.7.1 (twrp-12.1 minimal manifest) for the Pantech VEGA S5 (IM-A840S, ef44)
#
DEVICE_PATH := device/pantech/ef44

# Platform: Snapdragon S4 Pro (MSM8960, Krait), 32-bit
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := krait
TARGET_BOARD_PLATFORM := msm8960
TARGET_BOOTLOADER_BOARD_NAME := MSM8960
TARGET_NO_BOOTLOADER := true
# Android 12's libbinder only builds for the 64-bit binder ABI. The 3.4 kernel
# speaks the old 32-bit one, so binder services won't run in this recovery;
# TWRP's UI, adb, MTP and backups don't need them (battery comes from sysfs)
TARGET_USES_64_BIT_BINDER := true

# Kernel: the LineageOS ef44 kernel, built by ef44-port/twrp/build-twrp.sh
# (TARGET_PREBUILT_KERNEL is copied in as prebuilt/zImage)
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/zImage
BOARD_KERNEL_BASE := 0x80200000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x3F \
    kgsl.mmutype=gpummu androidboot.emmc=true vmalloc=0x16000000 \
    androidboot.selinux=permissive
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x02000000 --tags_offset 0x00000100

# Partitions (recovery is mmcblk0p20, 10 MiB)
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 10485760
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1468006400
BOARD_USERDATAIMAGE_PARTITION_SIZE := 13136478208
TARGET_USERIMAGES_USE_EXT4 := true
# recovery/root/system/etc/mke2fs.conf keeps formatted ext4 mountable by the
# 3.4 kernel: without it mke2fs 1.45 defaults to metadata_csum (needs 3.18)
# and Format Data leaves /data and /cache unmountable for TWRP and the ROM
TARGET_COPY_OUT_VENDOR := vendor
BOARD_SUPPRESS_SECURE_ERASE := true

# The whole recovery has to fit the 10 MiB partition with the kernel: LZMA
# ramdisk (legacy .lzma, which the kernel unpacks with CONFIG_RD_LZMA; it has
# no CONFIG_RD_XZ for BOARD_RAMDISK_USE_XZ)
BOARD_RAMDISK_USE_LZMA := true

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_QCOM_RTC_FIX := true
BOARD_HAS_NO_SELECT_BUTTON := true
RECOVERY_SDCARD_ON_DATA := true

# Android 12 build system on an old device tree
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_MISSING_REQUIRED_MODULES := true
PLATFORM_VERSION := 16.1.0
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# TWRP
TW_THEME := portrait_hdpi
TW_DEVICE_VERSION := ef44
TW_BRIGHTNESS_PATH := /sys/class/leds/lcd-backlight/brightness
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 160
TW_INTERNAL_STORAGE_PATH := "/data/media/0"
TW_INTERNAL_STORAGE_MOUNT_POINT := "data"
TW_EXTERNAL_STORAGE_PATH := "/external_sd"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "external_sd"
TW_NO_SCREEN_BLANK := true
# ef44's own init.recovery.usb.rc (legacy android_usb, Pantech USB IDs)
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
# Off unless set (this branch tests TW_ flags with ifneq, so "false" means on).
# Crypto stays off: ef44 uses FDE at most, which this branch can't decrypt
# Leave out what does not fit in 10 MiB
TW_USE_TOOLBOX := true
TW_EXCLUDE_TWRPAPP := true
TW_EXCLUDE_APEX := true
TW_EXCLUDE_PYTHON := true
TW_EXCLUDE_NANO := true
TW_EXCLUDE_BASH := true
TW_EXCLUDE_LPDUMP := true
TW_EXCLUDE_LPTOOLS := true
# (TW_EXCLUDE_ENCRYPTED_BACKUPS is inverted on this branch: left unset, the
# backup encryption and its libopenaes stay out)
TW_NO_EXFAT_FUSE := true
TW_EXCLUDE_SUPERSU := true
TW_USE_LEGACY_BATTERY_SERVICES := true

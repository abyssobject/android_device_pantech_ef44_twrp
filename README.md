# TWRP 3.7.1 디바이스 트리 — Pantech VEGA S5 (IM-A840S, ef44)

twrp-12.1 minimal manifest로 빌드하는 VEGA S5(MSM8960, 32비트 ARMv7, 3.4 커널)용
TWRP 3.7.1_12 디바이스 트리입니다.

## 동작하는 기능

- 화면, 터치, 밝기, 화면 끄기·켜기, 진동, 배터리 표시
- /system, /data, /cache, /persist, EFS, 모뎀, 외장 SD 인식과 마운트
- 백업과 복원, 포맷과 초기화, ROM zip 설치
- ADB, MTP(내부 저장소와 SD), adb sideload

암호화된 /data의 복호화는 지원하지 않습니다(FDE, 바인더 필요).

## 필요한 것

1. **TWRP 소스**: twrp-12.1 minimal manifest
   ```
   repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1
   repo sync
   ```
2. **커널**: [android_kernel_pantech_ef44](https://github.com/abyssobject/android_kernel_pantech_ef44)
   `lineage-14.1` 브랜치를 `twrp_ef44s_defconfig`로 빌드한 zImage를 `prebuilt/zImage`에 넣습니다.
   Android 12 init과 TWRP가 3.4 커널에서 동작하려면 이 브랜치의 수정이 필요합니다.
   - `vfs`: O_PATH 파일 디스크립터에 fstat 허용
   - `mm`: vm.mmap_rnd_bits
   - 터치 부팅 보정, 밝기 0에서 백라이트 끄기
3. **TWRP 소스 패치**: 이 커널의 USB 가젯은 FunctionFS가 없어서 adb와 MTP는 구형 장치를 써야 합니다.
   - `packages/modules/adb`: adbd가 `/dev/android_adb`를 사용
   - `bootable/recovery`:
     - minadbd(sideload)도 같은 장치를 사용
     - MTP 장치를 한 번만 열도록 수정
     - 전송이 실패하면 MTP 항목을 삭제

## 빌드

```
. build/envsetup.sh
lunch twrp_ef44-eng
mka recoveryimage
```

빌드 결과는 약 12.8MB라서 10MB 리커버리 파티션에 들어가지 않습니다(빌드 마지막의 "too large" 오류는 정상입니다).
다음 작업으로 줄인 뒤 다시 패킹합니다.

- 아무도 링크하지 않는 ICU 라이브러리, 3.4 커널에서 동작하지 않는 바인더 서비스(service manager, health HAL, charger), 영어 외 번역을 뺍니다.
- 램디스크를 `lzma -9`로 압축합니다. 커널은 `CONFIG_RD_LZMA`만 지원하고 XZ는 지원하지 않습니다.
- `mkbootimg`로 다시 패킹합니다:
  `--base 0x80200000 --pagesize 2048 --ramdisk_offset 0x02000000 --tags_offset 0x00000100`

최종 이미지는 약 10.3MB입니다.

## 참고

- 리커버리 파티션 mmcblk0p20(10MB)이고, 부트 파티션은 mmcblk0p7(9MB)입니다.
- `recovery/root/system/etc/mke2fs.conf`는 포맷할 때 metadata_csum과 64bit를 쓰지 않도록 합니다.
  이 두 기능을 쓰면 3.4 커널에서 /data와 /cache를 마운트할 수 없습니다.
- 이 기기의 부트로더는 `fastboot boot`를 지원해서, 플래시하지 않고 이미지를 테스트할 수 있습니다.

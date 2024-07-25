# OC-XPS-7590

[XPS 7590 with OpenCore](https://github.com/gorquan/OC-XPS-7590)的后续维护版本，已经获得作者本人授权，感谢原作者的无私奉献，让我们能够在 XPS 7590 上安装 MacOS。本仓库将持续更新，以适配最新的 Opencore 版本和 MacOS 版本。

x64 的 Hackintosh 已经时日无多，让我们且行且珍惜。

## 引导版本

- OpenCore: 1.0.1 开发版（使用[Opencore Auxiliary Tools](https://github.com/ic005k/OCAuxiliaryTools)同步最新版本）

- MacOS: 适配 MacOS 15 public beta 1

## 配置信息

| Key        | Value                          |
| ---------- | ------------------------------ |
| 型号       | XPS-7590                       |
| CPU        | Intel Core i5 9300H            |
| 核芯显卡   | Intel UHD Graphics 630         |
| 内建显示屏 | SHP14BA 15.6" 1080p **非触屏** |
| 内存       | Samsung 16GB DDR4 2666MHz x2   |
| 板载声卡   | Realtek ALC298/ALC3266         |
| 无限网卡   | Killer AX1650x (200NGW)        |

## 使用前注意

- **请先参考该文章：[XPS 7590 1.6.0 UEFI: unlock undervolting and remove CFG lock](https://www.reddit.com/r/Dell/comments/fzv599/xps_7590_160_uefi_unlock_undervolting_and_remove/)，对 CFG Lock 进行解锁再使用该 OpenCore！**
- 请先在 BIOS 中将 SATA Mode 设置为 AHCI。
- 极其不建议使用 OpenCore 对 Windows 进行引导！若要切换开机引导，建议按 F12 选择引导设备。
- 使用前请先**更新序列号**，即`MLB`、`SystemSerialNumber`和`SystemUUID`，我在 config 中使用`Generate One`进行占位，使用时请自行生成。
- 推荐的 config 编辑工具：[Opencore Auxiliary Tools](https://github.com/ic005k/OCAuxiliaryTools)

## 工作情况

**需要注意**：Wi-Fi 暂时没有原生驱动，I2C 触控板驱动做出了调整

- CPU：
  - 正常变频,最低频率 800MHz
  - 温度正常
  - CPU 的调度可以通过[One Key CPU Friend](https://github.com/stevezhengshiqi/one-key-cpufriend)进行调整
  - 应该不会再出现高负载锁 800Mhz 的玄学情况
- 板载声卡：
  - 正常工作
  - 支持耳机、内置扬声器和 HDMI 音频输出
  - 支持内建麦克风
  - 当前版本 UAC 设备可用
- 核芯显卡：
  - 正常工作
  - 支持 HDMI 输出
  - 优化亮度调节
- 内建显示屏：
  - 正常工作
- 电池：
  - 正常工作
  - 续航时间可以长达 5 小时（电池健康情况下）
- **无线网卡**：
  - 暂时没有原生驱动
  - 需要使用[itlwm](https://github.com/OpenIntelWireless/itlwm/releases)
  - 需要搭配使用[HeliPort](https://github.com/OpenIntelWireless/HeliPort/releases)
- **蓝牙**：
  - macOS 15 到目前为止蓝牙不需要修改
  - 除 AirPods Pro 2 外正常工作 [No audio output on Airpods Pro 2 #462](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/issues/462)
  - 能够与其他设备正常连接
  - 睡眠唤醒可能需要执行 `sudo killall bluetoothd` 重启 bluetoothd，我用 sleepwatcher 设置了自动化
  - 不同的系统对蓝牙 kext 的要求不同，详见[OpenIntelWireless/IntelBluetoothFirmware](https://openintelwireless.github.io/IntelBluetoothFirmware/FAQ.html#what-additional-steps-should-i-do-to-make-bluetooth-work-on-macos-monterey-and-newer)
- 键盘：
  - 正常工作
  - 键盘灯能够正常显示
  - 快捷键正常工作
- **触控板**：
  - 正常工作
  - macOS 15 移除了非妙控板以外的所有触控板的 id，所以需要修改 VoodooInput，已经替换，验证正常工作。
- 睡眠：
  - 正常工作
  - 盒盖睡眠正常工作
- 休眠：
  - 正常工作
  - 休眠唤醒正常工作
- 读卡器：
  - 我的读卡器损坏了，无法测试
- USB
  - 所有 USB 端口正常工作
  - 支持安卓手机 USB 网络共享功能（已经启用`HoRNDIS.kext`）
  - C 口正常工作，支持 USB3.1 设备热插拔
  - 雷电口理论上正常工作，未测试

### 存在问题的设备

- 独显
  - 无法进行驱动，已经屏蔽
- 读卡器
  - 未知

## 结构目录

- 最新版会提供完整的 EFI，目前仓库最新版：**1.0.1**
- 建议自己使用 OCAT 进行后续维护

- BOOT EFI 标准引导文件夹
  - BOOTx64.efi 用于引导 OpenCore，同时解决 Windows 抢占引导优先级问题
- OC OpenCore 引导程序文件夹

  - ACPI DSDT/SSDT 补丁文件夹
    - SSDT-AWAC-DISABLE.aml 用于禁用 AWAC 来启动 RTC
    - SSDT-EC-USBX.aml 用于在 EC 正常工作时修复 USB 电源
    - SSDT-EC.aml & SSDT-USBX.aml 用于 fake EC 以及提供 USB 供电，上述两种方案二选一。
    - SSDT-PLUG.aml 用于修复电源管理，Monterey 以上不再需要
    - SSDT-PTSWAK.aml 用于修复睡眠唤醒
    - SSDT-NDGP_OFF.aml 用于禁用独显
    - SSDT-EXT4-WakeScreen.aml 用于唤醒后亮屏
    - SSDT-LIDPatch.aml 用于盒盖睡眠
    - [SSDT-FnInsert_BTNV_dell.aml](#引导补充说明)
    - SSDT-TB3-7590.aml 用于雷电口
  - Kexts 内核补丁
    - Lilu 用于提供插件支持
    - VirtualSMC 用于提供虚拟 SMC
    - WhateverGreen 用于提供核显支持
    - AppleALC 用于提供声卡支持
    - BlueToolFixup 用于提供蓝牙支持
    - IntelBluetoothFirmware 用于提供蓝牙支持
    - Itlwm 用于提供无线网卡支持
    - NVMeFix 用于修复 NVMe 问题
    - SMCBatteryManager 用于提供电池支持
    - SMCProcessor 用于提供 CPU 信息支持
    - SMCSuperIO 用于提供风扇支持
    - SMCLightSensor 用于提供光感支持
    - SMCDellSensors 用于提供 dell 传感器支持
    - USBMap 用于定制 USB
    - VoodooI2C 用于提供触控板支持
    - VoodooI2CHID 用于提供触控板支持
    - VoodooPS2Controller 用于提供键盘支持
    - VerbStub 用于提供声卡支持
    - CPUFriend 用于提供 CPU 电源管理
    - CPUFriendDataProvider 用于提供 CPU 电源管理
    - HibernateFixup 用于修复休眠问题
    - HoRNDIS 用于支持安卓手机 USB 网络共享
    - RestrictEvents 用于修复 OTA 问题
  - Drivers 驱动
    - HfsPlus 用于支持 HFS+ 格式
    - OpenCanopy 用于提供 OpenCore 引导界面
    - OpenRuntime 用于提供 OpenCore 运行时支持
  - Resources 随本仓库提供几个自用的引导主题，可以自行选择使用
  - Tools 工具
    - CleanNvram 用于清理 NVRAM

- boot-args 说明

  - 必需参数

    - -igfxblt -igfxbls: 修复 Coffee Lake 核显开机黑屏问题，优化亮度调节
    - agdpmod=vit9696 独显配置
    - alcverbs=1 用于修复耳机爆音问题
    - -lilubetaall 引导测试版系统时候使用
    -

  - 可选参数

    - -v 显示详细启动信息，可用于调试
    - igfxfw=2 启用核显固件补丁，提高性能
    - darkwake=3 睡眠小憩配置，实测设置为 darkwake=3 没有什么问题
    - revpatch=sbvmm 配合`RestrictEvents.kext`用于修复 OTA 问题，若仍然无法 OTA 请临时禁用`BluetoolFixup`，更新完毕重新启用即可

## 驱动情况

- 全部驱动为更新时最新
- 建议自己使用 OCAT 更新驱动
- 可能需要根据系统微调驱动，参见各驱动的仓库

## 本仓库引导更新日志

[原仓库更新日志](https://github.com/gorquan/OC-XPS-7590?tab=readme-ov-file#引导更新日志)：**原仓库更新日志请移步原仓库查看**

- 2024-06-17

  - 完善文档
  - 补充丢失的 kexts

- 2024-06-12

  - 更新 OpenCore 到 1.0.1
  - 同步最新 kexts

## 引导补充说明

- 由于采用了 PNP0C0D 睡眠，因此 Fn+Insert 在外接 HDMI 情况下将关闭内屏而不是睡眠，当不外接 HDMI 时电脑将进行睡眠

### 进入系统后优化

- 对于睡眠部分，请参考[睡眠设置](#睡眠处理)
- 对于电池供电下唤醒导致耳机爆音/无声等问题，请参考[声卡问题处理](#声卡问题处理)

### 睡眠处理

1. 检查 hibernatemode 是否为 0 或 3

```shell
pmset -g | grep hibernatemode
```

2. 在终端执行以下命令

```shell
sudo pmset -a standby 0
sudo pmset -a proximitywake 0
sudo pmset -a hibernatemode 3 # 如果hibernatemode 不为3或0 执行此条命令
sudo pmset -a tcpkeepalive 0 # 如果仍然睡不着可以尝试一下睡眠期间断开网络连接
```

3. 除了“当显示器关闭时，防止电脑自动进入睡眠”是可选的外，请关闭设置-节能器里的所有其他选项。

### 声卡问题处理

板载声卡如果在电池供电状态下使用耳机，并从睡眠中唤醒会出现无声/爆音问题

- 原因

唤醒前`nid = 0x18 --> result 0x00000024`，唤醒后`nid = 0x18 --> result 0x00000000`，更改`nid = 0x18`的`result`为`0x00000024`即可正常发声

- 解决方式

有两种解决方式

- 使用[ALCPlugFix](https://github.com/gorquan/ALCPlugFix),出现问题后**插拔耳机**
- 执行以下命令：`alc-verb 0x18 SET_PIN_WIDGET_CONTROL 0x24`，需要参考**alc-verb 安装**步骤

- alc-verb 安装

`alc-verb`可以从 AppleALC 中获取，下载后请将其**放置**在`/usr/local/bin`目录下面

- 注意

如果采用两者，则**不要**再将`alc-verb`安装在`/usr/local/bin`目录下面，因为`ALCPlugFix`已经安装`alc-verb`到`/usr/local/bin`下。

### 尚未测试

- 雷电是否工作

## 感谢

- Apple
- 各位 Kext 开发者
- [@Acidanthera](https://github.com/acidanthera)
- [@daliansky](https://github.com/daliansky)
- [@geek5nan](https://github.com/geek5nan/Hackintosh-XPS7590)
- [@stevezhengshiqi](https://github.com/stevezhengshiqi)
- [@Dracay](https://github.com/Dracay)
- [@tiger511](https://github.com/tiger511)
- [@shadowed87](https://github.com/shadowed87)
- [@Pinming](https://github.com/Pinming)
- [@tctien342](https://github.com/tctien342)
- [@xxxzc](https://github.com/xxxzc)
- [@romancin](https://github.com/romancin)
- [@cholonam](https://github.com/cholonam)
- [@illusion899](https://github.com/illusion899)
- [@ic005k](https://github.com/ic005k/OCAuxiliaryTools)
- 原仓库作者 [@gorquan](https://github.com/gorquan)

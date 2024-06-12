# OC-XPS-7590

[XPS 7590 with OpenCore](https://github.com/gorquan/OC-XPS-7590)的后续维护版本，已经获得本人授权，感谢原作者的无私奉献，让我们能够在 XPS 7590 上安装 MacOS。本仓库将持续更新，以适配最新的 Opencore 版本和 MacOS 版本。

x64 的 Hackintosh 已经时日无多，让我们且行且珍惜。

## 引导版本

OpenCore: 1.0.1 开发版（使用[Opencore Auxiliary Tools](https://github.com/ic005k/OCAuxiliaryTools)同步最新版本）

MacOS: 理论上从 Big Sur 到 Sonoma 都可以使用，但是建议使用最新的版本，本人正在使用 Sonoma 14.5

## 配置信息

| Key        | Value                       |
| ---------- | --------------------------- |
| 型号       | XPS-7590                    |
| CPU        | Intel Core i7 9300H         |
| 核芯显卡   | Intel Graphics UHD 630      |
| 内建显示屏 | 15.6" 1080p **非触屏**      |
| 内存       | 金士顿 16GB DDR4 2666MHz x2 |
| 板载声卡   | Realtek ALC298/ALC3266      |
| 无限网卡   | Killer AX1650x (200NGW)     |

## 使用前注意

- **请先参考该文章：[XPS 7590 1.6.0 UEFI: unlock undervolting and remove CFG lock](https://www.reddit.com/r/Dell/comments/fzv599/xps_7590_160_uefi_unlock_undervolting_and_remove/)，对 CFG Lock 进行解锁再使用该 OpenCore！**
- 极其不建议使用 OpenCore 对 Windows 进行引导！若要切换开机引导，建议按 F12 选择引导设备。
- 使用前请先**更新序列号**，即`MLB`、`SystemSerialNumber`和`SystemUUID`，我在 config 中使用`Generate One`进行占位，使用时请自行生成。
- 推荐的 config 编辑工具：[Opencore Auxiliary Tools](https://github.com/ic005k/OCAuxiliaryTools)

## 工作情况

- CPU：
  - 正常工作
  - 正常变频,最低频率 800MHz
  - 温度正常
  - CPU 的调度可以通过[One Key CPU Friend](https://github.com/stevezhengshiqi/one-key-cpufriend)进行调整
- 板载声卡：
  - 正常工作
  - 支持耳机、内置扬声器和 HDMI 音频输出
  - 支持内建麦克风
- 核芯显卡：
  - 正常工作
  - 支持 HDMI 输出
  - 优化亮度调节
- 内建显示屏：
  - 正常工作
- 蓝牙：
  - 正常工作
  - 能够与其他设备正常连接
- 电池：
  - 正常工作
  - 续航时间可以长达 5 小时（电池健康情况下）
- 无线网卡：
  - 正常工作(intel 网卡需要使用[AirportItlwm](https://github.com/OpenIntelWireless/itlwm/releases)对应系统的版本)
  - 目前我使用的是 macOS 14.5，安装其他系统且需要使用 intel 网卡的请自行下载对应版本替换
  - 由于苹果在 macOS14 移除了白果卡的支持，因此想要免驱请安装 Ventura 以下的版本
- 蓝牙：
  - 除 AirPods Pro 2 外正常工作 [No audio output on Airpods Pro 2 #462](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/issues/462)
  - 能够与其他设备正常连接
  - 睡眠唤醒可能需要执行 `sudo killall bluetoothd` 重启 bluetoothd，我用 sleepwatcher 设置了自动化
- 键盘：
  - 正常工作
  - 键盘灯能够正常显示
  - 快捷键正常工作
- 触控板：
  - 正常工作
- 睡眠：
  - 正常工作
  - 盒盖睡眠正常工作
- 休眠：
  - 正常工作
  - 休眠唤醒正常工作
- 读卡器：
  - 我的读卡器损坏了，无法测试
- USB
  - 支持安卓手机 USB 网络共享功能

### 存在问题的设备

- 独显
  - 无法进行驱动，已经屏蔽
- 读卡器
  - 未知

## 结构目录

- 最新版会提供完整的 EFI，目前仓库最新版：**1.0.1**
- 建议自己使用 OCAT 进行后续维护

## 驱动情况

- 全部驱动为更新时最新
- 建议自己使用 OCAT 更新驱动
- 可能需要根据系统微调驱动，参见各驱动的仓库

## 本仓库引导更新日志

原仓库更新日志：**原仓库更新日志请移步原仓库查看**

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
- [@Dracay](https://github.com/Dracay)
- [@tiger511](https://github.com/tiger511)
- [@shadowed87](https://github.com/shadowed87)
- [@Pinming](https://github.com/Pinming)
- [@tctien342](https://github.com/tctien342)
- [@xxxzc](https://github.com/xxxzc)
- [@romancin](https://github.com/romancin)
- [@cholonam](https://github.com/cholonam)
- [@illusion899](https://github.com/illusion899)
- 原仓库作者 [@gorquan](https://github.com/gorquan)

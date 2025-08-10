# btusb DKMS Module

This project provides a standalone DKMS (Dynamic Kernel Module Support) package for the `btusb` kernel module.

Why would you need this? Well, hopefully you don't! I made the mistake of buying a USB Dongle which combines Bluetooth and Wi-Fi functionality (TP-Link Archer TX10UB Nano) with the rtl8851bu chipset. So obviously neither the Bluetooth nor the Wi-Fi was working out of the box on my System.

The Wi-Fi part was relatively easy to fix by simply installing the driver [fofajardo/rtl8851bu](https://github.com/fofajardo/rtl8851bu).

The Bluetooth part, however, was... well... easy as well. I noticed that the `btusb` recently got an update with exactly that device in the upstream kernel. So all I had to do was to build the module using DKMS. As I'm on a fairly recent kernel, I guess I could have just waited a few weeks for the update to be included but meh.

Anyway: If you need newer versions of the `btusb` module for your old kernel, this repository might help.

## What does this repository do?

This package automatically downloads and builds the following Bluetooth USB modules from the upstream Linux kernel:
- `btusb` - Main Bluetooth USB driver
- `btintel` - Intel Bluetooth firmware support
- `btbcm` - Broadcom Bluetooth firmware support  
- `btrtl` - Realtek Bluetooth firmware support
- `btmtk` - MediaTek Bluetooth firmware support

These modules provide the latest device support and bug fixes from the upstream kernel.

It automatically downloads and builds the latest versions of these modules. It is not needed to download the whole kernel source.

## Prerequisites

Before installing, make sure you have the necessary packages:

```bash
# On Ubuntu/Debian:
sudo apt update
sudo apt install dkms build-essential linux-headers-$(uname -r) curl

# On RHEL/CentOS/Fedora:
sudo dnf install dkms kernel-devel kernel-headers curl
# or on older versions:
sudo yum install dkms kernel-devel kernel-headers curl

# On Arch Linux:
sudo pacman -S dkms linux-headers curl
```

**Note**: The project requires `curl` or `wget` to download source files automatically.

## Installation

```bash
sudo dkms install .
sudo modprobe -r btusb # unload the original module if loaded
sudo modprobe btusb # load the new module
```

## Uninstallation

```bash
sudo dkms remove btusb/master --all
```

## Add another device

If you have a different device that is compatible with the `btusb` module, you can manually add support for it by following these steps.

1. Download sources
    ```bash
    make download_sources
    ```

2. Make your modifications
    Simply edit `build/btusb.c` to suit your needs.

3. Test build locally (optional but recommended)
    ```bash
    make
    ```

4. Install via DKMS (uses your modified sources)
    ```bash
    sudo dkms install .
    ```

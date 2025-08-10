# SPDX-License-Identifier: GPL-2.0
# Makefile for btusb DKMS module - downloads source files automatically

# URLs for downloading source files from Linux kernel master branch
KERNEL_BASE_URL := https://raw.githubusercontent.com/torvalds/linux/master/drivers/bluetooth

# Use a build directory for all sources and artifacts
BUILD_DIR := build

# Build separate modules like the kernel does
obj-m += btusb.o
obj-m += btintel.o
obj-m += btbcm.o
obj-m += btrtl.o
obj-m += btmtk.o

KDIR ?= /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

# Download source files from kernel repository
all: download_sources
	$(MAKE) -C $(KDIR) M=$(PWD)/$(BUILD_DIR) modules -j$(shell nproc)
	@echo "Copying modules to project directory..."
	@cp $(BUILD_DIR)/*.ko . 2>/dev/null || true

download_sources: $(BUILD_DIR)
	@echo "Downloading Bluetooth USB source files from Linux kernel master..."
	@if [ ! -f $(BUILD_DIR)/btusb.c ]; then \
		echo "Downloading btusb.c..."; \
		curl -sSL $(KERNEL_BASE_URL)/btusb.c -o $(BUILD_DIR)/btusb.c || wget -q $(KERNEL_BASE_URL)/btusb.c -O $(BUILD_DIR)/btusb.c; \
	fi
	@if [ ! -f $(BUILD_DIR)/btintel.c ]; then \
		echo "Downloading btintel.c..."; \
		curl -sSL $(KERNEL_BASE_URL)/btintel.c -o $(BUILD_DIR)/btintel.c || wget -q $(KERNEL_BASE_URL)/btintel.c -O $(BUILD_DIR)/btintel.c; \
	fi
	@if [ ! -f $(BUILD_DIR)/btintel.h ]; then \
		echo "Downloading btintel.h..."; \
		curl -sSL $(KERNEL_BASE_URL)/btintel.h -o $(BUILD_DIR)/btintel.h || wget -q $(KERNEL_BASE_URL)/btintel.h -O $(BUILD_DIR)/btintel.h; \
	fi
	@if [ ! -f $(BUILD_DIR)/btbcm.c ]; then \
		echo "Downloading btbcm.c..."; \
		curl -sSL $(KERNEL_BASE_URL)/btbcm.c -o $(BUILD_DIR)/btbcm.c || wget -q $(KERNEL_BASE_URL)/btbcm.c -O $(BUILD_DIR)/btbcm.c; \
	fi
	@if [ ! -f $(BUILD_DIR)/btbcm.h ]; then \
		echo "Downloading btbcm.h..."; \
		curl -sSL $(KERNEL_BASE_URL)/btbcm.h -o $(BUILD_DIR)/btbcm.h || wget -q $(KERNEL_BASE_URL)/btbcm.h -O $(BUILD_DIR)/btbcm.h; \
	fi
	@if [ ! -f $(BUILD_DIR)/btrtl.c ]; then \
		echo "Downloading btrtl.c..."; \
		curl -sSL $(KERNEL_BASE_URL)/btrtl.c -o $(BUILD_DIR)/btrtl.c || wget -q $(KERNEL_BASE_URL)/btrtl.c -O $(BUILD_DIR)/btrtl.c; \
	fi
	@if [ ! -f $(BUILD_DIR)/btrtl.h ]; then \
		echo "Downloading btrtl.h..."; \
		curl -sSL $(KERNEL_BASE_URL)/btrtl.h -o $(BUILD_DIR)/btrtl.h || wget -q $(KERNEL_BASE_URL)/btrtl.h -O $(BUILD_DIR)/btrtl.h; \
	fi
	@if [ ! -f $(BUILD_DIR)/btmtk.c ]; then \
		echo "Downloading btmtk.c..."; \
		curl -sSL $(KERNEL_BASE_URL)/btmtk.c -o $(BUILD_DIR)/btmtk.c || wget -q $(KERNEL_BASE_URL)/btmtk.c -O $(BUILD_DIR)/btmtk.c; \
	fi
	@if [ ! -f $(BUILD_DIR)/btmtk.h ]; then \
		echo "Downloading btmtk.h..."; \
		curl -sSL $(KERNEL_BASE_URL)/btmtk.h -o $(BUILD_DIR)/btmtk.h || wget -q $(KERNEL_BASE_URL)/btmtk.h -O $(BUILD_DIR)/btmtk.h; \
	fi
	@echo "Creating build Makefile..."
	@echo "obj-m += btusb.o" > $(BUILD_DIR)/Makefile
	@echo "obj-m += btintel.o" >> $(BUILD_DIR)/Makefile
	@echo "obj-m += btbcm.o" >> $(BUILD_DIR)/Makefile
	@echo "obj-m += btrtl.o" >> $(BUILD_DIR)/Makefile
	@echo "obj-m += btmtk.o" >> $(BUILD_DIR)/Makefile
	@echo "All source files ready!"

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Force re-download of sources (for updates)
update-sources:
	@echo "Forcing re-download of source files..."
	@rm -rf $(BUILD_DIR)
	@$(MAKE) download_sources

clean:
	@echo "Removing build directory and downloaded files..."
	@rm -rf $(BUILD_DIR)
	@rm -f *.ko

install:
	$(MAKE) -C $(KDIR) M=$(PWD)/$(BUILD_DIR) modules_install

.PHONY: all clean install download_sources update-sources

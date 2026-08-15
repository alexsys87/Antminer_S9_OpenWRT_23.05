define Device/avnet_zynq-zed
	$(call Device/FitImageGzip)
	DEVICE_VENDOR := Avnet
	DEVICE_MODEL := ZedBoard
endef
TARGET_DEVICES += avnet_zynq-zed

define Device/digilent_zynq-zybo
	$(call Device/FitImageGzip)
	DEVICE_VENDOR := Digilent
	DEVICE_MODEL := Zybo
endef
TARGET_DEVICES += digilent_zynq-zybo

define Device/digilent_zynq-zybo-z7
	$(call Device/FitImageGzip)
	DEVICE_VENDOR := Digilent
	DEVICE_MODEL := Zybo Z7
endef
TARGET_DEVICES += digilent_zynq-zybo-z7

define Device/xlnx_zynq-zc702
	$(call Device/FitImageGzip)
	DEVICE_VENDOR := Xilinx
	DEVICE_MODEL := ZC702
	DEVICE_PACKAGES:=kmod-can kmod-can-xilinx-can
endef
TARGET_DEVICES += xlnx_zynq-zc702

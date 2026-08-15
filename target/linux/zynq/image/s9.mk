define Device/antminer_s9
	$(call Device/FitImageGzip)
	DEVICE_VENDOR := Antminer
	DEVICE_MODEL := S9 (C45)
	DEVICE_DTS := zynq-s9
	IMAGE/sdcard.img.gz := zynq-sdcard-s9 | gzip
endef
TARGET_DEVICES += antminer_s9

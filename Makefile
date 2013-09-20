ARCHS = armv7
THEOS_DEVICE_IP = 192.168.1.109

include theos/makefiles/common.mk

TWEAK_NAME = GoogleTranslateScheme
GoogleTranslateScheme_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

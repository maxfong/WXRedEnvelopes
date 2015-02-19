include theos/makefiles/common.mk

TWEAK_NAME = bonus
bonus_FILES = Tweak.xm
bonus_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

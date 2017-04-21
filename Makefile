GO_EASY_ON_ME=1

DEBUG=0
PACKAGE_VERSION=$(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WhatsAppCustomizer
WhatsAppCustomizer_FILES = Tweak.xm
WhatsAppCustomizer_FRAMEWORKS = UIKit CoreGraphics
WhatsAppCustomizer_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 WhatsApp"

SUBPROJECTS += whatsappcustomizerpref
include $(THEOS_MAKE_PATH)/aggregate.mk

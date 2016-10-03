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

include theos/makefiles/common.mk

TWEAK_NAME = WhatsAppCustomizer
WhatsAppCustomizer_FILES = Tweak.xm
WhatsAppCustomizer_FRAMEWORKS = UIKit CoreGraphics
WhatsAppCustomizer_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 WhatsApp"
	#install.exec "killall -9 Preferences"

SUBPROJECTS += whatsappcustomizerpref
include $(THEOS_MAKE_PATH)/aggregate.mk

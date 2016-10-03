ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = WhatsAppCustomizerPref
WhatsAppCustomizerPref_FILES = WhatsAppCustomizerPref.mm
WhatsAppCustomizerPref_INSTALL_PATH = /Library/PreferenceBundles
WhatsAppCustomizerPref_FRAMEWORKS = UIKit
WhatsAppCustomizerPref_PRIVATE_FRAMEWORKS = Preferences
WhatsAppCustomizerPref_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/WhatsAppCustomizerPref.plist$(ECHO_END)

#include <libcolorpicker.h>
#include <Headers.h>

#define SETTINGS_FILE @"/var/mobile/Library/Preferences/com.fidele007.whatsappcustomizerpref.plist"

%hook WhatsAppAppDelegate
- (void)setWindow:(UIWindow *)arg1 {
	%orig;
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		NSString *tintColor = [settings objectForKey:@"tintColor"];
		[self.window setTintColor:LCPParseColorString(tintColor, @"#007CFF")];
	}
}
%end

%hook UIStatusBarNewUIStyleAttributes
- (id)initWithRequest:(id)arg1 backgroundColor:(id)arg2 foregroundColor:(id)arg3 {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		NSString *statusBarBackgroundColor = [settings objectForKey:@"statusBarBackgroundColor"];
		if (![statusBarBackgroundColor isEqualToString:@"#FFFFFF:0"]) {
			arg2 = LCPParseColorString(statusBarBackgroundColor, @"#FFFFFF:0");
		}
		
		NSString *statusBarForegroundColor = [settings objectForKey:@"statusBarForegroundColor"];
		if (![statusBarForegroundColor isEqualToString:@"#000000:1"]) {
			arg3 = LCPParseColorString(statusBarForegroundColor, @"#000000");
		}
	}
	return %orig;
}
%end

%hook WATheme
// Set font size in Chat
- (void)setFontSize:(double)arg1 {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		if ([[settings objectForKey:@"chatFontSize"] doubleValue]) {
			arg1 = [[settings objectForKey:@"chatFontSize"] doubleValue];
		}
	}
	%orig(arg1);
}

- (UIColor *)tintColor {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		NSString *tintColor = [settings objectForKey:@"tintColor"];
		return LCPParseColorString(tintColor, @"#007CFF");
	}
	return %orig;
}
%end

%hook ContactsViewController
- (void)viewWillAppear:(BOOL)arg1 {
	%orig;
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer && self.tableView) {
		NSString *tintColor = [settings objectForKey:@"tintColor"];
		self.tableView.sectionIndexColor = LCPParseColorString(tintColor, @"#007CFF");
	}
}
%end

%hook ContactTableViewCell
- (void)layoutSubviews {
	%orig;
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		NSString *tintColor = [settings objectForKey:@"tintColor"];
		self.tintColor = LCPParseColorString(tintColor, @"#007CFF");
	}
}
%end

%hook WAContactInfoTableViewCell
- (void)layoutSubviews {
	%orig;
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		NSString *tintColor = [settings objectForKey:@"tintColor"];
		self.tintColor = LCPParseColorString(tintColor, @"#007CFF");
	}
}
- (UILabel *)valueLabel {
	if (%orig) {
		NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
		BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
		if (enabledWhatsAppCustomizer) {
			NSString *tintColor = [settings objectForKey:@"tintColor"];
			UILabel *valueLabel = %orig;
			if (![valueLabel.textColor isEqual:[UIColor blackColor]]) {
				valueLabel.textColor = LCPParseColorString(tintColor, @"#007CFF");
				return valueLabel;
			}
		}
	}
	return %orig;
}
%end

%hook _WANoBlurNavigationBar
- (void)layoutSubviews {
	%orig;
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		// Set navigation bar tint color
		NSString *tintColor = [settings objectForKey:@"tintColor"];
		self.tintColor = LCPParseColorString(tintColor, @"#007CFF");
		// Set navigation bar title color
		NSString *navbarTitleColor = [settings objectForKey:@"navbarTitleColor"];
		self.titleTextAttributes = [NSDictionary dictionaryWithObject:LCPParseColorString(navbarTitleColor, @"#000000") forKey:NSForegroundColorAttributeName];
		// Set navigation bar background color
		NSString *navbarBackgroundColor = [settings objectForKey:@"navbarBackgroundColor"];
		MSHookIvar<UIView *>(self, "_grayBackgroundView").backgroundColor = LCPParseColorString(navbarBackgroundColor, @"#F7F7F7");
	}
}
%end

// Tint tab bar
%hook WATabBarController
- (void)viewWillAppear:(BOOL)arg1 {
	%orig;
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (self.tabBar && enabledWhatsAppCustomizer) {
		NSString *tintColor = [settings objectForKey:@"tintColor"];
		self.tabBar.tintColor = LCPParseColorString(tintColor, @"#007CFF");
	}
}
%end

// Tint all buttons
%hook WAChatListHeaderCell
- (UIButton *)broadcastButton {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (%orig && enabledWhatsAppCustomizer) {
		NSString *tintColor = [settings objectForKey:@"tintColor"];
		UIButton *broadcastButton = %orig;
		broadcastButton.tintColor = LCPParseColorString(tintColor, @"#007CFF");
		return broadcastButton;
	}
	return %orig;
}
- (UIButton *)groupButton {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (%orig && enabledWhatsAppCustomizer) {
		NSString *tintColor = [settings objectForKey:@"tintColor"];
		UIButton *groupButton = %orig;
		groupButton.tintColor = LCPParseColorString(tintColor, @"#007CFF");
		return groupButton;
	}
	return %orig;
}
%end

// Set title and caption label color
%hook WAConversationHeaderView
- (WALabel *)titleLabel {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (%orig && enabledWhatsAppCustomizer) {
		NSString *navbarTitleColor = [settings objectForKey:@"navbarTitleColor"];
		WALabel *titleLabel = %orig;
		titleLabel.textColor = LCPParseColorString(navbarTitleColor, @"#000000");
		return titleLabel;
	}
	return %orig;
}
- (UILabel *)captionLabel {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (%orig && enabledWhatsAppCustomizer) {
		NSString *navbarTitleColor = [settings objectForKey:@"navbarTitleColor"];
		UILabel *captionLabel = %orig;
		captionLabel.textColor = LCPParseColorString(navbarTitleColor, @"#7B7B7B");
		return captionLabel;
	}
	return %orig;
}
%end

%hook WAChatBar
- (void)layoutSubviews {
	%orig;
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		// set toolbar background color
		NSString *toolbarBackgroundColor = [settings objectForKey:@"toolbarBackgroundColor"];
		UIToolbar *chatToolBar = (UIToolbar *)MSHookIvar<UIView *>(self, "_backgroundView");
		chatToolBar.barTintColor = LCPParseColorString(toolbarBackgroundColor, @"#F7F7F7");
		// Set toolbar items color
		NSString *toolbarItemColor = [settings objectForKey:@"toolbarItemColor"];
		self.attachMediaButton.tintColor = LCPParseColorString(toolbarItemColor, @"#007CFF");
		self.cameraButton.tintColor = LCPParseColorString(toolbarItemColor, @"#007CFF");
		self.pttButton.tintColor = LCPParseColorString(toolbarItemColor, @"#007CFF");
		self.sendButton.tintColor = LCPParseColorString(toolbarItemColor, @"#007CFF");
		// Set color for PPT items
		MSHookIvar<UIImageView *>(self, "_pttMic").tintColor = LCPParseColorString(toolbarItemColor, @"#000000");
		MSHookIvar<UIImageView *>(self, "_pttMicInactive").tintColor = LCPParseColorString(toolbarItemColor, @"#007CFF");
		MSHookIvar<UILabel *>(self, "_pttRecordingProgressLabel").textColor = LCPParseColorString(toolbarItemColor, @"#000000");
		MSHookIvar<UIImageView *>(self, "_pttBucket").tintColor = LCPParseColorString(toolbarItemColor, @"#000000");
		MSHookIvar<UIImageView *>(self, "_pttBucketLid").tintColor = LCPParseColorString(toolbarItemColor, @"#000000");
	}
}
%end

// Set color for PPT Cancel label and arrow
%hook WAAnimatedCancelLabel
- (void)layoutSubviews {
	%orig;
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		NSString *toolbarItemColor = [settings objectForKey:@"toolbarItemColor"];
		UILabel *cancelLabel = MSHookIvar<UILabel *>(self, "_label");
		cancelLabel.textColor = LCPParseColorString(toolbarItemColor, @"#000000");

		UIImageView *slideArrow = MSHookIvar<UIImageView *>(self, "_slideArrow");
		slideArrow.tintColor = LCPParseColorString(toolbarItemColor, @"#000000");
	}
}
%end

// Normal bubble image view
%hook WAMessageCell
- (UIImageView *)bubbleImageView {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		UIImageView *customBubbleImageView = %orig;
		customBubbleImageView.image = [customBubbleImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		if (self.cellData.isFromMe) {
			if ([self class] == %c(WAAudioMessageCell)) {
				NSString *yourInstantVoiceBubbleColor = [settings objectForKey:@"yourInstantVoiceBubbleColor"];
				[customBubbleImageView setTintColor:LCPParseColorString(yourInstantVoiceBubbleColor, @"#DCF8C6")];
			} else {
				NSString *yourBubbleColor = [settings objectForKey:@"yourBubbleColor"];
				[customBubbleImageView setTintColor:LCPParseColorString(yourBubbleColor, @"#DCF8C6")];
			}
		} else if ([self class] == %c(WAGroupEventMessageCell)) {
			NSString *eventTextBubbleColor = [settings objectForKey:@"eventTextBubbleColor"];
			[customBubbleImageView setTintColor:LCPParseColorString(eventTextBubbleColor, @"#D0E9FB")];
		} else {
			if ([self class] == %c(WAAudioMessageCell)) {
				NSString *otherPersonInstantVoiceBubbleColor = [settings objectForKey:@"otherPersonInstantVoiceBubbleColor"];
				[customBubbleImageView setTintColor:LCPParseColorString(otherPersonInstantVoiceBubbleColor, @"#FAFAFA")];
			} else {
				NSString *otherPersonBubbleColor = [settings objectForKey:@"otherPersonBubbleColor"];
				[customBubbleImageView setTintColor:LCPParseColorString(otherPersonBubbleColor, @"#FAFAFA")];
			}
		}
	}
	return %orig;
}

// WAInstantVoiceBubbleView
- (UIView *)bubbleView {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		// Get instance voice bubble image
		UIImageView *instantVoiceBubbleImageView = MSHookIvar<UIImageView *>(self, "_imageViewBubble");
		instantVoiceBubbleImageView.image = [instantVoiceBubbleImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		if (self.cellData.isFromMe) {
			// Set your instant voice bubble color
			NSString *yourInstantVoiceBubbleColor = [settings objectForKey:@"yourInstantVoiceBubbleColor"];
			[instantVoiceBubbleImageView setTintColor:LCPParseColorString(yourInstantVoiceBubbleColor, @"#DCF8C6")];
		} else {
			// Set other person instant voice bubble color
			NSString *otherPersonInstantVoiceBubbleColor = [settings objectForKey:@"otherPersonInstantVoiceBubbleColor"];
			[instantVoiceBubbleImageView setTintColor:LCPParseColorString(otherPersonInstantVoiceBubbleColor, @"#FAFAFA")];
		}

		if (%orig) {
			// Get time stamp label
			UIView *originalView = %orig;
			WAInstantVoiceBubbleView *instantVoiceBubbleView = (WAInstantVoiceBubbleView *) originalView;
			WAMessageFooterView *messageFooterView = instantVoiceBubbleView.messageStatusView;
			UILabel *timeStampLabel = MSHookIvar<UILabel *>(messageFooterView, "_timestampLabel");
			if (self.cellData.isFromMe) {
				// Set time stamp label color
				NSString *yourTimeStampLabelColor = [settings objectForKey:@"yourTimeStampLabelColor"];
				[timeStampLabel setTextColor:LCPParseColorString(yourTimeStampLabelColor, @"#D3D3D3")];
			} else {
				// Set time stamp label color
				NSString *otherPersonTimeStampLabelColor = [settings objectForKey:@"otherPersonTimeStampLabelColor"];
				[timeStampLabel setTextColor:LCPParseColorString(otherPersonTimeStampLabelColor, @"#D3D3D3")];
			}
		}
	}
	return %orig;
}

- (WAMessageFooterView *)footerView {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		if (%orig) {
			WAMessageFooterView *footerView = %orig;
			UILabel *timeStampLabel = MSHookIvar<UILabel *>(footerView, "_timestampLabel");
			if (self.cellData.isFromMe) {
				NSString *yourTimeStampLabelColor = [settings objectForKey:@"yourTimeStampLabelColor"];
				[timeStampLabel setTextColor:LCPParseColorString(yourTimeStampLabelColor, @"#D3D3D3")];
			} else {
				NSString *otherPersonTimeStampLabelColor = [settings objectForKey:@"otherPersonTimeStampLabelColor"];
				[timeStampLabel setTextColor:LCPParseColorString(otherPersonTimeStampLabelColor, @"#D3D3D3")];
			}
			return footerView;
		}
	}
	return %orig;
}

- (UILabel *)fromNameLabel {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		if (%orig) {
			UILabel *fromNameLabel = %orig;
			NSString *senderLabelColor = [settings objectForKey:@"senderLabelColor"];
			[fromNameLabel setTextColor:LCPParseColorString(senderLabelColor, @"#32948A")];
			return fromNameLabel;
		}
	}
	return %orig;
}
%end

%hook WAChatCellData
- (NSArray *)textMessages {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		NSArray *textMessageArray = %orig;
		if (textMessageArray != nil) {
			for (_TextMessage_TextKit *textMessage in %orig) {
				if (self.isFromMe) {
					NSString *yourTextColor = [settings objectForKey:@"yourTextColor"];
					NSString *yourURLTextColor = [settings objectForKey:@"yourURLTextColor"];
					textMessage.textColor = LCPParseColorString(yourTextColor, @"#000000");
					textMessage.urlColor = LCPParseColorString(yourURLTextColor, @"#1184FB");
				} else {
					NSString *otherPersonTextColor = [settings objectForKey:@"otherPersonTextColor"];
					NSString *otherPersonURLTextColor = [settings objectForKey:@"otherPersonURLTextColor"];
					textMessage.textColor = LCPParseColorString(otherPersonTextColor, @"#000000");
					textMessage.urlColor = LCPParseColorString(otherPersonURLTextColor, @"#1184FB");
				}
			}
		}
	}
	return %orig;
}
%end

// Set date bubble view and date label color
%hook WADateBubbleView
- (void)layoutSubviews {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		// Set date bubble color
		UIImageView *bubbleImageView = MSHookIvar<UIImageView *>(self, "_backgroundView");
		bubbleImageView.image = [bubbleImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		NSString *dateBubbleColor = [settings objectForKey:@"dateBubbleColor"];
		[bubbleImageView setTintColor:LCPParseColorString(dateBubbleColor, @"#D7DCF0")];
		
		// Set date label color
		UILabel *dateLabel = MSHookIvar<UILabel *>(self, "_titleLabel");
		NSString *dateLabelColor = [settings objectForKey:@"dateLabelColor"];
		[dateLabel setTextColor:LCPParseColorString(dateLabelColor, @"#000000")];
	}

	%orig;
}
%end

%hook WAMessageFooterView
- (id)statusImage {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		UIImageView *statusImageView = MSHookIvar<UIImageView *>(self, "_statusImageView");
		UIImage *statusImage  = %orig;
		if (self.status == 6 || self.status == 532575944710) { //seen
			statusImage = [statusImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			NSString *messageStatusColor = [settings objectForKey:@"messageStatusColor"];
			[statusImageView setTintColor:LCPParseColorString(messageStatusColor, @"#1184FB")];
		}
		return statusImage;
	}
	return %orig;
}
%end

// Set time stamp label color
%hook WATextMessageCell
- (void)layoutSubviews {
	%orig;
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		WAMessageTextView *messageTextView = MSHookIvar<WAMessageTextView *>(self, "_messageTextView");
		WAMessageFooterView *footerView = MSHookIvar<WAMessageFooterView *>(messageTextView, "_footerView");
		UILabel *timeStampLabel = MSHookIvar<UILabel *>(footerView, "_timestampLabel");
		if (self.cellData.isFromMe) {
			NSString *yourTimeStampLabelColor = [settings objectForKey:@"yourTimeStampLabelColor"];
			[timeStampLabel setTextColor:LCPParseColorString(yourTimeStampLabelColor, @"#D3D3D3")];
		} else {
			NSString *otherPersonTimeStampLabelColor = [settings objectForKey:@"otherPersonTimeStampLabelColor"];
			[timeStampLabel setTextColor:LCPParseColorString(otherPersonTimeStampLabelColor, @"#D3D3D3")];
		}
	}	
}
%end

%hook WAGroupEventMessageCell
- (void)layoutSubviews {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		WALabel *eventTextLabel = MSHookIvar<WALabel *>(self, "_eventTextLabel");
		NSString *eventTextColor = [settings objectForKey:@"eventTextColor"];
		[eventTextLabel setTextColor:LCPParseColorString(eventTextColor, @"#000000")];
	}
	%orig;
}
%end

// Fix rounded cornered image (the original implementation is kinda messed up)

%hook WALargeMediaMessageCell
- (void)layoutSubviews {
	%orig;
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (enabledWhatsAppCustomizer) {
		// Hide _roundedCornersImageView
		UIImageView *roundedCornersImageView = MSHookIvar<UIImageView *>(self, "_roundedCornersImageView");
		roundedCornersImageView.hidden = 1;
		// Rounded corner of lowerRightShadowView
		if (self.lowerRightShadowView) {
			self.lowerRightShadowView.layer.cornerRadius = 5;
			self.lowerRightShadowView.layer.masksToBounds = YES;
		}

		// Set timestamp label color for large media message cell
		if (self.footerView) {
			UILabel *timeStampLabel = MSHookIvar<UILabel *>(self.footerView, "_timestampLabel");
			if (self.cellData.isFromMe) {
				NSString *yourTimeStampLabelColor = [settings objectForKey:@"yourTimeStampLabelColor"];
				[timeStampLabel setTextColor:LCPParseColorString(yourTimeStampLabelColor, @"#D3D3D3")];
			} else {
				NSString *otherPersonTimeStampLabelColor = [settings objectForKey:@"otherPersonTimeStampLabelColor"];
				[timeStampLabel setTextColor:LCPParseColorString(otherPersonTimeStampLabelColor, @"#D3D3D3")];
			}
		}
	}
}
%end

// Rounded corners of image
%hook WAMediaDataPresentationController
- (UIView *)view {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	BOOL enabledWhatsAppCustomizer = [[settings objectForKey:@"enabledWhatsAppCustomizer"] boolValue];
	if (%orig && enabledWhatsAppCustomizer) {
		UIView *imageView = %orig;
		imageView.layer.cornerRadius = 5;
		imageView.layer.masksToBounds = YES;
		return imageView;
	}
	return %orig;
}
%end

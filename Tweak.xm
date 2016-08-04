#include <libcolorpicker.h>
#include <Headers.h>

#define SETTINGS_FILE @"/var/mobile/Library/Preferences/com.fidele007.whatsappcustomizerpref.plist"

%hook WhatsAppAppDelegate
- (void)setWindow:(UIWindow *)arg1 {
  %orig;
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    NSString *tintColor = settings[@"tintColor"];
    self.window.tintColor = LCPParseColorString(tintColor, @"#007CFF");
  }
}
%end

%hook UIStatusBarNewUIStyleAttributes
- (id)initWithRequest:(id)arg1 backgroundColor:(id)arg2 foregroundColor:(id)arg3 {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    NSString *statusBarBackgroundColor = settings[@"statusBarBackgroundColor"];
    if (![statusBarBackgroundColor isEqualToString:@"#FFFFFF:0"]) {
      arg2 = LCPParseColorString(statusBarBackgroundColor, @"#FFFFFF:0");
    }

    NSString *statusBarForegroundColor = settings[@"statusBarForegroundColor"];
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
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    if ([settings[@"chatFontSize"] doubleValue]) {
      arg1 = [settings[@"chatFontSize"] doubleValue];
    }
  }
  %orig(arg1);
}

- (UIColor *)tintColor {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    NSString *tintColor = settings[@"tintColor"];
    return LCPParseColorString(tintColor, @"#007CFF");
  }
  return %orig;
}
%end

%hook ContactsViewController
- (void)viewWillAppear:(BOOL)arg1 {
  %orig;
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer && self.tableView) {
    NSString *tintColor = settings[@"tintColor"];
    self.tableView.sectionIndexColor = LCPParseColorString(tintColor, @"#007CFF");
  }
}
%end

%hook ContactTableViewCell
- (void)layoutSubviews {
  %orig;
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    NSString *tintColor = settings[@"tintColor"];
    self.tintColor = LCPParseColorString(tintColor, @"#007CFF");
  }
}
%end

%hook WAContactInfoTableViewCell
- (void)layoutSubviews {
  %orig;
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    NSString *tintColor = settings[@"tintColor"];
    self.tintColor = LCPParseColorString(tintColor, @"#007CFF");
  }
}
- (UILabel *)valueLabel {
  if (%orig) {
    NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
    BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
    if (enabledWhatsAppCustomizer) {
      NSString *tintColor = settings[@"tintColor"];
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
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    // Set navigation bar tint color
    NSString *tintColor = settings[@"tintColor"];
    self.tintColor = LCPParseColorString(tintColor, @"#007CFF");
    // Set navigation bar title color
    NSString *navbarTitleColor = settings[@"navbarTitleColor"];
    UIColor *titleColor = LCPParseColorString(navbarTitleColor, @"#000000");
    self.titleTextAttributes = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    // Set navigation bar background color
    NSString *navbarBackgroundColor = settings[@"navbarBackgroundColor"];
    MSHookIvar<UIView *>(self, "_grayBackgroundView").backgroundColor = LCPParseColorString(navbarBackgroundColor, @"#F7F7F7");
  }
}
%end

// Tint tab bar
%hook WATabBarController
- (void)viewWillAppear:(BOOL)arg1 {
  %orig;
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (self.tabBar && enabledWhatsAppCustomizer) {
    NSString *tintColor = settings[@"tintColor"];
    self.tabBar.tintColor = LCPParseColorString(tintColor, @"#007CFF");
  }
}
%end

// Tint all buttons
%hook WAChatListHeaderCell
- (UIButton *)broadcastButton {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (%orig && enabledWhatsAppCustomizer) {
    NSString *tintColor = settings[@"tintColor"];
    UIButton *broadcastButton = %orig;
    broadcastButton.tintColor = LCPParseColorString(tintColor, @"#007CFF");
    return broadcastButton;
  }
  return %orig;
}
- (UIButton *)groupButton {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (%orig && enabledWhatsAppCustomizer) {
    NSString *tintColor = settings[@"tintColor"];
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
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (%orig && enabledWhatsAppCustomizer) {
    NSString *navbarTitleColor = settings[@"navbarTitleColor"];
    WALabel *titleLabel = %orig;
    titleLabel.textColor = LCPParseColorString(navbarTitleColor, @"#000000");
    return titleLabel;
  }
  return %orig;
}

- (UILabel *)captionLabel {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (%orig && enabledWhatsAppCustomizer) {
    NSString *navbarTitleColor = settings[@"navbarTitleColor"];
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
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    // set toolbar background color
    NSString *toolbarBackgroundColor = settings[@"toolbarBackgroundColor"];
    UIToolbar *chatToolBar = (UIToolbar *)MSHookIvar<UIView *>(self, "_backgroundView");
    chatToolBar.barTintColor = LCPParseColorString(toolbarBackgroundColor, @"#F7F7F7");
    // Set toolbar items color
    NSString *toolbarItemColor = settings[@"toolbarItemColor"];
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
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    NSString *toolbarItemColor = settings[@"toolbarItemColor"];
    UILabel *cancelLabel = MSHookIvar<UILabel *>(self, "_label");
    cancelLabel.textColor = LCPParseColorString(toolbarItemColor, @"#000000");

    UIImageView *slideArrow = MSHookIvar<UIImageView *>(self, "_slideArrow");
    slideArrow.tintColor = LCPParseColorString(toolbarItemColor, @"#000000");
  }
}
%end

// Text bubble color (Deprecated)
%hook WAMessageCell
- (UIImageView *)bubbleImageView {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    UIImageView *customBubbleImageView = %orig;
    customBubbleImageView.image = [customBubbleImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if (self.cellData.isFromMe) {
      if ([self class] == %c(WAAudioMessageCell)) {
        NSString *yourInstantVoiceBubbleColor = settings[@"yourInstantVoiceBubbleColor"];
        customBubbleImageView.tintColor = LCPParseColorString(yourInstantVoiceBubbleColor, @"#DCF8C6");
      } else {
        NSString *yourBubbleColor = settings[@"yourBubbleColor"];
        customBubbleImageView.tintColor = LCPParseColorString(yourBubbleColor, @"#DCF8C6");
      }
    } else if ([self class] == %c(WAGroupEventMessageCell)) {
      NSString *eventTextBubbleColor = settings[@"eventTextBubbleColor"];
      customBubbleImageView.tintColor = LCPParseColorString(eventTextBubbleColor, @"#D0E9FB");
    } else {
      if ([self class] == %c(WAAudioMessageCell)) {
        NSString *otherPersonInstantVoiceBubbleColor = settings[@"otherPersonInstantVoiceBubbleColor"];
        customBubbleImageView.tintColor = LCPParseColorString(otherPersonInstantVoiceBubbleColor, @"#FAFAFA");
      } else {
        NSString *otherPersonBubbleColor = settings[@"otherPersonBubbleColor"];
        customBubbleImageView.tintColor = LCPParseColorString(otherPersonBubbleColor, @"#FAFAFA");
      }
    }
  }
  return %orig;
}

// WAInstantVoiceBubbleView
- (UIView *)bubbleView {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    // Get instance voice bubble image
    UIImageView *instantVoiceBubbleImageView = MSHookIvar<UIImageView *>(self, "_imageViewBubble");
    instantVoiceBubbleImageView.image = [instantVoiceBubbleImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if (self.cellData.isFromMe) {
      // Set your instant voice bubble color
      NSString *yourInstantVoiceBubbleColor = settings[@"yourInstantVoiceBubbleColor"];
      instantVoiceBubbleImageView.tintColor = LCPParseColorString(yourInstantVoiceBubbleColor, @"#DCF8C6");
    } else {
      // Set other person instant voice bubble color
      NSString *otherPersonInstantVoiceBubbleColor = settings[@"otherPersonInstantVoiceBubbleColor"];
      instantVoiceBubbleImageView.tintColor = LCPParseColorString(otherPersonInstantVoiceBubbleColor, @"#FAFAFA");
    }

    if (%orig) {
      // Get time stamp label
      UIView *originalView = %orig;
      WAInstantVoiceBubbleView *instantVoiceBubbleView = (WAInstantVoiceBubbleView *) originalView;
      WAMessageFooterView *messageFooterView = instantVoiceBubbleView.messageStatusView;
      UILabel *timeStampLabel = MSHookIvar<UILabel *>(messageFooterView, "_timestampLabel");
      if (self.cellData.isFromMe) {
        // Set time stamp label color
        NSString *yourTimeStampLabelColor = settings[@"yourTimeStampLabelColor"];
        timeStampLabel.textColor = LCPParseColorString(yourTimeStampLabelColor, @"#D3D3D3");
      } else {
        // Set time stamp label color
        NSString *otherPersonTimeStampLabelColor = settings[@"otherPersonTimeStampLabelColor"];
        timeStampLabel.textColor = LCPParseColorString(otherPersonTimeStampLabelColor, @"#D3D3D3");
      }
    }
  }
  return %orig;
}

// Timestamp color
- (WAMessageFooterView *)footerView {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    if (%orig) {
      WAMessageFooterView *footerView = %orig;
      UILabel *timeStampLabel = MSHookIvar<UILabel *>(footerView, "_timestampLabel");
      if (self.cellData.isFromMe) {
        NSString *yourTimeStampLabelColor = settings[@"yourTimeStampLabelColor"];
        timeStampLabel.textColor = LCPParseColorString(yourTimeStampLabelColor, @"#D3D3D3");
      } else {
        NSString *otherPersonTimeStampLabelColor = settings[@"otherPersonTimeStampLabelColor"];
        timeStampLabel.textColor = LCPParseColorString(otherPersonTimeStampLabelColor, @"#D3D3D3");
      }
      return footerView;
    }
  }
  return %orig;
}

// Sender label color
- (UILabel *)fromNameLabel {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    if (%orig) {
      UILabel *fromNameLabel = %orig;
      NSString *senderLabelColor = settings[@"senderLabelColor"];
      fromNameLabel.textColor = LCPParseColorString(senderLabelColor, @"#32948A");
      return fromNameLabel;
    }
  }
  return %orig;
}
%end

// Message text color
%hook WAChatCellData
- (NSArray *)textMessages {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    NSArray *textMessageArray = [%orig mutableCopy];
    if (textMessageArray && [textMessageArray count] > 0) {
      for (_TextMessage_TextKit *textMessage in textMessageArray) {
        if (self.isFromMe) {
          NSString *yourTextColor = settings[@"yourTextColor"];
          NSString *yourURLTextColor = settings[@"yourURLTextColor"];
          textMessage.textColor = LCPParseColorString(yourTextColor, @"#000000");
          textMessage.urlColor = LCPParseColorString(yourURLTextColor, @"#1184FB");
        } else {
          NSString *otherPersonTextColor = settings[@"otherPersonTextColor"];
          NSString *otherPersonURLTextColor = settings[@"otherPersonURLTextColor"];
          textMessage.textColor = LCPParseColorString(otherPersonTextColor, @"#000000");
          textMessage.urlColor = LCPParseColorString(otherPersonURLTextColor, @"#1184FB");
        }
      }
      return textMessageArray;
    }
  }
  return %orig;
}
%end

// Set date bubble view and date label color
%hook WADateBubbleView
- (void)layoutSubviews {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    // Set date bubble color
    UIImageView *bubbleImageView = MSHookIvar<UIImageView *>(self, "_backgroundView");
    bubbleImageView.image = [bubbleImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    NSString *dateBubbleColor = settings[@"dateBubbleColor"];
    bubbleImageView.tintColor = LCPParseColorString(dateBubbleColor, @"#D7DCF0");

    // Set date label color
    UILabel *dateLabel = MSHookIvar<UILabel *>(self, "_titleLabel");
    NSString *dateLabelColor = settings[@"dateLabelColor"];
    dateLabel.textColor = LCPParseColorString(dateLabelColor, @"#000000");
  }

  %orig;
}
%end

%hook WAMessageFooterView
- (id)statusImage {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    UIImageView *statusImageView = MSHookIvar<UIImageView *>(self, "_statusImageView");
    UIImage *statusImage  = %orig;
    if (self.status == 6 || self.status == 532575944710) { //seen
      statusImage = [statusImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      NSString *messageStatusColor = settings[@"messageStatusColor"];
      statusImageView.tintColor = LCPParseColorString(messageStatusColor, @"#1184FB");
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
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    WAMessageTextView *messageTextView = MSHookIvar<WAMessageTextView *>(self, "_messageTextView");
    WAMessageFooterView *footerView = MSHookIvar<WAMessageFooterView *>(messageTextView, "_footerView");
    UILabel *timeStampLabel = MSHookIvar<UILabel *>(footerView, "_timestampLabel");
    if (self.cellData.isFromMe) {
      NSString *yourTimeStampLabelColor = settings[@"yourTimeStampLabelColor"];
      timeStampLabel.textColor = LCPParseColorString(yourTimeStampLabelColor, @"#D3D3D3");
    } else {
      NSString *otherPersonTimeStampLabelColor = settings[@"otherPersonTimeStampLabelColor"];
      timeStampLabel.textColor = LCPParseColorString(otherPersonTimeStampLabelColor, @"#D3D3D3");
    }
  }
}
%end

%hook WAGroupEventMessageCell
- (void)layoutSubviews {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (enabledWhatsAppCustomizer) {
    WALabel *eventTextLabel = MSHookIvar<WALabel *>(self, "_eventTextLabel");
    NSString *eventTextColor = settings[@"eventTextColor"];
    eventTextLabel.textColor = LCPParseColorString(eventTextColor, @"#000000");
  }
  %orig;
}
%end

// Fix rounded cornered image (the original implementation is kinda messed up)

%hook WALargeMediaMessageCell
- (void)layoutSubviews {
  %orig;
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
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
        NSString *yourTimeStampLabelColor = settings[@"yourTimeStampLabelColor"];
        timeStampLabel.textColor = LCPParseColorString(yourTimeStampLabelColor, @"#D3D3D3");
      } else {
        NSString *otherPersonTimeStampLabelColor = settings[@"otherPersonTimeStampLabelColor"];
        timeStampLabel.textColor = LCPParseColorString(otherPersonTimeStampLabelColor, @"#D3D3D3");
      }
    }
  }
}
%end

// Rounded corners of image
%hook WAMediaDataPresentationController
- (UIView *)view {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (%orig && enabledWhatsAppCustomizer) {
    UIView *imageView = %orig;
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    return imageView;
  }
  return %orig;
}
%end

/**************************************************************************************************
***************************************** New WhatsApp ********************************************
***************************************************************************************************/

%hook WAMessageMediaSliceView
- (WAAutoCropImageView *)imageView {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (%orig && enabledWhatsAppCustomizer) {
    UIImageView *roundedCornersImageView = MSHookIvar<UIImageView *>(self, "_roundedCornersImageView");
    roundedCornersImageView.hidden = YES;

    UIView *containerView = MSHookIvar<UIView *>(self, "_containerView");
    containerView.layer.cornerRadius = 5;
    containerView.layer.masksToBounds = YES;
  }
  return %orig;
}
%end

// New text bubble colors
%hook WAMessageContainerView
- (void)updateBubbleImageView {
  %orig;

  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (!enabledWhatsAppCustomizer) {
    return;
  }

  WAChatCellData *cellData = self.cellData;
  if (!cellData) {
    return;
  }

  _WANoHighlightImageView *customBubbleImageView = MSHookIvar<_WANoHighlightImageView *>(self, "_bubbleImageView");
  customBubbleImageView.image = [customBubbleImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

  if (cellData.isFromMe) {
    if ([self audioSliceView]) {
      NSString *yourInstantVoiceBubbleColor = settings[@"yourInstantVoiceBubbleColor"];
      customBubbleImageView.tintColor = LCPParseColorString(yourInstantVoiceBubbleColor, @"#DCF8C6");
    } else {
      NSString *yourBubbleColor = settings[@"yourBubbleColor"];
      customBubbleImageView.tintColor = LCPParseColorString(yourBubbleColor, @"#DCF8C6");
    }
  } else if (!self.cellData.canBeForwarded) {
      NSString *eventTextBubbleColor = settings[@"eventTextBubbleColor"];
      customBubbleImageView.tintColor = LCPParseColorString(eventTextBubbleColor, @"#D0E9FB");
  } else {
    if ([self audioSliceView]) {
      NSString *otherPersonInstantVoiceBubbleColor = settings[@"otherPersonInstantVoiceBubbleColor"];
      customBubbleImageView.tintColor = LCPParseColorString(otherPersonInstantVoiceBubbleColor, @"#FAFAFA");
    } else {
      NSString *otherPersonBubbleColor = settings[@"otherPersonBubbleColor"];
      customBubbleImageView.tintColor = LCPParseColorString(otherPersonBubbleColor, @"#FAFAFA");
    }
  }
}
%end

// Footer status colors
%hook WAMessageStatusSlice
- (NSAttributedString *)attributedStringForMessage:(id)arg1 {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (!enabledWhatsAppCustomizer || ![arg1 isKindOfClass:%c(WAMessage)]) {
    return %orig;
  }

  NSMutableAttributedString *attrString = [%orig mutableCopy];
  WAMessage *message = (WAMessage *)arg1;
  NSRange timeRange;
  if (message.isFromMe) {
      timeRange = NSMakeRange(2, [attrString length] - 4);
      NSString *yourTimeStampLabelColor = settings[@"yourTimeStampLabelColor"];
      [attrString beginEditing];
      [attrString addAttribute:NSForegroundColorAttributeName
                         value:LCPParseColorString(yourTimeStampLabelColor, @"#D3D3D3")
                         range:timeRange];
      [attrString endEditing];
      if ((int)message.footerStatus == 6) {
          NSRange seenStatusRange = NSMakeRange([attrString length] - 2, 2);
          NSString *messageStatusColor = settings[@"messageStatusColor"];
          [attrString beginEditing];
          [attrString addAttribute:NSForegroundColorAttributeName
                             value:LCPParseColorString(messageStatusColor, @"#1184FB")
                             range:seenStatusRange];
          [attrString endEditing];
      }
  } else {
      timeRange = NSMakeRange(2, [attrString length] - 2);
      NSString *otherPersonTimeStampLabelColor = settings[@"otherPersonTimeStampLabelColor"];
      [attrString beginEditing];
      [attrString addAttribute:NSForegroundColorAttributeName
                         value:LCPParseColorString(otherPersonTimeStampLabelColor, @"#D3D3D3")
                         range:timeRange];
      [attrString endEditing];
  }

  return attrString;
}
%end

// Sender name label color
%hook WAMessageSenderNameSlice
- (WAMessageSenderNameSlice *)initWithMessage:(id)arg1 metrics:(id)arg2 {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (!enabledWhatsAppCustomizer) {
    return %orig;
  }

  WAMessageSenderNameSlice *senderNameSlice = %orig;
  if (!senderNameSlice) {
      return %orig;
  }

  NSTextStorage *textStorage = MSHookIvar<NSTextStorage *>(senderNameSlice, "_senderNameTextStorage");
  NSString *senderLabelColor = settings[@"senderLabelColor"];
  NSRange range = NSMakeRange(0, [textStorage length]);
  [textStorage removeAttribute:NSForegroundColorAttributeName range:range];
  [textStorage addAttribute:NSForegroundColorAttributeName
                      value:LCPParseColorString(senderLabelColor, @"#32948A")
                      range:range];

  return senderNameSlice;
}
%end

// Message text colors
%hook WAMessage
- (NSAttributedString *)attributedText {
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (!enabledWhatsAppCustomizer) {
    return %orig;
  }

  NSMutableAttributedString *attrString = [%orig mutableCopy];
  NSRange range = NSMakeRange(0, [attrString length]);
  [attrString removeAttribute:NSForegroundColorAttributeName range:range];
  if (self.isFromMe) {
      NSString *yourTextColor = settings[@"yourTextColor"];
      [attrString beginEditing];
      [attrString addAttribute:NSForegroundColorAttributeName
                         value:LCPParseColorString(yourTextColor, @"#000000")
                         range:range];
      [attrString endEditing];
  } else if (!self.canBeForwarded) {
      NSString *eventTextColor = settings[@"eventTextColor"];
      [attrString beginEditing];
      [attrString addAttribute:NSForegroundColorAttributeName
                         value:LCPParseColorString(eventTextColor, @"#000000")
                         range:range];
      [attrString endEditing];
  } else {
      NSString *otherPersonTextColor = settings[@"otherPersonTextColor"];
      [attrString beginEditing];
      [attrString addAttribute:NSForegroundColorAttributeName
                         value:LCPParseColorString(otherPersonTextColor, @"#000000")
                         range:range];
      [attrString endEditing];
  }

  return attrString;
}
%end

// URL Colors
%hook WAMessageAttributedTextSliceView
- (void)reloadSliceAfterChange:(unsigned long long)arg1 {
  %orig;
  NSDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE] autorelease];
  BOOL enabledWhatsAppCustomizer = [settings[@"enabledWhatsAppCustomizer"] boolValue];
  if (!enabledWhatsAppCustomizer || [self.slice.links count] == 0) {
    return;
  }

  NSTextStorage *textStorage = MSHookIvar<NSTextStorage *>(self.slice, "_textStorage");
  NSRange range = NSMakeRange(0, [textStorage length]);
  if (self.cellData.isFromMe) {
    NSString *yourURLTextColor = settings[@"yourURLTextColor"];
    for (WAMessageAttributedTextSliceLink *link in self.slice.links) {
      NSString *pattern = [NSString stringWithFormat:@"(%@)", link.text];
      NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                             options:kNilOptions
                                                                               error:nil];
      [regex enumerateMatchesInString:textStorage.string options:kNilOptions range:range usingBlock:
          ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
              NSRange subStringRange = [result rangeAtIndex:1];
              [textStorage addAttribute:NSForegroundColorAttributeName
                                  value:LCPParseColorString(yourURLTextColor, @"#1184FB")
                                  range:subStringRange];
              [textStorage addAttribute:NSUnderlineColorAttributeName
                                  value:LCPParseColorString(yourURLTextColor, @"#1184FB")
                                  range:subStringRange];
          }];
    }
  } else {
    NSString *otherPersonURLTextColor = settings[@"otherPersonURLTextColor"];
    for (WAMessageAttributedTextSliceLink *link in self.slice.links) {
      NSString *pattern = [NSString stringWithFormat:@"(%@)", link.text];
      NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                             options:kNilOptions
                                                                               error:nil];
      [regex enumerateMatchesInString:textStorage.string options:kNilOptions range:range usingBlock:
          ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
              NSRange subStringRange = [result rangeAtIndex:1];
              [textStorage addAttribute:NSForegroundColorAttributeName
                                  value:LCPParseColorString(otherPersonURLTextColor, @"#1184FB")
                                  range:subStringRange];
              [textStorage addAttribute:NSUnderlineColorAttributeName
                                  value:LCPParseColorString(otherPersonURLTextColor, @"#1184FB")
                                  range:subStringRange];
          }];
    }
  }
}
%end

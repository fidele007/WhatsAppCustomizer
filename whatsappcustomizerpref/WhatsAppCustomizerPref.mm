#import "common.h"
#import <libcolorpicker.h>

#define SETTINGS_FILE @"/var/mobile/Library/Preferences/com.fidele007.whatsappcustomizerpref.plist"

@interface UIApplication (WhatsAppCustomizer)
- (BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2 ;
@end

@interface PSListController (WhatsAppCustomizer)
- (void)clearCache;
- (void)reload;
- (void)viewWillAppear:(BOOL)animated;
- (void)reloadSpecifiers;
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier;
@end

@interface WhatsAppCustomizerPrefListController: PSListController {
  UIWindow *_settingsView;
}
@end

@implementation WhatsAppCustomizerPrefListController
- (id)specifiers {
  if(_specifiers == nil) {
    _specifiers = [[self loadSpecifiersFromPlistName:@"WhatsAppCustomizerPref" target:self] retain];

    UIBarButtonItem *saveChangesButton = [[UIBarButtonItem alloc] 
                                            initWithTitle:@"Save" 
                                                    style:UIBarButtonItemStylePlain 
                                                   target:self 
                                                   action:@selector(saveChangesButtonClicked:)];

    [[self navigationItem] setRightBarButtonItem:saveChangesButton animated:YES];
    [saveChangesButton release];
  }
  return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _settingsView = [[UIApplication sharedApplication] keyWindow];
  _settingsView.tintColor = [UIColor cyanColor];
  self.navigationController.navigationController.navigationBar.barTintColor = [UIColor 
      colorWithRed:0.031 green:0.467 blue:0.482 alpha:1];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  _settingsView = [[UIApplication sharedApplication] keyWindow];
  _settingsView.tintColor = nil;
  self.navigationController.navigationController.navigationBar.barTintColor = nil;
}

- (void)saveChangesButtonClicked:(id)sender {
  [self.view endEditing:YES];
  system("killall -9 WhatsApp");
  UIAlertView *savedAlert = [[UIAlertView alloc] initWithTitle:@"Settings" 
                                                       message:@"Your settings have been saved." 
                                                      delegate:self 
                                             cancelButtonTitle:@"OK" 
                                             otherButtonTitles:nil, nil];
  [savedAlert show];
  [savedAlert release];
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
  NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
  if (!settings[specifier.properties[@"key"]]) {
    return specifier.properties[@"default"];
  }
  return settings[specifier.properties[@"key"]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
  NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
  [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE]];
  [defaults setObject:value forKey:specifier.properties[@"key"]];
  [defaults writeToFile:SETTINGS_FILE atomically:YES];
}

- (void)resetPreferences {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSMutableDictionary *settings;
  if ([fileManager fileExistsAtPath:SETTINGS_FILE]) {
    settings = [NSMutableDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
  } else {
    settings = [[NSMutableDictionary alloc] init];
  }
  [settings setObject:@"#DCF8C6:1" forKey:@"yourBubbleColor"];
  [settings setObject:@"#DCF8C6:1" forKey:@"yourInstantVoiceBubbleColor"];
  [settings setObject:@"#000000:1" forKey:@"yourTextColor"];
  [settings setObject:@"#1184FB:1" forKey:@"yourURLTextColor"];
  [settings setObject:@"#D3D3D3:1" forKey:@"yourTimeStampLabelColor"];
  [settings setObject:@"#1184FB:1" forKey:@"messageStatusColor"];

  [settings setObject:@"#FAFAFA:1" forKey:@"otherPersonBubbleColor"];
  [settings setObject:@"#FAFAFA:1" forKey:@"otherPersonInstantVoiceBubbleColor"];
  [settings setObject:@"#000000:1" forKey:@"otherPersonTextColor"];
  [settings setObject:@"#1184FB:1" forKey:@"otherPersonURLTextColor"];
  [settings setObject:@"#D3D3D3:1" forKey:@"otherPersonTimeStampLabelColor"];

  [settings setObject:@"#D7DCF0:1" forKey:@"dateBubbleColor"];
  [settings setObject:@"#000000:1" forKey:@"dateLabelColor"];

  [settings setObject:@"#32948A:1" forKey:@"senderLabelColor"];
  [settings setObject:@"#D0E9FB:1" forKey:@"eventTextBubbleColor"];
  [settings setObject:@"#000000:1" forKey:@"eventTextColor"];

  [settings setObject:@"#007CFF:1" forKey:@"tintColor"];
  [settings setObject:@"#F7F7F7:1" forKey:@"navbarBackgroundColor"];
  [settings setObject:@"#000000:1" forKey:@"navbarTitleColor"];
  [settings setObject:@"#FFFFFF:0" forKey:@"statusBarBackgroundColor"];
  [settings setObject:@"#000000:1" forKey:@"statusBarForegroundColor"];

  [settings setObject:@"#F7F7F7:1" forKey:@"toolbarBackgroundColor"];
  [settings setObject:@"#007CFF:1" forKey:@"toolbarItemColor"];

  [settings setObject:@"" forKey:@"chatFontSize"];
  
  if ([settings writeToFile:SETTINGS_FILE atomically:YES]) {
    [self reloadSpecifiers];
    system("killall -9 WhatsApp");
    UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"Settings" 
                                                         message:@"Your settings have been reset to defaults." 
                                                        delegate:self 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil, nil];
    [resetAlert show];
    [resetAlert release];
  }
}

- (void)launchWhatsApp {
  UIApplication *sharedApp = [UIApplication sharedApplication];
  if (!sharedApp) {
    return;
  }

  [sharedApp launchApplicationWithIdentifier:@"net.whatsapp.WhatsApp" suspended:NO];
}

- (void)twitter {
  UIApplication *sharedApp = [UIApplication sharedApplication];
  if (!sharedApp) {
    return;
  }

  if ([sharedApp canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
    [sharedApp openURL:[NSURL URLWithString:@"tweetbot:///user_profile/kienforcefidele"]];
  } else if ([sharedApp canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
    [sharedApp openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=kienforcefidele"]];
  } else if ([sharedApp canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
    [sharedApp openURL:[NSURL URLWithString:@"twitter://user?screen_name=kienforcefidele"]];
  } else {
    [sharedApp openURL:[NSURL URLWithString:@"http://twitter.com/intent/follow?screen_name=kienforcefidele"]];
  }
}

- (void)donate {
  UIApplication *sharedApp = [UIApplication sharedApplication];
  if (!sharedApp) {
    return;
  }

  [sharedApp openURL:[NSURL URLWithString:@"https://www.paypal.me/fidele007/"]];
}

- (void)seeSourceCode {
  UIApplication *sharedApp = [UIApplication sharedApplication];
  if (!sharedApp) {
    return;
  }

  [sharedApp openURL:[NSURL URLWithString:@"https://github.com/fidele007/whatsapp-customizer"]];
}
@end

@interface WhatsAppCustomizerCell : PSTableCell {
  UILabel *_label;
  UILabel *_underLabel;
  UILabel *_hiddenLabel;
}
- (id)initWithSpecifier:(id)arg1;
@end

@implementation WhatsAppCustomizerCell
- (id)initWithSpecifier:(PSSpecifier *)specifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];
  if (self) {
    int width = [[UIScreen mainScreen] bounds].size.width;
    
    // Create hidden label
    CGRect hiddenFrame = CGRectMake(0, -700, width, 705);
    _hiddenLabel = [[UILabel alloc] initWithFrame:hiddenFrame];
    [_hiddenLabel setText:@"You got me :)"];
    [_hiddenLabel setBackgroundColor:[UIColor colorWithRed:0.043 green:0.651 blue:0.671 alpha:1]];
    _hiddenLabel.textColor = [UIColor purpleColor];
    _hiddenLabel.textAlignment = NSTextAlignmentCenter;
    _hiddenLabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 20];
    [self addSubview:_hiddenLabel];
    [_hiddenLabel release];

    CGRect frame = CGRectMake(0, 5, width, 50);
    CGRect botFrame = CGRectMake(0,35,width, 60);

    _label = [[UILabel alloc] initWithFrame:frame];
    [_label setLineBreakMode:UILineBreakModeWordWrap];
    [_label setNumberOfLines:1];
    [_label setText:@"WhatsAppCustomizer"];
    [_label setBackgroundColor:[UIColor colorWithRed:0.043 green:0.651 blue:0.671 alpha:1]];
    _label.textColor = [UIColor blackColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];

    _underLabel = [[UILabel alloc] initWithFrame:botFrame];
    [_underLabel setNumberOfLines:1];
    _underLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    [_underLabel setText:@"by fidele007"];
    [_underLabel setBackgroundColor:[UIColor colorWithRed:0.043 green:0.651 blue:0.671 alpha:1]];
    _underLabel.textColor = [UIColor blackColor];
    _underLabel.textAlignment = NSTextAlignmentCenter;

    [self addSubview:_underLabel];
    [self addSubview:_label];
    [_underLabel release];
    [_label release];
  }
  return self;
}

- (CGFloat)preferredHeightForWidth:(double)arg1 inTableView:(id)arg2 {
  return 80.0;
}

@end

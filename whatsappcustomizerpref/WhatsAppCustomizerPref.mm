#import "common.h"
#import <libcolorpicker.h>
#include <UIKit/UIApplication2.h>

#define SETTINGS_FILE @"/var/mobile/Library/Preferences/com.fidele007.whatsappcustomizerpref.plist"

@interface WhatsAppCustomizerPrefListController: PSListController {
	UIWindow *settingsView;
}
@end

@interface PSListController ()
-(void)clearCache;
-(void)reload;
-(void)viewWillAppear:(BOOL)animated;
-(void)reloadSpecifiers;
-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier;
@end

@implementation WhatsAppCustomizerPrefListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"WhatsAppCustomizerPref" target:self] retain];
		UIBarButtonItem *saveChangesButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveChangesButtonClicked:)];
	    [[self navigationItem] setRightBarButtonItem:saveChangesButton animated:YES];
	    [saveChangesButton release];
	}
	return _specifiers;
}

-(void)viewWillAppear:(BOOL)animated {
	// [self clearCache];
	// [self reload];
	[super viewWillAppear:animated];
	settingsView = [[UIApplication sharedApplication] keyWindow];
	settingsView.tintColor = [UIColor cyanColor];
	self.navigationController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.031 green:0.467 blue:0.482 alpha:1];
	// [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	settingsView = [[UIApplication sharedApplication] keyWindow];
	settingsView.tintColor = nil;
	self.navigationController.navigationController.navigationBar.barTintColor = nil;
	// [[UIApplication sharedApplication] setStatusBarStyle:nil];
}

-(void)saveChangesButtonClicked:(id)sender {
	[self.view endEditing:YES];
	system("killall -9 WhatsApp");
	UIAlertView *savedAlert = [[UIAlertView alloc] initWithTitle:@"Settings" message:@"Your settings have been saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[savedAlert show];
	[savedAlert release];
}

-(void)launchWhatsApp {
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"net.whatsapp.WhatsApp" suspended:NO];
}

-(id)readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE];
	if (!settings[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return settings[specifier.properties[@"key"]];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:SETTINGS_FILE]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:SETTINGS_FILE atomically:YES];
}

// -(void)resetPreferences {
// 	if (self) {
// 		for (PSSpecifier *specifier in [self specifiers]) {
// 			if ([specifier propertyForKey:@"key"]) {
// 				[self setPreferenceValue:[specifier propertyForKey:@"fallback"] specifier:specifier];
// 			}
// 		}
// 		[self reloadSpecifiers];
// 	}
// }

-(void)resetPreferences {
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
		UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"Settings" message:@"Your settings have been reset to defaults." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[resetAlert show];
		[resetAlert release];
	}
}

-(void)twitter {
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tweetbot:///user_profile/kienforcefidele"]];
    } else if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=kienforcefidele"]];
    } else if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"twitter://user?screen_name=kienforcefidele"]];
    } else {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://twitter.com/intent/follow?screen_name=kienforcefidele"]];
    }
}

-(void)donate {
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.paypal.me/fidele007/"]];
}

-(void)seeSourceCode {
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://github.com/fidele007/whatsapp-customizer"]];
}
@end

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)arg1;
@end

@interface WhatsAppCustomizerCell : PSTableCell <PreferencesTableCustomView> {
	UILabel *_label;
	UILabel *underLabel;
	UILabel *hiddenLabel;
	CGFloat height;
}
@end

@implementation WhatsAppCustomizerCell
-(id)initWithSpecifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];
	if (self) {
		int width = [[UIScreen mainScreen] bounds].size.width;
		
		// Create hidden label
		CGRect hiddenFrame = CGRectMake(0, -700, width, 705);
		hiddenLabel = [[UILabel alloc] initWithFrame:hiddenFrame];
		[hiddenLabel setText:@"You got me :)"];
		[hiddenLabel setBackgroundColor:[UIColor colorWithRed:0.043 green:0.651 blue:0.671 alpha:1]];
		hiddenLabel.textColor = [UIColor purpleColor];
		hiddenLabel.textAlignment = NSTextAlignmentCenter;
		hiddenLabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 20];
		[self addSubview:hiddenLabel];
		[hiddenLabel release];
		// End creating hidden label

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

		underLabel = [[UILabel alloc] initWithFrame:botFrame];
		[underLabel setNumberOfLines:1];
		underLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
		[underLabel setText:@"by fidele007"];
		[underLabel setBackgroundColor:[UIColor colorWithRed:0.043 green:0.651 blue:0.671 alpha:1]];
		underLabel.textColor = [UIColor blackColor];
		underLabel.textAlignment = NSTextAlignmentCenter;
 
		[self addSubview:underLabel];
		[self addSubview:_label];
		[underLabel release];
		[_label release];
	}
	return self;
}
 
-(CGFloat)preferredHeightForWidth:(double)arg1 inTableView:(id)arg2 {
	return 80.0;
}

@end

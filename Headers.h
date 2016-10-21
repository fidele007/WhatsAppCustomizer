@interface NSLayoutManager (WhatsAppCustomizer)
- (void)setBackgroundLayoutEnabled:(BOOL)arg1 ;
- (void)replaceTextStorage:(id)arg1 ;
@end

@interface WALabel : UILabel
@end

@interface TextMessage
@property (nonatomic,retain) UIColor *textColor;
@property (nonatomic,retain) UIColor *urlColor;
@end

@interface _TextMessage_TextKit : TextMessage
@end

@interface WAChatCellData : NSObject
@property (nonatomic,readonly) BOOL canBeForwarded;
@property (nonatomic,readonly) BOOL isFromMe;
@property (nonatomic,retain) NSArray *textMessages;
@property (nonatomic,readonly) unsigned long long footerStatus;
@end

@interface WAMessageCell : UITableViewCell
@property (nonatomic,readonly) WAChatCellData *cellData;
@property (nonatomic,retain) UIImageView *bubbleImageView;
@property (nonatomic,readonly) UIView *bubbleView;
@property (nonatomic,readonly) UILabel *fromNameLabel;
@end

@interface WATextMessageCell : WAMessageCell
@end

@interface WAMessageTextView : UIView
@end

@interface WAMessageFooterView : UIView
@property (nonatomic,readonly) unsigned long long status;
@end

@interface WABubbleView : UIView
@property (nonatomic,readonly) WAMessageFooterView *messageStatusView;
@end

@interface WAInstantVoiceBubbleView : WABubbleView
@end

@interface WAGroupEventMessageCell : WAMessageCell
@end

@interface WALargeMediaMessageCell : WAMessageCell
@property (nonatomic,readonly) UIImageView *lowerRightShadowView;
@property (nonatomic,readonly) WAMessageFooterView *footerView;
@end

@interface _WANoBlurNavigationBar : UINavigationBar
@end

@interface WAConversationHeaderView : UIView
@end

@interface WAChatBar : UIView
@property (nonatomic,readonly) UIButton *sendButton;
@property (nonatomic,readonly) UIButton *attachMediaButton;
@property (nonatomic,readonly) UIButton *cameraButton;
@property (nonatomic,readonly) UIButton *pttButton;
@end

@interface WATabBarController : UITabBarController
@end

@interface ContactsViewController
@property (nonatomic,retain) UITableView *tableView;
@end

@interface ContactTableViewCell : UITableViewCell
@end

@interface WAContactInfoTableViewCell : UITableViewCell
@end

@interface WAProfilePictureThumbnailView : UIImageView
@end

@interface WAChatSessionCell : UITableViewCell
@end

@interface _WAChatSessionCellModern : WAChatSessionCell
@end

@interface WhatsAppAppDelegate : NSObject
@property (nonatomic,retain) UIWindow *window;
- (void)resetViewControllers;
@end

// New
@interface _WANoHighlightImageView : UIImageView
@end

@interface WAMessage
@property (assign,nonatomic) BOOL isFromMe;
@property (nonatomic,readonly) BOOL canBeForwarded;
@property (nonatomic,readonly) unsigned long long footerStatus;
- (NSAttributedString *)footerAttributedText;
- (NSAttributedString *)attributedText;
@end

@interface WAMessageContainerView : UIView {
  _WANoHighlightImageView*_bubbleImageView;
  NSArray*_sliceViews;
}
@property (nonatomic,readonly) WAChatCellData *cellData;
@property (nonatomic,readonly) NSArray *sliceViews;
@property (nonatomic,readonly) WAMessage * message;
- (id)audioSliceView;
- (void)reloadSliceViews;
- (void)reloadSlicesIfNeeded;
@end

@interface WAAutoCropImageView : UIImageView
@end

@interface WAMessageContainerSlice : NSObject
@property (nonatomic,copy,readonly) NSArray *links;
@end

@interface WAMessageSenderNameSliceRenderer : NSObject {
  NSTextStorage* _senderNameTextStorage;
}
@end

@interface WAMessageSenderNameSlice : WAMessageContainerSlice {
  // WhatsApp v2.16.11 and lower
  NSTextStorage *_senderNameTextStorage;
  // WhatsApp v2.16.12 and higher
  WAMessageSenderNameSliceRenderer* _renderer;
}
-(id)initWithMessage:(id)arg1 metrics:(id)arg2 ;
@end

@interface WAMessageAttributedTextSlice : WAMessageContainerSlice {
  NSTextStorage *_textStorage;
  NSLock *_textObjectsLock;
}
@property (nonatomic,copy,readonly) NSArray *links;
@end

@interface WAMessageContainerSliceView
@property (nonatomic,readonly) WAMessage *message;
@property (nonatomic,readonly) WAChatCellData *cellData;
@end

@interface WAMessageAttributedTextSliceView : WAMessageContainerSliceView
@property (nonatomic,readonly) WAMessageAttributedTextSlice *slice;
@end

@interface WAMessageAttributedTextSliceLink : NSObject
@property (nonatomic,copy) NSString *text;
@end

@interface WAApplication : UIApplication
+ (WhatsAppAppDelegate *)wa_delegate;
@end

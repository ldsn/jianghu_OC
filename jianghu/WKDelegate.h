
#import <WebKit/WebKit.h>
@protocol WKDelegate <NSObject>

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

@interface WKDelegate : UIViewController <WKScriptMessageHandler>

@property (weak , nonatomic) id<WKDelegate> delegate;

@end

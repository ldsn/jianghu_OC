//
//  WV.h
//  jianghu
//
//  Created by fanmingfei on 22/11/2017.
//  Copyright © 2017 fanmingfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "PopView.h"


@interface WV : NSObject <WKScriptMessageHandler, WKNavigationDelegate>

@property WKWebView *appView;
@property PopView *popView;
@property NSMutableArray *msgList;
@property BOOL status;

-(void) initWebView: (WKWebView*)av popView: (PopView*)pv;
-(void) sendMessage: (NSString *) evt message:(NSString *)arg;
- (void) flushMessage;
-(void)setConfig:(NSDictionary*)conf;
+ (void) setStatus: (BOOL) status;
+(WV*) getInstance;
@end

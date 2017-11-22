//
//  WV.h
//  jianghu
//
//  Created by fanmingfei on 22/11/2017.
//  Copyright © 2017 fanmingfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>


@interface WV : NSObject <WKScriptMessageHandler, WKNavigationDelegate>

@property WKWebView *appView;
@property WKWebView *popView;
-(void) initWebView: (WKWebView*)av popView: (WKWebView*)pv;
@end

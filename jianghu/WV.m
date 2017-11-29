//
//  WV.m
//  jianghu
//
//  Created by fanmingfei on 22/11/2017.
//  Copyright © 2017 fanmingfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WV.h"

@implementation WV

- (id) init {
    self = [super init];
    if (self) {
        NSLog(@"init webview");
    }
    return self;
}



- (void) initWebView:(WKWebView *)av popView:(WKWebView *)pv{
    self.appView = av;
    self.popView = pv;
    
    
    [av.configuration.userContentController addScriptMessageHandler:self  name:@"APP_VIEW"];
    [pv.configuration.userContentController addScriptMessageHandler:self  name:@"POP_VIEW"];
    
    
    av.navigationDelegate = self;
    pv.navigationDelegate = self;

    
    [self.popView setHidden:true];

    [self.popView setOpaque:false];
    [self.popView setBackgroundColor:[UIColor clearColor]];
    [self.popView.scrollView setBackgroundColor:[UIColor clearColor]];
    
    [self resetUA];
    
}

- (void) resetUA {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    // app版本
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [self.appView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSString *userAgent = result;
        NSString *newUserAgent = [[[userAgent stringByAppendingString:@" JH "] stringByAppendingString:version] stringByAppendingString: @" APP_VIEW JH_IOS"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.appView setCustomUserAgent:newUserAgent];
    }];
    
    [self.popView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSString *userAgent = result;
        NSString *newUserAgent = [[[userAgent stringByAppendingString:@" JH "] stringByAppendingString:version] stringByAppendingString: @" POP_VIEW JH_IOS"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.popView setCustomUserAgent:newUserAgent];
    }];
}



#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
        NSDictionary *body = message.body;
        NSString *event = [body valueForKey:@"event"];
        NSString *arg = [body valueForKey:@"arg"];
        if ([event isEqualToString:@"load"]) {
            NSLog(@"%@",arg);
            [self.popView evaluateJavaScript:@"window.document && (document.innerHTML = '')" completionHandler:^(id xxx, NSError * _Nullable error) {
            }];
            NSURLRequest *URL = [NSURLRequest requestWithURL: [NSURL URLWithString:arg] cachePolicy:1 timeoutInterval:30.0f];
            [self.popView loadRequest: URL];
        }
        if ([event isEqualToString:@"hide"]) {
            [self.popView setHidden:true];
        }
        if ([event isEqualToString:@"show"]) {
            [self.popView setHidden:false];
        }
        
        if ([event isEqualToString:@"back"]) {
            if ([message.name isEqualToString:@"APP_VIEW"]) {
                [self.appView goBack];
            } else if ([message.name isEqualToString:@"POP_VIEW"]) {
                [self.popView goBack];
            }
        }
}



@end


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

static WV* _instance;

//初始化方法
- (WV*)init{
    // 只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    if (!_instance.msgList) {
        _instance.msgList = [NSMutableArray array];
    }
    
    return _instance;
}

+ (WV*) getInstance {
    return [[self alloc] init];
}

//alloc会调用allocWithZone:
+(WV*)allocWithZone:(struct _NSZone *)zone{
    //只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}



- (void) initWebView:(WKWebView *)av popView:(WKWebView *)pv{
    self.appView = av;
    self.popView = pv;
    
    
    
    [av.configuration.userContentController addScriptMessageHandler:self  name:@"APP_VIEW"];
    [pv.configuration.userContentController addScriptMessageHandler:self  name:@"POP_VIEW"];
    
    
    av.navigationDelegate = self;
//    pv.navigationDelegate = self;

    
    [self.popView setHidden:true];

    [self.popView setOpaque:false];
    [self.popView setBackgroundColor:[UIColor clearColor]];
    [self.popView.scrollView setBackgroundColor:[UIColor clearColor]];
    
    [self resetUA];
    
}
- (void) webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"404" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [webView loadRequest:request];
}

-(void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webview finish");
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

- (void) sendMessage: (NSString *) evt message:(NSString *)arg {
    
    NSLog(@"%@,%@", evt,arg);
    if(!self.status){
        NSLog(@"添加msgList");
        NSArray * msg = [[NSArray alloc] initWithObjects:evt, arg, nil];
        [[WV getInstance].msgList addObject:msg];
    } else {
        NSLog(@"sendMessage");
        NSString *script = [[[[@"window.__receiveJHMessage('" stringByAppendingString:evt] stringByAppendingString:@"','"] stringByAppendingString: arg] stringByAppendingString: @"')"];
        [[WV getInstance].appView evaluateJavaScript:script completionHandler:^(id xxx, NSError * _Nullable error) {
            if(error) {
                NSLog(@"%@", error);
            }
        }];
    }
    
}
- (void) flushMessage {
    [self setStatus:true];

    for (int i =0; i < self.msgList.count; i++) {
        NSArray * msg = [self.msgList objectAtIndex:i];
        NSString *type = [msg objectAtIndex:0];
        NSString *arg = [msg objectAtIndex:1];
        [self sendMessage:type message:arg];
    }
    [self.msgList removeAllObjects];
}
+ (void) setStatus: (BOOL) status {
    NSLog(@"设置状态%@",status?@"true":@"false");
    [WV getInstance].status = status;
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
    
    if ([event isEqualToString:@"inited"]){
        [self flushMessage];
    }
}



@end


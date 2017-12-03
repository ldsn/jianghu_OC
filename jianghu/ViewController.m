//
//  ViewController.m
//  jianghu
//
//  Created by fanmingfei on 04/11/2017.
//  Copyright © 2017 fanmingfei. All rights reserved.
//

#import "ViewController.h"




@implementation ViewController 



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"0");
    // Do any additional setup after loading the view, typically from a nib.
    CGRect statusFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect screen = [self.view bounds];
    
    CGRect rect = CGRectMake(0, statusFrame.size.height, screen.size.width, screen.size.height - statusFrame.size.height);
    
    
    WKWebViewConfiguration *configuration1 = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController1 =[[WKUserContentController alloc]init];
    configuration1.userContentController = userContentController1;
    
    WKWebViewConfiguration *configuration2 = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController2 =[[WKUserContentController alloc]init];
    configuration2.userContentController = userContentController2;
    
    self.appView = [[WKWebView alloc] initWithFrame:rect configuration:configuration1];
    self.popView = [[PopView alloc] initWithFrame:rect configuration:configuration2];

    bool debug = true;
    if(!debug) {
        [self.appView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://jianghu.ldustu.com"] cachePolicy:1 timeoutInterval:30.0f]];
    } else {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
        NSURL* url = [NSURL fileURLWithPath:path];
        NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
        [self.appView  loadRequest:request];
    }
    
    WV* wv = [WV getInstance];
    
    [wv initWebView:self.appView popView:self.popView];
    
    
    [self.view addSubview:self.appView];
    [self.view addSubview:self.popView];
    
    // 订阅前后台切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aa) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bb) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}



- (void)bb {
    [self.appView evaluateJavaScript:@"alert(123)" completionHandler:^(id _Nullable wd, NSError * _Nullable error) {
        
    }];
    
    NSLog(@"13");
    
}


- (void)aa {
    NSLog(@"13");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


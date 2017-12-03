//
//  WKWebView+PopView.h
//  jianghu
//
//  Created by fanmingfei on 29/11/2017.
//  Copyright © 2017 fanmingfei. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface PopView: WKWebView
@property(nonatomic) float clickAlpha;
-(void) modifyClickAlpha:(float)clickAlpha;
@end

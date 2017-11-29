//
//  WKWebView+PopView.m
//  jianghu
//
//  Created by fanmingfei on 29/11/2017.
//  Copyright © 2017 fanmingfei. All rights reserved.
//

#import "PopView.h"

@implementation PopView


-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat alpha = [self getPointAlpha:point];
    return alpha > 0.2f;
}

- (CGFloat)getPointAlpha:(CGPoint)point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    return pixel[3]/255.0;
}
@end

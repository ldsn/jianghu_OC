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
    if(self.clickAlpha == 0) {
        return true;
    } else if (self.clickAlpha == 1){
        return false;
    }
    CGFloat alpha = [self getPointAlpha:point];
    NSLog(@"ClickAlpha: %f, currAlpha%f", self.clickAlpha, alpha);
    return alpha > self.clickAlpha;
}

-(void) modifyClickAlpha:(float)clickAlpha{
    NSLog(@"setClickAlpha: %f", clickAlpha);
    self.clickAlpha = clickAlpha;
}

- (CGFloat)getPointAlpha:(CGPoint)point {
    NSLog(@"Point:%f,%f",point.x, point.y);
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

//
//  WVV.m
//  jianghu
//
//  Created by fanmingfei on 22/11/2017.
//  Copyright © 2017 fanmingfei. All rights reserved.
//

#import <Foundation/Foundation.h>
static Class *class = nil;



@implementation MyClass



+(MyClass *)sharedMyClass{
    
    @synchronized(self){  //为了确保多线程情况下，仍然确保实体的唯一性
        
        if (!class) {
            
            [[self alloc] init]; //该方法会调用 allocWithZone
            
        }
        
    }
    
    return class;
    
}



+(id)allocWithZone:(NSZone *)zone{
    
    @synchronized(self){
        
        if (!class) {
            
            class = [super allocWithZone:zone]; //确保使用同一块内存地址
            
            return class;
            
        }
        
    }
    
    return nil;
    
}



- (id)copyWithZone:(NSZone *)zone;{
    
    return self; //确保copy对象也是唯一
    
}



-(id)retain{
    
    return self; //确保计数唯一
    
}



- (unsigned)retainCount

{
    
    return UINT_MAX;  //装逼用的，这样打印出来的计数永远为-1
    
}



- (id)autorelease

{
    
    return self;//确保计数唯一
    
} 



- (oneway void)release

{
    
    //重写计数释放方法
    
}

@end


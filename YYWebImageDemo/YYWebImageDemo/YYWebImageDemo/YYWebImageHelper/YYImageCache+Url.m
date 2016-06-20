//
//  YYImageCache+Url.m
//  YYWebImageDemo
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 李政. All rights reserved.
//

#import "YYImageCache+Url.h"
#import <objc/runtime.h> 

@implementation YYImageCache (Url)

//hook类方法
void exchangeMethod(Class aClass, SEL oldSEL, SEL newSEL)
{
    Method oldMethod = class_getClassMethod(aClass, oldSEL);
    assert(oldMethod);
    Method newMethod = class_getClassMethod(aClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
}

+ (void)hook
{
    exchangeMethod([YYImageCache class],
                   @selector(sharedCache),
                   @selector(hook_sharedCache));
}

+ (instancetype)hook_sharedCache
{
    [[self class] hook_sharedCache];
    static YYImageCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                   NSUserDomainMask, YES) firstObject];
//        cachePath = [cachePath stringByAppendingPathComponent:@"com.ibireme.yykit"];
//        cachePath = [cachePath stringByAppendingPathComponent:@"images"];
        cache = [[self alloc] initWithPath:cachePath];
    });
    NSLog(@"hook_sharedCache");
    return cache;
}

@end

//
//  UIImageView+CBDWebImage.m
//  YYWebImageDemo
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 李政. All rights reserved.
//

#import "UIImageView+CBDWebImage.h"
#import <YYWebImage/YYWebImage.h>
#import "Masonry.h"
#import <objc/runtime.h>

@implementation UIImageView (CBDWebImage)

@dynamic activity;
static char View_Activity;

- (UIActivityIndicatorView *)activity {
    return objc_getAssociatedObject(self, &View_Activity);
}

- (void)setActivity:(UIActivityIndicatorView *)activity{
    [self willChangeValueForKey:@"activity"];
    objc_setAssociatedObject(self, &View_Activity, activity, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"activity"];
}

- (NSURL *)cbd_imageURL {
    return [self yy_imageURL];
}

-(void)setCbd_imageURL:(NSURL *)cbd_imageURL{
    if(!self.activity)
    {
        self.activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activity.frame = CGRectMake(0, 0, 30, 30);
        [self addSubview:self.activity];
        [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0);
            make.centerX.mas_offset(0);
        }];
        [self.activity startAnimating];
    }else
    {
        if(!self.activity.isAnimating)
        {
            [self.activity startAnimating];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self yy_setImageWithURL:cbd_imageURL
                 placeholder:nil
                     options:kNilOptions
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                      //
                      [weakSelf.activity stopAnimating];
                      if(error)
                      {
                          NSLog(@"%@",error.description);
                      }
                      NSLog(@"%lu",(unsigned long)from);
                  }];
}


- (void)cbd_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(YYWebImageOptions)options
                completion:(YYWebImageCompletionBlock)completion {
    if(!self.activity)
    {
        self.activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activity.frame = CGRectMake(0, 0, 30, 30);
        [self addSubview:self.activity];
        [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_offset(0);
        }];
        [self.activity startAnimating];
    }else
    {
        if(!self.activity.isAnimating)
        {
            [self.activity startAnimating];
        }
    }
    [self yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:completion];
    __weak typeof(self) weakSelf = self;
    completion=^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        //
        [weakSelf.activity stopAnimating];
        NSLog(@"%lu",(unsigned long)from);
    };
}

@end

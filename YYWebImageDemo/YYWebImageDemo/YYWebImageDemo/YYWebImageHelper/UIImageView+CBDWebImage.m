//
//  UIImageView+CBDWebImage.m
//  YYWebImageDemo
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 李政. All rights reserved.
//

#import "UIImageView+CBDWebImage.h"
#import "Masonry.h"
#import <objc/runtime.h>

@implementation UIImageView (CBDWebImage)

@dynamic activity;
@dynamic progressView;
static char View_Activity;
static char View_ProgressView;

#pragma mark - Property

- (UIActivityIndicatorView *)activity {
    return objc_getAssociatedObject(self, &View_Activity);
}

- (void)setActivity:(UIActivityIndicatorView *)activity{
    [self willChangeValueForKey:@"activity"];
    objc_setAssociatedObject(self, &View_Activity, activity, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"activity"];
}

- (CBDProgressView *)progressView {
    return objc_getAssociatedObject(self, &View_ProgressView);
}

- (void)setProgressView:(CBDProgressView *)progressView{
    [self willChangeValueForKey:@"progressView"];
    objc_setAssociatedObject(self, &View_ProgressView, progressView, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"progressView"];
}

#pragma mark - Method

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
    __weak typeof(self) weakSelf = self;
    YYWebImageCompletionBlock completionBlock=^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        //
        [weakSelf.activity stopAnimating];
        NSLog(@"%lu",(unsigned long)from);
        completion(image, url, from, stage, error);
    };
    [self yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:kNilOptions
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:completionBlock];
}

- (void)cbd_setImageWithURL:(NSURL *)imageURL
                placeholder:(UIImage *)placeholder
                    options:(YYWebImageOptions)options
                    progress:(YYWebImageProgressBlock)progress
                 completion:(YYWebImageCompletionBlock)completion {
    if(!self.progressView)
    {
        self.progressView=[[CBDProgressView alloc] initWithFrame:CGRectMake(0, 0, 0, 3)];
        self.progressView.progress=0.0;
        [self addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_offset(0);
            make.width.mas_equalTo(0.618*self.frame.size.width);//黄金比例
            make.height.mas_equalTo(3);
        }];
    }
    __weak typeof(self) weakSelf = self;
    YYWebImageCompletionBlock completionBlock=^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if(weakSelf.progressView)
        {
            [weakSelf.progressView removeFromSuperview];
        }
        completion(image, url, from, stage, error);
    };
    YYWebImageProgressBlock progressBlock=^(NSInteger receivedSize, NSInteger expectedSize){
        float x=(receivedSize* 1.0)/(expectedSize* 1.0);
        if(x>=0)
        {
            weakSelf.progressView.progress=x;
        }else
        {
            if(weakSelf.progressView)
            {
                [weakSelf.progressView removeFromSuperview];
            }
        }
        progress(receivedSize,expectedSize);
    };
    [self yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:kNilOptions
                     manager:nil
                    progress:progressBlock
                   transform:nil
                  completion:completionBlock];
}


@end

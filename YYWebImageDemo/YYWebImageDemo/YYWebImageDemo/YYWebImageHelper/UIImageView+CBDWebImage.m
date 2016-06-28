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
static char Value_loadType;

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

- (enumLoadingType)loadType
{
    return [objc_getAssociatedObject(self, &Value_loadType) intValue];
}

-(void)setLoadType:(enumLoadingType)_loadType
{
    objc_setAssociatedObject(self, &Value_loadType, @(_loadType), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - Method

- (NSURL *)cbd_imageURL {
    return [self yy_imageURL];
}

-(void)setCbd_imageURL:(NSURL *)cbd_imageURL{
    
    [self cbd_setImageWithURL:cbd_imageURL placeholder:nil options:kNilOptions completion:nil];
}


- (void)cbd_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(YYWebImageOptions)options
                completion:(YYWebImageCompletionBlock)completion {
    [self cbd_setImageWithURL:imageURL placeholder:placeholder options:options progress:nil completion:completion];
}

- (void)cbd_setImageWithURL:(NSURL *)imageURL
                placeholder:(UIImage *)placeholder
                    options:(YYWebImageOptions)options
                    progress:(YYWebImageProgressBlock)progress
                 completion:(YYWebImageCompletionBlock)completion {
    if(self.loadType==enumLoadActivityIndicator)
    {
        self.activity=[self createLoadingView];
        if(!self.activity.isAnimating)
        {
            [self.activity startAnimating];
        }
    }else if(self.loadType==enumLoadProgressLine)
    {
        self.progressView=[self createLoadingView];
    }
    __weak typeof(self) weakSelf = self;
    YYWebImageCompletionBlock completionBlock=^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if(weakSelf.loadType==enumLoadActivityIndicator)
        {
            [weakSelf.activity stopAnimating];
        }else if(weakSelf.loadType==enumLoadProgressLine)
        {
            [weakSelf.progressView removeFromSuperview];
        }
        completion(image, url, from, stage, error);
    };
    YYWebImageProgressBlock progressBlock=^(NSInteger receivedSize, NSInteger expectedSize){
        float x=(receivedSize* 1.0)/(expectedSize* 1.0);
        if(weakSelf.loadType==enumLoadActivityIndicator)
        {
            [weakSelf.activity stopAnimating];
        }else if(weakSelf.loadType==enumLoadProgressLine)
        {
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

-(id)createLoadingView{
    if(self.loadType==enumLoadActivityIndicator)
    {
        if(!self.activity)
        {
            self.activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            self.activity.frame = CGRectMake(0, 0, 30, 30);
            [self addSubview:self.activity];
            [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_offset(0);
                make.centerX.mas_offset(0);
            }];
        }
        return self.activity;
    }else if(self.loadType==enumLoadProgressLine)
    {
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
        return self.progressView;
    }else
    {
        return nil;
    }
}

@end

//
//  UIImageView+CBDWebImage.h
//  YYWebImageDemo
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 李政. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYWebImage/YYWebImage.h>
#import "CBDProgressView.h"

@interface UIImageView (CBDWebImage)

@property (nullable, nonatomic, strong) NSURL *cbd_imageURL;
@property (nullable, nonatomic, strong,getter=activity) UIActivityIndicatorView *activity;
@property (nullable, nonatomic, strong) CBDProgressView *progressView;

- (void)cbd_setImageWithURL:(nullable NSURL *)imageURL
                placeholder:(nullable UIImage *)placeholder
                    options:(YYWebImageOptions)options
                 completion:(nullable YYWebImageCompletionBlock)completion;

- (void)cbd_setImageWithURL:(nullable NSURL *)imageURL
                placeholder:(nullable UIImage *)placeholder
                    options:(YYWebImageOptions)options
                   progress:(nullable YYWebImageProgressBlock)progress
                 completion:(nullable YYWebImageCompletionBlock)completion;
@end

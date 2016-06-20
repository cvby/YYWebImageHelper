//
//  UIImageView+CBDWebImage.h
//  YYWebImageDemo
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 李政. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CBDWebImage)

@property (nullable, nonatomic, strong) NSURL *cbd_imageURL;
@property (nullable, nonatomic, strong) UIActivityIndicatorView *activity;

@end

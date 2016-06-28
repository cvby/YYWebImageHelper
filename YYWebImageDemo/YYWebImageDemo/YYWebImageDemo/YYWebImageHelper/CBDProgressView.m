//
//  CBDProgressView.m
//  CarBaDa
//
//  Created by admin on 16/6/28.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "CBDProgressView.h"

@interface CBDProgressView()

@property (nonatomic,strong)CALayer *progressLayer;

@end

@implementation CBDProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.progressLayer = [CALayer layer];
        self.progressLayer.frame =CGRectMake(0,0,0, frame.size.height);
        self.progressLayer.backgroundColor = [UIColor cyanColor].CGColor;
        [self.layer addSublayer:self.progressLayer];
    }
    return self;
}

-(void)setProgress:(float)progress{
    _progress=progress;
    NSLog(@"%f",self.frame.size.width);
    self.progressLayer.frame =CGRectMake(0,0,self.frame.size.width *progress,self.frame.size.height);
}

@end

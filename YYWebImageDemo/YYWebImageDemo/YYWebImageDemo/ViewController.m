//
//  ViewController.m
//  YYWebImageDemo
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 李政. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+CBDWebImage.h"
#import <YYWebImage/YYWebImage.h>

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *svImageView;
@property (nonatomic,strong) YYAnimatedImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //[self test1];
    [self test2];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)test1{
    NSURL *path = [[NSBundle mainBundle]URLForResource:@"guidegif" withExtension:@"gif"];
    _imageView = [YYAnimatedImageView new];
    _imageView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_svImageView addSubview:_imageView];
    _imageView.yy_imageURL = path;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.65 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSURL *path2 = [[NSBundle mainBundle]URLForResource:@"guidegif_loop" withExtension:@"gif"];
        YYImage * image = [YYImage imageWithContentsOfFile:path2.path];
        _imageView.image = image;
    });
}

-(void)test2{
    UIImageView* imvAd=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    [_svImageView addSubview:imvAd];
    imvAd.cbd_imageURL=[NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1466392218&di=187f37fba96e86cd161e57c1aa31160e&src=http://attach.bbs.miui.com/forum/201502/03/150921dx9qaamw4kws9st4.jpg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

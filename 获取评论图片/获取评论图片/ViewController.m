//
//  ViewController.m
//  获取评论图片
//
//  Created by 蔡国龙 on 17/3/14.
//  Copyright © 2017年 TG. All rights reserved.
//

#import "ViewController.h"
#import "TGAlbumManager.h"
//#import "TGShowImageVC.h"
@interface ViewController ()<TGAlbumManagerDelegate>
@property(nonatomic)TGAlbumManager *mgr;
//TGAlbumManager *mgr
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_mgr) {
         _mgr = [TGAlbumManager new];
    }
    _mgr.delegate = self;
    [_mgr getImagesFromAlbum];
}
- (void)didFinishedImages:(NSArray<TGAssetModel *> *)images
{

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

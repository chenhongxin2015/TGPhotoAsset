//
//  TGAlbumManager.h
//  CurtilageSakuraProject
//
//  Created by apple on 2017/2/13.
//  Copyright © 2017年 lzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class TGAssetModel;
@protocol TGAlbumManagerDelegate <NSObject>
//获取完图片
- (void)didFinishedImages:(NSArray <TGAssetModel *>*)images;
@end
@interface TGAlbumManager : NSObject
@property (nonatomic,strong) NSMutableArray <TGAssetModel*>*albumsArray;
@property (nonatomic,strong) NSMutableArray <TGAssetModel*>*imagesAssetArray;

@property (nonatomic,strong) NSMutableArray *selectedImages;

@property (nonatomic,weak) UIViewController  <TGAlbumManagerDelegate>* delegate;
@property (nonatomic,assign) NSInteger maxCount;

- (void)getImagesFromAlbum;
@end

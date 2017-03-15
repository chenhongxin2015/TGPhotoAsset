//
//  TGAlbumManager.m
//  CurtilageSakuraProject
//
//  Created by apple on 2017/2/13.
//  Copyright © 2017年 lzq. All rights reserved.
//

#import "TGAlbumManager.h"
#import "TGAssetModel.h"
#import "TGShowImageVC.h"
//#import <AssetsLibrary/AssetsLibrary.h>
@interface TGAlbumManager()
//@property(nonatomic,strong)ALAssetsLibrary *assetsLibrary;


@end
@implementation TGAlbumManager

- (NSMutableArray *)imagesAssetArray
{
    if (!_imagesAssetArray) {
        _imagesAssetArray = [NSMutableArray array];
    }return _imagesAssetArray;
}
- (NSMutableArray *)albumsArray
{
    if (!_albumsArray) {
        _albumsArray = [NSMutableArray array];
    }return _albumsArray;
}

- (NSMutableArray *)selectedImages
{
    if (!_selectedImages) {
        _selectedImages = [NSMutableArray array];
    }return _selectedImages;
}
- (void)getImagesFromAlbum{
//    NSLog(@"yes");
    if (self.imagesAssetArray.count) {
        [self didFinishedImages];
//         [self.delegate didFinishedImages];
        return;
    }
    [self getFrom];
}

- (void)getFrom{
//    TGLog(@"ok");
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        // 这里便是无访问权限
        
//        [self.delegate pikerImageFinishedFromCamera:isCamera];
        
    }else
    {
        
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                NSLog(@"%@",[NSThread currentThread]);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self getAllAssetInPhotoAblumWithAscending:NO fromCamera:YES];
                });
                
            }];
            return;

        }

        [self getAllAssetInPhotoAblumWithAscending:NO fromCamera:NO];
        
        
    }
#else
#endif
    
}


#pragma mark - 获取相册内所有照片资源
- (void)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending fromCamera:(BOOL)isCamera
{
    
    
    
    
    
    
    //    [_imagesAssetArray removeAllObjects];
//    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (*stop) {
            NSLog(@"yes");
        }
        PHAsset *asset = (PHAsset *)obj;
        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
        TGAssetModel *model = [TGAssetModel new];
        model.pAsset = asset;
        model.isSelected = NO;
        
        [self.imagesAssetArray addObject:model];
//        [assets addObject:asset];
#ifdef TG_DEBUG
        NSLog(@"%s,line = %d ",__FUNCTION__,__LINE__);
        NSLog(@"当前方法：%s\n,当前行数%d\n,当前线程%@\n",__func__,__LINE__,[NSThread currentThread]);
#endif
    }];
    
    [self didFinishedImages];
    
//    return assets;
}
- (void)didFinishedImages{
    TGShowImageVC *vc = [TGShowImageVC new];
    vc.maxCount = self.maxCount;
    vc.didSelectedImages =^(NSArray *images){
        NSLog(@"%@",images);
         [self.delegate didFinishedImages:images];
        //        self.imageView.image = images[0];
        //        self.thumbIV.image = thumbnailImges[0];
    };
    vc.albumMgr = self;
    [self.delegate presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
}
#pragma mark -- PHPhotoLibraryChangeObserver
//相册变化回调

/*
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
#ifdef TG_DEBUG
    NSLog(@"当前方法：%s\n,当前行数%d\n,当前线程%@\n",__func__,__LINE__,[NSThread currentThread]);
    NSLog(@"%s,line = %d ",__FUNCTION__,__LINE__);
#endif
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        // your codes
        NSLog(@"保存相册");
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (!(status == PHAuthorizationStatusRestricted ||
              status == PHAuthorizationStatusDenied)){
            
            [self getAllAssetInPhotoAblumWithAscending:NO fromCamera:NO];
        }
    });
    
    
}
 */

@end

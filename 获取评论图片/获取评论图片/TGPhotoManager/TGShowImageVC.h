//
//  TGShowImageVC.h
//  CurtilageSakuraProject
//
//  Created by apple on 2017/2/13.
//  Copyright © 2017年 lzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGAlbumManager.h"

typedef void(^Block)(NSArray<TGAssetModel *> *images);
@interface TGShowImageVC : UIViewController
@property (nonatomic,strong) TGAlbumManager *albumMgr;
@property (nonatomic,strong) Block didSelectedImages;
@property (nonatomic,assign) NSInteger maxCount;
@end

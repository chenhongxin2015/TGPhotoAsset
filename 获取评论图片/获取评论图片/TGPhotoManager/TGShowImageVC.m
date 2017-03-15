//
//  TGShowImageVC.m
//  CurtilageSakuraProject
//
//  Created by apple on 2017/2/13.
//  Copyright © 2017年 lzq. All rights reserved.
//

#import "TGShowImageVC.h"
#import "TGImageCell.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface TGShowImageVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) NSMutableArray *selecedImages;
@property(nonatomic,strong) NSMutableArray *thumbnailImges;
@property(nonatomic,strong) UIView *toolView;



@end

@implementation TGShowImageVC

- (UIView *)toolView
{
    if (_toolView == nil) {
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [_toolView setBackgroundColor:[UIColor orangeColor]];
        [self.view addSubview:_toolView];
    }return _toolView;
}
- (NSMutableArray *)selecedImages
{
    if (!_selecedImages) {
        _selecedImages = [NSMutableArray array];
    }return _selecedImages;
}
- (NSMutableArray *)thumbnailImges
{
    
    
    if (!_thumbnailImges) {
        _thumbnailImges = [NSMutableArray array];
    }return _thumbnailImges;
}


static NSString * const reuseIdentifier = @"Cell";
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        CGFloat width = (SCREEN_WIDTH - 4 * 4)/3;
        CGFloat height = width;
        layout.itemSize = CGSizeMake(width, height);
        layout.minimumLineSpacing = 4;
        layout.minimumInteritemSpacing = 4;
        layout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
         [_collectionView registerNib:[UINib nibWithNibName:@"TGImageCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        [self.view addSubview:_collectionView];
    }return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册";
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finished)];
    [self toolView];

}
- (void)finished{
    
    
    for (TGAssetModel *model in self.albumMgr.selectedImages) {
        model.isSelected = NO;
    }
    self.didSelectedImages(self.albumMgr.selectedImages);
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self.albumMgr.selectedImages removeAllObjects];
    }];
    

}



- (void)setAsset:(TGAssetModel *)asset
{

    // 获取资源图片的 fullScreenImage
//    UIImage *contentImage = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    //仅显示缩略图，不控制质量显示
    /**
     PHImageRequestOptionsResizeModeNone,
     PHImageRequestOptionsResizeModeFast, //根据传入的size，迅速加载大小相匹配(略大于或略小于)的图像
     PHImageRequestOptionsResizeModeExact //精确的加载与传入size相匹配的图像
     */
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = YES;
    //    param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
//    __weak typeof(self) weakSelf;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset.pAsset targetSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT ) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {

        if (image.size.width > 100) {
            [self.selecedImages addObject:image];
            NSLog(@"完成选择图片%@",info);
            if (self.selecedImages.count == self.albumMgr.selectedImages.count) {
                
                [self.albumMgr.selectedImages removeAllObjects];
                //            self.
//                NSLog(@"完成选择图片%ld %ld",self.selecedImages.count,self.albumMgr.selectedImages.count);
//                self.didSelectedImages(self.selecedImages,self.thumbnailImges);
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                return ;
            }
            
        }else
        {
            [self.thumbnailImges addObject: image];
           NSLog(@"选择图片%@",info);

        }

    }];
#else
    //     ALAssetRepresentation *representation = [asset.asset defaultRepresentation];
    //  self.imageView.image  =   [UIImage imageWithCGImage:representation.fullScreenImage];
#endif
    
    
    
    
//    self.selectedBtn.selected = asset.isSelected;
    
}





- (void)goback{
    
    for (TGAssetModel *model in self.albumMgr.selectedImages) {
        model.isSelected = NO;
    }
    [self.albumMgr.selectedImages removeAllObjects];

    [self.navigationController dismissViewControllerAnimated:YES completion:^{

    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.albumMgr.imagesAssetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TGImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.asset = self.albumMgr.imagesAssetArray[indexPath.row];
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TGAssetModel *model = self.albumMgr.imagesAssetArray[indexPath.row];
    model.isSelected = !model.isSelected;
    if (self.albumMgr.selectedImages.count >= (self.maxCount ? self.maxCount :3) &&model.isSelected) {
        model.isSelected = !model.isSelected;
        NSString *message = [NSString stringWithFormat:@"最多选择%ld张图片",((self.maxCount ? self.maxCount :3))];
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
//        UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"<#type#>" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:action1];
//        [ac addAction:action1];
        [self presentViewController:ac animated:YES completion:nil];
//        [SVProgressHUD showInfoWithStatus:@"最多选择3张图片"];
        return;
    }
//
    if (model.isSelected) {
        [self.albumMgr.selectedImages addObject:model];
    }else
    {
        [self.albumMgr.selectedImages removeObject:model];
    }
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}
@end

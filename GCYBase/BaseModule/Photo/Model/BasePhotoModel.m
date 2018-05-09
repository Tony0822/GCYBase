//
//  BasePhotoModel.m
//  GCYBase
//
//  Created by gaochongyang on 2018/5/8.
//

#import "BasePhotoModel.h"
#import "BaseConst.h"
#import <objc/runtime.h>

const char * kThumbImageKey = "kThumbImageKey";//缩略图
const char * kFullScreenImageKey = "kFullScreenImageKey";//屏幕大小图
const char * kOriginalImageKey = "kOriginalImageKey";//原图
const char * kPHImageFileURLKey = "kPHImageFileURLKey";//原图本地路径
const char * kOriginalImageData = "kOriginalImageData";//原图data
const char * kOriginalImageSize = "kOriginalImageSize";//原图大小


@implementation BasePhotoModel

+ (PHImageManager *)sharedPHImageManager {
    static PHImageManager *imageManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageManager = [[PHImageManager alloc] init];
    });
    return imageManager;
}

- (void)setPhAsset:(PHAsset *)phAsset {
    _phAsset = phAsset;
    // 图片的属性
    [self getOriginalImageSizeWithAsset:phAsset];
}

#pragma mark -- 缩略图

- (void)thumbImageWithBlock:(GetThumbImageBlock)getThumbImageBlock {
    // 取出关联对象，所关联的值
    UIImage *image = objc_getAssociatedObject(self, kThumbImageKey);
    if (image != nil) {
        GetThumbImageBlock(image);
        return;
    }
    CGFloat itemWH = (SCREEN_WIDTH - (4+1)*PADDING/2)/4;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    [[BasePhotoModel sharedPHImageManager] requestImageForAsset:self.phAsset
                                                     targetSize:CGSizeMake(itemWH * screenScale, itemWH * screenScale)
                                                    contentMode:PHImageContentModeAspectFill
                                                        options:options
                                                  resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                      NSLog(@"1-----缩略图");
                                                      getThumbImageBlock(result);
                                                      // 此处设置关联对象
                                                      objc_setAssociatedObject(self, kThumbImageKey, result, OBJC_ASSOCIATION_COPY_NONATOMIC);
                                                  }];
}

#pragma mark -- 全屏图
- (void)fullScreenImageWithBlock:(GetFullScreenImageBlock)GetFullScreenImageBlock {
    UIImage *image = objc_getAssociatedObject(self, kFullScreenImageKey);
    if (image != nil) {
        GetFullScreenImageBlock(image, YES);
        return;
    }
    CGFloat screenScale = [UIScreen mainScreen].scale;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    [[BasePhotoModel sharedPHImageManager] requestImageForAsset:self.phAsset
                                                     targetSize:CGSizeMake(SCREEN_WIDTH * screenScale, SCREEN_WIDTH *screenScale)
                                                    contentMode:PHImageContentModeAspectFill
                                                        options:options
                                                  resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                      NSLog(@"2-----全屏图");
                                                      if ([[info valueForKey:@"PHImageResultIsDegradedKey"] integerValue] == 0) {
                                                          GetFullScreenImageBlock(result, YES);
                                                          objc_setAssociatedObject(self, kFullScreenImageKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                                                      } else {
                                                          GetFullScreenImageBlock(result, NO);
                                                      }
    }];
}

#pragma mark -- 原图相关元素

- (NSString *)originalImageFileURL {
    NSString *path = objc_getAssociatedObject(self, kPHImageFileURLKey);
    return path;
}

- (NSData *)originalImageData {
    NSData *data = objc_getAssociatedObject(self, kOriginalImageData);
    return data;
}

- (CGFloat)originalImageSize {
    NSString *size = objc_getAssociatedObject(self, kOriginalImageSize);
    return [size floatValue];
}

- (void)getOriginalImageSizeWithAsset:(PHAsset *)phAsset {
    [[BasePhotoModel sharedPHImageManager] requestImageDataForAsset:phAsset
                                                            options:nil
                                                      resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                          CGFloat dataSize = imageData.length/(1024*1024.0);
                                                          objc_setAssociatedObject(self, kOriginalImageSize, [NSString stringWithFormat:@"%f", dataSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                                                          objc_setAssociatedObject(self, kOriginalImageData, imageData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                                                          objc_setAssociatedObject(self, kPHImageFileURLKey, [info objectForKey:@"PHImageFileURLKey"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                                                      }];
}

- (BOOL)isVideoType {
    PHAssetMediaType mediaType = self.phAsset.mediaType;
    return mediaType == PHAssetMediaTypeVideo ? YES : NO;
}

- (NSString *)videoTime {
    NSInteger time = (NSInteger)self.phAsset.duration;
    NSInteger minute = time / 60;
    CGFloat second = time % 60;
    return [NSString stringWithFormat:@"%zd:%.2f", minute, second];
}
@end

//
//  BasePhotoGroupModel.h
//  GCYBase
//
//  Created by gaochongyang on 2018/5/8.
//

#import <Foundation/Foundation.h>
#import <Photos/PHCollection.h>

@interface BasePhotoGroupModel : NSObject
/** 相册组名 */
@property (nonatomic , copy) NSString *groupName;

/** 相册组缩略图 */
@property (nonatomic , strong) UIImage *thumbImage;

/** 单个相册图片总数 */
@property (nonatomic , assign) NSInteger assetsCount;

/** 相册的类型 Saved Photos... */
@property (nonatomic , copy) NSString *type;

/** PHotoKit group */
@property(nonatomic,strong) PHAssetCollection *assetCollection;

@end

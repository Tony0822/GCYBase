//
//  GCYPhotoAuthor.h
//  GCYBase
//
//  Created by gaochongyang on 2018/5/4.
//

#import <Foundation/Foundation.h>

typedef void (^CheckSuccess)(void);
typedef void (^CheckFailure)(NSString *message);

@interface BasePhotoAuthor : NSObject

/**
 检查相册权限

 @param success success
 @param failure failure
 */
+ (void)checkPhotAuthorSuccess:(CheckSuccess)success failure:(CheckFailure)failure;

/**
 检查相机权限

 @param success success
 @param failure failure
 */
+ (void)checkCameraAuthorSuccess:(CheckSuccess)success failure:(CheckFailure)failure;

@end

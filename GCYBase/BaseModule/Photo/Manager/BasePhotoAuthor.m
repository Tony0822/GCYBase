//
//  GCYPhotoAuthor.m
//  GCYBase
//
//  Created by gaochongyang on 2018/5/4.
//

#import "BasePhotoAuthor.h"
#import <Photos/Photos.h>

@implementation BasePhotoAuthor

#pragma mark --private
+ (BOOL)isCameraDenied {
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied) {
        return YES;
    }
    return NO;
}

+ (BOOL)isCameraNotDetermined {
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (author == AVAuthorizationStatusNotDetermined) {
        return YES;
    }
    return NO;
}

+ (BOOL)isPhotoAlbumDenied {
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusDenied || author == PHAuthorizationStatusRestricted) {
        return YES;
    }
    return NO;
}

+ (BOOL)isPhotoAlbumNotDetermined {
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusNotDetermined) {
        return YES;
    }
    return NO;
}

#pragma mark -- public
+ (void)checkPhotAuthorSuccess:(CheckSuccess)success failure:(CheckFailure)failure {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
      // 第一次安装APP，还未确定权限，调用这里
        if ([BasePhotoAuthor isPhotoAlbumNotDetermined]) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                // 该API从ios8.0 开始支持，系统弹出授权对话框
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                            // 用户拒绝，跳转到自定义提示页面
                            NSLog(@"用户拒绝");
                            if (failure) {
                                failure(@"用户拒绝访问相册");
                            }
                        } else if (status == PHAuthorizationStatusAuthorized) {
                            // 用户授权，弹出相册对话框
                            if (success) {
                                success();
                            }
                        }
                    });
                }];
            } else {
                NSLog(@"ios 8 以下不支持");
                if (failure) {
                    failure(@"ios 8 以下不支持");
                }
            }
        } else if ([BasePhotoAuthor isPhotoAlbumDenied]) {
            // 如果已经拒绝，则弹出对话框
            NSLog(@"拒绝访问相册，可以设置隐私里开启");
            if (failure) {
                failure(@"拒绝访问相册，可以设置隐私里开启");
            }
        } else {
            NSLog(@"已经授权");
            if (success) {
                success();
            }
        }
    } else {
        // 当前设备不支持打开相册
        NSLog(@"当前设备不支持打开相册");
        if (failure) {
            failure(@"当前设备不支持打开相册");
        }
    }
    
}

+ (void)checkCameraAuthorSuccess:(CheckSuccess)success failure:(CheckFailure)failure {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 第一次安装APP，还未确定权限，调用这里
        if ([BasePhotoAuthor isPhotoAlbumNotDetermined]) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                // 该API从ios8.0 开始支持，系统弹出授权对话框
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                            // 用户拒绝，跳转到自定义提示页面
                            NSLog(@"用户拒绝");
                            if (failure) {
                                failure(@"用户拒绝访问相机");
                            }
                        } else if (status == PHAuthorizationStatusAuthorized) {
                            // 用户授权，弹出相机对话框
                            if (success) {
                                success();
                            }
                        }
                    });
                }];
            } else {
                NSLog(@"ios 8 以下不支持");
                if (failure) {
                    failure(@"ios 8 以下不支持");
                }
            }
        } else if ([BasePhotoAuthor isPhotoAlbumDenied]) {
            // 如果已经拒绝，则弹出对话框
            NSLog(@"拒绝访问相机，可以设置隐私里开启");
            if (failure) {
                failure(@"拒绝访问相机，可以设置隐私里开启");
            }
        } else {
            NSLog(@"已经授权");
            if (success) {
                success();
            }
        }
    } else {
        // 当前设备不支持打开相机
        NSLog(@"当前设备不支持打开相机");
        if (failure) {
            failure(@"当前设备不支持打开相机");
        }
    }
}

@end

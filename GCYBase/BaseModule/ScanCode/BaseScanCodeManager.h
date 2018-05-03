//
//  BaseScanCodeManager.h
//  GCYBase
//
//  Created by gaochongyang on 2018/5/3.
//

#import <Foundation/Foundation.h>

typedef void (^ScanCodeSuccessBlock)(NSString *result);
typedef void (^ScanCodeErrorBlock)();

@interface BaseScanCodeManager : NSObject
+ (instancetype)shareScanCodeManager;

/**
 相机扫码

 @param viewController 当前vc
 @param success successBlock
 @param error error
 */
- (void)startScanCode:(UIViewController *)viewController success:(ScanCodeSuccessBlock)success error:(ScanCodeErrorBlock)error;

/**
 手机相册

 @param image 二维码
 @param finish finish
 */
- (void)recognizeQRCodeFromImage:(UIImage *)image finish:(void (^)(NSString *result, NSError *error))finish;
- (void)resume;

@end

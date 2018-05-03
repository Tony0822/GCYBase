//
//  BaseScanCodeManager.m
//  GCYBase
//
//  Created by gaochongyang on 2018/5/3.
//

#import "BaseScanCodeManager.h"
#import "ReaderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Frame.h"

@interface BaseScanCodeManager () <UIAlertViewDelegate> {
    UIViewController *_viewController;
}
@property (nonatomic, strong) ReaderViewController *readerVC;
@property (nonatomic, copy) ScanCodeSuccessBlock successBlock;
@property (nonatomic, copy) ScanCodeErrorBlock errorBlock;
@end

@implementation BaseScanCodeManager

+ (instancetype)shareScanCodeManager {
    static BaseScanCodeManager *_scanCodeManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _scanCodeManager = [[self alloc] init];
    });
    return _scanCodeManager;
}

- (void)startScanCode:(UIViewController *)viewController success:(ScanCodeSuccessBlock)success error:(ScanCodeErrorBlock)error {
    _viewController = viewController;
    _successBlock = success;
    _errorBlock = error;
    __weak typeof(self) weakself = self;
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *msg = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许%@访问你的相机。", appName];
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [weakself starScan];
                } else {
                    [weakself showAlertMessage:msg];
                }
            });
        }];
    } else if (status == AVAuthorizationStatusDenied) {
        [self showAlertMessage:msg];
    } else if (status == AVAuthorizationStatusRestricted) {
        [self showAlertMessage:msg];
    } else {
        [self starScan];
    }
}
- (void)recognizeQRCodeFromImage:(UIImage *)image finish:(void (^)(NSString *result, NSError *error))finish {
    if (image && [image isKindOfClass:[UIImage class]]) {
        CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >= 1) {
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            if (finish) {
                finish(scannedResult, nil);
            }
        }
        else{
            NSError *error = [NSError errorWithDomain:@"QRCodeNotFound" code:-1000 userInfo:nil];
            finish(nil, error);
        }
    }else{
        NSError *error = [NSError errorWithDomain:@"QRCodeNotFound" code:-1000 userInfo:nil];
        if (finish) {
            finish(nil, error);
        }
    }
}

- (void)resume {
    [_readerVC startQReader];
}

- (void)addReaderVC {
    _readerVC = [[ReaderViewController alloc] init];
    CGFloat navHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 44.0;
    _readerVC.view.frame = CGRectMake(0, navHeight, _viewController.view.width, _viewController.view.height - navHeight);
    [_viewController.view addSubview:_readerVC.view];
}

- (void)starScan {
    [self addReaderVC];
    [_viewController addChildViewController:self.readerVC];
    self.readerVC.QReaderFinish = self.successBlock;
}

#pragma mark -- UIAlertViewDelegate
- (void)showAlertMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.errorBlock) {
        self.errorBlock();
    }
}

@end

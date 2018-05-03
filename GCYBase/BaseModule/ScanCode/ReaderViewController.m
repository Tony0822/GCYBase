//
//  ReaderViewController.m
//  GCYBase
//
//  Created by gaochongyang on 2018/4/28.
//

#import "ReaderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Frame.h"

@interface ReaderViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property(nonatomic,strong)UIView *overView;

@property(nonatomic, assign) NSInteger version;
//播放
@property(nonatomic,strong)AVAudioPlayer *player;

@property(nonatomic,strong)UIImageView *lineImageView;
@property(nonatomic,strong)UIImageView *scaningImageView;

@property(nonatomic,strong)UIView *coverTopView;
@property(nonatomic,strong)UIView *coverLeftView;
@property(nonatomic,strong)UIView *coverRightView;
@property(nonatomic,strong)UIView *coverBottomView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ReaderViewController
{
    int num;
    BOOL upOrdown;
    NSTimer *timer;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    upOrdown = NO;
    num = 0;
    
    self.view.backgroundColor = [UIColor clearColor];
    self.version = [[UIDevice currentDevice].systemVersion integerValue];
    
    NSString *mockBundleStr = [[NSBundle mainBundle] pathForResource:@"QRCode" ofType:@"bundle"];
    NSString *soundPath = [[NSBundle bundleWithPath:mockBundleStr] pathForResource:@"qrcode_found" ofType:@"wav"];
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
    self.player=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [self.player prepareToPlay];
    
    [self.view addSubview:self.activityIndicatorView];
    [self.view bringSubviewToFront:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.activityIndicatorView startAnimating];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.version >= 7) {
            [self initCapture];
        }
        
        [self createOverView];
        [self startLineTime];
        [self.activityIndicatorView stopAnimating];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicatorView stopAnimating];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        CGFloat activityW_H = 50;
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView.frame = CGRectMake((self.view.width - activityW_H) * 0.5, (self.view.height - activityW_H) *0.5, activityW_H, activityW_H);
    }
    return _activityIndicatorView;
}

/**
 *  添加过场动画
 */
-(void)createOverView
{
    if (self.overView == nil) {
        self.overView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.overView.backgroundColor = [UIColor clearColor];
    }
    
    [self.view addSubview:self.overView];
    for (UIView *subView in self.overView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIImage *scanImage = [UIImage imageNamed:@"QRCode.bundle/scan.png"];
    self.scaningImageView = [[UIImageView alloc] initWithImage:scanImage] ;
    self.scaningImageView.backgroundColor = [UIColor clearColor];
    self.scaningImageView.frame = CGRectMake((self.view.width - scanImage.size.width) / 2, 150,scanImage.size.width,scanImage.size.height);
    self.scaningImageView.clipsToBounds = YES;
    [self.overView addSubview:self.scaningImageView];
    
    
    UIImage *image = [UIImage imageNamed:@"QRCode.bundle/scanline.png"];
    self.lineImageView = [[UIImageView alloc] initWithImage:image];
    self.lineImageView.backgroundColor = [UIColor clearColor];
    self.lineImageView.frame = CGRectMake((self.scaningImageView.width - image.size.width) / 2,-image.size.height,image.size.width, image.size.height);
    [self.scaningImageView addSubview:self.lineImageView];
    
    self.coverTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.width,self.scaningImageView.top)];
    self.coverTopView.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:61.0/255.0 blue:58.0/255.0 alpha:1.0];
    self.coverTopView.alpha = 0.5f;
    [self.overView addSubview:self.coverTopView];
    
    self.coverLeftView = [[UIView alloc] initWithFrame:CGRectMake(0,self.coverTopView.bottom,self.scaningImageView.left,self.overView.height - self.coverTopView.height)];
    self.coverLeftView.backgroundColor = self.coverTopView.backgroundColor;
    self.coverLeftView.alpha = 0.5f;
    [self.overView addSubview:self.coverLeftView];
    
    self.coverRightView = [[UIView alloc] initWithFrame:CGRectMake((self.overView.width - self.coverLeftView.width),self.coverLeftView.top,self.coverLeftView.width, self.coverLeftView.height)];
    self.coverRightView.backgroundColor = self.coverTopView.backgroundColor;
    self.coverRightView.alpha = 0.5f;
    [self.overView addSubview:self.coverRightView];
    
    self.coverBottomView = [[UIView alloc] initWithFrame:CGRectMake(self.coverLeftView.right,self.scaningImageView.bottom,self.scaningImageView.width,self.overView.height - self.scaningImageView.bottom)];
    self.coverBottomView.backgroundColor = self.coverTopView.backgroundColor;
    self.coverBottomView.alpha = 0.5f;
    [self.overView addSubview:self.coverBottomView];
}

/**
 *  扫描中间横线动画
 */
-(void)animationLineView
{
    CGRect rect = self.lineImageView.frame;
    if (upOrdown == NO) {
        num ++;
        rect.origin.y = -self.lineImageView.image.size.height + 2*num;
        if (2*num >= (self.scaningImageView.height)) {
            upOrdown = YES;
        }
    }else {
        num --;
        rect.origin.y = -self.lineImageView.image.size.height + 2*num;
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    [UIView animateWithDuration:0.001 animations:^{
        self.lineImageView.frame = rect;
    }];
}

/**
 *  打开iOS7二维码扫描
 */
- (void)initCapture
{
//    //相机权限
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
//        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
//    {
//        UIAlertController * alterController=[UIAlertController alertControllerWithTitle:@"未打开相机使用权限" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"去设置"
//                                                        style:UIAlertActionStyleDefault
//                                                      handler:^(UIAlertAction*action){
//                                                          // 无权限 引导去开启
//                                                          NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                                                          if ([[UIApplication sharedApplication]canOpenURL:url]) {
//                                                              [[UIApplication sharedApplication]openURL:url];
//                                                          }
//                                                      }];
//
//        [alterController addAction:action1];
//        [self presentViewController:alterController animated:YES completion:nil];
//
//        return;
//    }
    
    
    NSError *error;
    
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    self.session = session;
    // Device
    AVCaptureDevice *capDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:capDevice error:&error];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([session canAddInput:input]){
        [session addInput:input];
    }
    
    if ([session canAddOutput:output]){
        [session addOutput:output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    if (self.preview == nil) {
        
    }
    AVCaptureVideoPreviewLayer *preview =[AVCaptureVideoPreviewLayer layerWithSession:session];
    preview.backgroundColor = [UIColor clearColor].CGColor;
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame =self.view.bounds;
    [self.view.layer addSublayer:preview];
    [session startRunning];
    
}
#pragma mark -- StartTimer
/**
 *  启动计时器，用于扫描动画
 */
- (void)startLineTime
{
    self.lineImageView.hidden = NO;
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animationLineView) userInfo:nil repeats:YES];
    }
}

/**
 *  停止扫描
 */
-(void)stopLineTime
{
    [timer invalidate];
    timer = nil;
    if (self.version >= 7) {
        if ([self.session isRunning]) {
            [self.session stopRunning];
        }
    }
    
    self.lineImageView.hidden = YES;
}
#pragma mark - public
/**
 *  启动二维码扫描
 */
-(void)startQReader
{
    if (self.version >= 7) {
        if ([self.session isRunning]) {
            return;
        }
        [self initCapture];
        [self createOverView];
        [self startLineTime];
    }
}


/**
 停止二维码扫描
 */
- (void)stopQReader {
    [self stopLineTime];

}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.session stopRunning];
    [self.player play];
    [self stopQReader];
    if ([metadataObjects count] >0){
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        if (self.QReaderFinish) {
            self.QReaderFinish(metadataObject.stringValue);
        }
    }
}



@end

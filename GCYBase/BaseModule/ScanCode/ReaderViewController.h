//
//  ReaderViewController.h
//  GCYBase
//
//  Created by gaochongyang on 2018/4/28.
//

#import <UIKit/UIKit.h>

@interface ReaderViewController : UIViewController

@property(nonatomic, copy) void(^QReaderFinish)(NSString *stringValue);
@property(nonatomic, copy) void(^QReaderFailed)(NSError *error);

/**
 *  启动二维码扫描
 */
-(void)startQReader;
/**
 *  停止二维码扫描
 */
-(void)stopQReader;

@end

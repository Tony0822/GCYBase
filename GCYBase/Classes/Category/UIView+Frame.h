//
//  UIView+Frame.h
//  GCYBase
//
//  Created by gaochongyang on 2018/4/19.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

- (void)setTlPos:(CGPoint)tlPoint;
- (void)setBrPos:(CGPoint)tlPoint;

- (void)setPosx:(float)x;
- (void)setPosy:(float)y;
- (CGPoint)brPos;
- (CGPoint)centerPos;

@end

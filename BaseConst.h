//
//  BaseConst.h
//  Pods
//
//  Created by gaochongyang on 2018/5/8.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define FONTSIZE(x) [UIFont systemFontOfSize:x]

#define WEAK_SELF(value) __weak typeof(self) value = self

// 判断是否是iPhone X
#define IPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (IPhoneX ? 44.f : 20.f)
// 导航栏高度
#define KNAVHEIGHT (IPhoneX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (IPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (IPhoneX ? 34.f : 0.f)

//
//  YQTabbarItem.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/5.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YQTabBarItemType) {
    YQTabBarItemNormal = 0,
    YQTabBarItemRise,
};

extern NSString *const kYQTabBarItemAttributeTitle;// NSString
extern NSString *const kYQTabBarItemAttributeNormalImageName;// NSString
extern NSString *const kYQTabBarItemAttributeSelectedImageName;// NSString
extern NSString *const kYQTabBarItemAttributeType;// NSNumber, YQTabBarItemType

@interface YQTabBarItem : UIButton

@property (nonatomic, assign) YQTabBarItemType tabBarItemType;

@end

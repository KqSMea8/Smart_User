//
//  YQTabbar.h
//  ZHYQ
//
//  Created by 焦平 on 2017/10/22.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQTabbarItem.h"

@protocol YQTabBarDelegate <NSObject>

- (void)tabBarDidSelectedRiseButton;

- (void)beginRecord;
- (void)cancleRecord;
- (void)finishRecord;

@end

@interface YQTabbar : UITabBar

@property (nonatomic, copy) NSArray<NSDictionary *> *tabBarItemAttributes;
@property (nonatomic, weak) id <YQTabBarDelegate> delegate;

@end

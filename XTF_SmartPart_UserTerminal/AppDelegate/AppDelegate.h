//
//  AppDelegate.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RoottabbarController.h"
#import "GuideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RoottabbarController *mainTabBar;

/***  是否允许横屏的标记 */
@property (nonatomic,assign)BOOL allowRotation;


@end


//
//  VisitTabbarViewController.h
//  DXWingGate
//
//  Created by coder on 2018/8/14.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitTabbarViewController : UITabBarController

/**
 设置小红点
 
 @param index tabbar下标
 @param isShow 是显示还是隐藏
 */
-(void)setRedDotWithIndex:(NSInteger)index isShow:(BOOL)isShow;

@end

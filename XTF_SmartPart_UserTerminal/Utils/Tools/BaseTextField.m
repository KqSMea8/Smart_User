//
//  BaseTextField.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/3/9.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    //禁用粘贴复制功能
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController)
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end

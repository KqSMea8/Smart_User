//
//  YQTapGestureRecognizer.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/7/31.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "YQTapGestureRecognizer.h"

@implementation YQTapGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action{
    self = [super initWithTarget:target action:action];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate

/**
 *  重写手势代理方法（添加了手势导致tableView的didSelectRowAtIndexPath方法失效）
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end

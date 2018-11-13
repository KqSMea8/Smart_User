//
//  DkSuccessPopView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/1/15.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PopViewType) {
    onWorkPopView = 0,
    offWorkPopView
};

@interface DkSuccessPopView : UIView

- (instancetype)initWithtimeTitle:(NSString *)timetTitle type:(PopViewType)type signContent:(NSString *)content;

/** show出这个弹窗 */
- (void)showInView:(UIView *)view;

@end

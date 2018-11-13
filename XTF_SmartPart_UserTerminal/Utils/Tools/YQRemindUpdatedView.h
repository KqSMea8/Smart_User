//
//  YQRemindUpdatedView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/2/1.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, buttonType) {
    cancleButton = 0,
    sureButton
};

@protocol YQRemindUpdatedViewDelegate <NSObject>

-(void)remaindViewBtnClick:(buttonType)btn;

@end

@interface YQRemindUpdatedView : UIView

@property (nonatomic,weak) id<YQRemindUpdatedViewDelegate> delegate;

@property (nonatomic,copy) NSString *isMust;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;

- (void)show;

- (void)dismiss;

@end

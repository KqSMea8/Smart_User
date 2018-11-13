//
//  PopView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/19.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 弹窗上的按钮
 
 - AlertButtonLeft: 左边的按钮
 - AlertButtonRight: 右边的按钮
 */
typedef NS_ENUM(NSUInteger, AbnormalButton) {
    AlertButtonLeft = 0,
    AlertButtonRight
};

typedef NS_ENUM(NSUInteger, PopViewType) {
    payPwdPopView = 0,
    setPayPwdPopView,
    verPayPwdPopView,
    normalPopView,
    kqDetailPopView
};

#pragma mark - 协议

@class PopView;

@protocol DeclarePopViewDelegate <NSObject>

@optional

- (void)declareAlertView:(PopView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)forgetPwdClickAction;

- (void)openSmallPaySwtichAction:(UISwitch *)statusSwitch;

@end


#pragma mark - interface

/** 弹窗 */
@interface PopView : UIView

/** 这个弹窗对应的orderID */
@property (nonatomic,copy) NSString *orderID;

@property (nonatomic,weak) id<DeclarePopViewDelegate> delegate;

@property (nonatomic,assign) PopViewType type;

@property (nonatomic,strong) UITextField *importPwdTex;

@property (nonatomic,strong) UITextField *surePayPwdTex;

@property (nonatomic,strong) UITextField *payPwdTex;

@property (nonatomic,strong) UISwitch *paySwitch;

@property (nonatomic,copy) NSString *signImageUrl;

@property (nonatomic,copy) NSString *addressStr;

/**
 
 @param title 弹窗标题
 @param message 弹窗message
 @param delegate 确定代理方
 @param leftButtonTitle 左边按钮的title
 @param rightButtonTitle 右边按钮的title
 @return 11
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle type:(PopViewType)type;

/** show出这个弹窗 */
- (void)show;

/** 移除此弹窗 */
- (void)dismiss;

@end

//
//  SelectPayTypeView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/20.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, payType) {
    cardpay = 0,
    alipay,
    wechatpay
};

@protocol selectPayTypeDelegate <NSObject>

-(void)currentSelectPayType:(payType)type;

@end

@interface SelectPayTypeView : UIView

- (void)showInView:(UIView *)view;

@property (nonatomic,copy) NSString *balanceStr;

@property (nonatomic,weak) id<selectPayTypeDelegate> delegate;

@property (nonatomic,assign) NSInteger currentSelectIndex;

@end

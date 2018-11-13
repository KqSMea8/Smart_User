//
//  IFLYPopView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/10.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IFLYCompleteDelegate <NSObject>

-(void)IFLYOviceComplete:(NSString *)resultStr;

@end

typedef NS_ENUM(NSUInteger, IFLYPopType) {
    IFLYPopRemindViewType = 0,
    IFLYPopViewType
};

@interface IFLYPopView : UIView

- (instancetype)initWithType:(IFLYPopType)type;

/** show出这个弹窗 */
- (void)show;

/** 移除此弹窗 */
- (void)dismiss;

@property (nonatomic,weak) id<IFLYCompleteDelegate> delegate;

@end

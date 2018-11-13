//
//  LeaveEarlyDkView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/7/3.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeaveEarlyDelegate <NSObject>

-(void)leaveEarlyContinueDk:(NSString *)type;

@end

@interface LeaveEarlyDkView : UIView

- (instancetype)initWithsignTime:(NSString *)time;

/** show出这个弹窗 */
- (void)show;

/** 移除此弹窗 */
- (void)dismiss;

@property (nonatomic,weak) id<LeaveEarlyDelegate> delegate;
@property (nonatomic,copy) NSString *signType;

@end

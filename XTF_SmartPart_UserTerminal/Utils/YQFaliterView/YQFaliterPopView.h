//
//  YQFaliterPopView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/14.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YQFaliterPopViewDelegate <NSObject>

-(void)resetCallBackAction;
-(void)completeCallBackAction;

@end

@interface YQFaliterPopView : UIView

/**
 *  显示属性选择视图
 *
 *  @param view 要在哪个视图中显示
 */
- (void)showInView:(UIView *)view;

/**
 *  属性视图的消失
 */
- (void)removeView;

@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,weak) id<YQFaliterPopViewDelegate> delegate;

@property (nonatomic,copy) NSString *visitName;
@property (nonatomic,copy) NSString *visitCarNum;
@property (nonatomic,copy) NSString *arriveTime;
@property (nonatomic,copy) NSString *leaveTime;

@end

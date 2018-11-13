//
//  IFLYViewController.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/25.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "RootViewController.h"

@protocol IFLYRecCompleteDelegate <NSObject>

-(void)IFLYRecComplete:(NSString *)resultStr;

@end

NS_ASSUME_NONNULL_BEGIN

@interface IFLYViewController : RootViewController

@property (nonatomic,weak) id<IFLYRecCompleteDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

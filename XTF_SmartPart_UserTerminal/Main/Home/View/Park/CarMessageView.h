//
//  CarMessageView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/21.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarRecordModel.h"

@protocol carMessageDelegate <NSObject>

-(void)navToParkSpace:(id)sender;
-(void)unlockParkSpace:(id)sender;
-(void)cancleBookParkSpace:(id)sender;

@end

@interface CarMessageView : UIView

@property (nonatomic,retain) CarRecordModel *carRecordModel;

@property (nonatomic,copy) NSString *currentTime;

@property (nonatomic,assign) id<carMessageDelegate> delegate;

@end

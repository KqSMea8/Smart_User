//
//  MineHeaderView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/8.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonMsgModel.h"

@protocol MineHeaderDelegate <NSObject>
//顶部点击
-(void)headerTap;
//快速充值
-(void)quickRechageTap;
//分享
-(void)shareTap;

@end

@interface MineHeaderView : UICollectionReusableView

@property (nonatomic,strong) PersonMsgModel *model;

@property (nonatomic,copy) NSString *money;

@property (nonatomic,assign) id<MineHeaderDelegate> delegate;

@end

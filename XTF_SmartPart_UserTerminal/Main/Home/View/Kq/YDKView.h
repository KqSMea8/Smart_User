//
//  YDKView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol reConfirmDKDelegate <NSObject>

-(void)reConfirmDKAction:(id)object;

@end

@interface YDKView : UIView

@property (nonatomic,strong) UILabel *dkTimeLab;
@property (nonatomic,strong) UIImageView *locationView;
@property (nonatomic,strong) UILabel *locationLab;
@property (nonatomic,strong) UIButton *cxdkBtn;
@property (nonatomic,strong) UIImageView *cxdkView;

@property (nonatomic,strong) UIImageView *statusView;

@property (nonatomic,weak) id<reConfirmDKDelegate> delegate;

@end

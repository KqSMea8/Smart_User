//
//  OnWorkView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/9.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnWorkView : UIView

@property (nonatomic,strong) UIView *circleView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UIView *ydkBgView;
@property (nonatomic,strong) UILabel *signLab;
@property (nonatomic,strong) UIImageView *locationView;
@property (nonatomic,strong) UILabel *locationLab;
@property (nonatomic,strong) UIImageView *statusView;
@property (nonatomic,strong) UIView *cxdkBgView;
@property (nonatomic,strong) UILabel *cxdkLab;
@property (nonatomic,strong) UIImageView *arrowView;

@property (nonatomic,strong) UIView *wdkBgView;
@property (nonatomic,strong) UIView *wdkTitleView;

@property (nonatomic,strong) UIView *dkBgView;
@property (nonatomic,strong) UILabel *dkTitleLab;
@property (nonatomic,strong) UILabel *dkTimeLab;
@property (nonatomic,strong) UILabel *dkLocationLab;
@property (nonatomic,strong) UIImageView *dkLocationView;

@end

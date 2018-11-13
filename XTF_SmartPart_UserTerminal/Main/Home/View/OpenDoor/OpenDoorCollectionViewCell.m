//
//  OpenDoorCollectionViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/1.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "OpenDoorCollectionViewCell.h"

@interface OpenDoorCollectionViewCell()

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UILabel *doorNameLab;
@property (nonatomic,strong) UIImageView *statusView;

@end

@implementation OpenDoorCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

-(void)_initView
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 38)];
    _topView.backgroundColor = TopViewColor;
    [self.contentView addSubview:_topView];
    
    _doorNameLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _topView.width-10, _topView.height)];
    _doorNameLab.font = [UIFont systemFontOfSize:17];
    _doorNameLab.textColor = KWhiteColor;
    _doorNameLab.textAlignment = NSTextAlignmentCenter;
    _doorNameLab.text = @"1号闸机";
    [_topView addSubview:_doorNameLab];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), self.width, self.height-CGRectGetMaxY(_topView.frame))];
    _bottomView.backgroundColor = KWhiteColor;
    [self.contentView addSubview:_bottomView];
    
    _statusView = [[UIImageView alloc] initWithFrame:CGRectMake(25*wScale, 5, _bottomView.width-50*wScale, _bottomView.height-10)];
    _statusView.backgroundColor = [UIColor clearColor];
    _statusView.image = [UIImage imageNamed:@"door_close"];
//    brake_close
    [_bottomView addSubview:_statusView];
}

-(void)setModel:(OpenDoorModel *)model
{
    _model = model;
    
    _doorNameLab.text = [NSString stringWithFormat:@"%@",model.DEVICE_NAME];
    
    
}

@end

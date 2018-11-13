//
//  OpenDoorCollectionReusableView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/20.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "OpenDoorCollectionReusableView.h"

@interface OpenDoorCollectionReusableView()
{
    UIView *lineView;
}

@end

@implementation OpenDoorCollectionReusableView

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
    lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 5, 20)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    lineView.layer.cornerRadius = 2;
    lineView.clipsToBounds = YES;
    [self addSubview:lineView];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 180, 20)];
    _titleLab.font = [UIFont systemFontOfSize:17];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = [UIColor blackColor];
    [self addSubview:_titleLab];
}

@end

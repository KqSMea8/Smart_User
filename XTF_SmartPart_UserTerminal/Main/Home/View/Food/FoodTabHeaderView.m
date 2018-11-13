//
//  FoodTabHeaderView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/2.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "FoodTabHeaderView.h"

@interface FoodTabHeaderView()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *leftLineView;
@property (nonatomic,strong) UIImageView *rightLineView;

@end

@implementation FoodTabHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];//_init表示初始化方法
    }
    return self;
}

-(void)_init
{
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake((self.width-60)/2, 0, 60, self.height)];
    _titleLab.text = @"面食";
    _titleLab.font = [UIFont systemFontOfSize:17];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLab];
    
    _leftLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.height-0.5)/2, _titleLab.origin.x-10, 0.5)];
    _leftLineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_leftLineView];
    
    _rightLineView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLab.frame)+10, (self.height-0.5)/2, _titleLab.origin.x-10, 0.5)];
    _rightLineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_rightLineView];
}

@end

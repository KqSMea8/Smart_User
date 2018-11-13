//
//  HomeMoreCollectionViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "HomeMoreCollectionViewCell.h"

@interface HomeMoreCollectionViewCell()
{
    
}

@end

@implementation HomeMoreCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _initView];
    }
    
    return self;
}

-(void)_initView
{
    
    [self.contentView addSubview:self.topImageView];
    self.topImageView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.titleLab];
}

-(UIImageView *)topImageView
{
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.frame = CGRectMake((self.contentView.frame.size.width - (self.contentView.frame.size.height-30))/2, 0, self.contentView.frame.size.height-30, self.contentView.frame.size.height-30);
    }
    return _topImageView;
}

-(UILabel *)titleLab
{
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"更多";
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.frame = CGRectMake(0, CGRectGetMaxY(_topImageView.frame)+15, self.contentView.frame.size.width, 15);
    }
    return _titleLab;
}

@end

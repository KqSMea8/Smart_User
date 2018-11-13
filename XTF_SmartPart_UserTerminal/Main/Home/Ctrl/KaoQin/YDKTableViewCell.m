//
//  YDKTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/3/22.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "YDKTableViewCell.h"
#import "YQScanImage.h"
#import "Utils.h"

@interface YDKTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *onWorkTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *onWorkIsPanchTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *locationLab;
@property (weak, nonatomic) IBOutlet UIImageView *stateView;
@property (weak, nonatomic) IBOutlet UIImageView *kqImageView;
@property (weak, nonatomic) IBOutlet UILabel *cxdkView;
@property (weak, nonatomic) IBOutlet UIImageView *cxdkArrow;
@property (weak, nonatomic) IBOutlet UIImageView *dkTypeView;

@property (nonatomic, assign) CGRect lastFrame;

@property (nonatomic, weak) UIImageView *imagView;

@end

@implementation YDKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _kqImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onWorkLookHumanFaceBigImage:)];
    [_kqImageView addGestureRecognizer:tap];
    
    //重新打卡
    _cxdkView.userInteractionEnabled = YES;
    _cxdkArrow.userInteractionEnabled = YES;
    UITapGestureRecognizer *cxdkViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reSaveOnWorkRecord)];
    [_cxdkView addGestureRecognizer:cxdkViewTap];
    
    UITapGestureRecognizer *cxdkArrowTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reSaveOnWorkRecord)];
    [_cxdkArrow addGestureRecognizer:cxdkArrowTap];
}

-(void)setOnWorkTime:(NSString *)onWorkTime
{
    _onWorkTime = onWorkTime;
    _onWorkTimeLab.text = onWorkTime;
}

-(void)setIsWorkDay:(NSString *)isWorkDay
{
    _isWorkDay = isWorkDay;
}

-(void)setIslack:(NSString *)islack
{
    _islack = islack;
}

-(void)setModel:(KqStatusModel *)model{
    _model = model;
    NSString *timeStr = [model.trunSignTime substringWithRange:NSMakeRange(0, 5)];
    _onWorkIsPanchTimeLab.text = [NSString stringWithFormat:@"%@已打卡",timeStr];
    _locationLab.text = model.signAddr;
    
    _kqImageView.contentMode = UIViewContentModeScaleAspectFill;
    _kqImageView.clipsToBounds = YES;
    if (![model.signImageUrl isKindOfClass:[NSNull class]]) {
        [_kqImageView sd_setImageWithURL:[NSURL URLWithString:model.signImageUrl] placeholderImage:[UIImage imageNamed:@"photo_sign"]];
    }
    
    if ([model.signStatus isEqualToString:@"1"]) {
        if ([model.isOutside isEqualToString:@"1"]) {
            _stateView.image = [UIImage imageNamed:@"kq_wq"];
        }else{
            if ([_isWorkDay isEqualToString:@"1"]) {
                _stateView.image = [UIImage imageNamed:@"normal"];
            }else{
                _stateView.image = [UIImage imageNamed:@"kq_overtime"];
            }
        }
    }else if ([model.signStatus isEqualToString:@"2"]){
        if ([model.isOutside isEqualToString:@"1"]) {
            _stateView.image = [UIImage imageNamed:@"kq_wq"];
        }else{
            if ([_isWorkDay isEqualToString:@"1"]) {
                _stateView.image = [UIImage imageNamed:@"later"];
            }else{
                _stateView.image = [UIImage imageNamed:@"kq_overtime"];
            }
        }
    }else{
        if ([model.isOutside isEqualToString:@"1"]) {
            _stateView.image = [UIImage imageNamed:@"kq_wq"];
        }else{
            if ([_isWorkDay isEqualToString:@"1"]) {
                _stateView.image = [UIImage imageNamed:@"kq_leaveEarly"];
            }else{
                _stateView.image = [UIImage imageNamed:@"kq_overtime"];
            }
        }
    }
    
    if ([model.channel isEqualToString:@"1"]) {
        _dkTypeView.image = [UIImage imageNamed:@"phoneDk"];
    }else{
        _dkTypeView.image = [UIImage imageNamed:@"faceDk"];
    }
    
    _cxdkView.hidden = YES;
    _cxdkArrow.hidden = YES;
}

-(void)onWorkLookHumanFaceBigImage:(UITapGestureRecognizer *)tap
{
    [self tapImageView:tap];
}

- (void)tapImageView:(UITapGestureRecognizer *)recognizer
{
    //添加遮盖
    UIView *cover = [[UIView alloc] init];
    cover.frame = [UIScreen mainScreen].bounds;
    cover.backgroundColor = [UIColor clearColor];
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (tapCover:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:cover];
    
    //添加图片到遮盖上
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.signImageUrl] placeholderImage:[UIImage imageNamed:@"_member_icon"]];
    imageView.frame = [cover convertRect:recognizer.view.frame fromView:self];
    self.lastFrame = imageView.frame;
    [cover addSubview:imageView];
    self.imagView = imageView;
    
    //放大
    [UIView animateWithDuration:0.3f animations:^{
        cover.backgroundColor = [UIColor blackColor];
        CGRect frame = imageView.frame;
        frame.size.width = cover.frame.size.width;
        if ([_imagView.image isKindOfClass:[NSNull class]]||_imagView.image == nil) {
            UIImage *image = [UIImage imageNamed:@"_member_icon"];
            frame.size.height = cover.frame.size.width * (image.size.height / image.size.width);
        }else{
            frame.size.height = cover.frame.size.width * (imageView.image.size.height / imageView.image.size.width);
        }
        
        frame.origin.x = 0;
        frame.origin.y = (cover.frame.size.height - frame.size.height) * 0.5;
        imageView.frame = frame;
    }];
}

- (void)tapCover:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.3f animations:^{
        recognizer.view.backgroundColor = [UIColor clearColor];
        self.imagView.frame = self.lastFrame;
        
    }completion:^(BOOL finished) {
        [recognizer.view removeFromSuperview];
        self.imagView = nil;
    }];
}


-(void)reSaveOnWorkRecord
{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(onWorkreSaveRecord:)]) {
        [self.delegate onWorkreSaveRecord:@"IN"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

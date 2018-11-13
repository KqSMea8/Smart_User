//
//  OffWorkYDKTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/3/23.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "OffWorkYDKTableViewCell.h"
#import "YQScanImage.h"

@interface OffWorkYDKTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *offWorkTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *offWorkSignTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *locationLab;
@property (weak, nonatomic) IBOutlet UIImageView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *offWorkReSaveRecordCtrl;
@property (weak, nonatomic) IBOutlet UIImageView *offWorkReSaveArrow;
@property (weak, nonatomic) IBOutlet UIImageView *humanFaceView;
@property (weak, nonatomic) IBOutlet UIImageView *offWorkDkTypeView;

@property (nonatomic, assign) CGRect lastFrame;
@property (nonatomic, weak) UIImageView *imagView;

@end

@implementation OffWorkYDKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _offWorkReSaveRecordCtrl.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reSaveKqRecord)];
    [_offWorkReSaveRecordCtrl addGestureRecognizer:tap];
    
    _humanFaceView.userInteractionEnabled = YES;
    UITapGestureRecognizer *humanFaceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookHumanFaceBigImage:)];
    [_humanFaceView addGestureRecognizer:humanFaceTap];
}

-(void)setOnWorkTime:(NSString *)onWorkTime
{
    _onWorkTime = onWorkTime;
    _offWorkTimeLab.text = _onWorkTime;
}

-(void)setIsWorkDay:(NSString *)isWorkDay
{
    _isWorkDay = isWorkDay;
}

-(void)setModel:(KqStatusModel *)model
{
    _model = model;
    
    NSString *timeStr = [model.trunSignTime substringWithRange:NSMakeRange(0, 5)];
    _offWorkSignTimeLab.text = [NSString stringWithFormat:@"%@已打卡",timeStr];
    _locationLab.text = model.signAddr;
    
    if ([model.signStatus isEqualToString:@"1"]) {
        if ([model.isOutside isEqualToString:@"1"]) {
            _statusView.image = [UIImage imageNamed:@"kq_wq"];
        }else{
            if ([_isWorkDay isEqualToString:@"1"]) {
                _statusView.image = [UIImage imageNamed:@"normal"];
            }else{
                _statusView.image = [UIImage imageNamed:@"kq_overtime"];
            }
            
        }
    }else if ([model.signStatus isEqualToString:@"2"]){
        if ([model.isOutside isEqualToString:@"1"]) {
            _statusView.image = [UIImage imageNamed:@"kq_wq"];
        }else{
            if ([_isWorkDay isEqualToString:@"1"]) {
                _statusView.image = [UIImage imageNamed:@"later"];
            }else{
                _statusView.image = [UIImage imageNamed:@"kq_overtime"];
            }
        }
    }else{
        if ([model.isOutside isEqualToString:@"1"]) {
            _statusView.image = [UIImage imageNamed:@"kq_wq"];
        }else{
            if ([_isWorkDay isEqualToString:@"1"]) {
                _statusView.image = [UIImage imageNamed:@"kq_leaveEarly"];
            }else{
                _statusView.image = [UIImage imageNamed:@"kq_overtime"];
            }
        }
    }
    
    if ([model.channel isEqualToString:@"1"]) {
        _offWorkDkTypeView.image = [UIImage imageNamed:@"phoneDk"];
    }else{
        _offWorkDkTypeView.image = [UIImage imageNamed:@"faceDk"];
    }
    
    _humanFaceView.contentMode = UIViewContentModeScaleAspectFill;
    _humanFaceView.clipsToBounds = YES;
    
    if (![model.signImageUrl isKindOfClass:[NSNull class]]) {
        [_humanFaceView sd_setImageWithURL:[NSURL URLWithString:model.signImageUrl] placeholderImage:[UIImage imageNamed:@"photo_sign"]];
    }
}

-(void)reSaveKqRecord{
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(offWorkreSaveRecord:)]) {
        [self.delegate offWorkreSaveRecord:@"OUT"];
    }
}

//查看人像大图
-(void)lookHumanFaceBigImage:(UITapGestureRecognizer *)tap
{
//    [YQScanImage scanBigImageWithImageView:self.humanFaceView imageUrl:_model.signImageUrl];
    [self tapImageView:tap];
}

- (void)tapImageView:(UITapGestureRecognizer *)recognizer
{
    //添加遮盖
    UIView *cover = [[UIView alloc] init];
    cover.frame = [UIScreen mainScreen].bounds;
    cover.backgroundColor = [UIColor clearColor];
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)]];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

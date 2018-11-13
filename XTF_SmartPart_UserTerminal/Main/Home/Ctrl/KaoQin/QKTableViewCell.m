//
//  QKTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/3/23.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "QKTableViewCell.h"

@interface QKTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *kqTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *reSaveRecordCtrl;
@property (weak, nonatomic) IBOutlet UIImageView *reSaveRecordArrow;

@end

@implementation QKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _reSaveRecordCtrl.hidden = YES;
    _reSaveRecordArrow.hidden = YES;
    _reSaveRecordCtrl.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reConfirmDKAction:)];
    [_reSaveRecordCtrl addGestureRecognizer:tap];
}

-(void)setIsAllowReDk:(NSString *)isAllowReDk
{
    _isAllowReDk = isAllowReDk;
    if ([isAllowReDk isEqualToString:@"1"]) {
        _reSaveRecordCtrl.hidden = NO;
        _reSaveRecordArrow.hidden = NO;
    }else{
        _reSaveRecordCtrl.hidden = YES;
        _reSaveRecordArrow.hidden = YES;
    }
}

-(void)setOnWorkTime:(NSString *)onWorkTime
{
    _onWorkTime = onWorkTime;
    _kqTimeLab.text = [NSString stringWithFormat:@"%@",_onWorkTime];
}

#pragma mark 重新打卡
-(void)reConfirmDKAction:(id)sender
{
    if (self.delegate != nil &&[self.delegate respondsToSelector:@selector(reConfirmDKAction:)]) {
        [self.delegate reConfirmDKAction:@"IN"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

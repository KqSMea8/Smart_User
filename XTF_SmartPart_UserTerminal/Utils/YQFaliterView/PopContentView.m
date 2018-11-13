//
//  PopContentView.m
//  DXWingGate
//
//  Created by coder on 2018/8/27.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import "PopContentView.h"
#import "WSDatePickerView.h"
#import "Utils.h"

@interface PopContentView()

@end

@implementation PopContentView


-(void)awakeFromNib
{
    [super awakeFromNib];
    _visitNameBgView.clipsToBounds = YES;
    _visitNameBgView.layer.borderColor = [UIColor colorWithHexString:@"#D2D2D2"].CGColor;
    _visitNameBgView.layer.borderWidth = 0.5;
    _visitNameBgView.layer.cornerRadius = 3;
    
    _visitCarNumBgView.clipsToBounds = YES;
    _visitCarNumBgView.layer.borderColor = [UIColor colorWithHexString:@"#D2D2D2"].CGColor;
    _visitCarNumBgView.layer.borderWidth = 0.5;
    _visitCarNumBgView.layer.cornerRadius = 3;
    
    UITapGestureRecognizer *arriveTimeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arriveTimeTapAction)];
    UITapGestureRecognizer *arriveTimeBgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arriveTimeTapAction)];
    
    UITapGestureRecognizer *leaveTimeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leaveTimeTapAction)];
    UITapGestureRecognizer *leaveTimeBgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leaveTimeTapAction)];
    
    _arriveTimeLab.userInteractionEnabled = YES;
    _arriveTimeBgView.userInteractionEnabled = YES;
    [_arriveTimeLab addGestureRecognizer:arriveTimeTap];
    [_arriveTimeBgView addGestureRecognizer:arriveTimeBgTap];
    
    _leaveTimeLab.userInteractionEnabled = YES;
    _leaveTimeBgView.userInteractionEnabled = YES;
    [_leaveTimeLab addGestureRecognizer:leaveTimeTap];
    [_leaveTimeBgView addGestureRecognizer:leaveTimeBgTap];
    
    NSString *currentTime = [Utils getCurrentTime];
    _arriveTimeLab.text = currentTime;
    _leaveTimeLab.text = currentTime;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)arriveTimeTapAction
{
    [self endEditing:YES];
    __weak typeof(self) _weakSelf = self;
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:nil CompleteBlock:^(NSDate *selectDate) {
//        NSString *date = [selectDate stringWithFormat:@"yyyy年MM"];
        NSString *date1 = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        _weakSelf.arriveTimeLab.text = [NSString stringWithFormat:@"%@",date1];
        
    }];
    datepicker.dateLabelColor = [UIColor colorWithHexString:@"#1B82D1"];
    datepicker.datePickerColor = [UIColor blackColor];
    datepicker.doneButtonColor = [UIColor colorWithHexString:@"#1B82D1"];
    datepicker.yearLabelColor = [UIColor clearColor];
    [datepicker show];
}

-(void)leaveTimeTapAction
{
    [self endEditing:YES];
    __weak typeof(self) _weakSelf = self;
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:nil CompleteBlock:^(NSDate *selectDate) {
//        NSString *date = [selectDate stringWithFormat:@"yyyy年MM"];
        NSString *date1 = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        _weakSelf.leaveTimeLab.text = [NSString stringWithFormat:@"%@",date1];
        
    }];
    datepicker.dateLabelColor = [UIColor colorWithHexString:@"#1B82D1"];
    datepicker.datePickerColor = [UIColor blackColor];
    datepicker.doneButtonColor = [UIColor colorWithHexString:@"#1B82D1"];
    datepicker.yearLabelColor = [UIColor clearColor];
    [datepicker show];
}

- (IBAction)resetBtnAction:(id)sender {
    self.visitNameTex.text = nil;
    self.visitCarNumTex.text = nil;
    self.arriveTimeLab.text = [Utils getCurrentTime];
    self.leaveTimeLab.text = [Utils getCurrentTime];
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(resetBtnCallBackAction)]) {
        [self.delegate resetBtnCallBackAction];
    }
}

- (IBAction)completeBtnAction:(id)sender {
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(completeBtnCallBackAction)]) {
        [self.delegate completeBtnCallBackAction];
    }
}

@end

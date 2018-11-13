//
//  MyCarTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "MyCarTableViewCell.h"

@interface MyCarTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *removeBindBtn;


@end

@implementation MyCarTableViewCell
{
    __weak IBOutlet UILabel *_carNoLabel;
    __weak IBOutlet UILabel *_carTypeLabel;
    __weak IBOutlet UILabel *stateLab;
    __weak IBOutlet UILabel *parkAreaLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self _initView];
    
}

-(void)_initView
{
    _removeBindBtn.layer.cornerRadius = 6;
}

- (IBAction)removeBindBtnAction:(id)sender {
    if(_removeBindDelegate && [_removeBindDelegate respondsToSelector:@selector(removeBind:)]){
        [_removeBindDelegate removeBind:_carListModel];
    }
}

- (void)setCarListModel:(CarListModel *)carListModel {
    _carListModel = carListModel;
    
    _carNoLabel.text = [NSString stringWithFormat:@"%@ %@", carListModel.carArea, carListModel.carNum];
    
    //车牌类型(1-小型车，2-中型车，3-大型车，4-电动车，5-摩托车)
    if([carListModel.carType isEqualToString:@"0"]){
        _carTypeLabel.text = @"小型车";
    }else if ([carListModel.carType isEqualToString:@"1"]) {
        _carTypeLabel.text = @"中型车";
    }else if ([carListModel.carType isEqualToString:@"2"]) {
        _carTypeLabel.text = @"大型车";
    }else if ([carListModel.carType isEqualToString:@"3"]) {
        _carTypeLabel.text = @"电动车";
    }else if ([carListModel.carType isEqualToString:@"4"]) {
        _carTypeLabel.text = @"摩托车";
    }else {
        _carTypeLabel.text = @"";
    }
    
    if (![carListModel.state isKindOfClass:[NSNull class]]&&carListModel.state !=nil&&[carListModel.state isEqualToString:@"1"]) {
        stateLab.text = @"已入场";
        parkAreaLab.hidden = NO;
        stateLab.hidden = NO;
        parkAreaLab.text = carListModel.carParkArea;
    }else{
        stateLab.centerY = _removeBindBtn.centerY;
        stateLab.text = @"未驶入";
        stateLab.hidden = NO;
        parkAreaLab.hidden = YES;
    }
}

@end

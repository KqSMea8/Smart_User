//
//  NetPayTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/27.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "NetPayTableViewCell.h"
#import "AESUtil.h"

#define weChatIcon @"icon_bill_wechat"
#define aliIcon @"icon_bill_ali"
#define card_payIcon @"card_pay"

#define vipIcon @"icon_bill_vip"
#define parkIcon @"icon_funts_parking"

@interface NetPayTableViewCell()
{
    __weak IBOutlet UILabel *_weekLab;
    __weak IBOutlet UILabel *_timeLab;
    __weak IBOutlet UIImageView *_typeView;
    __weak IBOutlet UILabel *_moneyLab;
    __weak IBOutlet UILabel *_typeLab;
    __weak IBOutlet UIImageView *_payTypeView;
}

@end

@implementation NetPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(NetPayModel *)model
{
    _model = model;
    
    /*
     orderType  订单类型，01-充值，02-消费
     
     payType  支付类型，01-微信，02-支付宝 03-一卡通
     */
    
    //支付宝
    if ([model.orderType isEqualToString:@"01"]) {
        if (![model.payType isKindOfClass:[NSNull class]]) {
            if ([model.payType isEqualToString:@"02"]) {
                _typeView.image = [UIImage imageNamed:aliIcon];
                _typeLab.text = @"支付宝消费";
            } else if ([model.payType isEqualToString:@"01"]) {
                _typeView.image = [UIImage imageNamed:weChatIcon];
                _typeLab.text = @"微信消费";
            }
        }
        
//        NSString *money = [AESUtil decryptAES:model.orderPrice key:AESKey];
        NSString *money = model.orderPrice;
        
        _moneyLab.text = [NSString stringWithFormat:@"%.2f元",[money floatValue]/100.00];
    }else{
        if (![model.payType isKindOfClass:[NSNull class]]) {
            _typeView.image = [UIImage imageNamed:@"canteenpay"];
            _typeLab.text = @"食堂消费";
        }
        
        if ([model.payType isEqualToString:@"02"]) {
            _payTypeView.image = [UIImage imageNamed:aliIcon];
        }else{
            _typeView.image = [UIImage imageNamed:weChatIcon];
        }
        
//        NSString *money = [AESUtil decryptAES:model.orderPrice key:AESKey];
        NSString *money = model.orderPrice;
        
        _moneyLab.text = [NSString stringWithFormat:@"%.2f元",[money floatValue]/100.00];
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate *billDate = [format dateFromString:model.orderPayDate];
    
    NSString *dateStr = [format stringFromDate:billDate];
    
    NSString *billDateStr = [NSString stringWithFormat:@"%@-%@", [dateStr substringWithRange:NSMakeRange(4, 2)], [dateStr substringWithRange:NSMakeRange(6, 2)]];
    
    NSString *billDateStr1 = [NSString stringWithFormat:@"%@:%@", [dateStr substringWithRange:NSMakeRange(8, 2)], [dateStr substringWithRange:NSMakeRange(10, 2)]];
    
    // 对比时间差
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:billDate.day];
    [_comps setMonth:billDate.month];
    [_comps setYear:billDate.year];
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger _weekday = [weekdayComponents weekday];
    
    if (billDate.isToday) {
        _weekLab.text = @"今天";
        _timeLab.text = billDateStr1;
    }else if (billDate.isYesterday) {
        _weekLab.text = @"昨天";
        _timeLab.text = billDateStr1;
    }else
    {
        _weekLab.text = [NSString stringWithFormat:@"周%@", [self weekStr:_weekday - 1]];
        _timeLab.text = billDateStr;
    }
}

- (NSString *)weekStr:(NSInteger)day {
    switch (day) {
        case 1:
            return @"一";
            break;
        case 2:
            return @"二";
            break;
        case 3:
            return @"三";
            break;
        case 4:
            return @"四";
            break;
        case 5:
            return @"五";
            break;
        case 6:
            return @"六";
            break;
        case 0:
            return @"日";
            break;
            
        default:
            break;
    }
    return @"";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

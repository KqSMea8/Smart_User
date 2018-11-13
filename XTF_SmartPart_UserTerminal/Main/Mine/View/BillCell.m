//
//  BillCell.m
//  ZAYun
//
//  Created by 魏唯隆 on 2017/7/16.
//  Copyright © 2017年 魏唯隆. All rights reserved.
//

#import "BillCell.h"
#import "AESUtil.h"

@implementation BillCell
{
    __weak IBOutlet UILabel *_weekLabel;
    __weak IBOutlet UILabel *_timeLabel;
    
    __weak IBOutlet UIImageView *_imgView;
    
    __weak IBOutlet UILabel *_valueLabel;
    __weak IBOutlet UILabel *_typeLabel;

}

#define weChatIcon @"wechat"
#define aliIcon @"alipay"
#define card_payIcon @"bankcard"

#define vipIcon @"icon_bill_vip"
#define parkIcon @"icon_funts_parking"

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(BalanceDetailModel *)model
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
                _imgView.image = [UIImage imageNamed:aliIcon];
                _typeLabel.text = @"支付宝充值";
            } else if ([model.payType isEqualToString:@"01"]) {
                _imgView.image = [UIImage imageNamed:weChatIcon];
                _typeLabel.text = @"微信充值";
            }else {
                // 线下充值
                _imgView.image = [UIImage imageNamed:@"money_topup"];
                _typeLabel.text = @"线下充值";
            }
        }
        
//        NSString *money = [AESUtil decryptAES:model.Base_Money key:AESKey];
        
        NSString *money = model.Base_Money;
        
        NSString *topupStr;
        if(![model.Base_ManMoney isKindOfClass:[NSNull class]]&&model.Base_ManMoney != nil && model.Base_ManMoney.integerValue != 0){
            topupStr = [NSString stringWithFormat:@"%.2f元，管理费%.2f元",money.floatValue/100, model.Base_ManMoney.floatValue/100];
        }else {
            topupStr = [NSString stringWithFormat:@"%.2f元",[money floatValue]/100.00];
        }
        _valueLabel.text = topupStr;

    }else{
//        if (![model.payType isKindOfClass:[NSNull class]]) {
            _imgView.image = [UIImage imageNamed:@"canteenpay"];
            if(model.Base_DataTwo == nil || [model.Base_DataTwo isKindOfClass:[NSNull class]]){
                if (![model.payType isKindOfClass:[NSNull class]]&&[model.payType isEqualToString:@"04"]) {
                    _typeLabel.text = @"NFC支付";
                }else{
                    _typeLabel.text = @"pos机刷卡";
                }
            }else {
                _typeLabel.text = @"app支付";
            }
//        }
//        NSString *money = [AESUtil decryptAES:model.Base_Money key:AESKey];
        NSString *money = model.Base_Money;
        _valueLabel.text = [NSString stringWithFormat:@"%.2f元",[money floatValue]/100.00];

    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate *billDate = [format dateFromString:model.orderPayTime];
    
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
        _weekLabel.text = @"今天";
        _timeLabel.text = billDateStr1;
    }else if (billDate.isYesterday) {
        _weekLabel.text = @"昨天";
        _timeLabel.text = billDateStr1;
    }else
    {
//        _weekLabel.text = [NSString stringWithFormat:@"周%@", [self weekStr:_weekday - 1]];
        _weekLabel.text = billDateStr;
        _timeLabel.text = billDateStr1;
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

    
@end

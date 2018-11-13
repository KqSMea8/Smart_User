//
//  VisitRecordTableViewCell.m
//  DXWingGate
//
//  Created by coder on 2018/8/24.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import "VisitRecordTableViewCell.h"
#import "Utils.h"

@interface VisitRecordTableViewCell()
{
    __weak IBOutlet UILabel *postTimeLab;
    __weak IBOutlet UILabel *statusLab;
    __weak IBOutlet UILabel *visitNameLab;
    __weak IBOutlet UILabel *visitPhoneLab;
    __weak IBOutlet UILabel *sexLab;
    __weak IBOutlet UILabel *carNumLab;
    __weak IBOutlet UILabel *beginTimeLab;
    __weak IBOutlet UILabel *endTimeLab;
    
}

@end

@implementation VisitRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(VisitHistoryModel *)model
{
    _model = model;
    NSString *dateString = [Utils exchWith:model.createTime WithFormatter:@"yyyy/MM/dd HH:mm:ss"];
    
    postTimeLab.text = [NSString stringWithFormat:@"%@",dateString];
    
    NSInteger status = model.status.integerValue;
    switch (status) {
        case 0:
        {
            statusLab.text = @"未到访";
            statusLab.textColor = [UIColor colorWithHexString:@"#FF4359"];
        }
            break;
        case 1:
        {
            statusLab.text = @"访问中";
            statusLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
        }
            break;
        case 2:
        {
            statusLab.text = @"已离开";
            statusLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
        }
            break;
        case 3:
        {
            statusLab.text = @"已取消";
            statusLab.textColor = [UIColor colorWithHexString:@"#FF4359"];
        }
            break;
        case 4:
        {
            statusLab.text = @"已离开";
            statusLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
        }
            break;
        default:
            break;
    }
    
    visitNameLab.text = [NSString stringWithFormat:@"%@(",model.visitorName];
    
    if (![model.visitorPhone isKindOfClass:[NSNull class]]&&model.visitorPhone != nil&&model.visitorPhone.length>0) {
        visitPhoneLab.text = [NSString stringWithFormat:@"%@",model.visitorPhone];
    }else{
        visitPhoneLab.text = @"-";
    }
    
    NSInteger sex = model.visitorSex.integerValue;
    NSArray *arr;
    if (![model.persionWith isKindOfClass:[NSNull class]]) {
        NSString *strUrl = [model.persionWith stringByReplacingOccurrencesOfString:@"，" withString:@","];
        arr = [strUrl componentsSeparatedByString:@","];
    }
    
    switch (sex) {
        case 1:
        {
            if (![arr isKindOfClass:[NSNull class]]&&arr.count != 0) {
                sexLab.text = [NSString stringWithFormat:@") 男 等%ld人",arr.count+1];
            }else{
                sexLab.text = [NSString stringWithFormat:@") 男"];
            }
        }
            break;
        case 2:
        {
            if (![arr isKindOfClass:[NSNull class]]&&arr.count != 0) {
                sexLab.text = [NSString stringWithFormat:@") 女 等%ld人",arr.count+1];
            }else{
                sexLab.text = [NSString stringWithFormat:@") 女"];
            }
        }
            break;
        case 3:
        {
            if (![arr isKindOfClass:[NSNull class]]&&arr.count != 0) {
                sexLab.text = [NSString stringWithFormat:@") 等%ld人",arr.count+1];
            }else{
                sexLab.text = [NSString stringWithFormat:@")"];
            }
        }
            break;
        default:
            break;
    }
    
    if (![model.carNo isKindOfClass:[NSNull class]]&&model.carNo != nil&&model.carNo.length != 0) {
        carNumLab.text = [NSString stringWithFormat:@"%@",model.carNo];
    }else{
        carNumLab.text = @"-";
    }
    
    NSString *beginStr = [Utils exchWith:model.beginTime WithFormatter:@"yyyy/MM/dd HH:mm:ss"];
    NSMutableAttributedString *beginAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"起 %@",beginStr]];
    NSDictionary *beginAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#1B82D1"]};
    [beginAttStr setAttributes:beginAttributes range:NSMakeRange(0,1)];
    beginTimeLab.attributedText = beginAttStr;
    
    NSString *endStr = [Utils exchWith:model.endTime WithFormatter:@"yyyy/MM/dd HH:mm:ss"];
    NSMutableAttributedString *endAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"止 %@",endStr]];
    NSDictionary *endAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF4359"]};
    [endAttStr setAttributes:endAttributes range:NSMakeRange(0,1)];
    endTimeLab.attributedText = endAttStr;
}

@end

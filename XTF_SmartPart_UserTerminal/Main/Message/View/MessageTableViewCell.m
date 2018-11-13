//
//  MessageTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/5.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell()
{
    
    __weak IBOutlet UIImageView *headerImageView;
    
    __weak IBOutlet UILabel *titleLab;
    
    __weak IBOutlet UILabel *timeLab;
    
    __weak IBOutlet UILabel *contentLab;
    __weak IBOutlet UILabel *unReadNumLab;
}

@end

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    timeLab.hidden = YES;
    unReadNumLab.layer.cornerRadius = 7.5;
    unReadNumLab.backgroundColor = [UIColor colorWithHexString:@"#eb4025"];
    unReadNumLab.clipsToBounds = YES;
    unReadNumLab.hidden = YES;
}

-(void)setModel:(ParkMessageModel *)model{
    
    headerImageView.image = [UIImage imageNamed:model.headerImage];
    
    titleLab.text = [NSString stringWithFormat:@"%@",model.titleStr];
    
    if ([model.PUSH_TIMESTR isKindOfClass:[NSNull class]]||model.PUSH_TIMESTR == nil) {
        timeLab.hidden = YES;
    }else{
        timeLab.hidden = NO;
        timeLab.text = [NSString stringWithFormat:@"%@",model.PUSH_TIMESTR];
    }
    
    if ([model.PUSH_CONTENT isKindOfClass:[NSNull class]]||model.PUSH_CONTENT == nil) {
        contentLab.text = @"暂无消息";
    }else{
        contentLab.text = [NSString stringWithFormat:@"%@",model.PUSH_CONTENT];
    }
    
    if ([model.UNREAD_SUM isKindOfClass:[NSNull class]]||model.UNREAD_SUM == nil||[model.UNREAD_SUM isEqualToString:@"0"]) {
        unReadNumLab.hidden = YES;
    }else{
        unReadNumLab.hidden = NO;
        if ([model.UNREAD_SUM integerValue] >99) {
            unReadNumLab.text = [NSString stringWithFormat:@"%@",@"99+"];
        }else{
            unReadNumLab.text = [NSString stringWithFormat:@"%@",model.UNREAD_SUM];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

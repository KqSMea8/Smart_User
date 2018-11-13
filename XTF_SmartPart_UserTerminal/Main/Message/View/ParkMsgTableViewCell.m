//
//  ParkMsgTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/5.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ParkMsgTableViewCell.h"
#import "ParkMessageModel.h"

@interface ParkMsgTableViewCell(){
    UIImageView *dotView;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end

@implementation ParkMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    dotView = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLab.right, _titleLab.top-5, 10, 10)];
    dotView.layer.cornerRadius = 2.5;
    dotView.clipsToBounds = YES;
    dotView.image = [UIImage imageNamed:@"dots"];
    dotView.hidden = YES;
    [self.contentView addSubview:dotView];
}

-(void)setParkMsgModel:(ParkMessageModel *)parkMsgModel {
    _parkMsgModel = parkMsgModel;
    
    _titleLab.text = [NSString stringWithFormat:@"%@",parkMsgModel.PUSH_TITLE];
    _timeLab.text = [NSString stringWithFormat:@"%@",parkMsgModel.PUSH_TIMESTR];
    _contentLab.text = [NSString stringWithFormat:@"%@",parkMsgModel.PUSH_CONTENT];
    
    CGSize size = [_titleLab.text sizeWithFont:[UIFont systemFontOfSize:17] forWidth:130 lineBreakMode:NSLineBreakByCharWrapping];
    
    dotView.frame = CGRectMake(size.width+12, _titleLab.top-5, 10, 10);
    if ([parkMsgModel.IS_READ isEqualToString:@"0"]) {
        dotView.hidden = NO;
    }else{
        dotView.hidden = YES;
    }
}

@end

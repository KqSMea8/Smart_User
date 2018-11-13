//
//  AControlTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/21.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "AControlTableViewCell.h"

@interface AControlTableViewCell()
{
    __weak IBOutlet UIImageView *doorStatusView;
    
    __weak IBOutlet UILabel *doorNameLab;
    
    __weak IBOutlet UIButton *openDoorBtn;
    
    __weak IBOutlet UIImageView *lockStatusView;
}

@end

@implementation AControlTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    lockStatusView.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(OpenDoorModel *)model
{
    _model = model;
    
    doorNameLab.text = [NSString stringWithFormat:@"%@",model.DEVICE_NAME];
    
    /*
     gatemachine_close   door_close
     */
    if ([model.DEVICE_TYPE isEqualToString:@"4-1"]) {
        doorStatusView.image = [UIImage imageNamed:@"gatemachine_close"];
    }else{
        doorStatusView.image = [UIImage imageNamed:@"door_close"];
    }
}

- (IBAction)openDoorBtnAction:(id)sender {
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(openDoorWithData:withAnimationView:)]) {
        [self.delegate openDoorWithData:_model withAnimationView:lockStatusView];
    }
}

@end

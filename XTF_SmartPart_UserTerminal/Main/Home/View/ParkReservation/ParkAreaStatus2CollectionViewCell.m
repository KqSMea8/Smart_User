//
//  ParkAreaStatus2CollectionViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/7/25.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "ParkAreaStatus2CollectionViewCell.h"

@interface ParkAreaStatus2CollectionViewCell()
{
    __weak IBOutlet UIView *bgView;
    __weak IBOutlet UIImageView *lockTypeView;
    __weak IBOutlet UIImageView *statusView;
    __weak IBOutlet NSLayoutConstraint *statusViewTopCons;
    __weak IBOutlet NSLayoutConstraint *statusTraCons;
    __weak IBOutlet UILabel *parkNumLab;
}

@end

@implementation ParkAreaStatus2CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    statusViewTopCons.constant = statusViewTopCons.constant*wScale;
    statusTraCons.constant = statusTraCons.constant*wScale;
}

-(void)setModel:(ParkAreaStatusModel *)model
{
    bgView.layer.cornerRadius = 6;
    bgView.layer.borderWidth = 2.5;
    if ([model.lockType isEqualToString:@"0"]) {
        if ([model.parkingStatus isEqualToString:@"0"]) {
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
            statusView.hidden = YES;
            lockTypeView.image = [UIImage imageNamed:@"curtainlock_lock"];
        }else if ([model.parkingStatus isEqualToString:@"3"]){
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#FF4359"].CGColor;
            statusView.hidden = NO;
            statusView.image = [UIImage imageNamed:@"groundLock_forbid"];
            lockTypeView.image = [UIImage imageNamed:@"curtainlock_lock"];
            
        }else if ([model.parkingStatus isEqualToString:@"4"]){
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#FF4359"].CGColor;
            statusView.hidden = NO;
            statusView.image = [UIImage imageNamed:@"groundLock_error"];
            lockTypeView.image = [UIImage imageNamed:@"curtainlock_lock"];
        }
    }else{
        if ([model.parkingStatus isEqualToString:@"0"]) {
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
            statusView.hidden = YES;
            lockTypeView.image = [UIImage imageNamed:@"groundLock_lock"];
        }else if ([model.parkingStatus isEqualToString:@"3"]){
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#FF4359"].CGColor;
            statusView.hidden = NO;
            statusView.image = [UIImage imageNamed:@"groundLock_forbid"];
            lockTypeView.image = [UIImage imageNamed:@"groundLock_lock"];
        }else if ([model.parkingStatus isEqualToString:@"4"]){
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#FF4359"].CGColor;
            statusView.hidden = NO;
            statusView.image = [UIImage imageNamed:@"groundLock_error"];
            lockTypeView.image = [UIImage imageNamed:@"groundLock_lock"];
        }
    }
    
    parkNumLab.text = [NSString stringWithFormat:@"%@",model.parkingSpaceName];
}

@end

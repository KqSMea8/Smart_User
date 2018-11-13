//
//  ParkAreaStatusCollectionViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/7/25.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "ParkAreaStatusCollectionViewCell.h"

@interface ParkAreaStatusCollectionViewCell()
{
    __weak IBOutlet UIView *bgView;
    __weak IBOutlet UIImageView *reserveView;
    
    __weak IBOutlet UIImageView *lockView_Open;
    __weak IBOutlet UIImageView *lockView_locak;
    
    __weak IBOutlet UILabel *areaNameLab;
    __weak IBOutlet UILabel *carNumLab;
    __weak IBOutlet NSLayoutConstraint *reserveTopCons;
    __weak IBOutlet NSLayoutConstraint *reserveTrailCons;
    __weak IBOutlet NSLayoutConstraint *lockView_lockTopCons;
    __weak IBOutlet NSLayoutConstraint *lockView_openTopCons;
    __weak IBOutlet NSLayoutConstraint *areaNameTopCons;
    __weak IBOutlet NSLayoutConstraint *carNumTopCons;
    __weak IBOutlet UILabel *parkNumLab;
}

@end

@implementation ParkAreaStatusCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    reserveTopCons.constant = reserveTopCons.constant*wScale;
    reserveTrailCons.constant = reserveTrailCons.constant*wScale;
    lockView_lockTopCons.constant = lockView_lockTopCons.constant*wScale;
    lockView_openTopCons.constant = lockView_openTopCons.constant*wScale;
    areaNameTopCons.constant = areaNameTopCons.constant*wScale;
    carNumTopCons.constant = carNumTopCons.constant*wScale;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

-(void)setupViews
{
    
}

-(void)setModel:(ParkAreaStatusModel *)model
{
    bgView.layer.cornerRadius = 6;
    bgView.layer.borderWidth = 2.5;
    if ([model.lockType isEqualToString:@"0"]) {
        areaNameLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
        areaNameLab.numberOfLines = 2;
        areaNameLab.textAlignment = NSTextAlignmentCenter;
        carNumLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
        if ([model.parkingStatus isEqualToString:@"0"]) {
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
            reserveView.hidden = YES;
            lockView_locak.hidden = NO;
            lockView_Open.hidden = YES;
            lockView_locak.image = [UIImage imageNamed:@"curtainlock_lock"];
            areaNameLab.text = @"车位";
            carNumLab.text = @"空闲";
            areaNameLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
            carNumLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
        }else if ([model.parkingStatus isEqualToString:@"1"]){
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
            reserveView.hidden = NO;
            lockView_locak.hidden = NO;
            lockView_Open.hidden = YES;
            lockView_locak.image = [UIImage imageNamed:@"curtainlock_lock"];
            NSString *areaStr = [model.carNo substringWithRange:NSMakeRange(0, 2)];
            NSString *carNumStr = [model.carNo substringWithRange:NSMakeRange(2, model.carNo.length-2)];
            areaNameLab.text = areaStr;
            carNumLab.text = carNumStr;
        }else if ([model.parkingStatus isEqualToString:@"2"]){
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
            reserveView.hidden = YES;
            lockView_locak.hidden = NO;
            lockView_Open.hidden = YES;
            lockView_locak.image = [UIImage imageNamed:@"curtainlock_lock"];
            NSString *areaStr = [model.carNo substringWithRange:NSMakeRange(0, 2)];
            NSString *carNumStr = [model.carNo substringWithRange:NSMakeRange(2, model.carNo.length-2)];
            areaNameLab.text = areaStr;
            carNumLab.text = carNumStr;
        }else if ([model.parkingStatus isEqualToString:@"5"]){
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#FF4359"].CGColor;
            reserveView.hidden = NO;
            lockView_locak.hidden = NO;
            lockView_Open.hidden = YES;
            reserveView.image = [UIImage imageNamed:@"Illegal"];
            lockView_locak.image = [UIImage imageNamed:@"curtainlock_lock"];
//            NSString *areaStr = [model.carNo substringWithRange:NSMakeRange(0, 2)];
//            NSString *carNumStr = [model.carNo substringWithRange:NSMakeRange(2, model.carNo.length-2)];
            if (![model.changeResion isKindOfClass:[NSNull class]]&&model.changeResion != nil&&model.changeResion.length != 0) {
                NSMutableString *changeResion = model.changeResion.mutableCopy;
                [changeResion insertString:@"\n" atIndex:2];
                areaNameLab.text = [NSString stringWithFormat:@"%@",changeResion];
                carNumLab.text = @"";
            }else{
                areaNameLab.text = @"非预\n约车";
                carNumLab.text = @"";
            }
        }
    }else{
        areaNameLab.numberOfLines = 2;
        areaNameLab.textAlignment = NSTextAlignmentCenter;
        if ([model.parkingStatus isEqualToString:@"0"]) {
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
            reserveView.hidden = YES;
            lockView_locak.hidden = NO;
            lockView_Open.hidden = YES;
            lockView_locak.image = [UIImage imageNamed:@"groundLock_lock"];
            if (![model.changeResion isKindOfClass:[NSNull class]]&&model.changeResion != nil&&model.changeResion.length >2) {
                areaNameLab.text = [NSString stringWithFormat:@"%@",[model.changeResion substringWithRange:NSMakeRange(0, 2)]];
                carNumLab.text = [NSString stringWithFormat:@"%@",[model.changeResion substringWithRange:NSMakeRange(2, model.changeResion.length - 2)]];
            }else{
                areaNameLab.text = @"车位";
                carNumLab.text = @"空闲";
            }
            areaNameLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
            carNumLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
        }else if ([model.parkingStatus isEqualToString:@"1"]){
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
            reserveView.hidden = NO;
            lockView_locak.hidden = NO;
            lockView_Open.hidden = YES;
            lockView_locak.image = [UIImage imageNamed:@"groundLock_lock"];
            NSString *areaStr = [model.carNo substringWithRange:NSMakeRange(0, 2)];
            NSString *carNumStr = [model.carNo substringWithRange:NSMakeRange(2, model.carNo.length-2)];
            areaNameLab.text = areaStr;
            carNumLab.text = carNumStr;
        }else if ([model.parkingStatus isEqualToString:@"2"]){
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
            reserveView.hidden = YES;
            lockView_locak.hidden = YES;
            lockView_Open.hidden = NO;
            lockView_locak.image = [UIImage imageNamed:@"groundLock_open"];
            NSString *areaStr = [model.carNo substringWithRange:NSMakeRange(0, 2)];
            NSString *carNumStr = [model.carNo substringWithRange:NSMakeRange(2, model.carNo.length-2)];
            areaNameLab.text = areaStr;
            carNumLab.text = carNumStr;
        }else if ([model.parkingStatus isEqualToString:@"5"]){
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#FF4359"].CGColor;
            reserveView.hidden = NO;
            lockView_locak.hidden = YES;
            lockView_Open.hidden = NO;
            reserveView.image = [UIImage imageNamed:@"Illegal"];
            lockView_locak.image = [UIImage imageNamed:@"groundLock_open"];
//            NSString *areaStr = [model.carNo substringWithRange:NSMakeRange(0, 2)];
//            NSString *carNumStr = [model.carNo substringWithRange:NSMakeRange(2, model.carNo.length-2)];
            if (![model.changeResion isKindOfClass:[NSNull class]]&&model.changeResion != nil&&model.changeResion.length != 0) {
                NSMutableString *changeResion = model.changeResion.mutableCopy;
                [changeResion insertString:@"\n" atIndex:2];
                areaNameLab.text = [NSString stringWithFormat:@"%@",changeResion];
                carNumLab.text = @"";
            }else{
                areaNameLab.text = @"非预\n约车";
                carNumLab.text = @"";
            }
        }
    }
    parkNumLab.text = [NSString stringWithFormat:@"%@",model.parkingSpaceName];
}

@end

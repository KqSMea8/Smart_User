//
//  ParkCountCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ParkCountCell.h"

@implementation ParkCountCell
{
    __weak IBOutlet UILabel *_parkName;
    __weak IBOutlet UILabel *freeNumLabel;
    
    __weak IBOutlet UILabel *_allNumLabel;
    
    __weak IBOutlet UIButton *_navBt;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _navBt.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    _navBt.layer.borderWidth = 0.8;
    _navBt.layer.cornerRadius = 4;
}

-(void)setModel:(ParkAreasModel *)model
{
    _parkName.text = [NSString stringWithFormat:@"%@",model.areaName];
    freeNumLabel.text = [NSString stringWithFormat:@"%@",model.areaIdle];
    _allNumLabel.text = [NSString stringWithFormat:@"剩/总%@",model.areaNum];
}

- (IBAction)navToPark:(id)sender {
    if(_navDelegate && [_navDelegate respondsToSelector:@selector(navPark:withLongitude:)]){
#warning 替换model 中经纬度
        [_navDelegate navPark:28.176368 withLongitude:113.083624];
    }
}

@end

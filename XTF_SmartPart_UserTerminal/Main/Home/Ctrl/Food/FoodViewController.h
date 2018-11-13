//
//  FoodViewController.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/1.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "RootViewController.h"

@interface FoodViewController : RootViewController

@property (weak, nonatomic) IBOutlet UIView *breakfeastBgView;
@property (weak, nonatomic) IBOutlet UIView *lunchBgView;
@property (weak, nonatomic) IBOutlet UIImageView *breakfeastView;
@property (weak, nonatomic) IBOutlet UIImageView *lunchView;
@property (weak, nonatomic) IBOutlet UILabel *breakfeastLab;
@property (weak, nonatomic) IBOutlet UILabel *lunchLab;
@property (weak, nonatomic) IBOutlet UIView *signView;

@property (nonatomic, copy) NSString *titleStr;

@end

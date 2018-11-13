//
//  WIFITableViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/28.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIFITableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *wifiNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *wifiImageView;
@property (weak, nonatomic) IBOutlet UIImageView *keyImageView;

@end

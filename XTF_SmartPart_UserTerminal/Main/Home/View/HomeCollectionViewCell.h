//
//  HomeCollectionViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstMenuModel.h"

@interface HomeCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *topImageView;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) FirstMenuModel *model;

@end

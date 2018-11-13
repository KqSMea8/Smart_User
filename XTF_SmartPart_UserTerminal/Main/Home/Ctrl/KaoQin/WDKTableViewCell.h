//
//  WDKTableViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/3/22.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol panchDelegate <NSObject>

-(void)panch:(NSString *)signType;

@end

@interface WDKTableViewCell : UITableViewCell

@property (nonatomic,weak) id<panchDelegate> delegate;

@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *signAddr;
@property (nonatomic,copy) NSString *onWorkTime;

@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy) NSString *longtitude;

@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

//
//  FindCarView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/12/14.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownParkMdel.h"

@interface FindCarView : UIView

@property (nonatomic, retain) DownParkMdel *downParkMdel;

- (void)showMenu;
- (void)hidMenu;

@end

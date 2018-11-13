//
//  FirstMenuModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/8.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface FirstMenuModel : BaseModel

/*
 "MENU_ICON" = "<null>";
 "MENU_ID" = 100;
 "MENU_LEVEL" = 1;
 "MENU_NAME" = "\U5176\U4ed6";
 "MENU_ORDER" = 1;
 "MENU_TYPE" = 3;
 "MENU_URL" = "<null>";
 "PARENT_MENU_ID" = "-1";
 */

@property (nonatomic,strong) NSNumber *MENU_ID;
@property (nonatomic,copy) NSString *MENU_TYPE;
@property (nonatomic,strong) NSNumber *MENU_ORDER;
@property (nonatomic,copy) NSString *MENU_ICON;
@property (nonatomic,copy) NSString *MENU_NAME;
@property (nonatomic,copy) NSString *MENU_LEVEL;
@property (nonatomic,copy) NSString *MENU_URL;
@property (nonatomic,strong) NSNumber *PARENT_MENU_ID;

@end

//
//  SelectPayTypeModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/20.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface SelectPayTypeModel : BaseModel

@property (nonatomic,copy) NSString *payTypeImage;
@property (nonatomic,copy) NSString *descriptionMsg;
@property (nonatomic,copy) NSString *status;

@end

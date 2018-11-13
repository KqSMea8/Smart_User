//
//  KqModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/4.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KqModel : NSObject

@property(strong,nonatomic) NSString *titleStr; //标题
@property (nonatomic,strong) NSString *style;

-(instancetype)initData:(NSDictionary*)dic;

@end

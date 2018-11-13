//
//  KqModel.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/4.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "KqModel.h"

@implementation KqModel

-(instancetype)initData:(NSDictionary*)dic
{
    if (self=[super init]) {
        self.titleStr=[dic objectForKey:@"titleStr"];
        self.style = [dic objectForKey:@"style"];
    }
    return self;
}

@end

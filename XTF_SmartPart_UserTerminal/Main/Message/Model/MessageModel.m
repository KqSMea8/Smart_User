//
//  MessageModel.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/5.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

-(instancetype)initData:(NSDictionary*)dic
{
    if (self=[super init]) {
        self.titleStr=[dic objectForKey:@"titleStr"];
        self.contentStr = [dic objectForKey:@"contentStr"];
        self.headerImage = [dic objectForKey:@"headerImage"];
        self.timeStr = [dic objectForKey:@"timeStr"];
    }
    return self;
}

@end

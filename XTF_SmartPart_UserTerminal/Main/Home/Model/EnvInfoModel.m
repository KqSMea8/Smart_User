//
//  EnvInfoModel.m
//  ZHYQ
//
//  Created by 魏唯隆 on 2018/1/8.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "EnvInfoModel.h"

@implementation EnvInfoModel

- (instancetype)initWithDataDic:(NSDictionary *)data {
    self = [super initWithDataDic:data];
    if(self){
        NSDictionary *attributes = data[@"attributes"];
        if(![attributes isKindOfClass:[NSNull class]]&&attributes != nil){
            EnvAttributesModel *model = [[EnvAttributesModel alloc] initWithDataDic:attributes];
            self.envAttributesModel = model;
        }
    }
    return self;
}

@end

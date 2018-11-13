//
//  PublicModel.h
//  ZHYQ
//
//  Created by 魏唯隆 on 2017/12/29.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface PublicModel : BaseModel

/*
 {
     "appCode": 2,
     "appType": "admin",
     "appUrl": "http://220.168.59.15:8081/hntfEsb/h5/appstore/admindown.html",
     "isMust": "1",
     "versionInfo": "1、测试第一个版本；\n2、解决相关bug。",
     "versionNum": "1.0.1"
 }
 */

@property (nonatomic,copy) NSString *appCode;
@property (nonatomic,copy) NSString *appType;
@property (nonatomic,copy) NSString *appUrl;
@property (nonatomic,copy) NSString *isMust;
@property (nonatomic,copy) NSString *versionInfo;
@property (nonatomic,copy) NSString *versionNum;

@end

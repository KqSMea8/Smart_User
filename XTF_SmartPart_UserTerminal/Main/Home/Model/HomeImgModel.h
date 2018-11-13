//
//  HomeImgModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/12/31.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface HomeImgModel : BaseModel

/*
{
    "android_url": "",
    "imageUrl": "http://220.168.59.11:8081/hntfEsb/upload/images/banner/bannaer.png",
    "ios_url": "",
    "web_url": ""
}
 */

@property (nonatomic,copy) NSString *android_url;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *ios_url;
@property (nonatomic,copy) NSString *web_url;

@end

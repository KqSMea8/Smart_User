//
//  ParkPhotoModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/12/14.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BaseModel.h"

@interface ParkPhotoModel : BaseModel

/*
{
    photoAddtime = 20160831171604;
    photoDesc = "\U505c\U8f66\U573a\U8be6\U60c5\U56fe\U7247";
    photoId = 12;
    photoObjectid = 8a04a41f56bc33a20156bc3726df0004;
    photoType = park;
    photoUrl = "http://tcb-yunpark.oss-cn-hangzhou.aliyuncs.com/yunpark/00000019/20160831/20160831171604114.jpg";
}
 */

@property (nonatomic, copy) NSString *photoAddtime;
@property (nonatomic, copy) NSString *photoDesc;
@property (nonatomic, copy) NSString *photoUrl;

@end

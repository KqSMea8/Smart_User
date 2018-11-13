//
//  NetworkClient.h
//  ZHYQ
//
//  Created by 焦平 on 2017/11/1.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ProgressFloat)(float progressFloat);
typedef void (^Succeed)(id responseObject);
typedef void (^Failure)(NSError *error);

@interface NetworkClient : NSObject

+ (NetworkClient *) sharedInstance;

/** get请求*/
- (void)GET:(NSString *)URLString dict:(id)dict progressFloat:(ProgressFloat)progressFloat succeed:(Succeed)succeed failure:(Failure)failure;

/** post请求*/
- (void)POST:(NSString *)URLString dict:(id)dict progressFloat:(ProgressFloat)progressFloat succeed:(Succeed)succeed failure:(Failure)failure;

/** 下载文件*/
-(void)DOWNLOAD:(NSString *)URLString progressFloat:(ProgressFloat)progressFloat downLoadDic:(Succeed)downLoadDic;

/** 上传多张图片*/
-(void)UPLOAD:(NSString *)URLString dict:(id)dict imageArray:(id)imageArray progressFloat:(ProgressFloat)progressFloat succeed:(Succeed)succeed failure:(Failure)failure;

@end

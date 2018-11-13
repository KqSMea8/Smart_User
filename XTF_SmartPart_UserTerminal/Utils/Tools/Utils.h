//
//  Utils.h
//  SYapp
//
//  Created by 焦平 on 2017/2/14.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/***************************************************************************
 *
 * 工具类
 *
 ***************************************************************************/

@class AppDelegate;
@class UserInfo;

@interface Utils : NSObject

/*
 AppDelegate
 */

+(AppDelegate *)applicationDelegate;

+ (UIImageView *)imageViewWithFrame:(CGRect)frame withImage:(UIImage *)image;


#pragma mark - alertView提示框
+(UIAlertView *)alertTitle:(NSString *)title message:(NSString *)msg delegate:(id)aDeleagte cancelBtn:(NSString *)cancelName otherBtnName:(NSString *)otherbuttonName;
#pragma mark - btnCreate
+(UIButton *)createBtnWithType:(UIButtonType)btnType frame:(CGRect)btnFrame backgroundColor:(UIColor*)bgColor;

#pragma mark isValidateEmail
+(BOOL)isValidateEmail:(NSString *)email;

+ (BOOL)valiMobile:(NSString *)mobile;

+(NSString *)convertToJsonData:(NSDictionary *)dict;

+(NSString *)getCurrentTime;

+(NSString *)getCurrentMouth;

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

+ (NSString *)getMonthBeginAndEndWith:(NSString *)dateStr;

+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour;

//比较两个时间之间的差值
+ (NSString *)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2;

+ (NSString *)UrlValueEncode:(NSString *)str;

+ (NSInteger)getDifferenceByDate:(NSString *)date;

+ (BOOL)judgePassWordLegal:(NSString *)pass;
+ (BOOL)isLocationServiceOpen;

+ (double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2;

+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

+ (NSString *)getCurrentHourTime;

+ (UIViewController *)getCurrentVC;//获取当前控制器

+ (NSString *)currentWeek;

+ (NSArray *)matchLongestSubstrings:(NSString *)str1 with:(NSString *)str2;

+ (NSString *)exchWith:(NSNumber *)time WithFormatter:(NSString *)dataformatter;

+ (NSInteger)getNowTimeTimestamp;

@end


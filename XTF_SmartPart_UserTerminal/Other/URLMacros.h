//
//  URLMacros.h
//  ZHYQ
//
//  Created by 焦平 on 2017/10/22.
//  Copyright © 2017年 焦平. All rights reserved.
//

#ifndef URLMacros_h
#define URLMacros_h

//内部版本号 每次发版递增
#define KVersionCode 1
/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 
 */

#define DevelopSever    1
#define TestSever       0
#define ProductSever    0

#if DevelopSever

/**开发服务器*/

//#define URL_main @"http://192.168.11.122:8090"
//#define MainUrl @"http://192.168.21.191/hntfEsb"
//#define MainUrl @"http://220.168.59.11:8081/hntfEsb"
#define MainUrl @"http://app.wisehn.com/hntfEsb"
//#define MainUrl @"http://220.168.59.15:8081/hntfEsb"
//#define MainUrl @"http://192.168.21.48:8080/hntfEsb" // 文可为
//#define MainUrl @"http://220.168.59.15:8081/hntfEsb"

//#define MainUrl @"http://192.168.21.61:8080/hntfEsb" //岳昊
//#define MainUrl @"http://192.168.207.212:8080/hntfEsb" //岳昊

//#define MainUrl  @"http://192.168.21.111:8080/hntfEsb"

#define MealMainUrl @"http://220.168.59.11:8083"      // 智慧餐饮、智慧幼儿园
//#define MealMainUrl @"http://192.168.21.45:8080"
#define TrainMainUrl @"http://220.168.59.11:8081"     // 智慧培训

//#define MainUrl @"http://192.168.21.45:8080/hntfEsb"
//#define MainUrl @"http://192.168.21.45:8080/hntfEsb"
//#define MainUrl @"http://192.168.206.23:8081/hntfEsb"
//#define reMainUrl @"http://192.168.21.66:8080/hntfEsb"
//#define MainUrl @"http://192.168.21.66:8080/hntfEsb"
//#define MainUrl @"http://j19o375809.iask.in:27511/hntfEsb"
//#define MainUrl @"http://192.168.1.107:8080/hntfEsb"
//#define MainUrl @"http://172.23.67.8:8080/hntfEsb"

// 用户端停车接口
#define ParkMain_Url @"http://115.29.51.72:8080/park-service"
//#define ParkMain_Url @"http://192.168.21.186:8082/service"
//#define ParkMain_Url @"http://www.hnzhangting.cn/park-service/hntfEsb"

#define KDomain @"http://115.29.51.72:8080/park-service"

#elif TestSever

/**测试服务器*/

#elif ProductSever

/**生产服务器*/

#endif

#pragma mark - ——————— 详细接口地址 ————————






#endif /* URLMacros_h */

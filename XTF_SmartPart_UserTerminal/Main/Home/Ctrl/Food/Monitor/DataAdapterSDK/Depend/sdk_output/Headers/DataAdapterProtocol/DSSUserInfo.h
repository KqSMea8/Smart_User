//
//  Userinfo.h
//  SDKWeikit
//
//  Created by ding_qili on 15/7/10.
//  Copyright (c) 2015年 ding_qili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSSBaseInfo.h"
/**
 *  @brief 推送状态 Push State
 */
typedef enum:NSInteger{
    pushState_on = 1,///<推送订阅开 on
    pushState_off = 0,///<推送订阅关 off
    pushState_none = -1///<推送订阅无 none
}DSSPushState;

/**
 *  @brief cloud type 是否支持云存储，支持何种云存储
 */
typedef enum:NSInteger{
    CloudType_local = 0,///<本地
    CloudType_dahua,///<=>大华云,
    CloudType_ali,///<=>阿里云
    CloudType_amazon,///<=>亚马逊
    CloudType_hdfs,///<<不知道 那个平台
    CloudType_hmyd, ///<<和目移动云
    CloudType_fastdfs,///<<fastdfs 也不知道是个啥玩意
}DSSCloudType;

/**
 *  @brief 用户角色类型 user role type
 */
typedef enum:NSInteger{
    UserRole_Normal = 0,///<一般用户 Normal
    UserRole_Enterprise,///<企业用户 Enterprise
    UserRole_Adminstrator,///<管理员 Adminstrator
}DSSUserRole;

/**
 * @brief 菜单权限模块值 Menu Module Right
 */
typedef enum:NSUInteger
{
    MenuModuleRight_Unknow    = 0x00000000,       ///<未知的菜单权限 unknow
    MenuModuleRight_Real      = 0x00000001,       ///<实时 monitor
    MenuModuleRight_Playback  = 0x00000002,       ///<回放 playback
    MenuModuleRight_Emap      = 0x00000004,       ///<地图 emap
    MenuModuleRight_Message   = 0x00000008,       ///<报警 alarm
    MenuModuleRight_TVWall    = 0x00000010,       ///<电视墙 tvwall
    MenuModuleRight_LocalFile = 0x00000020,       ///<本地文件 local file
    MenuModuleRight_AlarmScheme = 0x00000040,     ///<报警预案 alarm scheme
    MenuModuleRight_RecordDownLoad = 0x00000080,  ///<录像下载 record download
    MenuModuleRight_EntranceGuard = 0x00000100,   ///<门禁管理 EntranceGuard
}DSSMenuModuleRight;

/**
 *  @brief P2P server
 */
@interface DSSP2PServer : NSObject
/**
 *  @brief ip
 */
@property (copy,nonatomic,nullable) NSString * ip;
/**
 *  @brief port
 */
@property (nonatomic, assign) int port;

@end

/**
 *  @brief LoginInfo
 */
@interface DSSLoginInfo : NSObject
@property (strong,nonatomic,nullable) NSDate * timestamp;      ///<登录时的UNIX时间戳秒 time stamp
@property (copy,nonatomic,nullable) NSString * ip;             ///<登录时的IP地址 ip
@property (copy,nonatomic,nullable) NSString * clientType;     ///<客户端类型 client type
@property (copy,nonatomic,nullable) NSString * clientName;     ///<客户端名称 client name
@property (copy,nonatomic,nullable) NSString * location;       ///<登录时参考地址 location

@end

/**
 *  @brief 平台用户信息 UserInfo
 */
@interface DSSUserInfo : DSSBaseInfo
/**
 *  @brief 用户名称 user name
 */
@property (copy,nonatomic,nullable) NSString * userName;
/**
 *  @brief 手机号码 phone number
 */
@property (copy,nonatomic,nullable) NSString * phoneNumber;
/**
 *  @brief 昵称 nickName
 */
@property (copy,nonatomic,nullable) NSString * nickName;
/**
 *  @brief 用户头像 user icon
 */
@property (copy,nonatomic,nullable) NSString * userIcon;

/**
 *  @brief 用户所在组ID 如果没有返回-1 groupId
 */
@property (strong,nonatomic,nullable) NSString *groupId;


/**
 *  @brief 推送状态 pushState
 */
@property (nonatomic, assign) DSSPushState pushState;


/**
 *  @brief 最近一次登录的信息 last login info
 */
@property (strong,nonatomic,nullable) DSSLoginInfo * lastLoginInfo;


/**
 userId
 */
@property (nonatomic, copy,nullable) NSString *userId;

///useruuid
@property (nonatomic, copy,nullable) NSString *useruuid;

///menu right
@property (nonatomic, assign)int nMenuRight;

///isCloudBase
@property (nonatomic,assign) BOOL isCloudBase;

//---------------------------------------------- >>> extension by hsd.
@property (nonatomic, copy,nullable) NSString *passwordString;

/**
 呼叫号码
 */
@property (nonatomic, copy,nullable) NSString *sipNumber;
@end

//Ftp Address Info
@interface DSSFtpAddressInfo : DSSBaseInfo

@property (nonatomic, copy,nullable) NSString *ipAddress; ///<真实用到的地址 从innerIpAddress 和 outerIpAddress 中选择一个 需要检查tcp连通性
@property (nonatomic, copy,nullable) NSString *innerIpAddress;
@property (nonatomic, copy,nullable) NSString *innerPort;
@property (nonatomic, copy,nullable) NSString *maxSize;
@property (nonatomic, copy,nullable) NSString *outerIpAddress;
@property (nonatomic, copy,nullable) NSString *outerPort;
@property (nonatomic, copy,nullable) NSString *password;
@property (nonatomic, copy,nullable) NSString *path;
@property (nonatomic, copy,nullable) NSString *userName;

@end

//extend property
extern NSString * _Nullable const kUserInfoHandleDPSDKEntity;///<dss平台dpsdk的handle句柄，扩展字段

extern NSString * _Nullable const kUserInfoWebServicePort; //DSS版本 webservice请求端口
extern NSString * _Nullable const kUserInfoWebServiceIP;  //DSS版本 webservice请求IP

extern NSString * _Nullable const kUserInfoToken;
extern NSString * _Nullable const kUserInfoWebServerHost; ///< web服务地址主机
extern NSString * _Nullable const kUserInfoWebServerPort; ///< web服务地址端口
extern NSString * _Nullable const kUserInfoSubscribeMQ;   ///< 表示是mq还是长轮巡接收报警 默认是NO
extern NSString * _Nullable const kUserInfoMQAddress;   ///< 表示是mq还是长轮巡接收报警 默认是NO
extern NSString * _Nullable const kUserInfoIsExpress; ///< 表示是Express的版本还是Pro的

//
//  WeikitErrorCode.h
//  SDKWeikit
//
//  Created by ding_qili on 15/7/10.
//  Copyright (c) 2015年 ding_qili. All rights reserved.
//

#ifndef SDKWeikit_WeikitErrorCode_h
#define SDKWeikit_WeikitErrorCode_h


#endif
/**
 *  @brief ErrorCode
 */
typedef enum:NSUInteger {
    YYS_BEC_COMMON_BASE = 0,    ///< 成功 success
    YYS_BEC_COMMON_UNKNOWN,                     ///< 未知错误 unknow error
    YYS_BEC_COMMON_CREATE_DPSDK_FAILED,         ///< 创建DPSDK对象失败 create dpsdk failed
    /// 200 OK （API调用成功，但是具体返回结果，由content中的code和desc描述）
    YYS_BEC_COMMON_OK,
    /// 400 Bad Request （API格式错误，无返回内容）
    YYS_BEC_COMMON_BAD_REQUEST,
    /// 401 Unauthorized （用户名密码认证失败，无返回内容）
    YYS_BEC_COMMON_UNAUTHORIZED,
    /// 403 Forbidden （认证成功但是无权限，无返回内容）
    YYS_BEC_COMMON_FORBIDDEN,
    /// 404 Not Found （请求的URI错误，无返回内容)
    YYS_BEC_COMMON_NOT_FOUND,
    /// Precondition Failed （先决条件失败，无返回内容。通常是由于客户端所带的x-hs-date时间与服务器时间相差过大。）
    YYS_BEC_COMMON_PRECONDITION_FAILED,
    ////errorcode.NoVisitPriviledge 服务返回的错误 设备或者通道无权限
    YYS_BEC_COMMON_NOVISIT_PRIVILEDGE,
    /// 500 Internal Server Error （服务器内部错误，无返回内容）
    YYS_BEC_COMMON_SERVER_ERROR,
    /// 503 Service Unavailable （服务不可用，无返回内容。这种情况一般是因为接口调用超出频率限制。）
    YYS_BEC_COMMON_SERVICE_UNAVAILABLE,
    
    /// 网络异常 network error
    YYS_BEC_COMMON_NETWORK_ERROR,
    /// invalid access tocken
    YYS_BEC_COMMON_INVALID_ACCESSTOCKEN,
    /// respone error
    YYS_BEC_COMMON_RESPONE_ERROR,
}CommonErrorCode;

///环境变量模块 Environment ErrorCode
typedef enum:NSUInteger {
    YYS_BEC_ENVIRONMENT_BASE = 1000,    ///<environment errorCode base
    //YYS_BEC_ENVIRONMENT_INVALID_IP, ///<参数错误
    //YYS_BEC_ENVIRONMENT_INVALID_PORT, ///<参数错误
    //YYS_BEC_ENVIRONMENT_INVALID_USERNAME, ///<参数错误
    //YYS_BEC_ENVIRONMENT_INVALID_PASSWORD, ///<参数错误
}EnvironmentErrorCode;

/// 用户模块 User ErrorCode
typedef enum:NSUInteger
{
    YYS_BEC_USER_BASE = 2000,                   ///< 用户操作错误码开始 User errorCode base
    YYS_BEC_USER_UNKNOWN,                       ///< 用户相关操作错误不具体指明 User errorCode unknow
    YYS_BEC_USER_NAME_EXSIT,                    ///< 用户名已经存在 user name exsit
    YYS_BEC_USER_PHONE_EXSIT,                   ///< 手机号已经存在 phone exist
    YYS_BEC_USER_VALID_ERROR,                   ///< 验证码不匹配 valid error
    YYS_BEC_USER_VALID_SEND_FAILED,             ///< 验证码发送失败 valid send error
    YYS_BEC_USER_SAVE_ICON_FAILED,              ///< 保存用户头像失败 save icon failed
    YYS_BEC_USER_THIRD_ACCOUNT_VALID_FAILED,    ///< 第三方账号校验失败 third account valid failed
    YYS_BEC_USER_THIRD_ACCOUNT_BIND_OTHERS,     ///< 第三方账号已绑定其他账号 third account bind others
    YYS_BEC_USER_FREEZE,                        ///< 用户冻结 user freeze
    YYS_BEC_USER_THIRD_ACCOUNT_NOT_BIND,        ///< 第三方账号未绑定 third account not bind
    YYS_BEC_USER_PASSWORD_ERROR,                ///< 用户名和密码不匹配 user or password error
    YYS_BEC_USER_GET_VALIDCODE_TOO_MANY,        ///< 调用获取验证码太频繁 get validcode too many
    YYS_BEC_USER_AUTHORIZED_FREEZE,             ///< 子账号被冻结 authorized freeze
    YYS_BEC_USER_SESSION_EXIST,                 ///< 用户已登录 user session exist
    YYS_BEC_USER_INVALID_MAC_ADDR,              ///< 无效的mac地址 invalid mac address
    YYS_BEC_USER_LOGIN_FREEZE_FIVE_MIN,         ///< 用户锁定，5分钟之后重试 user locked
    YYS_BEC_USER_TOKEN_INVALID,                  ///< 用户token失效 user token invalid
    YYS_BEC_USER_EXPIRE,                         ///< 用户过期 user expire
    YYS_BEC_USER_DATE_FORBIDDEN,                 ///< 用户有效日期过期 date forbidden
    YYS_BEC_USER_CREATE_TOKEN_ERROR,             ///< 生成token异常 create token error
    YYS_BEC_USER_SIGNATURE_ERROR,                ///< 签名错误 signature error
    YYS_BEC_USER_NOT_EXSIT,                       ///< 用户不存在 user not exist
    YYS_BEC_USER_LOGIN_FAILED,                       ///< 登录失败 login failed
    YYS_BEC_USER_LOGIN_TIMEOUT,                       ///< 登录超时 login timeout
    YYS_BEC_USER_LICENSE_LIMIT,                       ///< 超过链接数 The number of APP connections exceeds license limit.
    YYS_BEC_SERVER_LICENSE_EXPIRED,               ///< License过期 The license has expired and you cannot login
}UserErrorCode;

/// 设备管理模块 Device ErrorCode
typedef enum:NSUInteger
{
    YYS_BEC_DEVICE_BASE = 3000,                 ///< 设备操作错误码开始 Device errorcode base
    YYS_BEC_DEVICE_NOT_EXIST,                   ///< 设备未注册 device not exist
    YYS_BEC_DEVICE_REGCODE_ERROR,               ///< 设备注册码错误 device register code error
    YYS_BEC_DEVICE_ADDBYYOURSELF,               ///< 设备被自己添加 device add by yourself
    YYS_BEC_DEVICE_PROJECT_NOT_MATCH,           ///< 设备项目属性和用户不匹配 project not match
    YYS_BEC_DEVICE_NOT_ADDED,                   ///< 设备未添加 device not added
    YYS_BEC_DEVICE_ADDBYOTHER,                  ///< 设备被别人添加 device add by other
    YYS_BEC_DEVICE_SHARE_INFO_ERROR,            ///< 分享失败 share error
    YYS_BEC_DEVICE_UPDATE_CHANNEL_FAIL,         ///< 修改通道失败 update channel fail
    YYS_BEC_DEVICE_OFFLINE,                     ///< 设备离线 device offline
    YYS_BEC_DEVICE_NOT_FIND,                     ///< 设备未找到 device not find
    YYS_BEC_CHANNEL_NO_ABILITY,                  ///< 通道无此能力 channel not ability
    YYS_BEC_DEVICE_SEARCHRECORD_OVER,            ///< 查询录像完成 query records over
    YYS_BEC_CHANNEL_CAMERA_OCCUPY,				 ///< 摄像头被其他用户锁定 camera occupy
    YYS_BEC_CHANNEL_PREPOINT_CODE_ALREADY_EXIST, ///< 预置点编号已存在 prepoint already exist
    YYS_BEC_CHANNEL_PREPOINT_CODE_PTZLOCK,      ///< 云台锁定 ptz lock
}DeviceErrorCode;

/// 消息模块 Message ErrorCode
typedef enum:NSUInteger
{
    YYS_BEC_MESSAGE_BASE = 4000,                ///< 消息操作错误码开始 Message errorcode base
    YYS_BEC_MESSAGE_PAGE_SIZE_TOO_BIG ,         ///< 超过最大的分页限制 Message page size too big
    YYS_BEC_MESSAGE_QUERY_COUNT_ZERO,           ///< 没有报警消息 no message
    YYS_BEC_MESSAGE_NO_MORE,                    ///< 没有更多的消息了 no more message
    YYS_BEC_MESSAGE_CONFIRM_FAILD,              ///< 报警确认失败 alarm confirm failed
    YYS_BEC_MESSAGE_SUBSCRIBE_FAILD             ///< 报警订阅失败 alarm subscribe failed
}MessageErrorCode;

/// 录像模块 Record ErrorCode
typedef enum:NSUInteger
{
    YYS_BEC_RECORD_BASE = 5000,                 ///< 录像操作错误码开始 Record errorcode base
    YYS_BEC_RECORD_CLOUD_STORAGE_NOT_FOUND,      ///< 云存储录像未找到 cloud record not found
    YYS_BEC_RECORD_DATE_FORMART_ERROR,           ///< 日期格式错误 record date formart erroor
    YYS_BEC_RECORD_NO_RECORDS,                   ///< 没有找到录像 no records
    YYS_BEC_RECORD_ENDTIME_LESS_BEGINTIME,       ///< 开始时间不能大于结束时间 endtime less begintime
    YYS_BEC_RECORD_STREAM_ID_IS_NOT_EXIST,       ///< 码流ID不存在
}RecordErrorCode;

/// 视频广场 Video ErrorCode
typedef enum:NSUInteger
{
    YYS_BEC_VIDEO_BASE = 6000,                 ///< 录像操作错误码开始
    YYS_BEC_VIDEO_HAS_SHARED,     ///< 视频已经被分享
    YYS_BEC_VIDEO_NOT_SHARED, ///< 视频还未被分享
    YYS_BEC_VIDEO_COMMENT_NOT_EXISTS,     ///< 评论不存在
    YYS_BEC_VIDEO_HAS_PRIZED, ///< 已经点过赞
    YYS_BEC_VIDEO_NOT_PRIZED, ///< 未点过赞
}VideoErrorCode;

/// 报警预案 AlarmScheme ErrorCode
typedef enum:NSUInteger
{
    YYS_BEC_ALARM_SCHEME_BASE = 7000,   ///< 报警预案错误码开始 AlarmScheme ErrorCode base
    YYS_BEC_ALARM_SCHEME_NOT_EXIST,     ///< 报警预案不存在 AlarmScheme not exist
    YYS_BEC_ALARM_SCHEME_INVALIDATE_FAILD, ///< 预案失效失败 AlarmScheme invalidate failed
}AlarmSchemeCode;

/// 收藏夹 Favourite ErrorCode
typedef enum:NSUInteger
{
    YYS_BEC_FAVOURITE_BASE = 8000,   ///< 收藏夹错误码开始 Favourite ErrorCode base
    YYS_BEC_FAVOURITE_CHANNEL_ALREADY_EXIST,     ///< 该文件夹下通道已存在 Favourite channel already exist
    YYS_BEC_FAVOURITE_CHANNEL_ALLFAILED          ///<多通道收藏全部失败 Favourite channel all failed
    
}FavouriteCode;

/// VTSS ErrorCode
typedef enum:NSUInteger
{
    YYS_BEC_VTSS_BASE = 9000,       ///< VTSS错误码开始 VTSS ErrorCode base
    YYS_BEC_VTSS_LOGIN_FAILED,      ///< VTSS登陆失败 VTSS login failed
    YYS_BEC_VTSS_LOGOUT_FAILED,     ///< VTSS注销失败 VTSS logout failed
}VTSSErrorCode;

/// 电视墙
typedef NS_ENUM(NSUInteger, TVWallCode)
{
    YYS_BEC_TVWALL_BASE = 10000,        ///< 电视墙错误码开始
    YYS_BEC_TVWALL_XML_CREATE_ERROR,    ///< 组装xml错误
    YYS_BEC_TVWALL_PROJECT_NOT_EXIST    ///< 计划不存在
};


typedef NS_ENUM(NSUInteger, LoginCode)
{
    DSS_LOGIN_PASSWORD_USERNAME_EMPTY = 100,   ///< 用户名或密码空
};


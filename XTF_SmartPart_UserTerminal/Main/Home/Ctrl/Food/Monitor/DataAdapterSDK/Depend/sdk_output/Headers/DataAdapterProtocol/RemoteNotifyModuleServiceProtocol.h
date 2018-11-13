//
//  RemoteNotifyModuleServiceProtocol.h
//  Pods
//
//  Created by zyx on 17/2/22.
//
//

#import <Foundation/Foundation.h>
#import "DataAdapterRemoteNotifyProtocol.h"

typedef enum _REMOTE_NOTIFY_ACTION : NSUInteger {
    REMOTE_NOTIFY_ACTION_UNKNOW,
    REMOTE_NOTIFY_ACTION_SERVER_DISCONNECT,    ///<server disconnect
    REMOTE_NOTIFY_ACTION_SERVER_CONNECTING,    ///<server connecting
    REMOTE_NOTIFY_ACTION_SERVER_CONNECTED,      ///<server connected
    
    REMOTE_NOTIFY_ACTION_SERVER_LOGOUT,       ///<logout
    
    REMOTE_NOTIFY_ACTION_DEVICE_ADD_GROUP,  ///<GroupInfo
    REMOTE_NOTIFY_ACTION_DEVICE_SET_BASIC_ROOT_GROUPID,  ///<NSString，基本组织树的根节点
    REMOTE_NOTIFY_ACTION_DEVICE_ADD_DEVICE, ///<DeviceInfo
    REMOTE_NOTIFY_ACTION_DEVICE_ADD_UNIT, ///<UnitInfo
    REMOTE_NOTIFY_ACTION_DEVICE_ADD_CHANNEL,    ///<ChannelInfo
    REMOTE_NOTIFY_ACTION_DEVICE_STATUS,     ///<DeviceInfo在线离线
    REMOTE_NOTIFY_ACTION_CHANNEL_STATUS,     ///<通道状态通知-在线离线
    
    REMOTE_NOTIFY_ACTION_ALARMHOST_DEVICE_STATUS,   ///<设备布撤防状态更新-DeviceInfo
    REMOTE_NOTIFY_ACTION_ALARMHOST_UNIT_STATUS,     ///<单元/子防区/子防区 状态更新-UnitInfo
    REMOTE_NOTIFY_ACTION_ALARMHOST_CHANNEL_STATUS,  ///<通道 旁路、取消旁路、报警状态更新-ChannelInfo
    
    REMOTE_NOTIFY_ACTION_ALARMSCHEME_ADD,   ///<add AlarmSchemeInfo
    REMOTE_NOTIFY_ACTION_ALARMSCHEME_DELETE,   ///<delete AlarmSchemeInfo
    REMOTE_NOTIFY_ACTION_ALARMSCHEME_UPDATE,   ///<update AlarmSchemeInfo
    REMOTE_NOTIFY_ACTION_ADS_CONNECTED,        ///<ads连接成功
    
    REMOTE_NOTIFY_ACTION_MESSAGE_GPS,       ///<GPS设备信息上报
    REMOTE_NOTIFY_ACTION_MESSAGE_ALARM_NEW, ///<AlarmMessageInfo
    REMOTE_NOTIFY_ACTION_MESSAGE_DOOR_NEW, ///<AlarmMessageInfo.doorMessage

    REMOTE_NOTIFY_ACTION_BUSINESS_NOTIFY,   ///<zgyh business notify
    REMOTE_NOTIFY_ACTION_MESSAGE_ALARMPIC_NOTIFY,  ///<报警图片 海外报警图片独立上报
    
    REMOTE_NOTIFY_ACTION_ALARM_COFIRM_NOTIFY,  ///<报警处理回调
    REMOTE_NOTIFY_ACTION_ALARM_COFIRM_NOTIFY_FINISH, ///<一轮报警处理完成
    REMOTE_NOTIFY_ACTION_ADS_RECONNECT,   ///<ADS的重连处理
    
    REMOTE_NOTIFY_ACTION_MODIFY_CHANNEL,
    REMOTE_NOTIFY_ACTION_MOVE_DEVICE,///<
    
    REMOTE_NOTIFY_ACTION_DELETE_DEVICE,///<
    REMOTE_NOTIFY_CHANNEL_RIGHT_CHANGE,///<
    REMOTE_NOTIFY_ACTION_USER_ROLE_CHANGED,
    REMOTE_NOTIFY_ACTION_ROLE_ORG_CHANGED,
    REMOTE_NOTIFY_ACTION_LOGIC_ORG_CHANGED,
    REMOTE_NOTIFY_ACTION_DELETE_ORG,///<
    REMOTE_NOTIFY_ACTION_MODIFY_ORG,///<
    REMOTE_NOTIFY_ACTION_MODIFY_MEDIAVK,
    
    REMOTE_NOTIFY_ACTION_DEVICE_PARSER,///<分级加载
    REMOTE_NOTIFY_ACTION_CHANNEL_PARSER,
    
    REMOTE_NOTIFY_ACTION_USER_CHANGE_PASSWORD, ///< 用户密码被修改
    REMOTE_NOTIFY_ACTION_USER_LOCKED,   ///< 用户被锁定
    REMOTE_NOTIFY_ACTION_USER_DELETE,   ///<用户被删除
    REMOTE_NOTIFY_ACTION_USER_LOGIN_TIME_EXPIRE, ///<用户过期
    REMOTE_NOTIFY_ACTION_USER_LICENSE_EXPIRED, ///授权过期
    
    REMOTE_NOTIFY_ACTION_DEVICE_LOAD_FINISHED,
    
    // 可视对讲分两种通知：事件通知 和 消息通知
    REMOTE_NOTIFY_ACTION_VT_CALL_EVENT_STOP,        ///< 呼叫挂断
    REMOTE_NOTIFY_ACTION_VT_CALL_EVENT_INVITE,      ///< 来电通知
    REMOTE_NOTIFY_ACTION_VT_CALL_EVENT_CANCEL,      ///< 两种情况下通知：1.客户端未接通前，VTO取消呼叫； 2.或者客户端30秒内未接听
    REMOTE_NOTIFY_ACTION_VT_CALL_EVENT_BYE,         ///< VTO挂断已接通的通话
    REMOTE_NOTIFY_ACTION_VT_CALL_EVENT_RING,        ///< 对端响铃
    REMOTE_NOTIFY_ACTION_VT_CALL_EVENT_BUSY,        ///< 对端忙线
    REMOTE_NOTIFY_ACTION_VT_CALL_MESSAGE_START,     ///< 对端接听
    
    REMOTE_NOTIFY_ACTION_ENTRANCEGUARD_ADD_PERSON,       ///<门禁模块新增人员
    REMOTE_NOTIFY_ACTION_ENTRANCEGUARD_DELETE_PERSON,       ///<门禁模块删除人员
    REMOTE_NOTIFY_ACTION_ENTRANCEGUARD_UPDATE_PERSON,       ///<门禁模块人员信息更新
    
    REMOTE_NOTIFY_ACTION_ENTRANCEGUARD_ADD_DEPARTMENT,       ///<门禁模块新增部门
    REMOTE_NOTIFY_ACTION_ENTRANCEGUARD_DELETE_DEPARTMENT,       ///<门禁模块删除部门
    REMOTE_NOTIFY_ACTION_ENTRANCEGUARD_DOORSTATUS_CHANGE,     ///<门禁模块开门状态变更
    ///< 电视墙
    REMOTE_NOTIFY_ACTION_TVWALL_ADD,           ///< 新增电视墙
    REMOTE_NOTIFY_ACTION_TVWALL_MODIFY,        ///< 修改电视墙，本修改通知消息权限字段无效，请勿使用
    REMOTE_NOTIFY_ACTION_TVWALL_DELETE,        ///< 删除电视墙
    REMOTE_NOTIFY_ACTION_TVWALL_MODIFY_RIGHT,  ///< 权限电视墙修改
    REMOTE_NOTIFY_ACTION_TVWALL_MODIFY_CONFIG, ///< 电视墙生效修改
    REMOTE_NOTIFY_ACTION_TVWALL_RUN_INFO,      ///<TODO:-电视墙运行信息通知
    REMOTE_NOTIFY_ACTION_TVWALL_NAME_MODIFY,   ///< 电视墙名字修改
    REMOTE_NOTIFY_ACTION_TVWALL_LAYOUT_MODIFY, ///< 电视墙布局修改通知（非平台通知，由本地判断，如果修改则通知上层）
    
} REMOTE_NOTIFY_ACTION;

@protocol WatcherRemoteNotifyProtocol
@required
-(void)watcherRemoteNotifyArrive:(REMOTE_NOTIFY_ACTION)action data:(id)content;
@end

@protocol RemoteNotifyModuleServiceProtocol <NSObject>

#pragma mark--register function to IDHModuleProtocol
-(void)addWathcer:(id<WatcherRemoteNotifyProtocol>)watcher;

#pragma mark--register function to IDHModuleProtocol
-(void)removeWathcer:(id<WatcherRemoteNotifyProtocol>)watcher;

#pragma mark--register function to IDHModuleProtocol
-(void)notify2Watchers:(REMOTE_NOTIFY_ACTION)action data:(id)content;

@end


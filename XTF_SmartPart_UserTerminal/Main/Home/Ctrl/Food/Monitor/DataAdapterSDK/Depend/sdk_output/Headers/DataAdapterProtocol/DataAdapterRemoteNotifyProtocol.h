//
//  DataAdapterRemoteNotifyProtocol.h
//  Pods
//
//  Created by zyx on 17/2/22.
//
//

#import <Foundation/Foundation.h>
//adapter notify
typedef enum _ADAPTER_NOTIFY_ACTION : NSUInteger {
    ADAPTER_NOTIFY_ACTION_SERVER_DISCONNECT,     ///<服务离线 server disconnect
    ADAPTER_NOTIFY_ACTION_SERVER_CONNECTING,     ///<服务连接中 server connecting
    ADAPTER_NOTIFY_ACTION_SERVER_CONNECTED,      ///<服务已连接 server connected
    ADAPTER_NOTIFY_ACTION_SERVER_RECONNECTED,      ///<服务自己恢复重新连接 server reconnected (先前的登陆和重新登陆都是ADAPTER_NOTIFY_ACTION_SERVER_CONNECTED)
    
    ADAPTER_NOTIFY_ACTION_SERVER_LOGOUT,         ///<服务退出 logout
    
    ADAPTER_NOTIFY_ACTION_ALARMHOST_DEVICE_STATUS,   ///<设备布撤防状态更新-DeviceInfo alrmhost device status
    ADAPTER_NOTIFY_ACTION_ALARMHOST_UNIT_STATUS,     ///<单元/子防区/子防区 状态更新-UnitInfo alrmhost unit status
    ADAPTER_NOTIFY_ACTION_ALARMHOST_CHANNEL_STATUS,  ///<通道 旁路、取消旁路、报警状态更新-ChannelInfo  alrmhost channel status
    
    ADAPTER_NOTIFY_ACTION_ALARMSCHEME_ADD,      ///<add AlarmSchemeInfo
    ADAPTER_NOTIFY_ACTION_ALARMSCHEME_DELETE,   ///<delete AlarmSchemeInfo
    ADAPTER_NOTIFY_ACTION_ALARMSCHEME_UPDATE,   ///<update AlarmSchemeInfo
    ADAPTER_NOTIFY_ACTION_ADS_CONNECTED,        ///<ads connected
    
    ADAPTER_NOTIFY_ACTION_MESSAGE_GPS,          ///<GPS设备信息上报
    ADAPTER_NOTIFY_ACTION_MESSAGE_ALARM_NEW,    ///<AlarmMessageInfo
    ADAPTER_NOTIFY_ACTION_MESSAGE_DOOR_NEW,     ///<AlarmMessageInfo.doorMessageInfo

    ADAPTER_NOTIFY_ACTION_BUSINESS_NOTIFY,     ///<zgyh business notify
    ADAPTER_NOTIFY_ACTION_MESSAGE_ALARMPIC_NOTIFY,  ///<报警图片 alarm picture notify
    
    ADAPTER_NOTIFY_ACTION_ALARM_COFIRM_NOTIFY,  ///<报警处理回调 alarm confirm notify
    ADAPTER_NOTIFY_ACTION_ALARM_COFIRM_NOTIFY_FINISH, ///<一轮报警处理完成
    ADAPTER_NOTIFY_ACTION_ADS_RECONNECT,   ///<ADS的重连处理 ADS reconnect
    
    ADAPTER_NOTIFY_ACTION_DEVICE_STATUS,    ///<设备状态 device status
    ADAPTER_NOTIFY_ACTION_CHANNEL_STATUS,   ///<通道状态 channel status
    ADAPTER_NOTIFY_ACTION_ADD_ORG,          ///<添加组织 add group
    ADAPTER_NOTIFY_ACTION_MODIFY_ORG,       ///<修改组织 modidy group
    ADAPTER_NOTIFY_ACTION_DELETE_ORG,       ///<删除组织 delete group
    ADAPTER_NOTIFY_ACTION_ADD_DEVICE,       ///<添加设备 add device
    ADAPTER_NOTIFY_ACTION_MODIFY_DEVICE,    ///<修改设备 modify device
    ADAPTER_NOTIFY_ACTION_MOVE_DEVICE,      ///<移动设备 move device
    ADAPTER_NOTIFY_ACTION_DELETE_DEVICE,    ///<删除设备 delete device
    ADAPTER_NOTIFY_ACTION_USER_ROLE_CHANGED,///<角色变更 user role changed
    ADAPTER_NOTIFY_ACTION_ROLE_ORG_CHANGED, ///<角色组织变更 role org changed
    ADAPTER_NOTIFY_ACTION_LOGIC_ORG_CHANGED,///<逻辑组织变更 logic org changed
    ADAPTER_NOTIFY_ACTION_CHANNEL_RIGHT_CHANGED,///<权限变更 channel right changed
    ADAPTER_NOTIFY_ACTION_MODIFY_MEDIAVK, ///<秘钥变更 Mediavk changed
    
    ADAPTER_NOTIFY_ACTION_USER_CHANGE_PASSWORD, ///< 用户密码被修改 user password changed
    ADAPTER_NOTIFY_ACTION_USER_LOCKED,   ///< 用户被锁定 user locked
    ADAPTER_NOTIFY_ACTION_USER_DELETE,   ///<用户被删除 user delete
    ADAPTER_NOTIFY_ACTION_USER_LOGIN_TIME_EXPIRE, ///<用户过期 login time expire
    ADAPTER_NOTIFY_ACTION_USER_LICENSE_EXPIRED,  //授权到期了
    
    // 可视对讲分两种通知：事件通知 和 消息通知
    ADAPTER_NOTIFY_ACTION_VT_CALL_EVENT_STOP,       ///< 呼叫挂断 call stop
    ADAPTER_NOTIFY_ACTION_VT_CALL_EVENT_INVITE,     ///< 来电通知 call invite
    ADAPTER_NOTIFY_ACTION_VT_CALL_EVENT_CANCEL,     ///< 两种情况下通知：1.客户端未接通前，VTO取消呼叫； 2.或者客户端30秒内未接听 call cancel
    ADAPTER_NOTIFY_ACTION_VT_CALL_EVENT_BYE,        ///< VTO挂断已接通的通话 call reject
    ADAPTER_NOTIFY_ACTION_VT_CALL_EVENT_RING,       ///< 对端响铃
    ADAPTER_NOTIFY_ACTION_VT_CALL_EVENT_BUSY,       ///< 对端忙线
    ADAPTER_NOTIFY_ACTION_VT_CALL_MESSAGE_START,    ///< 对端接听消息
    
    
    ADAPTER_NOTIFY_ACTION_ENTRANCEGUARD_ADD_PERSON,          ///<门禁模块新增人员 entranceguard add person
    ADAPTER_NOTIFY_ACTION_ENTRANCEGUARD_DELETE_PERSON,       ///<门禁模块删除人员 entranceguard delete person
    ADAPTER_NOTIFY_ACTION_ENTRANCEGUARD_UPDATE_PERSON,       ///<门禁模块人员信息更新 entranceguard update person

    ADAPTER_NOTIFY_ACTION_ENTRANCEGUARD_ADD_DEPARTMENT,       ///<门禁模块新增部门 entranceguard add department
    ADAPTER_NOTIFY_ACTION_ENTRANCEGUARD_DELETE_DEPARTMENT,       ///<门禁模块删除部门 entranceguard delete department
    ADAPTER_NOTIFY_ACTION_ENTRANCEGUARD_DOORSTATUS_CHANGE,   ///<门禁模块开门状态变更 entranceguard doorStatus channge
    // 电视墙
    ADAPTER_NOTIFY_ACTION_TVWALL_ADD,           ///< 新增电视墙 add tvwall
    ADAPTER_NOTIFY_ACTION_TVWALL_MODIFY,        ///< 修改电视墙，本修改通知消息权限字段无效，请勿使用; modify tvwall
    ADAPTER_NOTIFY_ACTION_TVWALL_DELETE,        ///< 删除电视墙 delete tvwall
    ADAPTER_NOTIFY_ACTION_TVWALL_MODIFY_RIGHT,  ///< 权限电视墙修改 tvwall modify right
    ADAPTER_NOTIFY_ACTION_TVWALL_MODIFY_CONFIG, ///< 电视墙生效修改 tvwall modify config
    ADAPTER_NOTIFY_ACTION_TVWALL_RUN_INFO,      ///<TODO:-电视墙运行信息通知 tvwall run info
    ADAPTER_NOTIFY_ACTION_TVWALL_NAME_MODIFY,   ///< 电视墙名字修改
    ADAPTER_NOTIFY_ACTION_TVWALL_LAYOUT_MODIFY, ///< 电视墙布局修改通知（非平台通知，由本地判断，如果修改则通知上层） tvwall layout modify
    //MQ
    ADAPTER_NOTIFY_ACTION_ADD_DEVICE_MQ,       ///<添加设备MQ通知 add device(MQ)
    ADAPTER_NOTIFY_ACTION_MODIFY_DEVICE_MQ,    ///<修改设备MQ通知 modify device(MQ)
} ADAPTER_NOTIFY_ACTION;

@protocol DataAdapterRemoteNotifyProtocol <NSObject>
#pragma mark--register function to IDHModuleProtocol
- (id)receiveApnsRemoteNotification:(NSDictionary *)userInfo;

@end

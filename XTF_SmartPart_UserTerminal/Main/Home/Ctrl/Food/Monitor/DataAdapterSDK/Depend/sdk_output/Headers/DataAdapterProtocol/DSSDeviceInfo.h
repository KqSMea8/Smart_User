//
//  DSSDeviceInfo.h
//  Pods
//
//  Created by zyx on 17/2/21.
//
//

#import <Foundation/Foundation.h>
#import "DSSBaseInfo.h"
#import "DSSUnitInfo.h"
#import "DHThreadSafeMultableArray.h"

typedef enum:NSInteger {
    MBL_DEV_TYPE_ENC_BEGIN            = 0,        ///< 编码设备
    MBL_DEV_TYPE_DVR                = MBL_DEV_TYPE_ENC_BEGIN + 1,            ///< DVR
    MBL_DEV_TYPE_IPC                = MBL_DEV_TYPE_ENC_BEGIN + 2,            ///< IPC
    MBL_DEV_TYPE_NVS                = MBL_DEV_TYPE_ENC_BEGIN + 3,            ///< NVS
    MBL_DEV_TYPE_MCD                = MBL_DEV_TYPE_ENC_BEGIN + 4,            ///< MCD
    MBL_DEV_TYPE_MDVR                = MBL_DEV_TYPE_ENC_BEGIN + 5,            ///< MDVR
    MBL_DEV_TYPE_NVR                = MBL_DEV_TYPE_ENC_BEGIN + 6,            ///< NVR
    MBL_DEV_TYPE_SVR                = MBL_DEV_TYPE_ENC_BEGIN + 7,            ///< SVR
    MBL_DEV_TYPE_PCNVR                = MBL_DEV_TYPE_ENC_BEGIN + 8,            ///< PCNVR，PSS自带的一个小型服务
    MBL_DEV_TYPE_PVR                = MBL_DEV_TYPE_ENC_BEGIN + 9,            ///< PVR
    MBL_DEV_TYPE_EVS                = MBL_DEV_TYPE_ENC_BEGIN + 10,            ///< EVS
    MBL_DEV_TYPE_MPGS                = MBL_DEV_TYPE_ENC_BEGIN + 11,            ///< MPGS
    MBL_DEV_TYPE_SMART_IPC            = MBL_DEV_TYPE_ENC_BEGIN + 12,            ///< SMART_IPC
    MBL_DEV_TYPE_SMART_TINGSHEN        = MBL_DEV_TYPE_ENC_BEGIN + 13,            ///< 庭审主机
    MBL_DEV_TYPE_SMART_NVR            = MBL_DEV_TYPE_ENC_BEGIN + 14,            ///< SMART_NVR
    MBL_DEV_TYPE_PRC                = MBL_DEV_TYPE_ENC_BEGIN + 15,            ///< 防护舱
    MBL_DEV_TYPE_JT808                = MBL_DEV_TYPE_ENC_BEGIN + 18,            ///< 部标JT808
    
    MBL_DEV_TYPE_VTT                = MBL_DEV_TYPE_ENC_BEGIN + 21,            ///< VTT
    MBL_DEV_TYPE_HCVR                = MBL_DEV_TYPE_ENC_BEGIN + 22,            ///< 海康CVR类型
    MBL_DEV_TYPE_IF                    = MBL_DEV_TYPE_ENC_BEGIN + 23,            ///< 智能ATM
    MBL_DEV_TYPE_VTO                = MBL_DEV_TYPE_ENC_BEGIN + 24,            ///< 金融VTO，当做编码器小类接入
    MBL_DEV_TYPE_ALARM_STUB_VTA     = MBL_DEV_TYPE_ENC_BEGIN + 25,          ///< VTA
    MBL_DEV_TYPE_THC                = MBL_DEV_TYPE_ENC_BEGIN + 26,            ///< 热成像设备
    MBL_DEV_TYPE_DSJ                = MBL_DEV_TYPE_ENC_BEGIN + 27,            ///< DSJ
    MBL_DEV_TYPE_MCS                = MBL_DEV_TYPE_ENC_BEGIN + 35,           ///<MCS设备
     MBL_DEV_TYPE_WATCHER            = MBL_DEV_TYPE_ENC_BEGIN + 39,           ///<守望者设备
    MBL_DEV_TYPE_SD                 = MBL_DEV_TYPE_ENC_BEGIN + 42,           ///<SD设备
    MBL_DEV_TYPE_ENC_END,
    
    MBL_DEV_TYPE_TVWALL_BEGIN        = 100,
    MBL_DEV_TYPE_BIGSCREEN            = MBL_DEV_TYPE_TVWALL_BEGIN + 1,        ///< 大屏
    MBL_DEV_TYPE_TVWALL_END,
    
    MBL_DEV_TYPE_DEC_BEGIN            = 200,        ///< 解码设备
    MBL_DEV_TYPE_NVD                = MBL_DEV_TYPE_DEC_BEGIN + 1,            ///< NVD
    MBL_DEV_TYPE_SNVD                = MBL_DEV_TYPE_DEC_BEGIN + 2,            ///< SNVD
    MBL_DEV_TYPE_UDS                = MBL_DEV_TYPE_DEC_BEGIN + 5,            ///< UDS
    MBL_DEV_TYPE_DEC_END,
    
    MBL_DEV_TYPE_MATRIX_BEGIN        = 300,        ///< 矩阵设备
    MBL_DEV_TYPE_MATRIX_M60                = MBL_DEV_TYPE_MATRIX_BEGIN    + 1,        ///< M60
    MBL_DEV_TYPE_MATRIX_NVR6000            = MBL_DEV_TYPE_MATRIX_BEGIN + 2,        ///< NVR6000
    MBL_DEV_TYPE_MATRIX_END,
    
    MBL_DEV_TYPE_IVS_BEGIN            = 400,        ///< 智能设备
    MBL_DEV_TYPE_ISD                = MBL_DEV_TYPE_IVS_BEGIN + 1,            ///< ISD 智能球
    MBL_DEV_TYPE_IVS_B                = MBL_DEV_TYPE_IVS_BEGIN + 2,            ///< IVS-B 行为分析服务
    MBL_DEV_TYPE_IVS_V                = MBL_DEV_TYPE_IVS_BEGIN + 3,            ///< IVS-V 视频质量诊断服务
    MBL_DEV_TYPE_IVS_FR                = MBL_DEV_TYPE_IVS_BEGIN + 4,            ///< IVS-FR 人脸识别服务
    MBL_DEV_TYPE_IVS_PC                = MBL_DEV_TYPE_IVS_BEGIN + 5,            ///< IVS-PC 人流量统计服务
    MBL_DEV_TYPE_IVS_M                = MBL_DEV_TYPE_IVS_BEGIN + 6,            ///< IVS_M 主从跟踪智能盒
    MBL_DEV_TYPE_IVS_PC_BOX            = MBL_DEV_TYPE_IVS_BEGIN + 7,            ///< IVS-PC 智能盒
    MBL_DEV_TYPE_IVS_B_BOX            = MBL_DEV_TYPE_IVS_BEGIN + 8,            ///< IVS-B 智能盒
    MBL_DEV_TYPE_IVS_M_BOX            = MBL_DEV_TYPE_IVS_BEGIN + 9,            ///< IVS-M 盒子
    MBL_DEV_TYPE_IVS_PRC            = MBL_DEV_TYPE_IVS_BEGIN + 10,            ///< 防护舱
    MBL_DEV_TYPE_IVS_IF                = MBL_DEV_TYPE_IVS_BEGIN + 11,            ///< IVS_IF
    MBL_DEV_TYPE_IVS_IPC            = MBL_DEV_TYPE_IVS_BEGIN + 12,            ///< IVS_IPC
    MBL_DEV_TYPE_IVS_SmartIPC        = MBL_DEV_TYPE_IVS_BEGIN + 13,            ///< IVS_SmartIPC
    MBL_DEV_TYPE_IVS_END,
    
    MBL_DEV_TYPE_BAYONET_BEGIN        = 500,        ///< -C相关设备
    MBL_DEV_TYPE_CAPTURE            = MBL_DEV_TYPE_BAYONET_BEGIN + 1,        ///< 卡口设备
    MBL_DEV_TYPE_SPEED                = MBL_DEV_TYPE_BAYONET_BEGIN + 2,        ///< 测速设备
    MBL_DEV_TYPE_TRAFFIC_LIGHT        = MBL_DEV_TYPE_BAYONET_BEGIN + 3,        ///< 闯红灯设备
    MBL_DEV_TYPE_INCORPORATE        = MBL_DEV_TYPE_BAYONET_BEGIN + 4,        ///< 一体化设备
    MBL_DEV_TYPE_PLATEDISTINGUISH    = MBL_DEV_TYPE_BAYONET_BEGIN + 5,        ///< 车牌识别设备
    MBL_DEV_TYPE_VIOLATESNAPPIC        = MBL_DEV_TYPE_BAYONET_BEGIN + 6,        ///< 违停检测设备
    MBL_DEV_TYPE_PARKINGSTATUSDEV    = MBL_DEV_TYPE_BAYONET_BEGIN + 7,        ///< 车位检测设备
    MBL_DEV_TYPE_ENTRANCE            = MBL_DEV_TYPE_BAYONET_BEGIN + 8,        ///< 出入口设备
    MBL_DEV_TYPE_VIOLATESNAPBALL    = MBL_DEV_TYPE_BAYONET_BEGIN + 9,        ///< 违停抓拍球机
    MBL_DEV_TYPE_THIRDBAYONET        = MBL_DEV_TYPE_BAYONET_BEGIN + 10,        ///< 第三方卡口设备
    MBL_DEV_TYPE_ULTRASONIC            = MBL_DEV_TYPE_BAYONET_BEGIN + 11,        ///< 超声波车位检测器
    MBL_DEV_TYPE_FACE_CAPTURE        = MBL_DEV_TYPE_BAYONET_BEGIN + 12,        ///< 人脸抓拍设备
    MBL_DEV_TYPE_ITC_SMART_NVR        = MBL_DEV_TYPE_BAYONET_BEGIN + 13,        ///< 卡口智能NVR设备
    MBL_DEV_TYPE_BAYONET_END,
    
    MBL_DEV_TYPE_ALARM_BEGIN        = 600,        ///< 报警设备
    MBL_DEV_TYPE_ALARMHOST            = MBL_DEV_TYPE_ALARM_BEGIN + 1,            ///< 网络报警主机
    MBL_DEV_TYPE_ALARM_END,
    
    MBL_DEV_TYPE_DOORCTRL_BEGIN        = 700,
    MBL_DEV_TYPE_DOORCTRL_DOOR         = MBL_DEV_TYPE_DOORCTRL_BEGIN + 1,        // 门禁
    MBL_DEV_TYPE_DOORCTRL_CENTERCTRL     = MBL_DEV_TYPE_DOORCTRL_BEGIN + 2,        // 门禁集中控制器
    MBL_DEV_TYPE_DOORCTRL_FACEGATE     = MBL_DEV_TYPE_DOORCTRL_BEGIN + 3,        // FACEGATE
    MBL_DEV_TYPE_DOORCTRL_END,

    
    MBL_DEV_TYPE_PE_BEGIN            = 800,
    MBL_DEV_TYPE_PE_PE                = MBL_DEV_TYPE_PE_BEGIN + 1,            ///< 动环
    MBL_DEV_TYPE_PE_AE6016            = MBL_DEV_TYPE_PE_BEGIN + 2,            ///< AE6016设备
    MBL_DEV_TYPE_PE_NVS                = MBL_DEV_TYPE_PE_BEGIN + 3,            ///< 带动环功能的NVS设备
    MBL_DEV_TYPE_PE_END,
    
    MBL_DEV_TYPE_VOICE_BEGIN        = 900,        ///< ip对讲
    MBL_DEV_TYPE_VOICE_MIKE            = MBL_DEV_TYPE_VOICE_BEGIN + 1,
    MBL_DEV_TYPE_VOICE_NET            = MBL_DEV_TYPE_VOICE_BEGIN + 2,
    MBL_DEV_TYPE_VOICE_END,
    
    MBL_DEV_TYPE_IP_BEGIN            = 1000,        ///< IP设备（通过网络接入的设备）
    MBL_DEV_TYPE_IP_SCNNER            = MBL_DEV_TYPE_IP_BEGIN + 1,            ///< 扫描枪
    MBL_DEV_TYPE_IP_SWEEP            = MBL_DEV_TYPE_IP_BEGIN + 2,            ///< 地磅
    MBL_DEV_TYPE_IP_POWERCONTROL    = MBL_DEV_TYPE_IP_BEGIN + 3,            ///< 电源控制器
    MBL_DEV_TYPE_IP_END,
    
    MBL_DEV_TYPE_MULTIFUNALARM_BEGIN= 1100,        ///< 多功能报警主机
    MBL_DEV_TYPE_VEDIO_ALARMHOST    = MBL_DEV_TYPE_MULTIFUNALARM_BEGIN + 1,    ///< 视频报警主机
    MBL_DEV_TYPE_MULTIFUNALARM_END,
    
    MBL_DEV_TYPE_SLUICE_BEGIN        = 1200,
    MBL_DEV_TYPE_SLUICE_DEV            = MBL_DEV_TYPE_SLUICE_BEGIN + 1,        ///< 出入口道闸设备
    MBL_DEV_TYPE_SLUICE_PARKING        = MBL_DEV_TYPE_SLUICE_BEGIN + 2,        ///< 停车场道闸设备
    MBL_DEV_TYPE_SLUICE_STOPBUFFER    = MBL_DEV_TYPE_SLUICE_BEGIN + 3,        ///< 视频档车器
    MBL_DEV_TYPE_SLUICE_END,
    
    MBL_DEV_TYPE_ELECTRIC_BEGIN        = 1300,
    MBL_DEV_TYPE_ELECTRIC_DEV        = MBL_DEV_TYPE_ELECTRIC_BEGIN + 1,        ///< 电网设备
    MBL_DEV_TYPE_ELECTRIC_END,
    
    MBL_DEV_TYPE_LED_BEGIN            = 1400,
    MBL_DEV_TYPE_LED_DEV            = MBL_DEV_TYPE_LED_BEGIN + 1,            ///< LED屏设备
    MBL_DEV_TYPE_LED_END,
    
    MBL_DEV_TYPE_VIBRATIONFIBER_BEGIN    = 1500,
    MBL_DEV_TYPE_VIBRATIONFIBER_DEV    = MBL_DEV_TYPE_VIBRATIONFIBER_BEGIN + 1,///< 震动光纤设备
    MBL_DEV_TYPE_VIBRATIONFIBER_END,
    
    MBL_DEV_TYPE_PATROL_BEGIN        = 1600,
    MBL_DEV_TYPE_PATROL_DEV            = MBL_DEV_TYPE_PATROL_BEGIN + 1,        ///< 巡更棒设备
    MBL_DEV_TYPE_PATROL_SPOT        = MBL_DEV_TYPE_PATROL_BEGIN + 2,        ///< 巡更点设备
    MBL_DEV_TYPE_PATROL_END,
    
    MBL_DEV_TYPE_SENTRY_BOX_BEGIN    = 1700,
    MBL_DEV_TYPE_SENTRY_BOX_DEV        = MBL_DEV_TYPE_SENTRY_BOX_BEGIN + 1,    ///< 哨位箱设备
    MBL_DEV_TYPE_SENTRY_BOX_END,
    
    MBL_DEV_TYPE_COURT_BEGIN        = 1800,
    MBL_DEV_TYPE_COURT_DEV            = MBL_DEV_TYPE_COURT_BEGIN + 1,            ///< 庭审设备
    MBL_DEV_TYPE_COURT_END,
    
    MBL_DEV_TYPE_VIDEO_TALK_BEGIN    = 1900,
    MBL_DEV_TYPE_VIDEO_TALK_VTNC    = MBL_DEV_TYPE_VIDEO_TALK_BEGIN + 1,
    MBL_DEV_TYPE_VIDEO_TALK_VTO        = MBL_DEV_TYPE_VIDEO_TALK_BEGIN + 2,
    MBL_DEV_TYPE_VIDEO_TALK_VTH        = MBL_DEV_TYPE_VIDEO_TALK_BEGIN + 3,
    MBL_DEV_TYPE_VIDEO_TALK_ANALOG_VTH        = MBL_DEV_TYPE_VIDEO_TALK_BEGIN + 4,
    MBL_DEV_TYPE_VIDEO_TALK_FENCE_VTO        = MBL_DEV_TYPE_VIDEO_TALK_BEGIN + 5,
    MBL_DEV_TYPE_VIDEO_TALK_DOORLOCK_VTH   =  MBL_DEV_TYPE_VIDEO_TALK_BEGIN + 6,
    MBL_DEV_TYPE_VIDEO_TALK_ANALOG_VTO        = MBL_DEV_TYPE_VIDEO_TALK_BEGIN + 7,    ///< 半数字门口机
    MBL_DEV_TYPE_VIDEO_TALK_VTS                = MBL_DEV_TYPE_VIDEO_TALK_BEGIN + 8,    ///< VTS管理机
    MBL_DEV_TYPE_VIDEO_TALK_SIP_PHONE        = MBL_DEV_TYPE_VIDEO_TALK_BEGIN + 10,    ///< 第三方厂家Sip话机
    MBL_DEV_TYPE_VIDEO_TALK_END,
    
    MBL_DEV_TYPE_BROADCAST_BEGIN    = 2000,
    MBL_DEV_TYPE_BROADCAST_ITC_T6700R = MBL_DEV_TYPE_BROADCAST_BEGIN + 1,    ///< ITC_T6700R广播设备
    MBL_DEV_TYPE_BROADCAST_END,
    
    MBL_DEV_TYPE_VIDEO_RECORD_SERVER_BEGIN = 2100,
    MBL_DEV_TYPE_VIDEO_RECORD_SERVER_BNVR    = MBL_DEV_TYPE_VIDEO_RECORD_SERVER_BEGIN + 1, ///< BNVR设备
    MBL_DEV_TYPE_VIDEO_RECORD_SERVER_OE    = MBL_DEV_TYPE_VIDEO_RECORD_SERVER_BEGIN + 2, ///< 手术设备(operation equipment)
    MBL_DEV_TYPE_VIDEO_RECORD_SERVER_END,
    
    MBL_DEV_TYPE_DISPATCHER_BEGIN    = 2200,
    MBL_DEV_TYPE_DISPATCHER            = MBL_DEV_TYPE_DISPATCHER_BEGIN + 1,    ///<指挥调度设备 dispatcher
    MBL_DEV_TYPE_DISPATCHER_END,
    
    MBL_DEV_TYPE_UNKNOWN,
}MBL_DEVICE_TYPE;

//device Provide
typedef enum:NSUInteger
{
    MBL_DEVICE_PROVIDER_UNKONW = 0,   ///<厂商未知 unknow
    MBL_DEVICE_PROVIDER_DAHUA  = 1,   ///<厂商大华 dahua
    MBL_DEVICE_PROVIDER_HIK    = 2,   ///<厂商海康 hik
    
}MBL_DEVICE_PROVIDER;
@interface DSSBaseDeviceInfo : DSSBaseInfo

@property (nonatomic, copy) NSString* deviceid;  ///< 设备id deviceid
@property (nonatomic, copy) NSString* name;   ///< 名称 name
@property (nonatomic, copy) NSString* parentid;///<父节点 parentid
@property (nonatomic, assign) MBL_DEVICE_TYPE devicetype; ///< 设备类型 device type
@property (nonatomic, assign) BOOL isOnline; ///<在线状态 isOnline
@property (nonatomic, assign) MBL_DEVICE_PROVIDER deviceProvide;  ///<设备厂商 device Provide
@property (nonatomic, assign) int nDevRight; ///<MBL_CHNL_RIGHT device right
@property (nonatomic, strong) NSMutableArray<NSString*> *units;///<单元子系统 child units
@property (nonatomic, strong) DHThreadSafeMultableArray<NSString*> *channels;  ///< 子节点 child /Users/caidong/Documents/SVNCode/DSS_New/P_2018.06.13_DSS_B_IPadClient_ChangeSwift/Depend/Depend_Common/DataAdapterProtocol/DataAdapterProtocol/Device/DSSDeviceInfo.hchannles

@property (nonatomic, copy) NSString *ip;       // IP
@property (nonatomic, assign) int port;         // port
@property (nonatomic, copy) NSString *devIp;    // 设备真实IP
@property (nonatomic, assign) int devPort;      // 设备真实port
@property (nonatomic, copy) NSString *userName; // 设备web登陆用户名
@property (nonatomic, copy) NSString *password; // 设备web登陆密码

@end

//alarmhost deviceInfo
@interface DSSAlarmHostDeviceInfo : DSSBaseInfo

@property (nonatomic, assign) MBL_ALARMHOST_STATUS_DEV alarmhostDevStatus;  ///< 报警主机状态类型 alarmhost status
// is alarmhost device
+ (BOOL) isAlarmHostDeviceType:(MBL_DEVICE_TYPE)devType;

@end

//videoTalk deviceInfo
@interface DSSVideoTalkDeviceInfo : DSSBaseInfo

@property (nonatomic, copy) NSString *callNum;  ///< 门口机号码 videoTalk callNum
// is videoTalk device
+ (BOOL)isVideoTalkDeviceType:(MBL_DEVICE_TYPE)devType;

@end
// deviceInfo
@interface DSSDeviceInfo : DSSBaseDeviceInfo

@property (nonatomic, strong) DSSAlarmHostDeviceInfo* alarmhostDeviceInfo;  ///< 报警主机信息 alarmhost deviceinfo
@property (nonatomic, strong) DSSVideoTalkDeviceInfo* videoTalkDeviceInfo;  ///< 门口机信息 videotalk deviceinfo
+ (BOOL)isGetChannelStatusByDevType:(MBL_DEVICE_TYPE)devType;

@end


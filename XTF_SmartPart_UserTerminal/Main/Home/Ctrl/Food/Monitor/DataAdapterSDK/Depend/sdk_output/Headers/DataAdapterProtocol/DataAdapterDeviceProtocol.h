//
//  DataAdapterDeviceProtocol.h
//  Pods
//
//  Created by zyx on 17/2/21.
//
//

#import <Foundation/Foundation.h>
#import "DSSGroupInfo.h"
#import "DSSDeviceInfo.h"
#import "DSSChannelInfo.h"
#import "DSSUserInfo.h"
#import "DSSEMapUIDataModel.h"
#import "DataAdapterRemoteNotifyProtocol.h"
#import "DataAdapterCoreProtocol.h"
#import "DSSMediaVKInfo.h"
/**
 *  需要实现的基本协议
 *  need implement protocol
 */
@protocol DataAdapterDeviceProtocol<NSObject>


/**
 登录成功之后需要调用的函数
 invoke after login

 @param userInfo userInfo
 */
#pragma mark--register function to IDHModuleProtocol
- (void)afterLoginInExcute:(DSSUserInfo *)userInfo;



/**
 登出成功之后需要调用的函数
 invoke after logout

 @param userInfo userInfo
 */
#pragma mark--register function to IDHModuleProtocol
- (void)afterLoginOutExcute:(DSSUserInfo *)userInfo;

/**
 设置web平台端口
 set web ip地址
 
 @param ip strIp
 */
#pragma mark--register function to IDHModuleProtocol
- (void)setHost:(NSString *)host;

/**
 设置web平台端口
 set web port

 @param port port
 */
#pragma mark--register function to IDHModuleProtocol
- (void)setPort:(int)port;

/**
 设置通知回调
 set remoteNotify block

 @param remoteNotifyBlock block
 */
#pragma mark--register function to IDHModuleProtocol
- (void)setRemoteNotifyBlock:(void (^)(ADAPTER_NOTIFY_ACTION, id))remoteNotifyBlock;

/**
 获取所有组织信息
 get all groupInfo
 
 @param block 每加载完一个组织，会执行block; execute block after load a group
 @param error error
 @return root groupInfo
 */
#pragma mark--register function to IDHModuleProtocol
- (DSSGroupInfo *)getRootGroupWithGroupBlock:(BOOL (^)(DSSGroupInfo *groupInfo))block error:(NSError**)error;

/**
 加载设备信息
 load devices
 
 @param devices 设备id数组; deviceId arry
 @param deviceBlock 加载完所有设备执行block; execute block after load all devices
 @param channelBlock 加载完一个设备的所有的通道，执行block; execute block after load a device
 @return
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)getDevices:(NSMutableArray *)devices withDeviceBlock:(BOOL (^)(NSArray *deviceInfosArray))deviceBlock channelBlock:(BOOL (^)(NSArray *channelInfosArray))channelBlock;

#pragma mark--register function to IDHModuleProtocol
- (BOOL)getDevices:(NSMutableArray *)devices fromGroup:(NSString *)groupId withDeviceBlock:(BOOL (^)(NSArray *deviceInfosArray))deviceBlock channelBlock:(BOOL (^)(NSArray *channelInfosArray))channelBlock;
/**
 是否逻辑树
 is logic tree
 
 @return
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)isLogicTree;

/**
 根据通道id获取设备id
 get deviceId from channelId
 
 @param channelId channelId
 @return deviceId
 */
#pragma mark--register function to IDHModuleProtocol
- (NSString *)getDeviceIdFromChannelId:(NSString *)channelId;

/**
 查询nvr等设备的通道状态
 query NVR channel status
 
 @param ocDeviceInfo deviceInfo
 */
#pragma mark--register function to IDHModuleProtocol
- (void)queryChannelStates:(DSSDeviceInfo *)ocDeviceInfo;

#pragma mark - 地图webservice
/**
 搜索通道信息（webservice）
 search channelInfo
 
 @param name name
 @param error error
 @return channel array
 */
#pragma mark--register function to IDHModuleProtocol
- (NSArray<NSString *> *)requestChInfowithChName:(NSString *)name error:(NSError **)error;
/**
 根据位置查询通道信息
 request all gis channels
 
 @param locationDic json串
 @param error error
 @return channelInfo array
 */
#pragma mark--register function to IDHModuleProtocol
- (NSArray *)requestAllGisChannels:(NSDictionary *)locationDic error:(NSError **)error;

/**
 查询地图类型
 request map type
 
 @param error error
 @return map type
 */
#pragma mark--register function to IDHModuleProtocol
- (NSString *)requestGisMapType:(NSError **)error;

/**
 查询通道地图信息
 request Gis channel
 
 @param channelId channelId
 @param error error
 @return
 */
#pragma mark--register function to IDHModuleProtocol
- (NSDictionary *)requestGisChannel:(NSString *)channelId error:(NSError **)error;

/**
 查询gps信息
 request GPS info
 
 @param deviceId 设备id deviceId
 @param startTime 开始时间 start time
 @param endTime 结束时间 end time
 @param interval interval
 @param error error
 @return
 */
#pragma mark--register function to IDHModuleProtocol
- (NSDictionary *)requestGpsInfoByDeviceId:(NSString *)deviceId startTime:(NSDate *)startTime endTime:(NSDate *)endTime interval:(NSString *)interval error:(NSError **)error;

/**
 查询bitmap信息
 request BitMapInfos
 
 @param error error
 @return
 */
#pragma mark--register function to IDHModuleProtocol
- (NSArray *)requestBitMapInfos:(NSError **)error;

#pragma mark - ptz
/**
 query Ptz prePoint
 
 @param channelid channelId
 @param error error
 @return prePointInfo array
 */
#pragma mark--register function to IDHModuleProtocol
- (NSArray<DSSPtzPrePointInfo *> *)queryPtzPrePoint:(NSString *)channelid error:(NSError **)error;

/**
 prePoint location
 
 @param channelid channelId
 @param prepointcode prepointcode
 @param error error
 @return
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)ptz:(NSString *)channelid location:(int)prepointcode error:(NSError **)error;
/**
 prePoint add
 
 @param channelid channelId
 @param prepointcode prepointcode
 @param name name
 @param error error
 @return
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)ptz:(NSString *)channelid add:(int)prepointcode name:(NSString *)name error:(NSError **)error;
/**
 prePoint delete
 
 @param channelid channelId
 @param prepointcode prepointcode
 @param error error
 @return
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)ptz:(NSString *)channelid delete:(int)prepointcode error:(NSError **)error;

/**
 ptz operation
 
 @param channelid channelId
 @param direction direction
 @param steplength step length
 @param bTry2Stop isStop
 @param error error
 @return
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)ptz:(NSString *)channelid direction:(MBL_PTZ_DIRECTION_GO)direction step:(int)steplength stop:(BOOL)bTry2Stop error:(NSError **)error;
/**
 zoom\foucus\aperture
 
 @param channelid channelId
 @param operation MBL_PTZ_OPERATION
 @param steplength step length
 @param bTry2Stop isStop
 @param error error
 @return
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)ptz:(NSString *)channelid operation:(MBL_PTZ_OPERATION)operation step:(int)steplength stop:(BOOL)bTry2Stop error:(NSError **)error;

/**
 获取设备当前的VKInfo
 
 @param  deviceId 设备编号
 @param  error error
 
 @return DSSMediaVKInfo
 */
#pragma mark--register function to IDHModuleProtocol
- (DSSMediaVKInfo *)queryCurrentMediaVKByDeviceId:(NSString *)deviceId error:(NSError **)error;



/**
 获取设备一段时间的VKInfo的数组
 
 @param  deviceId 设备编号
 @param  startTime 开始时间
 @param  endTime 结束时间
 @param  error error
 
 @return NSArray<DSSMediaVKInfo *>
 */
#pragma mark--register function to IDHModuleProtocol
- (NSString *)queryMediaVKByDeviceId:(NSString *)deviceId startTime:(NSDate *)startTime endTime:(NSDate *)endTime error:(NSError **)error;


@optional
/**

 deal receive message

 @param strReceiveMsg message
 */
#pragma mark--register function to IDHModuleProtocol
- (void)dealWithMessageResult:(NSString *)strReceiveMsg;

/**
 MQ notity parse deviceInfo
 
 @param dict MQ message
 @param deviceBlock execute block after load all devices
 @param channelBlock execute block after load a device
 @return
 */
#pragma mark--register function to IDHModuleProtocol
- (BOOL)getMQDevices:(NSDictionary *)dict withDeviceBlock:(BOOL (^)(NSArray *))deviceBlock channelBlock:(BOOL (^)(NSArray *))channelBlock;

/**
 获取设备callNumber
 @param deviceInfo 设备信息
 */
#pragma mark--register function to IDHModuleProtocol
- (void)getDeviceCallNumbers:(DSSDeviceInfo *)deviceInfo;

#pragma mark--register function to IDHModuleProtocol
- (NSDictionary *)queryAccessDoorStatus:(NSArray *)channelArray error:(NSError**)error;

- (void)clearUp;
@end


//
//  DHDeviceManager.h
//  DataAdapterExample_Example
//
//  Created by 32943 on 2018/1/31.
//  Copyright © 2018年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSSGroupInfo.h"
#import "DSSDeviceInfo.h"
#import "DSSChannelInfo.h"
#import "DSSUserInfo.h"

typedef NS_ENUM(NSInteger, TREENODE_TYPE) {
    TREENODE_TYPE_GROUP,  //组织 group
    TREENODE_TYPE_DEVICE, //设备 device
    TREENODE_TYPE_CHANNEL //通道 channel
};

@interface TreeNode : NSObject
@property (nonatomic, assign) TREENODE_TYPE nodeType; //节点类型
@property (nonatomic, assign) id content;             //数据
@property (nonatomic, assign) BOOL needHidden;        //是否隐藏
@end

@interface DHDeviceManager : NSObject
@property (nonatomic, strong) TreeNode *parentGroupNode; //根节点 root GroupNode
@property (nonatomic, strong) NSMutableDictionary<NSString *, TreeNode *> *treeNodeDic; //节点字典 nodes map
@property (nonatomic, assign) BOOL isShowDevice; //是否显示设备 isShowDevice

+ (DHDeviceManager *)sharedInstance;

+ (void)unSharedInstance;
/**
 登录成功之后需要调用的函数
 invoke after login
 
 @param userInfo userInfo
 */

- (void)afterLoginInExcute:(DSSUserInfo *)userInfo;



/**
 登出成功之后需要调用的函数
 invoke after logout
 
 @param userInfo userInfo
 */

- (void)afterLoginOutExcute:(DSSUserInfo *)userInfo;


/**
 加载设备树
 load deviceTree

 @param error error
 @return root node 根节点信息
 */
- (TreeNode *)loadDeviceTree:(NSError**)error;

/**
 获取组织信息
 get groupinfo

 @param groupId 组织id
 @return groupinfo 组织信息
 */
- (DSSGroupInfo *)getGroupInfo:(NSString *)groupId;

/**
 获取设备信息
 get deviceinfo

 @param deviceId 设备id
 @return deviceinfo 设备信息
 */
- (DSSDeviceInfo *)getDeviceInfo:(NSString *)deviceId;

/**
 获取通道信息
 get channelinfo
 
 @param channelId 通道id
 @return channelinfo 通道信息
 */
- (DSSChannelInfo *)getChannelInfo:(NSString *)channelId;

/**
 根据电话号码获取设备信息
 get deviceinfo by Number

 @param callNum 号码
 @return deviceinfo 设备信息
 */
- (DSSDeviceInfo *)getDeviceInfoByCallNum:(NSString *)callNum;

/**
 操作云台方向
 
 @param channelid 通道id
 @param direction 方向
 @param steplength 步长
 @param bTry2Stop 是否停止
 @param error error
 @return
 */
- (BOOL)ptz:(NSString *)channelid direction:(MBL_PTZ_DIRECTION_GO)direction step:(int)steplength stop:(BOOL)bTry2Stop error:(NSError **)error;
/**
 云台操作变倍、变焦、光圈
 ptz operation:zoom,foucus,aperture
 
 @param channelid 通道id
 @param operation 变倍、变焦、光圈
 @param steplength 步长
 @param bTry2Stop 是否停止
 @param error error
 @return
 */
- (BOOL)ptz:(NSString *)channelid operation:(MBL_PTZ_OPERATION)operation step:(int)steplength stop:(BOOL)bTry2Stop error:(NSError **)error;
/**
 查询云台预置点信息
 query prepoint
 
 @param channelid 通道id
 @param error error
 @return 预置点信息
 */
- (NSArray<DSSPtzPrePointInfo *> *)queryPtzPrePoint:(NSString *)channelid error:(NSError **)error;
/**
 预置点定位
 location prepoint
 
 @param channelid 通道id
 @param prepointcode 预置点
 @param error error
 @return
 */
- (BOOL)ptz:(NSString *)channelid location:(int)prepointcode error:(NSError **)error;

@end

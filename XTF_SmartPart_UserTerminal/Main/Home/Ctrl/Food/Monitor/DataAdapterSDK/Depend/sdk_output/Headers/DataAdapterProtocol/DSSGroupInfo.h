//
//  GroupInfo.h
//  Pods
//
//  Created by zyx on 17/2/21.
//
//

#import <Foundation/Foundation.h>
#import "DSSBaseInfo.h"
#import "DHThreadSafeMultableArray.h"

// groupInfo
@interface DSSGroupInfo : DSSBaseInfo

@property (nonatomic, copy) NSString* groupid;  ///< 组织id groupId
@property (nonatomic, copy) NSString* name;     ///< 名称 name
@property (nonatomic, copy) NSString* parentid;      ///<父节点 parentId
@property (nonatomic, strong) DHThreadSafeMultableArray<NSString*> *childgroups;  ///< 子组织 child groups
@property (nonatomic, strong) DHThreadSafeMultableArray<NSString*> *devices;     ///< 子设备 child devices
@property (nonatomic, strong) DHThreadSafeMultableArray<NSString*> *channels;    ///< 子通道 child channels
@property (nonatomic, assign) NSTimeInterval createTime; ///< create time

@end

// extend property
extern NSString *const isDeviceLoaded; ///< is child devices loaded
extern NSString *const isChannelLoaded; ///< is child channels loaded

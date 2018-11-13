//
//  RecordInfo.h
//  Pods
//
//  Created by zyx on 17/2/27.
//
//

#import <Foundation/Foundation.h>
#import "DSSBaseInfo.h"


///录像来源 Record source
typedef NS_ENUM(NSUInteger, RecordSource){
    RecordSource_all,///<所有录像 All
    RecordSource_platform,///< 云录像 Platform
    RecordSource_device,///< 设备录像 Device
};

/// 录像类型 Record type
typedef NS_ENUM(NSUInteger, MBL_RECORD_TYPE) {
    MBL_RECORD_TYPE_UNKONWN			= 0,							///< 全部录像    All Record
    MBL_RECORD_TYPE_MANUAL			= 1,							///< 手动录像    Manual Record
    MBL_RECORD_TYPE_ALARM			= 2,							///< 报警录像    Alarm Record
    MBL_RECORD_TYPE_MOTION_DETECT	= 3,							///< 移动侦测    Motion Detect
    MBL_RECORD_TYPE_VIDEO_LOST		= 4,							///< 视频丢失    Video Lost
    MBL_RECORD_TYPE_VIDEO_SHELTER	= 5,							///< 视频遮挡    Video Shelter
    MBL_RECORD_TYPE_TIMER			= 6,							///< 定时录像    Timer Record
    MBL_RECORD_TYPE_ALL_DAY			= 7,							///< 全天录像    All Day Record
};

@interface DSSBaseRecordInfo : DSSBaseInfo

@property (nonatomic, copy) NSString* channelid;                ///< 通道id channelid
@property (nonatomic, copy) NSString* name;                     ///< 名称 name
@property (nonatomic, assign) RecordSource source;              ///< 录像源 Record Source
@property (nonatomic, assign) MBL_RECORD_TYPE recordType;       ///< 录像类型 Record Type
@property (nonatomic, assign) NSTimeInterval startTime;         ///< 开始时间 start time
@property (nonatomic, assign) NSTimeInterval endTime;           ///< 结束时间 end time
@property (nonatomic, assign) int length;                       ///< 长度 length
@property (nonatomic) int streamType;                           ///< 码流类型 Stream type

@end

//录像扩展信息 Record extend info
@interface DSSRecordExtendInfo : DSSBaseInfo

@property (nonatomic, copy) NSString* diskId;   ///< 磁盘id      diskId
@property (nonatomic, assign) int planId;       ///< 录像计划id   planId
@property (nonatomic, assign) int fileHandle;   ///< 文件句柄    fileHandle
@property (nonatomic, assign) int ssId;         ///< 存储服务ID   ssId

@end

@interface DSSRecordInfo : DSSBaseRecordInfo

@property (nonatomic, strong) DSSRecordExtendInfo* dssExtendRecordInfo; ///<dss录像扩展信息
@end

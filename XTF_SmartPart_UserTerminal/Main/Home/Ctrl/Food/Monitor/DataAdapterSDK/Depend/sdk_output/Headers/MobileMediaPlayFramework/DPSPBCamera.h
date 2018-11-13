//
//  DPSPBCamera.h
//  PlayerComponent
//
//  Created by ding_qili on 16/4/11.
//  Copyright © 2016年 ding_qili. All rights reserved.
//

#import "OCCamera.h"

//dps Video playback parameters
@interface DPSPBCameraArg : NSObject

@property NSString * fileName; // filename
@property double  filelen; // file length
@property uint32_t ssId;//Storage service ID
@property uint64_t fileHander;//file handler
@property NSString * diskId;//disk id
@property NSDate * startTime; // start time
@property NSDate * endTime; // end time
@property int recordSource;//1-all 2-device record 3-platform record

@end


@interface DPSPBCamera : Camera

// playback parameters
@property (copy,nonatomic) NSArray<DPSPBCameraArg*> *arrayCameraArg;

// channdel id
@property NSString * cameraId;

// device record Played by time, platform record Played by file
@property BOOL isPlayBackByTime;

// Specify the time to start playback, timeIntervalSince1970
@property (nonatomic) long needBeginTime;

// support backward
@property (nonatomic) BOOL needBack;

// stream type: 1 main stream, 2 sub stream, 3 third stream
@property (assign, nonatomic) int           streamType;

// handle of DPSDK
@property (assign, nonatomic) int64_t           dpHandle;

// token of DSS rest api
@property (copy, nonatomic) NSString* dpRestToken;

// host
@property (copy, nonatomic) NSString* server_ip;

// port
@property (assign, nonatomic) int server_port;

// is cloud
@property (nonatomic,assign) BOOL  isCloudBase;

@property (nonatomic,assign) BOOL  isEncrypt;

@property (copy, nonatomic) NSString* passwordKey;

@end

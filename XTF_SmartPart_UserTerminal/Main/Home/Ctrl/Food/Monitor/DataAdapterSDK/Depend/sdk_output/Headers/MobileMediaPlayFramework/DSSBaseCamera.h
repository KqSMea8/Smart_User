//
//  DSSBaseCamera.h
//  PlayerComponent
//
//  Created by xiayuguo on 14/12/5.
//  Copyright (c) 2014年 xyg. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "OCCamera.h"


@interface DSSBaseCamera : Camera
/**
 * handle of DPSDK
 */
@property (assign, nonatomic) long           dpHandle;
/**
 * token of DSS rest api
 */
@property (copy, nonatomic) NSString* dpRestToken;

@property (copy, nonatomic) NSString* server_ip;
@property (assign, nonatomic) int server_port;

/**
 * ID of camera. get this value from platform
 */
@property (copy, nonatomic) NSString*      cameraID;

/**
 * stream type
 * streamType 					1主码流，2子码流，3三码流
 */
@property (assign, nonatomic) int           streamType;

/**
 * whether check permission
 */
@property (assign, nonatomic) bool          isCheckPermission;

@property (nonatomic,copy) NSString *deviceID;

@property (assign, nonatomic) bool          isEncrypt;

@property (nonatomic,copy) NSString *passwordKey;

@end

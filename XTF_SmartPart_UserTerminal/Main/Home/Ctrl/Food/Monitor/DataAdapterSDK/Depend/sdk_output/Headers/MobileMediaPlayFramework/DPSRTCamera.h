//
//  DPSRTCamera.h
//  PlayerComponent
//
//  Created by ding_qili on 16/3/24.
//  Copyright © 2016年 ding_qili. All rights reserved.
//

#import "DSSBaseCamera.h"


typedef NS_ENUM(NSInteger, DPSRTCameraPlayResult) {
    faild = 100,
};

@interface DPSRTCamera : DSSBaseCamera

/**
 * media type of stream. 1.video 2.audio 3.video and audio
 */
@property (assign, nonatomic) int     mediaType;

// is cloud
@property (nonatomic,assign) BOOL     bCloudBase;

@end

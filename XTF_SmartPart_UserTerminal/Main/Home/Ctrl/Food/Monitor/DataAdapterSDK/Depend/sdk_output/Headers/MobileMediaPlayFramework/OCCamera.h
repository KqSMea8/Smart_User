//
//  DataSourceDescription.h
//  PlayerComponent
//
//  Created by zhangwei on 14-4-24.
//  Copyright (c) 2014年 zhangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Camera : NSObject
    /**
     * whether use minimized memory
     */
    @property (assign, nonatomic) bool       useMiniMemory;
    @property (strong, nonatomic) NSString*  dataSavePath;

@end

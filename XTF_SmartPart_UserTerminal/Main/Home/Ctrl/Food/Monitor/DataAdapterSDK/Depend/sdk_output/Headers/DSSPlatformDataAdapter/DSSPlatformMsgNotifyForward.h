//
//  DSSPlatformMsgNotifyForward.h
//  Pods
//
//  Created by chenfeifei on 2017/9/20.
//
//

#import <Foundation/Foundation.h>
@protocol NotifyForwardProtocol<NSObject>

@required
- (void)notifyForward:(void *)cbMsg;

@end

@interface DSSPlatformMsgNotifyForward : NSObject

@property (nonatomic, weak, nullable) id <NotifyForwardProtocol> notifyDelegate;

- (void)addNotifyMsg:(void *)cbMsg;
    
- (void)stopForwardThread;




@end

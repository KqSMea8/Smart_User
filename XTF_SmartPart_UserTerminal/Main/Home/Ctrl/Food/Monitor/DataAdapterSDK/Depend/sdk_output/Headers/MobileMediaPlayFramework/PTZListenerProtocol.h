//
//  PTZListenerProtocol.h
//  Pods
//
//  Created by zyx on 17/3/21.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,PtzOperation) {
    ePTZCtrl_Begin               = 0x01 << 0,
    ePTZCtrl_End                 = 0x01 << 1,
    
    ePTZCtrl_ZoomIn              = 0x01 << 2,    ///< 缩小
    ePTZCtrl_ZoomOut             = 0x01 << 3,    ///< 放大
    
    ePTZCtrl_DirectionLeft       = 0x01 << 4,	///< 左
    ePTZCtrl_DirectionRight      = 0x01 << 5,	///< 右
    ePTZCtrl_DirectionUp         = 0x01 << 6,	///< 上
    ePTZCtrl_DirectionDown       = 0x01 << 7,	///< 下
    ePTZCtrl_DirectionLeftup     = 0x01 << 8,	///< 左上
    ePTZCtrl_DirectionRightup    = 0x01 << 9,	///< 右上
    ePTZCtrl_DirectionLeftdown   = 0x01 << 10,	///< 左下
    ePTZCtrl_DirectionRightdown  = 0x01 << 11,	///< 右下
};


@protocol PTZListenerProtocol <NSObject>


/**
 PTZ Control

 @param winIndex       window index
 @param ptzType        @see PtzOperation
 @param isLongPress    isLongPress
 */
-(void)onPTZControl:(int)winIndex type:(PtzOperation)ptzType longPress:(BOOL)isLongPress;

@end

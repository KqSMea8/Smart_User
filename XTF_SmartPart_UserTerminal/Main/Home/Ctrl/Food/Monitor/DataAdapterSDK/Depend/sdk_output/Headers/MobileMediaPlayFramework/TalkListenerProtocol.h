//
//  TalkListenerProtocol.h
//  Pods
//
//  Created by zyx on 17/3/21.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TalkResultType) {
    eTalkFailed,	// Failed
    eTalkSuccess,	// Success
    eTalkAudioSessionId,    // 可视对讲音频会话Id
    eTalkAudioPort,    // 可视对讲音频端口
    eTalkVideoSessionId,    // 可视对讲视频会话Id
    eTalkVideoPort,    // 可视对讲视频端口
    
};

@protocol TalkListenerProtocol <NSObject>

/**
 Talk result

 @param winIndex      window index
 @param talkResult    @see TalkResultType
 */
-(void)onTalkResult:(int)winIndex result:(TalkResultType)talkResult;

@optional
-(void)onSipTalkResult:(int)winIndex talkResultType:(TalkResultType)talkResultType data:(NSString *)data;

@end

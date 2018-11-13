//
//  DHPlayWindow.h
//  Pods
//
//  Created by zyx on 17/3/21.
//
//

#import <UIKit/UIKit.h>
#import "MediaPlayListenerProtocol.h"
#import "WindowOperationListenerProtocol.h"
#import "PTZListenerProtocol.h"
#import "TalkListenerProtocol.h"

//capture file type
typedef NS_ENUM(NSUInteger, MEDIA_CAPTURE_TYPE) {
    MEDIA_CAPTURE_TYPE_RECORD = 1,     // record
    MEDIA_CAPTURE_TYPE_SNAP = 2,	   // capture
};

/**
 jump to local file when clicked

 @param capturepath: file path
 @param captureType: file type
 */
typedef void (^CaptureClickBlock)(NSString *capturepath,MEDIA_CAPTURE_TYPE captureType);

@class OCCamera, Camera, DSSSIPTalkCamera, DSSRTPSIPTalkCamera;
@protocol MediaPlayListenerProtocol, WindowOperationListenerProtocol, PTZListenerProtocol, TalkListenerProtocol;

@interface DHPlayWindow : UIView

/**
 Whether to hide the toolbar
 */
@property (nonatomic, assign) BOOL hideDefultToolViews;

/**
 Whether to hide the top toolbar
 */
@property (nonatomic, assign) BOOL hidebgviewTop;

/**
 Whether to hide the bottom toolbar
 */
@property (nonatomic, assign) BOOL hidebgviewBottom;

/**
 Whether to hide the progress bar
 */
@property (nonatomic, assign) BOOL hidebgviewTimeProgress;

/**
 Whether to hide PTZ
 */
@property (nonatomic, assign) BOOL hidebtnPtz;

/**
 Whether to hide PageIndicator
 */
@property (nonatomic, assign) BOOL hidebgviewPageIndicator;

/**
 Whether to hide the toolbar when touch
 */
@property (nonatomic, assign) BOOL needTouchToHideDefultToolViews;

/**
 Whether to hide the talk button
 */
@property (nonatomic, assign) BOOL hidePlayWindowTalkBtn;

/**
 set CaptureClickBlock
 
 @param captureClickBlock: Click to jump to local file
 */
- (void)showCaptureView:(CaptureClickBlock)captureClickBlock;


/**
 set setCaptureViewframe
 
 @param
 */
- (void)setCaptureViewBottom:(CGFloat)offset;

/**
 Get the path of the capture or record
 
 @param host
 @param port
 @param userName
 @return: the path of the capture or record
 */
+(NSString*) getMediaFolderByHost:(NSString*)host Port:(int)port UserName:(NSString*)userName;

/**
 parameter settings
 
 @param host
 @param port
 @param userName
 */
-(void) setHost:(NSString*)host Port:(int)port UserName:(NSString*)userName;


#pragma mark- listener

/**
 Add listener for play status
 
 @param mediaPlayListener: listener
 */
-(void) addMediaPlayListener:(id<MediaPlayListenerProtocol>)mediaPlayListener;

/**
 Remove listener for play status
 
 @param mediaPlayListener: listener
 */
-(void) removeMediaPlayListener:(id<MediaPlayListenerProtocol>)mediaPlayListener;

/**
 Add listener for PTZ control
 
 @param ptzListener : listener
 */
-(void) addPTZListener:(id<PTZListenerProtocol>)ptzListener;

/**
 Remove listener for PTZ control
 
 @param ptzListener 监听者
 */
-(void) removePTZListener:(id<PTZListenerProtocol>)ptzListener;

/**
 Add listener for talk status
 
 @param talkListener 监听者
 */
-(void) addTalkListener:(id<TalkListenerProtocol>)talkListener;

/**
 Remove listener for talk status
 
 @param talkListener 监听者
 */
-(void) removeTalkListener:(id<TalkListenerProtocol>)talkListener;

/**
 Add listener for window touch
 
 @param windowOperationListener : listener
 */
-(void) addWindowOperationListener:(id<WindowOperationListenerProtocol>)windowOperationListener;

/**
 Remove listener for window touch
 
 @param windowOperationListener : listener
 */
-(void) removeWindowOperationListener:(id<WindowOperationListenerProtocol>)windowOperationListener;


#pragma mark - play

/**
 *
 *  Set the number of windows per page
 *
 *  @param count: number of windows
 */
-(void) defultwindows:(int)count;

/**
 Set parameters, play in the specified window
 
 @param camera : Play related parameters
 @param name : Channel name
 @param winIndex : Window index
 @param provide : device provider
 @return:  Success:0 Failed:-1
 */
-(int) playCamera:(Camera*)camera withName:(NSString*)name at:(int)winIndex deviceProvide:(int)provide;

/**
 Set parameters and play in the first window that is not in play status
 
 @param camera : Play related parameters
 @param name : Channel name
 @param winIndex : Window index
 @param provide : device provider
 @return:  Success:0 Failed:-1
 */
-(int) playCamera:(Camera *)camera withName:(NSString*)name deviceProvide:(int)provide;

/**
 Play
 
 @param winIndex : Window index
 @return: Success:0 Failed:-1
 */
-(int) play:(int)winIndex;

- (int) setKey:(NSString *)passwordkey winIndex:(int)winIndex;

/**
 stop
 
 @param winIndex Window index
 @return : Success:0 Failed:-1
 */
-(int) stop:(int)winIndex;

/**
 Stop playing all windows
 
 @return : Success:0 Failed:-1
 */
-(int) stopAll;

/**
 Pause
 
 @param winIndex Window index
 @return : Success:0 Failed:-1
 */
-(int) pause:(int)winIndex;

/**
 Resume
 
 @param winIndex Window index
 @return : Success:0 Failed:-1
 */
-(int) resume:(int)winIndex;

/**
 Stop and restores window display to initial state
 
 @param winIndex: Window index
 @return : Success:0 Failed:-1
 */
-(int) resumePlay:(int)winIndex;

/**
 Playback from the specified time
 
 @param winIndex: Window index
 @param seekTime: timeIntervalSince1970
 @return : Success:0 Failed:-1
 */
-(int) seek:(int)winIndex byTime:(long)seekTime;

/**
 Set fast play speed level
 
 @param winIndex: Window index
 @param level: Speed level: 0 1 2 3 . 0 is the normal speed. The higher the number, the faster
 @return: Success:0 Failed:-1
 */
-(int) fastPlay:(int)winIndex level:(int)level;

/**
 Set slow play speed level
 
 @param winIndex: Window index
 @param level: Speed level: 0 1 2 3 . 0 is the normal speed. The higher the number, the slower
 @return: Success:0 Failed:-1
 */
-(int) slowPlay:(int)winIndex level:(int)level;

/**
 Set speed multiple
 
 @param winIndex : Window index
 @param speed : Speed 1/8 1/4 1/2 1 2 4 8
 @return: Success:0 Failed:-1
 */
- (int)setPlaySpeed:(float)speed atWinIndex:(int)winIndex;

/**
 Open audio
 
 @param winIndex : Window index
 @return: Success:0 Failed:-1
 */
-(int) openAudio:(int)winIndex;

/**
 Close audio
 
 @param winIndex : Window index
 @return: Success:0 Failed:-1
 */
-(int) closeAudio:(int)winIndex;

/**
 Open talk
 
 @param winIndex : Window index
 @return: Success:0 Failed:-1
 */
-(int) startTalk:(int)winIndex;

/**
 Close talk
 
 @param winIndex : Window index
 @return: Success:0 Failed:-1
 */
-(int) stopTalk:(int)winIndex;

/**
 Open Rtsp talk with Current token
 
 @param token : current token
 @param winIndex : Window index
 @return: Success:0 Failed:-1
 */
-(int) startRtspTalkWithCurrentToken:(NSString *)token winIndex:(int)winIndex;

/**
 Start SipTalk

 @param camera : Play related parameters
 @param winIndex : Window index
 @return : Success:0 Failed:-1
 */
- (int)startSipTalkWithCamera:(DSSSIPTalkCamera *)camera atIndex:(int)winIndex;


/**
 Start Rtp SipTalk

 @param camera : Play related parameters
 @param winIndex : Window index
 @return : Success:0 Failed:-1
 */
- (int)startRtpSipTalkWithCamera:(DSSRTPSIPTalkCamera *)camera atIndex:(int)winIndex;


/**
 Stop SipTalk

 @param winIndex : Window index
 @return: Success:0 Failed:-1
 */
- (int)stopSipTalk:(int)winIndex;

/**
 Start sipTalk audio capture

 @param winIndex : Window index
 @return: Success:0 Failed:-1
 */
- (int)startSipTalkSampleAudio:(int)winIndex;

/**
 Stop sipTalk audio capture
 
 @param winIndex : Window index
 @return: Success:0 Failed:-1
 */
- (int)stopSipTalkSampleAudio:(int)winIndex;

/**
 Get sipTalk callback function address

 @return: Callback function address
 */
- (long)getSipTalkCallBack;

/**
 Start record
 
 @param winIndex : Window index
 @return: Success:0 Failed:-1
 */
-(NSString *) startRecord:(int)winIndex;

/**
 Stop record
 
 @param winIndex : Window index
 @return: Success:0 Failed:-1
 */
-(int) stopRecord:(int)winIndex;


/**
 Set IVS information.
 Need to be called after calling function :-(int) playCamera:(Camera*)camera withName:(NSString*)name at:(int)winIndex deviceProvide:(int)provide;
 
 @param winIndex : Window index
 @param type: IVS information type: 0x01-pos 0x02-ivspc
 @param showInfo: Whether to display IVS information in playWindow
 */
-(void) setIvs:(int)winIndex type:(int)type showInfo:(BOOL)showInfo;

/**
 Snapshot
 
 @param winIndex : Window index
 @return @""
 */
-(NSString *) snapshot:(int)winIndex;

/**
 SnapshotOutOfPath
 
 @param winIndex : Window index
 @return UIImage
 */
-(UIImage *) snapshotOutOfPath:(int)winIndex;

/**
 Ptz control
 
 @param winIndex : Window index
 @param bEnable
 @return Success:0 Failed:-1
 */
-(int) setEnablePtz:(int)winIndex enable:(BOOL)bEnable;

/**
 Electronic amplification
 
 @param winIndex : Window index
 @param bEnable
 @return Success:0 Failed:-1
 */
-(int) setEnableElectricZoom:(int)winIndex enable:(BOOL)bEnable;

/**
 Whether the window enable touch
 
 @param bEnable
 @return Success:0 Failed:-1
 */
-(int) setEnableFreezeMode:(BOOL)bEnable;

/**
 Whether is playing status?
 
 @param winIndex : Window index
 @return YES/NO
 */
-(BOOL) isPlaying:(int)winIndex;

/**
 Whether is paused status?
 
 @param winIndex : Window index
 @return YES/NO
 */
-(BOOL) isPause:(int)winIndex;

/**
 Whether the PTZ control is on
 
 @param winIndex : Window index
 @return YES/NO
 */
-(BOOL) isPtzOpened:(int)winIndex;

/**
 Whether is recording
 
 @param winIndex : Window index
 @return YES/NO
 */
-(BOOL) isRecording:(int)winIndex;

/**
 Whether is talking.
 
 @param winIndex : Window index
 @return YES/NO
 */
-(BOOL) isTalking:(int)winIndex;

/**
 Whether audio is open.
 
 @param winIndex: Window index
 @return YES/NO
 */
-(BOOL) isAudioOpened:(int)winIndex;

/**
 Scale

 @param scale : Scale multiple
 @param index: Window index
 */
-(void) scale:(float)scale atIndex:(int)index;

/**
 Get Window scale multiple

 @param index : Window index
 @return: multiple
 */
-(float)getScale:(int)index;


#pragma mark-

/**
 Restore the status of the button in the toolbar.

 @param winIndex : Window index
 @param nBtnIndex : Button index
 @return YES/NO
 */
-(BOOL) stopToolbarBtnFlash:(int)winIndex BtnIndex:(int)nBtnIndex;

/**
 Set the UIPageControl total number of pages and the current page
 
 @param curPage : Current page
 @param totalPages : Number of pages
 */
-(void) updatePageIndicator:(int)curPage totalPage:(int)totalPages;

/**
 Hide the "+" button above all windows
 */
-(void)setOpenImageHidden;

/**
 Set the height of the toolbar
 
 @param height
 @param winIndex : Window index
 */
-(void) setToolBarHeight:(int)height winIndex:(int)winIndex;

/**
 Set whether the toolbar is show
 
 @param isShow : Whether to hide
 @param winIndex : Window index
 */
- (void)showPlayWindowToolBar:(BOOL)isShow windowIndex:(int)winIndex;

/**
 Maximize the specified window
 
 @param winIndex : Window index
 */
- (void) maximizeWindow:(int)winIndex;

- (BOOL) isWindowMaximized;

/**
 Switch to the page of the specified window
 
 @param winIndex : Window index
 */
- (void) switchToPage:(int)winIndex;

/**
 Select the specified window
 
 @param winIndex : Window index
 */
- (void)setCellSeleted:(int)winIndex;

/**
 Window reverts to default size
 
 @param winIndex : Window index
 */
- (void) resumeWindow:(int)winIndex;


#pragma mark-

/**
 Get the selected window index
 
 @return : Window index
 */
-(int) getSelectedWindowIndex;

/**
 
 @return: The number of windows in the current page, the window returns 1 in full screen
 */
-(int) getPageCellNumber;

/**
 
 @return: Return split type, such as 4 split
 */
-(int) getSplitNumber;

/**
 
 @return : The current page
 */
-(int) getCurrentPage;

/**
 
 @return : Total page count
 */
-(int) getPageCount;


/**
 
 @param index : Window index
 @return: Camera
 */
- (Camera*) getCamera:(int)index;

/**
 Get the window index according to the position of the window

 @param pos : The position of the window
 @return : Window index
 */
- (int)getIndexByWinPosition:(int)pos;

/**
 Get the window position according to the index of the window
 
 @param winIndex : The index of the window
 @return : Window position
 */
- (int)getWinPositionByIndex:(int)winIndex;


/**
 set auto append one page when all cell played, default is NO

 @param need YES or NO
 */
- (void)setNeedAutoAppendPage:(BOOL)need;


/**
 Sets the maximum number of Windows supported，default is 16

 @param count: max cell count
 */
- (void)setMaxCellCount:(int)count;

@end

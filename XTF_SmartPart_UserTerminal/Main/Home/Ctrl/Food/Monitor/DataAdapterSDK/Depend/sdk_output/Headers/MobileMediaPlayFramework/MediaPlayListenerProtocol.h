//
//  MediaPlayListenerProtocol.h
//  Pods
//
//  Created by zyx on 17/3/21.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,PlayStatusType) {
    ePlayFirstFrame = 1,// Get the first frame of data, and then display the playback screen
    ePlayEnd,			// End of video playback
    eNetworkaAbort,		// network anomaly
    ePlayFailed,		// Playback abnormality, check playback video data error
    eBadFile,			// Abnormal file, unsupported file format
    eSeekFailed,		// Drag and drop failure
    eSeekSuccess,		// Drag and drop success
    eSeekCrossBorder,	// Dragging across the border
    ePlayDataOver,      // End of play all files
    ePlayNoAuthority,   // No permission to play
    ePlayStatusMax,
};


@protocol MediaPlayListenerProtocol <NSObject>
@optional
/**
 * play status
 * @param winIndex    window index
 * @param status      PlayStatusType
 */
-(void) onPlayeStatusCallback:(int)winIndex status:(PlayStatusType)status;

/**
 * show bitrate
 * @param winIndex      window index
 * @param bitrate       bitrate
 */
-(void) onShowBitrate:(int)winIndex bitrate:(float)bitrate;

/**
 * playback time
 * @param time   absolute time
 * @param stamp  stamp time
 */
-(void) onPlayTime:(int)winIndex time:(long)time stamp:(int)stamp;

/**
 * local file play
 * @param winIndex      window index
 * @param startTime     startTime
 * @param endTime       EndTime
 */
-(void) onFileTime:(int)winIndex start:(long)startTime end:(long)endTime;

/**
 * get IVSPosData
 * @param winIndex     window index
 * @param osdText      osdText
 */
- (void) onIVSPosData:(int)index WithOsdText:(NSString*)osdText;

/**
 *	@brief	The original intelligent information pBuf in the stream is json format; see IvsDraw for parsing.
 *
 *	@param 	index: 	window index
 *  @return If return YES, pBuf will not continue to be sent to CellWindow. It will not parse drawing smart information on CellWindow.
 */
- (void) onIVSInfo:(int)winIndex buf:(char*) pBuf type:(long)lType len:(long)lLen realLen:(long) lReallen;

@end

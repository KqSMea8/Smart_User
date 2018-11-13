//
//  OperationListenerProtocol.h
//  Pods
//
//  Created by zyx on 17/3/21.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WinControlType) {
    eWinControl_Open,  //Click the icon on the window to select the channel
    //eWinControl_Reflash,   //Click the icon on the window to refresh window
    //eWinControl_Replay,     //Click the icon on the window to replay
};

@protocol WindowOperationListenerProtocol <NSObject>

@optional


/**
 Select the specified window

 @param winIndex
 */
-(void) onWindowSelected:(int)winIndex;

/**
 Switch pages

 @param newPage          destination page
 @param oldPage          last page
 @param totalPages       total number of pages
 @param type             0-change page, 1-maximum page, 2-resume page
 */
-(void) onPageChange:(int)newPage from:(int)oldPage totalPage:(int)totalPages type:(int)type;

/**
 Change split mode

 @param nCurCellNumber       current cell number of one page
 @param nCurPage             current page
 @param totalPages           total number of pages
 @param nOldCellNumber       last cell number of one page
 @param nOldPage             last page
 */
-(void) onSplitNumber:(int)nCurCellNumber ofPage:(int)nCurPage totalPage:(int)totalPages from:(int)nOldCellNumber ofPage:(int)nOldPage;

/**
 Click the icon on the window

 @param winIndex        window index
 @param controltype     0
 */
-(void) onControlClick:(int)winIndex type:(WinControlType)controltype;


/**
 Select cell window

 @param newWinIndex        destination window index
 @param oldWinIndex        last window index
 */
-(void) onSelectWinIndexChange:(int)newWinIndex from:(int)oldWinIndex;

/**
 Start move cell window

 @param winIndex :    window index
 */
- (void) onMoveWindowBegin:(int)winIndex;


/**
 Moving cell window

 @param winIndex       window index
 @param point          touch point
 */
- (void) onMovingWindow:(int)winIndex Point:(CGPoint)point;


/**
 End move cell window
 
 @param winIndex       window index
 @param point          touch point
 */
- (BOOL) onMoveWindowEnd:(int)winIndex Point:(CGPoint)point;

/**
 Exchange cell window

 @param moveWinIndex   last window index
 @param desWinIndex    destination window index
 */
- (void) onSwapCell:(int)moveWinIndex Des:(int)desWinIndex;

@end

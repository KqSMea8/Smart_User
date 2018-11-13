//
//  DHHudPrecess.h
//  iDMSS
//
//  Created by nobuts on 13-4-1.
//
//
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface DHHudPrecess : NSObject<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    MBProgressHUD *TipHUD;
}
+ (DHHudPrecess *) sharedInstance;
- (void) ShowTips:(NSString*)strTips  delayTime:(NSTimeInterval)delay  atView:(UIView*)pView withCenterPoint:(CGPoint)point;
- (void) ShowTips:(NSString*)strTips  delayTime:(NSTimeInterval)delay atView:(UIView*)pView;
- (void) showWaiting:(NSString*)strTips onTarget:(id)target withObject:(id)object animated:(BOOL)animated   atView:(UIView*)pView;
- (void) showWaiting:(NSString*)strTips WhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated  atView:(UIView*)pView;
- (void) showProgress:(NSString*)strTips WhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated  atView:(UIView*)pView;
- (void) updateProgress:(float)progress;
-(void) clearUp;

-(void) showWaiting:(NSString*)strTips;
@end

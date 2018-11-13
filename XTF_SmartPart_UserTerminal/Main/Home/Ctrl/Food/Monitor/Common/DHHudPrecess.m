//
//  DHHudPrecess.m
//  iDMSS
//
//  Created by nobuts on 13-4-1.
//
//
#import "DHHudPrecess.h"
#import <pthread.h>
static DHHudPrecess * __shareHudPrecess = nil;
@implementation DHHudPrecess
+ (DHHudPrecess *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shareHudPrecess = [[self alloc] init];
    });    
    return __shareHudPrecess;
}
- (id)init
{
	if ((self = [super init]))
    {
       
	}
	
	return self;
}
- (void) ShowTips:(NSString*)strTips  delayTime:(NSTimeInterval)delay  atView:(UIView*)pView
{
    RunOnMainThread(
    [self ShowTips:strTips delayTime:delay atView:pView withCenterPoint:CGPointMake([[UIApplication sharedApplication] keyWindow].bounds.size.width/2, [[UIApplication sharedApplication] keyWindow].bounds.size.height/2)];
                    )
}

- (void) ShowTips:(NSString*)strTips  delayTime:(NSTimeInterval)delay  atView:(UIView*)pView withCenterPoint:(CGPoint)point
{
    [HUD hideAnimated:NO];
    TipHUD = nil;
    if (0 == pthread_main_np())
    {
        NSLog(@"ShowTips2: should not run to here!");
        
        return;
    }
    
    if (NULL == pView)
    {
        pView = [[UIApplication sharedApplication] keyWindow];
    }
    
    if (NULL == pView)
    {
        return;
    }

    TipHUD = [MBProgressHUD showHUDAddedTo:pView animated:YES];
    TipHUD.mode = MBProgressHUDModeText;
    TipHUD.label.text = strTips;
    TipHUD.offset = CGPointMake(point.x-pView.bounds.size.width/2, point.y-pView.bounds.size.height/2);
    TipHUD.margin = 10.f;
    TipHUD.removeFromSuperViewOnHide = YES;
    [TipHUD setUserInteractionEnabled:NO];
    
    [TipHUD hideAnimated:YES afterDelay:delay];
    
}
-(void) showWaiting:(NSString*)strTips
{
    [self showWaiting:strTips onTarget:nil withObject:nil animated:NO atView:nil];
}
- (void) showWaiting:(NSString*)strTips onTarget:(id)target withObject:(id)object animated:(BOOL)animated   atView:(UIView*)pView
{
    HUD = [[MBProgressHUD alloc] initWithView:pView];
    HUD.delegate = self;
    
    [pView addSubview:HUD];
    
    HUD.label.text = strTips;
    
    [HUD showAnimated:animated];
}
-(void)clearUp
{
    [HUD hideAnimated:NO];
    HUD = nil;
}
- (void) showWaiting:(NSString*)strTips WhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated atView:(UIView*)pView
{
    HUD = [[MBProgressHUD alloc] initWithView:pView];
    HUD.delegate = self;
   
	[pView addSubview:HUD];
	
	HUD.label.text = strTips;
	
    [HUD showAnimated:animated];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        // Start executing the requested task
        [target performSelector:method withObject:object];
#pragma clang diagnostic pop
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [HUD hideAnimated:animated];
        });
    });
}
- (void) showProgress:(NSString*)strTips WhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated   atView:(UIView*)pView
{
    if (NULL == pView)
    {
        return ;
    }
    
    
    if (NULL == pView) {
        pView = [UIApplication sharedApplication].keyWindow;
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:pView];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeDeterminate;
    
	[pView addSubview:HUD];
	
	HUD.label.text = strTips;
	
    [HUD showAnimated:animated];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        // Start executing the requested task
        [target performSelector:method withObject:object];
#pragma clang diagnostic pop
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [HUD hideAnimated:animated];
        });
    });
}
- (void) updateProgress:(float)progress
{
    if (HUD != NULL &&  HUD.superview)
    {
        HUD.progress = progress;
    }
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}
@end

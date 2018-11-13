//
//  ParkIngCell.h
//  
//
//  Created by 魏唯隆 on 2017/11/30.
//

#import <UIKit/UIKit.h>

@protocol ParkIngDelegate <NSObject>

-(void)navToParkSpace:(id)sender;
-(void)unlockParkSpace:(id)sender;
-(void)cancleBookParkSpace:(id)sender;

@end

@interface ParkIngCell : UITableViewCell

@property (nonatomic, strong) UIButton *bindBtn;

@property (nonatomic, copy) NSArray *carLists;

@property (nonatomic, copy) NSString *isHidden;

@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, assign) id<ParkIngDelegate> delegate;
@end

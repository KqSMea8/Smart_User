//
//  PopContentView.h
//  DXWingGate
//
//  Created by coder on 2018/8/27.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopContentDelegate <NSObject>

-(void)resetBtnCallBackAction;
-(void)completeBtnCallBackAction;

@end

@interface PopContentView : UIView

@property (weak, nonatomic) IBOutlet UIView *visitNameBgView;
@property (weak, nonatomic) IBOutlet UIView *visitCarNumBgView;
@property (weak, nonatomic) IBOutlet UITextField *visitNameTex;
@property (weak, nonatomic) IBOutlet UITextField *visitCarNumTex;
@property (weak, nonatomic) IBOutlet UILabel *arriveTimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *arriveTimeBgView;
@property (weak, nonatomic) IBOutlet UILabel *leaveTimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *leaveTimeBgView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;

@property (nonatomic,weak) id<PopContentDelegate> delegate;

@end

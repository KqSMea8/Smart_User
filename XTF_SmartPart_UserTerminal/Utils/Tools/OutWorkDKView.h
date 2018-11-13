//
//  OutWorkDKView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/4/9.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol wqDkSaveRecordDelegate <NSObject>

-(void)wqDkSaveRecord:(NSString *)signType humanFace:(UIImage *)image signRemake:(NSString *)mark;

-(void)wqLookHumanFaceBigImage:(UIImageView *)imageView humanFace:(UIImage *)image;

@end

@interface OutWorkDKView : UIView

- (instancetype)initWithimage:(UIImage *)image signTime:(NSString *)time signAddr:(NSString *)addr;

/** show出这个弹窗 */
- (void)show;

/** 移除此弹窗 */
- (void)dismiss;

@property (nonatomic,copy) NSString *signType;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *addr;

@property (nonatomic,weak) id<wqDkSaveRecordDelegate> delegate;

@end

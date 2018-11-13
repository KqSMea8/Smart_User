//
//  CameraViewController.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/4/24.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "RootViewController.h"

@protocol imagePickerDelegate <NSObject>

- (void)imagePicker:(UIViewController *)picker didFinishPickingImage:(UIImage *)image;

@end

@interface CameraViewController : RootViewController

@property (nonatomic,weak) id<imagePickerDelegate> delegate;

//拍完照后左右按钮
@property (nonatomic, copy) NSString *leftBtnTitle;
@property (nonatomic, copy) NSString *rightBtnTitle;

@end

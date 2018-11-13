//
//  PointSelectView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/5/31.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "PointSelectView.h"

@implementation PointSelectView

+ (void)pointImageSelect:(UIView *)selView {
    [UIView animateWithDuration:0.2 animations:^{
        selView.transform = CGAffineTransformScale(selView.transform, 1.2, 1.2);
        
        selView.layer.shadowOffset = CGSizeMake(0, 3);
        selView.layer.shadowRadius = 5.0;
        selView.layer.shadowColor = [UIColor blackColor].CGColor;
        selView.layer.shadowOpacity = 0.8;
        
    }completion:^(BOOL finished) {
        
    }];
    
}

+ (void)recoverSelImgView:(UIView *)selView {
    [UIView animateWithDuration:0.2 animations:^{
        selView.transform = CGAffineTransformIdentity;
    }];
    selView.layer.shadowOffset = CGSizeMake(0, 0);
    selView.layer.shadowRadius = 0;
    selView.layer.shadowColor = [UIColor clearColor].CGColor;
    selView.layer.shadowOpacity = 0;
}

@end

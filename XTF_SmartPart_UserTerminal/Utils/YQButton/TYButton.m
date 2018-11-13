//
//  TYButton.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/21.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "TYButton.h"

@implementation TYButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect titleF = self.titleLabel.frame;
    CGRect imageF = self.imageView.frame;
    titleF.origin.x = 0;
    self.titleLabel.frame = titleF;
    imageF.origin.x = CGRectGetMaxX(titleF);
    self.imageView.frame = imageF;
}

@end

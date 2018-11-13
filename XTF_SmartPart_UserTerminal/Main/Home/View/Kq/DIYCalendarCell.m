//
//  DIYCalendarCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/16.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "DIYCalendarCell.h"

@implementation DIYCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = CGRectInset(self.bounds, 0.5, 0.5);
}

@end

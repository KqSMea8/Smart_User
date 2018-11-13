//
//  DIYCalendarCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/16.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <FSCalendar/FSCalendar.h>

typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeNone,
    SelectionTypeSingle,
    SelectionTypeLeftBorder,
    SelectionTypeMiddle,
    SelectionTypeRightBorder
};

@interface DIYCalendarCell : FSCalendarCell

@property (weak, nonatomic) CAShapeLayer *selectionLayer;

@property (assign, nonatomic) SelectionType selectionType;

@end

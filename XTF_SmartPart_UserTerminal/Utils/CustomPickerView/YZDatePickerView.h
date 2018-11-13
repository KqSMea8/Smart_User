//
//  YZDatePickerView.h
//  DXWingGate
//
//  Created by coder on 2018/9/4.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZDatePickerView;

@protocol  YZPickerDateDelegate<NSObject>

- (void)pickerDate:(YZDatePickerView *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day timeRange:(NSString *)timerange;

@end

@interface YZDatePickerView : UIButton

@property(nonatomic, weak)id <YZPickerDateDelegate>delegate;

- (instancetype)initWithDelegate:(id)delegate;

- (void)show;

@end

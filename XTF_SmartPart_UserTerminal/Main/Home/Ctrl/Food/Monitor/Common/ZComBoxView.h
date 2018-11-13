//
//  ZComBoxView.h
//  DemoDPSDK
//
//  Created by mac on 15/4/22.
//  Copyright (c) 2015年 chen_zhongbo. All rights reserved.
//
#import <UIKit/UIKit.h>
#include "MBProgressHUD.h"
@protocol ZComBoxViewDelegate
- (void)setBeginTime:(NSDate*)time;
- (void)setEndTime:(NSDate*)time;
- (void)setRecordType:(int)type;
- (void)setRecordResourc:(int)type;
- (void)setPlaybackType:(int)type;
- (void)setPlaybackSpeed:(int)type;
@end
@interface ZComBoxView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
{
    CGRect   m_Rect;
}

- (id)initFrameSetBeginTime:(CGRect)frame;
- (id)initFrameSetEndTime:(CGRect)frame;
- (id)initFrameSetRecordType:(CGRect)frame;
- (id)initFrameSetRecordResource:(CGRect)frame;
- (id)initFrameSetPlaybackType:(CGRect)frame;
- (id)initFrameSetPlaybackSpeed:(CGRect)frame;

@property(nonatomic, retain) UIDatePicker* pDatePicker;
@property(nonatomic, retain) UIPickerView* pPicker;
@property(nonatomic, retain) UIButton*   pBtnOk;
@property(nonatomic, retain) UIButton*   pBtnCancel;
@property(nonatomic, strong) NSArray*   arrPicker;
@property(nonatomic, weak) id<ZComBoxViewDelegate> delegate;
@end

//
//  NoDataView.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol reloadDelegate <NSObject>

-(void)reload;

@end

@interface NoDataView : UIView

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, assign) id<reloadDelegate> delegate;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) BOOL isNeedBtn;

@end

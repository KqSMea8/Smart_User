//
//  YQWebViewController.h
//  ZHYQ
//
//  Created by 焦平 on 2017/10/24.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "RootViewController.h"
#import <WebKit/WebKit.h>

@interface YQWebViewController : RootViewController

@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic,strong) UIProgressView * progressView;
@property (nonatomic) UIColor *progressViewColor;
@property (nonatomic,weak) WKWebViewConfiguration * webConfiguration;
@property (nonatomic, copy) NSString * url;

-(instancetype)initWithUrl:(NSString *)url;

//更新进度条
-(void)updateProgress:(double)progress;

//更新导航栏按钮，子类去实现
-(void)updateNavigationItems;

@end

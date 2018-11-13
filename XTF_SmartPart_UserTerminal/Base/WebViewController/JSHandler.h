//
//  JSHandler.h
//  ZHYQ
//
//  Created by 焦平 on 2017/10/24.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface JSHandler : NSObject<WKScriptMessageHandler>
@property (nonatomic,weak,readonly) UIViewController * webVC;
@property (nonatomic,strong,readonly) WKWebViewConfiguration * configuration;

-(instancetype)initWithViewController:(UIViewController *)webVC configuration:(WKWebViewConfiguration *)configuration;

-(void)cancelHandler;

@end

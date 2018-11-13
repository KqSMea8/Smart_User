//
//  JSHandler.m
//  ZHYQ
//
//  Created by 焦平 on 2017/10/24.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "JSHandler.h"

@interface JSHandler ()


@end

@implementation JSHandler

-(instancetype)initWithViewController:(UIViewController *)webVC configuration:(WKWebViewConfiguration *)configuration {
    self = [super init];
    if (self) {
        _webVC = webVC;
        _configuration = configuration;
        //js handler
        //注册JS 事件
        //        [configuration.userContentController addScriptMessageHandler:self name:@"showImages"];
//        [configuration.userContentController addScriptMessageHandler:self name:@"backPage"];
        //        [configuration.userContentController addScriptMessageHandler:self name:@"showVideo"];
        //        [configuration.userContentController addScriptMessageHandler:self name:@"issueMoment"];
        //        [configuration.userContentController addScriptMessageHandler:self name:@"JSShare"];
        
    }
    return self;
}

#pragma mark -  JS 调用 Native  代理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
//    if ([message.name isEqualToString:@"backPage"]) {
//        //返回
//        if (self.webVC.presentingViewController) {
//            [self.webVC dismissViewControllerAnimated:YES completion:nil];
//        }else{
//            [self.webVC.navigationController popViewControllerAnimated:YES];
//        }
//    }
    
}

#pragma mark -  记得要移除
-(void)cancelHandler {
    //    [_configuration.userContentController removeScriptMessageHandlerForName:@"showImages"];
    //    [_configuration.userContentController removeScriptMessageHandlerForName:@"backPage"];
    //    [_configuration.userContentController removeScriptMessageHandlerForName:@"showVideo"];
    //    [_configuration.userContentController removeScriptMessageHandlerForName:@"issueMoment"];
    //    [_configuration.userContentController removeScriptMessageHandlerForName:@"JSShare"];
}

-(void)dealloc {
    
}

@end

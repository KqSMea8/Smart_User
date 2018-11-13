//
//  ParamDES.m
//  TanXun
//
//  Created by 魏唯隆 on 2016/12/22.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "ParamDES.h"

@implementation ParamDES
#pragma mark 手机号DES加密
+ (NSString *)desCustMobile:(NSString *)requestUrl {
    NSArray *urlArray = [requestUrl componentsSeparatedByString:@"?"];
    if(urlArray.count >= 2){
        NSString *paramStr = urlArray.lastObject;
        NSMutableArray *params = [paramStr componentsSeparatedByString:@"&"].mutableCopy;
        // custMobile friendsCustMobile  replayCustMobile likeCustMobile  givedCustMobile createCustMobile
        // custMobile
        [params enumerateObjectsUsingBlock:^(NSString *param, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *paramKey = [param componentsSeparatedByString:@"="].firstObject;
            if([paramKey isEqualToString:@"custMobile"]){
                NSString *custMobile = [param componentsSeparatedByString:@"="].lastObject;
                NSString *desCustMobile = [DES3Util encryptUseDES:custMobile key:[[NSUserDefaults standardUserDefaults] objectForKey:KPublicKey]];
                NSString *desParam = [NSString stringWithFormat:@"%@=%@", @"custMobile", desCustMobile];
                [params replaceObjectAtIndex:idx withObject:desParam];
            }
        }];
        // friendsCustMobile
        [params enumerateObjectsUsingBlock:^(NSString *param, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *paramKey = [param componentsSeparatedByString:@"="].firstObject;
            if([paramKey isEqualToString:@"friendsCustMobile"]){
                NSString *custMobile = [param componentsSeparatedByString:@"="].lastObject;
                NSString *desCustMobile = [DES3Util encryptUseDES:custMobile key:[[NSUserDefaults standardUserDefaults] objectForKey:KPublicKey]];
                NSString *desParam = [NSString stringWithFormat:@"%@=%@", @"friendsCustMobile", desCustMobile];
                [params replaceObjectAtIndex:idx withObject:desParam];
            }
        }];
        // replayCustMobile
        [params enumerateObjectsUsingBlock:^(NSString *param, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *paramKey = [param componentsSeparatedByString:@"="].firstObject;
            if([paramKey isEqualToString:@"replayCustMobile"]){
                NSString *custMobile = [param componentsSeparatedByString:@"="].lastObject;
                NSString *desCustMobile = [DES3Util encryptUseDES:custMobile key:[[NSUserDefaults standardUserDefaults] objectForKey:KPublicKey]];
                NSString *desParam = [NSString stringWithFormat:@"%@=%@", @"replayCustMobile", desCustMobile];
                [params replaceObjectAtIndex:idx withObject:desParam];
            }
        }];
        // likeCustMobile
        [params enumerateObjectsUsingBlock:^(NSString *param, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *paramKey = [param componentsSeparatedByString:@"="].firstObject;
            if([paramKey isEqualToString:@"likeCustMobile"]){
                NSString *custMobile = [param componentsSeparatedByString:@"="].lastObject;
                NSString *desCustMobile = [DES3Util encryptUseDES:custMobile key:[[NSUserDefaults standardUserDefaults] objectForKey:KPublicKey]];
                NSString *desParam = [NSString stringWithFormat:@"%@=%@", @"likeCustMobile", desCustMobile];
                [params replaceObjectAtIndex:idx withObject:desParam];
            }
        }];
        // givedCustMobile
        [params enumerateObjectsUsingBlock:^(NSString *param, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *paramKey = [param componentsSeparatedByString:@"="].firstObject;
            if([paramKey isEqualToString:@"givedCustMobile"]){
                NSString *custMobile = [param componentsSeparatedByString:@"="].lastObject;
                NSString *desCustMobile = [DES3Util encryptUseDES:custMobile key:[[NSUserDefaults standardUserDefaults] objectForKey:KPublicKey]];
                NSString *desParam = [NSString stringWithFormat:@"%@=%@", @"givedCustMobile", desCustMobile];
                [params replaceObjectAtIndex:idx withObject:desParam];
            }
        }];
        // createCustMobile
        [params enumerateObjectsUsingBlock:^(NSString *param, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *paramKey = [param componentsSeparatedByString:@"="].firstObject;
            if([paramKey isEqualToString:@"createCustMobile"]){
                NSString *custMobile = [param componentsSeparatedByString:@"="].lastObject;
                NSString *desCustMobile = [DES3Util encryptUseDES:custMobile key:[[NSUserDefaults standardUserDefaults] objectForKey:KPublicKey]];
                NSString *desParam = [NSString stringWithFormat:@"%@=%@", @"createCustMobile", desCustMobile];
                [params replaceObjectAtIndex:idx withObject:desParam];
            }
        }];
        
        NSMutableString *newUrl = [NSMutableString stringWithFormat:@"%@?", urlArray.firstObject];
        [params enumerateObjectsUsingBlock:^(NSString *param, NSUInteger idx, BOOL * _Nonnull stop) {
            if(idx == (params.count - 1)){
                [newUrl appendFormat:@"%@", param];
            }else{
                [newUrl appendFormat:@"%@&", param];
            }
        }];
        
        return newUrl;
    }else {
        return requestUrl;
    }
    
}
@end

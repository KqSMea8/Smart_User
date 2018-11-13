//
//  MessageModel.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/5.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,copy) NSString *headerImage;
@property (nonatomic,copy) NSString *titleStr; //标题
@property (nonatomic,copy) NSString *timeStr;
@property (nonatomic,copy) NSString *contentStr;

-(instancetype)initData:(NSDictionary*)dic;

@end

//
//  NSString+category.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/28.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (category)

- (NSInteger)getStringLenthOfBytes;

- (NSString *)subBytesOfstringToIndex:(NSInteger)index;

@end

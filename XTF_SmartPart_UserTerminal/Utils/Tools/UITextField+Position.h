//
//  UITextField+Position.h
//  ZHYQ
//
//  Created by 魏唯隆 on 2018/8/29.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Position)

- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange)range;

// 删除光标位置字符
- (void)positionDelete;
// 新增光标位置字符
- (void)positionAddCharacter:(NSString *)character;

@end

NS_ASSUME_NONNULL_END

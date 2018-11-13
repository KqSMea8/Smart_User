//
//  UITextField+Position.m
//  ZHYQ
//
//  Created by 魏唯隆 on 2018/8/29.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "UITextField+Position.h"

@implementation UITextField (Position)


- (NSRange) selectedRange {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void) setSelectedRange:(NSRange) range {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];

}

// 删除光标位置字符
- (void)positionDelete {
    NSRange range = [self selectedRange];
    NSString *frontStr;
    if(range.location > 0){
        frontStr = [self.text substringWithRange:NSMakeRange(0, range.location-1)];
    }else {
        frontStr = @"";
    }
    NSString *afterStr = [self.text substringWithRange:NSMakeRange(range.location, self.text.length - range.location)];
    
    self.text = [NSString stringWithFormat:@"%@%@", frontStr, afterStr];
    // 重新定位光标
    [self setSelectedRange:NSMakeRange(range.location-1, 0)];
}
// 新增光标位置字符
- (void)positionAddCharacter:(NSString *)character {
    NSRange range = [self selectedRange];
    NSString *frontStr;
    if(range.location > 0){
        frontStr = [self.text substringWithRange:NSMakeRange(0, range.location)];
    }else {
        frontStr = @"";
    }
    NSString *afterStr = [self.text substringWithRange:NSMakeRange(range.location, self.text.length - range.location)];
    
    self.text = [NSString stringWithFormat:@"%@%@%@", frontStr, character, afterStr];
    // 重新定位光标
    [self setSelectedRange:NSMakeRange(range.location+1, 0)];
}

@end

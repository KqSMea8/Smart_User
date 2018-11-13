//
//  DHThreadSafeMultableDictionary.h
//  Pods
//
//  Created by 32943 on 2017/6/29.
//
// 参考淘宝weex

#import <Foundation/Foundation.h>

@interface DHThreadSafeMultableDictionary<__covariant KeyType, __covariant ObjectType> : NSMutableDictionary<KeyType, ObjectType> 

- (nullable ObjectType)objectForKey:(nullable KeyType)aKey;

@end

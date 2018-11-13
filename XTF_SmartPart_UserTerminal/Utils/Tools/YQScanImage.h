//
//  YQScanImage.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/4/11.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YQScanImage : NSObject

/**
 *  浏览大图
 *
 *  @param scanImageView 图片所在的imageView
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageView imageUrl:(NSString *)imgUrl;
+(void)scanBigImageWithImageView:(UIImageView *)currentImageView humanFaceImage:(UIImage *)currentImage;

@end

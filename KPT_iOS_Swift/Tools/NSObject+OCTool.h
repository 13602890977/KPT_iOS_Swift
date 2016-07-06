//
//  NSObject+OCTool.h
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/1.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (OCTool)
///返回26个大写英文字母（OC的方法）
- (NSMutableArray *)creatTwenty_sixArr;

+(NSString *)marshal;

///七牛token获取
+(NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey;

///将签名的底色改成透明
+ (UIImage*)imageToTransparent:(UIImage*)image;


@end

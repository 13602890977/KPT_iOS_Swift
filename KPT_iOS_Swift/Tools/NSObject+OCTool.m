//
//  NSObject+OCTool.m
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/1.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

#import "NSObject+OCTool.h"

@implementation NSObject (OCTool)
- (NSMutableArray *)creatTwenty_sixArr {
    NSMutableArray *_toBeReturned = [[NSMutableArray alloc]init];
    for(char c = 'A';c<='Z';c++)
        [_toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
    return _toBeReturned;
}


@end

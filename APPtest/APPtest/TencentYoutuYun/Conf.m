//
//  Conf.m
//  YoutuYunDemo
//
//  Created by Patrick Yang on 15/9/15.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "Conf.h"

#define API_END_POINT @"http://api.youtu.qq.com/youtu"
#define API_VIP_END_POINT @"https://vip-api.youtu.qq.com/youtu"

@implementation Conf

+ (Conf *)instance
{
    static Conf *singleton = nil;
    if (singleton) {
        return singleton;
    }
    singleton = [[Conf alloc] init];
    return singleton;
}

-(instancetype)init{
    self = [super init];
    _appId = @"10096776";      // 替换APP_ID
    _secretId = @"AKIDLwjSbCi75xgEbtQAIGbljmkbHvbnKgMY";    // 替换SECRET_ID
    _secretKey = @"WSH6oqiPKeR4mi6cGgBY2fRRI1d7va5Q";   // 替换SECRET_KEY
    _API_END_POINT = API_END_POINT;
    _API_VIP_END_POINT = API_VIP_END_POINT;
    return self;
}

@end

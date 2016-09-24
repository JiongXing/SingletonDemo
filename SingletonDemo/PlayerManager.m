//
//  PlayerManager.m
//  SingletonDemo
//
//  Created by JiongXing on 16/9/24.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import "PlayerManager.h"

static PlayerManager *_instance = nil;

@interface PlayerManager ()

/// 本类管理的成员变量
@property (nonatomic, strong) AVPlayer *player;

@end


@implementation PlayerManager

/// 重写以保证本类只开辟一块内存，对象唯一
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

/// 重写以禁止开辟新内存
- (id)copyWithZone:(struct _NSZone *)zone {
    return _instance;
}

/// 重写以进行各项初始化工作
- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        _instance.player = [[AVPlayer alloc] init];
    });
    return _instance;
}

/// 取本类单例
+ (instancetype)shareInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

/// 取本类单例管理的对象
+ (AVPlayer *)sharePlayer {
    return [PlayerManager shareInstance].player;
}

@end

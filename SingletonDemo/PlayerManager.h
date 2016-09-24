//
//  PlayerManager.h
//  SingletonDemo
//
//  Created by JiongXing on 16/9/24.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerManager : NSObject

/// 取本类单例
+ (instancetype)shareInstance;

/// 取本类单例管理的对象
+ (AVPlayer *)sharePlayer;

@end

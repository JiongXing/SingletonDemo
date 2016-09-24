# SingletonDemo
严谨的单例写法

把一个类单例化，需要保证在整个进程生命周期内，这个类最多只存在一个实例。
有几点需要考虑：
1. 保证多线程下只为此类分配一次内存
2. 禁止通过内存拷贝创建第二个实例，即使发生拷贝行为，也只返回唯一实例
3. 保证此类只作一次初始化
4. 提供简洁明了的访问接口

> 单例化PlayerManager类

```objc
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
```
```objc
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
```

> 测试：

```objc
//
//  main.m
//  SingletonDemo
//
//  Created by JiongXing on 16/9/24.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerManager.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PlayerManager *manager1 = [PlayerManager shareInstance];
            AVPlayer *player1 = [PlayerManager sharePlayer];
            NSLog(@"manager1:%@, player1:%@", manager1, player1);
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PlayerManager *manager2 = [[PlayerManager alloc] init];
            NSLog(@"manager2:%@", manager2);
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PlayerManager *manager3 = [[PlayerManager alloc] init];
            NSLog(@"manager3:%@", manager3);
        });
        
        // 1秒后结束进程
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            exit(0);
        });
        while (YES) {
            
        }
    }
    return 0;
}

```

> 控制台输出：

```
2016-09-24 16:33:23.257 SingletonDemo[1556:105961] manager1:<PlayerManager: 0x100200640>, player1:<AVPlayer: 0x1003083a0>
2016-09-24 16:33:23.257 SingletonDemo[1556:105964] manager3:<PlayerManager: 0x100200640>
2016-09-24 16:33:23.257 SingletonDemo[1556:105962] manager2:<PlayerManager: 0x100200640>
```

可以看到，多次创建PlayerManager，都为同一实例。

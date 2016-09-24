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

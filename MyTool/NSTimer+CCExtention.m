//
//  NSTimer+CCExtention.m
//  TestDemo
//
//  Created by Chris Captain on 2018/1/11.
//  Copyright © 2018年 Chris_Captain. All rights reserved.
//

#import "NSTimer+CCExtention.h"

@implementation NSTimer (CCExtention)

+ (NSTimer *)cc_scheduledTimeWithTimerInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats;
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(cc_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)cc_blockInvoke:(NSTimer *)timer
{
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}
@end

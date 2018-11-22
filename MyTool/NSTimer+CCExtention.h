//
//  NSTimer+CCExtention.h
//  TestDemo
//
//  Created by Chris Captain on 2018/1/11.
//  Copyright © 2018年 Chris_Captain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (CCExtention)

+ (NSTimer *)cc_scheduledTimeWithTimerInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats;

@end

//
//  MyTimer.h
//  ddcp
//
//  Created by lidan on 2018/3/19.
//  Copyright © 2018年 xyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTimer : NSObject
@property (nonatomic, copy) void(^runingtime)();
-(void)starmytimerwithdata:(int )time;
-(void)starmytimerwithdata:(int )time  runingaction:(void (^)())RuningBlock;
-(void)suspended;//暂停
-(void)restore;//恢复
-(void)destructiontimer;//销毁
@end

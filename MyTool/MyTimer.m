//
//  MyTimer.m
//  ddcp
//
//  Created by lidan on 2018/3/19.
//  Copyright © 2018年 xyf. All rights reserved.
//

#import "MyTimer.h"
@interface MyTimer()

@property(nonatomic,retain) dispatch_source_t timer;
@property(nonatomic,retain) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) int   runstate;  //状态  0 未运行 1 运行



@end
@implementation MyTimer
-(void)starmytimerwithdata:(int)time runingaction:(void (^)())RuningBlock{
     _runstate=1;
    if (_timer==nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),time*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_runstate==0) {
                    
                }else{
                    RuningBlock();
                }
                
            });
        });
        dispatch_resume(_timer);
    }
}

-(void)runingtimeaction{
    self.runingtime();
}
-(void)suspended{
    _runstate=0;
}
-(void)restore{
    _runstate=1;
}
-(void)destructiontimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    
}
@end

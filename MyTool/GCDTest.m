//
//  GCDTest.m
//  tlkj
//
//  Created by lidan on 2018/5/4.
//  Copyright © 2018年 xyf. All rights reserved.
//

#import "GCDTest.h"

@implementation GCDTest
-(void)test{
//     串行队列的创建方法
        dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
        // 并发队列的创建方法
        dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
        // 主队列的获取方法
        dispatch_queue_t queue3 = dispatch_get_main_queue();
    
        // 同步执行任务创建方法
        dispatch_sync(queue, ^{
            // 这里放同步执行任务代码
        });
        // 异步执行任务创建方法
        dispatch_async(queue, ^{
            // 这里放异步执行任务代码
        });
    
}
/** * 同步执行 + 串行队列 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。 同步执行 + 串行队列不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。*/

+(void)syncSerial {
        NSLog(@"currentThread---%@",[NSThread currentThread]); // 打印当前线程
        NSLog(@"syncSerial---begin");
        dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_sync(queue, ^{ // 追加任务1
            for (int i = 0; i < 2; ++i)
            {
                [NSThread sleepForTimeInterval:2];
                // 模拟耗时操作
                NSLog(@"1---%@",[NSThread currentThread]);
                // 打印当前线程
    
            } });
        dispatch_sync(queue, ^{ // 追加任务2
            for (int i = 0; i < 2; ++i) { [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"2---%@",[NSThread currentThread]);
                // 打印当前线程
    
            } }); dispatch_sync(queue, ^{ // 追加任务3
                for (int i = 0; i < 2; ++i) { [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                    NSLog(@"3---%@",[NSThread currentThread]);
                    // 打印当前线程
    
                } });
        NSLog(@"syncSerial---end");
    
}
-(void)GCDtest{
    dispatch_group_t group = dispatch_group_create(); // dispatch_queue_t globeQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t concurrentQ = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_enter(group);
    dispatch_async(concurrentQ, ^{ dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"1--over"); dispatch_group_leave(group);
        
    });
        
    }); dispatch_group_enter(group);
    
    dispatch_async(concurrentQ, ^{ dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"2--over"); dispatch_group_leave(group);
        
    });
        
    });
    
    dispatch_group_enter(group);//可以写在每个组前面,也可以全部提到任务最前面
    dispatch_async(concurrentQ, ^{ dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3--over");
        dispatch_group_leave(group); });
        
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{ NSLog(@"全部结束......");
        
    });
    
    
    NSLog(@" waiting... ");
    
}
-(void)testgdc2{
        dispatch_group_t serviceGroup = dispatch_group_create();
        DLog(@"开始了"); dispatch_group_enter(serviceGroup);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{ sleep(3);
            DLog(@"第一个任务开始了");
    
        });
        dispatch_group_wait(serviceGroup, dispatch_time(DISPATCH_TIME_NOW, 5 *NSEC_PER_SEC)); DLog(@"等待");
    
        dispatch_group_leave(serviceGroup); dispatch_group_enter(serviceGroup);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{ sleep(10);
    
            DLog(@"第二个任务开始了");
            dispatch_group_leave(serviceGroup);
    
        });
    
        dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{ DLog(@"全部都执行完了"); });
}


/*
 https://www.cnblogs.com/yajunLi/p/6274282.html
 iOS GCD中级篇 - dispatch_semaphore（信号量）的理解及使用
 理解这个概念之前，先抛出一个问题
 
 问题描述：
 
 假设现在系统有两个空闲资源可以被利用，但同一时间却有三个线程要进行访问，这种情况下，该如何处理呢？
 
 或者
 
 我们要下载很多图片，并发异步进行，每个下载都会开辟一个新线程，可是我们又担心太多线程肯定cpu吃不消，那么我们这里也可以用信号量控制一下最大开辟线程数。
 
 
 
 定义：
 
 1、信号量：就是一种可用来控制访问资源的数量的标识，设定了一个信号量，在线程访问之前，加上信号量的处理，则可告知系统按照我们指定的信号量数量来执行多个线程。
 
 其实，这有点类似锁机制了，只不过信号量都是系统帮助我们处理了，我们只需要在执行线程之前，设定一个信号量值，并且在使用时，加上信号量处理方法就行了。
 
 
 
 2、信号量主要有3个函数，分别是：
 
 //创建信号量，参数：信号量的初值，如果小于0则会返回NULL
 dispatch_semaphore_create（信号量值）
 
 //等待降低信号量
 dispatch_semaphore_wait（信号量，等待时间）
 
 //提高信号量
 dispatch_semaphore_signal(信号量)
 　　
 
 注意，正常的使用顺序是先降低然后再提高，这两个函数通常成对使用。　（具体可参考下面的代码示例）
 
 
 
 3、那么就开头提的问题，我们用代码来解决

 10
 -(void)dispatchSignal{
 //crate的value表示，最多几个资源可访问
 dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
 dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 
 //任务1
 dispatch_async(quene, ^{
 dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
 NSLog(@"run task 1");
 sleep(1);
 NSLog(@"complete task 1");
 dispatch_semaphore_signal(semaphore);
 });<br>
 //任务2
 dispatch_async(quene, ^{
 dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
 NSLog(@"run task 2");
 sleep(1);
 NSLog(@"complete task 2");
 dispatch_semaphore_signal(semaphore);
 });<br>
 //任务3
 dispatch_async(quene, ^{
 dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
 NSLog(@"run task 3");
 sleep(1);
 NSLog(@"complete task 3");
 dispatch_semaphore_signal(semaphore);
 });
 }
 执行结果：
 
 　　
 
 总结：由于设定的信号值为2，先执行两个线程，等执行完一个，才会继续执行下一个，保证同一时间执行的线程数不超过2。
 
 
 
 这里我们扩展一下，假设我们设定信号值=1
 
 1
 dispatch_semaphore_create(1)<br><br>
 那么结果就是：
 
 
 
 
 
 如果设定信号值=3
 
 1
 dispatch_semaphore_create(3)<br><br>
 那么结果就是：
 
 
 
 其实设定为3，就是不限制线程执行了，因为一共才只有3个线程。
 
 
 
 
 
 */









@end

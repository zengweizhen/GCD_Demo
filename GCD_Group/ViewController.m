//
//  ViewController.m
//  GCD_Group
//
//  Created by Jney on 2017/7/28.
//  Copyright © 2017年 Jney. All rights reserved.
//

#import "ViewController.h"
#import "NetWorkTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

#pragma mark - GCD利用队列dispatch_group_enter(group)和dispatch_group_leave(group)组实现异步转同步操作
/**
 利用队列组实现异步转同步
 */
- (IBAction)dispatch_group_t:(UIButton *)sender {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        ///异步十个发送请求
        [self networking:0 group:group];
        [self networking:1 group:group];
        [self networking:2 group:group];
        [self networking:3 group:group];
        [self networking:4 group:group];
        [self networking:5 group:group];
        [self networking:6 group:group];
        [self networking:7 group:group];
        [self networking:8 group:group];
        [self networking:9 group:group];
    });
}


/**
 网络请求

 @param index 表示第几次请求
 @param group 队列组
 */
- (void) networking:(NSInteger)index group:(dispatch_group_t)group{
    
    ///通知group，下面的任务马上要放到group中执行了
    //和内存管理的引用计数类似，我们可以认为group也持有一个整形变量(只是假设)，当调用enter时计数加1，调用leave时计数减1，当计数为0时会调用dispatch_group_wait会结束等待；
    dispatch_group_enter(group);
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"参数" forKey:@"key"];
    [NetWorkTool postWithURLString:@"https://example.com" parameters:params success:^(id success) {
        NSLog(@"第%zd次网络请求",index);
        ///通知group，任务完成了，该任务要从group中移除了
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        NSLog(@"第%zd次网络请求",index);
        ///通知group，任务完成了，该任务要从group中移除了
        dispatch_group_leave(group);
    }];
    //当dispatch_group_enter的时候计数器加一,线程就会进入等待状态 当dispatch_group_leave的时候计数器减一线程会自动结束等待,这样就实现了医异步的网络请求同步处理
    //会把队列组中的任务按顺序执行
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}




//----------------------------------------------------------分割线----------------------------------------------------------


#pragma mark - GCD利用信号量dispatch_semaphore实现异步转同步操作
/**
 利用信号量dispatch_semaphore
 */
- (IBAction)dispatch_semaphore:(UIButton *)sender {
    //创建一个信号量(可以理解为有多少个车位)
    //假设现在车位已经满了
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        //这里同时发送10个异步网络请求
        [self netWorking_semaphore:0 semaphore:semaphore];
        [self netWorking_semaphore:1 semaphore:semaphore];
        [self netWorking_semaphore:2 semaphore:semaphore];
        [self netWorking_semaphore:3 semaphore:semaphore];
        [self netWorking_semaphore:4 semaphore:semaphore];
        [self netWorking_semaphore:5 semaphore:semaphore];
        [self netWorking_semaphore:6 semaphore:semaphore];
        [self netWorking_semaphore:7 semaphore:semaphore];
        [self netWorking_semaphore:8 semaphore:semaphore];
        [self netWorking_semaphore:9 semaphore:semaphore];
        
        
    });
}

/**
 利用信号量实现网络请求异步转同步操作

 @param index 表示第几次网络请求
 @param semaphore 信号量
 */
- (void)netWorking_semaphore:(NSInteger)index semaphore:(dispatch_semaphore_t)semaphore{
    
    //此时的semaphore为0 可以理解为当前车库已满
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"参数" forKey:@"key"];
    [NetWorkTool postWithURLString:@"https://example.com" parameters:params success:^(id success) {
        NSLog(@"第%zd次网络请求",index);
        ///信号量加一(可以理解为已经走了一辆车,车库空位进行加一),此时的信号量为一
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        NSLog(@"第%zd次网络请求",index);
        ///信号量加一(可以理解为已经走了一辆车,车库空位进行加一),此时的信号量为一
        dispatch_semaphore_signal(semaphore);
    }];
    //这里可以理解为又来了一辆车,进行型号量减一操作,当信号量减一以后得到的值大于零时表示还有空车位 还可以来车(即线程不阻塞),当信号量减一后的值为零时表示已经满了,没有空车位了,则进行线程阻塞,不在处理其他线程,直到执行dispatch_semaphore_signal进行型号量加一操作后才解除阻塞
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

@end

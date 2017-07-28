# GCD_Demo

使用GCD信号量实现异步的网络请求同步处理


GCD利用队列dispatch_group_enter(group)和dispatch_group_leave(group)组实现异步转同步操作

和内存管理的引用计数类似，我们可以认为group也持有一个整形变量(只是假设)，当调用enter时计数加1，调用leave时计数减1，当计数为0时会调用dispatch_group_wait会结束等待

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
    
    
    
    GCD利用信号量dispatch_semaphore实现异步转同步操作

    信号量可以这样理解:
   
　　信号量的值就相当于剩余车位的数目，dispatch_semaphore_wait函数就相当于来了一辆车，dispatch_semaphore_signal就相当于走了一辆车。停车位的剩余数目在初始化的时候就已经指明了（dispatch_semaphore_create（long value）），调用一次dispatch_semaphore_signal，剩余的车位就增加一个；调用一次dispatch_semaphore_wait剩余车位就减少一个；当剩余车位为0时，再来车（即调用dispatch_semaphore_wait）就只能等待。有可能同时有几辆车等待一个停车位。有些车主没有耐心，给自己设定了一段等待时间，这段时间内等不到停车位就走了，如果等到了就开进去停车。而有些车主就像把车停在这，所以就一直等下去。

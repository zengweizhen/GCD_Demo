//
//  NetWorkTool.m
//  AFNetWorkingTool
//
//  Created by Jney on 16/5/3.
//  Copyright © 2016年 Jney. All rights reserved.
//

#import "NetWorkTool.h"

@implementation NetWorkTool
+(instancetype)shareInstance{
    static NetWorkTool *manager = nil;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        manager = [[NetWorkTool alloc]init];
    });
    return manager;
}
#pragma mark -- POST请求 --
+ (void)postWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(id success))success failure:(void (^)(NSError * error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            // JSON格式转换成字典，IOS5中自带解析类NSJSONSerialization从response中解析出数据放到字典中
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
            success(obj);
            //NSLog(@"post网络请求成功:%@",obj);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
            //NSLog(@"post网络请求失败:%@",error);
        }
    }];
}
#pragma mark -- 上传图片 --
+ (void)uploadWithURLString:(NSString *)URLString parameters:(id)parameters uploadParam:(UploadParam *)uploadParam success:(void (^)(id))success failure:(void (^)(NSError *))failure{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //必须在此Block中处理上传的文件
        //将上传的数据拼接到fromData中
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];

}


+(void)getDataWithUrl:(NSString *)url andParams:(NSMutableDictionary*)params success:(void (^)(id object))success failure:(void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
        [manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success) {
                // JSON格式转换成字典，IOS5中自带解析类NSJSONSerialization从response中解析出数据放到字典中
                id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
                success(obj);
                //NSLog(@"网络请求成功:%@",obj);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure) {
                failure(error);
                //NSLog(@"网络请求失败:%@",error);
            }
            
        }];


}


@end

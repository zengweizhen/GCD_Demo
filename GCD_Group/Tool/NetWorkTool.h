//
//  NetWorkTool.h
//  AFNetWorkingTool
//
//  Created by Jney on 16/5/3.
//  Copyright © 2016年 Jney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UploadParam.h"
@interface NetWorkTool : NSObject
/**
 *  单例
 */
+(instancetype)shareInstance;

/**
 *  网络请求
 */
//post请求
+(void)postWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(id success))success failure:(void (^)(NSError * error))failure;

//get请求
+(void)getDataWithUrl:(NSString *)url andParams:(NSMutableDictionary*)params success:(void (^)(id object))success
failure:(void (^)(NSError *error))failure;

/**
 *  上传图片
 */
+(void)uploadWithURLString:(NSString *)URLString parameters:(id)parameters uploadParam:(UploadParam *)uploadParam success:(void (^)(id object))success failure:(void (^)(NSError *error))failure;
@end

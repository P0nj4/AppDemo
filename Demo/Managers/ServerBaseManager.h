//
//  BaseManager.h
//  Demo
//
//  Created by German Pereyra on 12/11/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#define kStrGenericError @"genericServerError"
#define kServerURL @"http://mobile-test.theelectricfactory.com/services/"

#import <Foundation/Foundation.h>

@interface ServerBaseManager : NSObject

- (void)makeRequest:(NSString *)url onSuccess:(void (^)(id json))successHandler onError:(void (^)(NSError *error))errorHandler;
- (void)makeSyncRequest:(NSString *)url onSuccess:(void (^)(id json))successHandler onError:(void (^)(NSError *error))errorHandler;

@end

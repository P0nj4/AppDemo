//
//  BaseManager.m
//  Demo
//
//  Created by German Pereyra on 12/11/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "BaseManager.h"

@implementation BaseManager

- (void)makeRequest:(NSString *)url onSuccess:(void (^)(id json))successHandler onError:(void (^)(NSError *error))errorHandler {
    NSString *strURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urlForReq = [NSURL URLWithString:strURL];
    NSLog(@"request %@", urlForReq);
    
    NSURLRequest* urlRequest =  [NSURLRequest requestWithURL:urlForReq cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:0 error:&connectionError];
            if (!connectionError) {
                successHandler(jsonResult);
            }
        }
        if (errorHandler)
            errorHandler(connectionError);
    }];
}

@end

//
//  ProductManager.m
//  Demo
//
//  Created by German Pereyra on 12/11/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//


#import "ProductManager.h"
#import "Product.h"

@interface ProductManager ()
@property (nonatomic, weak) id<ProductManagerDelegate> delegate;
@end

static ProductManager *sharedPManager = nil;

@implementation ProductManager

+ (ProductManager *)sharedInstance {
    @synchronized(self) {
        if (sharedPManager == nil) {
            sharedPManager = [[self alloc] init]; // assignment not done here
        }
    }
    return sharedPManager;
}

- (void)getAllProducts:(id<ProductManagerDelegate>)delegate {
    NSString *serverUrl = kServerURL;
    serverUrl = [serverUrl stringByAppendingString:@"products.json"];
    [self makeRequest:serverUrl onSuccess:^(id jsonResult) {
        if (delegate) {
            NSMutableArray *response = [[NSMutableArray alloc] init];
            NSArray *result = jsonResult;
            Product *prodAux;
            for (NSDictionary *obj in result) {
                prodAux = [[Product alloc] init];
                [prodAux setAttributesFromJson:obj];
                [response addObject:prodAux];
            }
            [delegate getAllProductsResult:response errorMessage:nil];
        }
    } onError:^(NSError *error) {
        [[self delegate] getAllProductsResult:nil errorMessage:NSLocalizedString(kStrGenericError, nil)];
    }];
}



@end

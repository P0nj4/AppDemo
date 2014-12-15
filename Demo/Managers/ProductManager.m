//
//  ProductManager.m
//  Demo
//
//  Created by German Pereyra on 12/15/14.
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

- (void)loadProductsWithDelegate:(id<ProductManagerDelegate>)delegate {
    NSString *serverUrl = kServerURL;
    serverUrl = [serverUrl stringByAppendingString:@"products.json"];
    self.delegate = delegate;
    __weak typeof(self) weakerSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakerSelf makeRequest:serverUrl onSuccess:^(id jsonResult) {
            if (delegate) {
                if (!weakerSelf.allProducts)
                    weakerSelf.allProducts = [[NSMutableDictionary alloc] init];
                
                NSArray *result = jsonResult;
                Product *prodAux;
                for (NSDictionary *obj in result) {
                    prodAux = [[Product alloc] init];
                    [prodAux setAttributesFromJson:obj];
                    if (prodAux.identifier != 0)
                        [weakerSelf.allProducts setObject:prodAux forKey:[NSNumber numberWithInteger:prodAux.identifier]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[weakerSelf delegate] respondsToSelector:@selector(didLoadProducts:)]) {
                        [[weakerSelf delegate] didLoadProducts:nil];
                    }
                });
                
            }
        } onError:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
            if ([[weakerSelf delegate] respondsToSelector:@selector(didLoadProducts:)])
                [[weakerSelf delegate] didLoadProducts:error];
            });
        }];
    });
}



@end

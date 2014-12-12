//
//  ProductManager.h
//  Demo
//
//  Created by German Pereyra on 12/11/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "BaseManager.h"

@protocol ProductManagerDelegate <NSObject>
- (void)getAllProductsResult:(NSMutableArray *)result errorMessage:(NSString *)error;
@end

@interface ProductManager : BaseManager
- (void)getAllProducts:(id<ProductManagerDelegate>)delegate;
+ (ProductManager *)sharedInstance;
@end

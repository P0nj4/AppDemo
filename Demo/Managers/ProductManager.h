//
//  ProductManager.h
//  Demo
//
//  Created by German Pereyra on 12/11/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "ServerBaseManager.h"

@protocol ProductManagerDelegate <NSObject>
- (void)didLoadProducts:(NSError *)error;
@end

@interface ProductManager : ServerBaseManager
@property (nonatomic, strong) NSMutableDictionary *allProducts;
- (void)loadProductsWithDelegate:(id<ProductManagerDelegate>)delegate;
+ (ProductManager *)sharedInstance;
@end

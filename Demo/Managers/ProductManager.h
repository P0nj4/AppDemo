//
//  ProductManager.h
//  Demo
//
//  Created by German Pereyra on 12/11/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "BaseManager.h"

@protocol ProductManagerDelegate <NSObject>
- (void)didLoadProducts:(NSError *)error;
@end

@interface ProductManager : BaseManager
@property (nonatomic, strong) NSMutableDictionary *allProducts;
- (void)loadProductsWithDelegate:(id<ProductManagerDelegate>)delegate;
+ (ProductManager *)sharedInstance;
@end

//
//  OrderManager.h
//  Demo
//
//  Created by German Pereyra on 12/15/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "DataBaseManager.h"
#import "Order.h"

@interface OrderManager : DataBaseManager
+ (OrderManager *)sharedInstance;
- (NSInteger)insert:(Order *)order error:(NSError **)error;
- (void)update:(Order *)order error:(NSError **)error;
- (NSMutableDictionary *)getAll;
@end

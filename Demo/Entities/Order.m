//
//  Order.m
//  Demo
//
//  Created by German Pereyra on 12/11/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "Order.h"

@implementation Order

- (void)setClient:(Client *)client {
    self.clientIdentifier = client.identifier;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.products = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString *)description {
    NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
    NSArray *allKeys = self.products.allKeys;
    NSNumber *quantity;
    for (NSNumber *prod in allKeys) {
        quantity = [self.products objectForKey:prod];
        [str appendFormat:@"(%i) - ProdId %i, ", [quantity intValue], [prod intValue]];
    }
    
    return str;
}

@end

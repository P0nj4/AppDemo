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

@end

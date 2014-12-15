//
//  Order.m
//  Demo
//
//  Created by German Pereyra on 12/11/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "Order.h"
#import "ClientManager.h"

@implementation Order

- (void)setClient:(Client *)client {
    self.clientIdentifier = client.identifier;
    _client = client;
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


- (void)loadClientDelegate:(id<OrderDelegate>)delegate {
    self.delegate = delegate;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Client *cliAux = [[ClientManager sharedInstance] loadSyncClientById:self.clientIdentifier];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.client = cliAux;
            if (weakSelf.delegate) {
                [weakSelf.delegate clientDidLoad];
            }
        });
    });
}


@end

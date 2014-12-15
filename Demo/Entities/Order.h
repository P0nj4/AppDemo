//
//  Order.h
//  Demo
//
//  Created by German Pereyra on 12/15/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "Client.h"

@protocol OrderDelegate <NSObject>
- (void)clientDidLoad;
@end


@interface Order : NSObject
@property (nonatomic, weak) id<OrderDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *products;
@property (nonatomic, weak) Client *client;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSInteger clientIdentifier;
- (void)loadClientDelegate:(id<OrderDelegate>)delegate;
@end

//
//  Order.h
//  Demo
//
//  Created by German Pereyra on 12/11/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "Client.h"

@interface Order : NSObject
@property (nonatomic, strong) NSMutableDictionary *products;
@property (nonatomic, weak) Client *client;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSInteger clientIdentifier;


@end

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
@property (nonatomic, weak) Product *product;
@property (nonatomic, weak) Client *client;
@property (nonatomic) NSInteger quantity;

@end

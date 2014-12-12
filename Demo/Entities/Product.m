//
//  Product.m
//  Demo
//
//  Created by German Pereyra on 12/11/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "Product.h"

@implementation Product

- (void)setAttributesFromJson:(NSDictionary *)json{
    self.identifier = [[json objectForKey:@"id"] integerValue];
    if (!IsNull([json objectForKey:@"nombre"]))
        self.name = [json objectForKey:@"nombre"];
    if (!IsNull([json objectForKey:@"img"]))
        self.imageURL = [json objectForKey:@"img"];
    self.price = [[json objectForKey:@"precio"] doubleValue];
}

@end

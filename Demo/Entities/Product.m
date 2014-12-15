//
//  Product.m
//  Demo
//
//  Created by German Pereyra on 12/15/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "Product.h"

@implementation Product

- (void)setAttributesFromJson:(NSDictionary *)json{
    self.identifier = [[json objectForKey:@"id"] integerValue];
    if (!IsNull([json objectForKey:@"nombre"]))
        self.name = [json objectForKey:@"nombre"];
    if (!IsNull([json objectForKey:@"img"]))
        self.imageURL = [NSURL URLWithString:[json objectForKey:@"img"]];
    self.price = [[json objectForKey:@"precio"] doubleValue];
}

- (void)loadImageWithDelegate:(id<ProductDelegate>)delegate {
    self.delegate = delegate;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:weakSelf.imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.img = [UIImage imageWithData:imageData];
            if (weakSelf.delegate) {
                [weakSelf.delegate imageDidLoad];
            }
        });
    });
}

@end

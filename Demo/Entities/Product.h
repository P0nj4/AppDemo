//
//  Product.h
//  Demo
//
//  Created by German Pereyra on 12/11/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Product : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *img;
@property (nonatomic) double price;
@property (nonatomic) NSInteger identifier;
- (void)setAttributesFromJson:(NSDictionary *)json;
@end

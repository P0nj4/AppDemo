//
//  Product.h
//  Demo
//
//  Created by German Pereyra on 12/15/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ProductDelegate <NSObject>
- (void)imageDidLoad;
@end

@interface Product : NSObject
@property (nonatomic, weak) id<ProductDelegate> delegate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *img;
@property (nonatomic) double price;
@property (nonatomic) NSInteger identifier;
- (void)setAttributesFromJson:(NSDictionary *)json;
- (void)loadImageWithDelegate:(id<ProductDelegate>)delegate;
@end

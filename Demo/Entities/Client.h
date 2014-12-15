//
//  Client.h
//  Demo
//
//  Created by German Pereyra on 12/15/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Client : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) NSInteger identifier;
- (void)setAttributesFromJson:(NSDictionary *)json;
@end

//
//  CartTableViewController.h
//  Demo
//
//  Created by German Pereyra on 12/12/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"
#import "Order.h"

@interface CartTableViewController : UITableViewController
@property (nonatomic, weak) Client *client;
@property (nonatomic, strong) Order *order;
@end

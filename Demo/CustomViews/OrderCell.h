//
//  OrderCell.h
//  Demo
//
//  Created by German Pereyra on 12/15/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface OrderCell : UITableViewCell <OrderDelegate>
@property (weak, nonatomic) IBOutlet UILabel *clientLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) Order *order;
@end

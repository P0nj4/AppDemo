//
//  OrderCell.m
//  Demo
//
//  Created by German Pereyra on 12/15/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrder:(Order *)order {
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
    self.dateLabel.text = [fomatter stringFromDate:order.date];
    _order = order;
    if (order.client) {
        self.clientLabel.text = order.client.name;
    } else {
        self.clientLabel.text = @"wait...";
        [order loadClientDelegate:self];
    }
}

- (void)clientDidLoad {
    if (self.order.client) {
        self.clientLabel.text = self.order.client.name;
    }
}

@end

//
//  ClientCell.m
//  Demo
//
//  Created by German Pereyra on 12/12/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "ClientCell.h"

@interface ClientCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end


@implementation ClientCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setClient:(Client *)client {
    _client = client;
    self.nameLabel.text = client.name;
    self.addressLabel.text = client.address;
}
@end

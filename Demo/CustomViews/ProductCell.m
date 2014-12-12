//
//  ProductCell.m
//  Demo
//
//  Created by German Pereyra on 12/12/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "ProductCell.h"

@interface ProductCell () <ProductDelegate>
@end

@implementation ProductCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProduct:(Product *)product {
    _product = product;
    self.nameLabel.text = product.name;
    if (product.img) {
        self.image.image = product.img;
    } else {
        [product loadImageWithDelegate:self];
    }
}

- (void)imageDidLoad {
    self.image.image = _product.img;
}

@end

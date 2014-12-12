//
//  ProductCell.m
//  Demo
//
//  Created by German Pereyra on 12/12/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "ProductCell.h"

@interface ProductCell () <ProductDelegate, UITextFieldDelegate>
@end

@implementation ProductCell

- (void)awakeFromNib {
    self.quantityTextField.delegate = self;
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(productCellDidChange:ForProduct:)]) {
        [self.delegate productCellDidChange:[textField.text integerValue] ForProduct:self.product];
    }
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0";
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
}

@end

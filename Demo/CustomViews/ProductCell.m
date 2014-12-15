//
//  ProductCell.m
//  Demo
//
//  Created by German Pereyra on 12/15/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "ProductCell.h"

@interface ProductCell () <ProductDelegate, UITextFieldDelegate>
@end

@implementation ProductCell

- (void)awakeFromNib {
    self.quantityTextField.delegate = self;
    [self.quantityTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
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
        self.image.hidden = YES;
        [product loadImageWithDelegate:self];
    }
}

- (void)imageDidLoad {
    self.image.image = _product.img;
    self.image.hidden = NO;
}

- (BOOL)textFieldDidChange:(UITextField *)textField {
    NSInteger quantity = 0;
    if (textField.text.length != 0) {
        quantity = [textField.text integerValue];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(productCellDidChange:ForProduct:)]) {
        [self.delegate productCellDidChange:quantity ForProduct:self.product];
    }
    
    return YES;
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

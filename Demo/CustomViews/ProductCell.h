//
//  ProductCell.h
//  Demo
//
//  Created by German Pereyra on 12/12/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductCell : UITableViewCell
@property (nonatomic, weak) Product *product;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@end

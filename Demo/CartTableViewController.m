//
//  CartTableViewController.m
//  Demo
//
//  Created by German Pereyra on 12/12/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#define kTotalQuantityTag 343534534

#import "CartTableViewController.h"

//entities
#import "ProductManager.h"
#import "Product.h"
#import "Order.h"

//custom views
#import "LoadingView.h"
#import "ProductCell.h"

@interface CartTableViewController () <ProductManagerDelegate, ProductCellDelegate>
@property (nonatomic, strong) NSArray *listOfProducts;
@property (nonatomic, strong) NSMutableDictionary *orders;
@property (nonatomic, strong) UILabel *totalQuantityLabel;
@end

@implementation CartTableViewController

- (void)setListOfProducts:(NSArray *)listOfProducts {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    _listOfProducts = [listOfProducts sortedArrayUsingDescriptors:@[sort]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![ProductManager sharedInstance].allProducts || [ProductManager sharedInstance].allProducts.count == 0) {
        [LoadingView loadingShowOnView:self.view animated:NO frame:self.tableView.bounds];
        [[ProductManager sharedInstance] loadProductsWithDelegate:self];
    } else {
        self.listOfProducts = [[ProductManager sharedInstance].allProducts allValues];
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = doneButton;

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.listOfProducts)
        return self.listOfProducts.count;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Product *prod = [self.listOfProducts objectAtIndex:indexPath.row];
    if (((ProductCell *)cell).product) {
        ((ProductCell *)cell).product.delegate = nil;
    }
    [((ProductCell *)cell) setProduct:prod];
    Order *ordAux = [self.orders objectForKey:[NSNumber numberWithInteger:prod.identifier]];
    if (ordAux) {
        ((ProductCell *)cell).quantityTextField.text = [NSString stringWithFormat:@"%ld",(long) ordAux.quantity];
    } else {
        ((ProductCell *)cell).quantityTextField.text = @"0";
    }
    ((ProductCell *)cell).delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = (ProductCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.quantityTextField becomeFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    float tableWidth = self.tableView.frame.size.width;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableWidth, 44)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    footerView.backgroundColor = [UIColor darkGrayColor];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (tableWidth / 2) - 20, 20)];
    totalLabel.autoresizingMask = UIViewAutoresizingNone;
    totalLabel.text = @"Total";
    totalLabel.font = [UIFont systemFontOfSize:17];
    totalLabel.textColor = [UIColor blackColor];
    
    self.totalQuantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalLabel.frame) + 10, 10, tableWidth - (CGRectGetMaxX(totalLabel.frame) + 20), 20)];
    self.totalQuantityLabel.tag = kTotalQuantityTag;
    self.totalQuantityLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.totalQuantityLabel.textAlignment = NSTextAlignmentRight;
    self.totalQuantityLabel.text = @"$0";
    self.totalQuantityLabel.font = [UIFont systemFontOfSize:17];
    self.totalQuantityLabel.textColor = [UIColor blackColor];
    
    [footerView addSubview:totalLabel];
    [footerView addSubview:self.totalQuantityLabel];
    
    return footerView;
}

#pragma mark - ProductManagerDelegate
- (void)didLoadProducts:(NSError *)error {
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"Oups" message:NSLocalizedString(@"genericServerError", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"retry", nil) otherButtonTitles:nil] show];
        return;
    }
    [LoadingView loadingHideOnView:self.view animated:YES];
    self.listOfProducts = [[[ProductManager sharedInstance] allProducts] allValues];
    [self.tableView reloadData];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[ProductManager sharedInstance] loadProductsWithDelegate:self];
}

#pragma mark - ProductCellDelegate
- (void)productCellDidChange:(NSInteger)quantity ForProduct:(Product *)product{
    if (!self.orders) {
        self.orders = [[NSMutableDictionary alloc] init];
    }
    Order *orderAux;
    orderAux = [self.orders objectForKey:[NSNumber numberWithInteger:product.identifier]];
    if (!orderAux)
        orderAux = [[Order alloc] init];
    
    orderAux.product = product;
    orderAux.client = self.client;
    orderAux.quantity = quantity;
    [self.orders setObject:orderAux forKey:[NSNumber numberWithInteger:product.identifier]];
    [self updateTotalAmount];
}

#pragma mark - Private methods
- (void)updateTotalAmount {
    if (self.orders && self.orders.count > 0) {
        NSArray *allOrders = [self.orders allValues];
        double total = 0;
        for (Order *oAux in allOrders) {
            total += oAux.quantity * oAux.product.price;
        }
        NSLog(@"%f",total);
        self.totalQuantityLabel.text = [NSString stringWithFormat:@"$%.2f", total];
        
    }
}

- (void)doneAction {
#warning guardar en base de datos
}

- (void)cancelAction {
    self.orders = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

@end

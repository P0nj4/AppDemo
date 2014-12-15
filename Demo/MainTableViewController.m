//
//  MainTableViewController.m
//  Demo
//
//  Created by German Pereyra on 12/12/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

//view controllers
#import "MainTableViewController.h"
#import "CartTableViewController.h"

//entities & managers
#import "ClientManager.h"
#import "OrderManager.h"
#import "Client.h"

//custom views
#import "LoadingView.h"
#import "ClientCell.h"

@interface MainTableViewController () <ClientManagerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (nonatomic, strong) NSArray *listOfClients;
@property (nonatomic, strong) NSArray *listOfOrders;
- (IBAction)segmentedDidChanged:(id)sender;
@end

@implementation MainTableViewController

- (void)setListOfClients:(NSArray *)listOfClients {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    _listOfClients= [listOfClients sortedArrayUsingDescriptors:@[sort]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (![[ClientManager sharedInstance] allClients] || [[[ClientManager sharedInstance] allClients] count] == 0) {
        [LoadingView loadingShowOnView:self.view animated:NO frame:self.view.bounds];
        [[ClientManager sharedInstance] loadClientsWithDelegate:self];
    } else
        self.listOfClients = [[[ClientManager sharedInstance] allClients] allValues];
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
    if (self.segmented.selectedSegmentIndex == 0) {
        if (self.listOfClients)
            return self.listOfClients.count;
    } else {
        return self.listOfOrders.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmented.selectedSegmentIndex == 0) {
        ClientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClientTVCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"ClientCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ClientTVCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ClientTVCell"];
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OrderCell"];
        }
        Order *oAux = [self.listOfOrders objectAtIndex:indexPath.row];
        NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
        [fomatter setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
        cell.detailTextLabel.text = [fomatter stringFromDate:oAux.date];
        cell.textLabel.text = [NSString stringWithFormat:@"%i",oAux.clientIdentifier];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmented.selectedSegmentIndex == 0) {
        Client *client = [self.listOfClients objectAtIndex:indexPath.row];
        ClientCell *clientCell = (ClientCell *)cell;
        [clientCell setClient:client];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmented.selectedSegmentIndex == 0) {
        [self performSegueWithIdentifier:@"addProducts" sender:nil];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addProducts"]) {
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Client *client = [self.listOfClients objectAtIndex:path.row];
        
        CartTableViewController *vc = [segue destinationViewController];
        [vc setClient:client];
    }
    
}

#pragma mark - ClientManagerDelegate
- (void)didLoadClients:(NSError *)error {
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"Oups" message:NSLocalizedString(@"genericServerError", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"retry", nil) otherButtonTitles:nil] show];
        return;
    }
    [LoadingView loadingHideOnView:self.view animated:YES];
    self.listOfClients = [[[ClientManager sharedInstance] allClients] allValues];
    [self.tableView reloadData];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[ClientManager sharedInstance] loadClientsWithDelegate:self];
}

#pragma mark - Actions 
- (IBAction)segmentedDidChanged:(id)sender {
    if (self.segmented.selectedSegmentIndex == 1) {
        self.listOfOrders = nil;
        self.listOfOrders = [[[OrderManager sharedInstance] getAll] allValues];
    }
    [self.tableView reloadData];
}

@end

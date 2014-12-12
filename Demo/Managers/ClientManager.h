//
//  ClientManager.h
//  Demo
//
//  Created by German Pereyra on 12/11/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "BaseManager.h"

@class Client;

@protocol ClientManagerDelegate <NSObject>
- (void)didLoadClients:(NSError *)error;
- (void)didLoadClientById:(NSError *)error;
@end

@interface ClientManager : BaseManager
@property (nonatomic, strong) NSMutableDictionary *allClients;
- (void)loadClientsWithDelegate:(id<ClientManagerDelegate>)delegate;
- (void)loadClientById:(NSInteger)identifier delegate:(id<ClientManagerDelegate>)delegate;
+ (ClientManager *)sharedInstance;
@end

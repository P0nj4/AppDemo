//
//  ClientManager.h
//  Demo
//
//  Created by German Pereyra on 12/15/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "ServerBaseManager.h"

@class Client;

@protocol ClientManagerDelegate <NSObject>
- (void)didLoadClients:(NSError *)error;
- (void)didLoadClientById:(NSError *)error;
@end

@interface ClientManager : ServerBaseManager
@property (nonatomic, strong) NSMutableDictionary *allClients;
- (void)loadClientsWithDelegate:(id<ClientManagerDelegate>)delegate;
- (Client *)loadSyncClientById:(NSInteger)identifier;
+ (ClientManager *)sharedInstance;
@end

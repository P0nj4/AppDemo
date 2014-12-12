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
- (void)getAllClientsResult:(NSMutableArray *)result errorMessage:(NSString *)error;
- (void)getClientByIdResult:(Client *)result errorMessage:(NSString *)error;
@end

@interface ClientManager : BaseManager
- (void)getAllClients:(id<ClientManagerDelegate>)delegate;
- (void)getClientById:(NSInteger)identifier delegate:(id<ClientManagerDelegate>)delegate;
+ (ClientManager *)sharedInstance;
@end

//
//  ClientManager.m
//  Demo
//
//  Created by German Pereyra on 12/11/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//



#import "ClientManager.h"
#import "Client.h"

static ClientManager *sharedManager = nil;

@interface ClientManager ()
@property (nonatomic, weak) id<ClientManagerDelegate> delegate;
@end

@implementation ClientManager

+ (ClientManager *)sharedInstance {
    @synchronized(self) {
        if (sharedManager == nil) {
            sharedManager = [[self alloc] init]; // assignment not done here
        }
    }
    return sharedManager;
}

- (void)getAllClients:(id<ClientManagerDelegate>)delegate {
    NSString *serverUrl = kServerURL;
    serverUrl = [serverUrl stringByAppendingString:@"clients.json"];
    [self makeRequest:serverUrl onSuccess:^(id jsonResult) {
        if (delegate) {
            NSMutableArray *response = [[NSMutableArray alloc] init];
            NSArray *result = jsonResult;
            Client *cliAux;
            for (NSDictionary *obj in result) {
                cliAux = [[Client alloc] init];
                [cliAux setAttributesFromJson:obj];
                [response addObject:cliAux];
            }
            [delegate getAllClientsResult:response errorMessage:nil];
        }
    } onError:^(NSError *error) {
        [[self delegate] getAllClientsResult:nil errorMessage:NSLocalizedString(kStrGenericError, nil)];
    }];
}

- (void)getClientById:(NSInteger)identifier delegate:(id<ClientManagerDelegate>)delegate {
    
    NSString *serverUrl = kServerURL;
    serverUrl = [serverUrl stringByAppendingString:[NSString stringWithFormat:@"clientById.php?id=%ld", (long)identifier]];
    [self makeRequest:serverUrl onSuccess:^(id jsonResult) {
        if (delegate) {
            NSDictionary *result = jsonResult;
            Client *cliAux = [[Client alloc] init];
            [cliAux setAttributesFromJson:result];
            [delegate getClientByIdResult:cliAux errorMessage:nil];
        }
    } onError:^(NSError *error) {
        [[self delegate] getClientByIdResult:nil errorMessage:NSLocalizedString(kStrGenericError, nil)];
    }];

}
@end

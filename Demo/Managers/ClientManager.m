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

- (void)loadClientsWithDelegate:(id<ClientManagerDelegate>)delegate {
    NSString *serverUrl = kServerURL;
    serverUrl = [serverUrl stringByAppendingString:@"clients.json"];
    self.delegate = delegate;
    __weak typeof(self) weakerSelf = self;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [weakerSelf makeSyncRequest:serverUrl onSuccess:^(id jsonResult) {
            if (delegate) {
                if (!weakerSelf.allClients)
                    weakerSelf.allClients = [[NSMutableDictionary alloc] init];
                
                NSArray *result = jsonResult;
                Client *cliAux;
                for (NSDictionary *obj in result) {
                    cliAux = [[Client alloc] init];
                    [cliAux setAttributesFromJson:obj];
                    if (cliAux.identifier != 0)
                        [weakerSelf.allClients setObject:cliAux forKey:[NSNumber numberWithInteger:cliAux.identifier]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[weakerSelf delegate] respondsToSelector:@selector(didLoadClients:)])
                        [[weakerSelf delegate] didLoadClients:nil];
                });
            }
        } onError:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[weakerSelf delegate] respondsToSelector:@selector(didLoadClients:)])
                    [[weakerSelf delegate] didLoadClients:error];
            });
        }];
        
    });
}

- (void)loadClientById:(NSInteger)identifier delegate:(id<ClientManagerDelegate>)delegate {
    NSNumber *numIdentifier = [NSNumber numberWithInteger:identifier];
    if (self.allClients && [self.allClients objectForKey:numIdentifier])
        [self.allClients setObject:nil forKey:numIdentifier];
    
    NSString *serverUrl = kServerURL;
    serverUrl = [serverUrl stringByAppendingString:[NSString stringWithFormat:@"clientById.php?id=%ld", (long)identifier]];
    [self makeRequest:serverUrl onSuccess:^(id jsonResult) {
        if (delegate) {
            NSDictionary *result = jsonResult;
            Client *cliAux = [[Client alloc] init];
            [cliAux setAttributesFromJson:result];
            [self.allClients setObject:cliAux forKey:numIdentifier];
            if ([delegate respondsToSelector:@selector(didLoadClientById:)])
                [delegate didLoadClientById:nil];
        }
    } onError:^(NSError *error) {
        if ([delegate respondsToSelector:@selector(didLoadClientById:)])
            [[self delegate] didLoadClientById:error];
    }];
    
}
@end

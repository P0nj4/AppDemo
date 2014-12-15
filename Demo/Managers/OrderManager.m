//
//  OrderManager.m
//  Demo
//
//  Created by German Pereyra on 12/15/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "OrderManager.h"

static OrderManager *sharedManager = nil;

@implementation OrderManager
+ (OrderManager *)sharedInstance {
    @synchronized(self) {
        if (sharedManager == nil) {
            sharedManager = [[self alloc] init]; // assignment not done here
        }
    }
    return sharedManager;
}

- (NSMutableDictionary *)getAll {
    FMDatabase *database = [self getDB];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT * from pedidos p inner join pedido_productos pp on (pp.id_pedido = p.id)", nil];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    Order *order = nil;
    while([results next]) {
        NSInteger idAux = [results intForColumn:@"id_pedido"];
        order = [dict objectForKey:[NSNumber numberWithInteger:idAux]];
        if (!order) {
            order = [[Order alloc] init];
            order.identifier = idAux;
            order.date = [results dateForColumn:@"fecha"];
            order.clientIdentifier = [results intForColumn:@"id_cliente"];
        }
        
        if(!order.products) {
            order.products = [[NSMutableDictionary alloc] init];
        }
        
        NSInteger productId = [results intForColumn:@"id_producto"];
        NSInteger quantity = [results intForColumn:@"cantidad"];
        
        [order.products setObject:[NSNumber numberWithInteger:quantity] forKey:[NSNumber numberWithInteger:productId]];
        
        [dict setObject:order forKey:[NSNumber numberWithInteger:order.identifier]];
    }
    [database close];
    
    return dict;
}

- (NSInteger)insert:(Order *)order error:(NSError **)error {
    if (order.clientIdentifier == 0) {
        *error = [[NSError alloc] initWithDomain:@"insertError" code:1000 userInfo:nil];
        return 0;
    }
    
    FMDatabase *database = [self getDB];
    [database open];
    [database beginTransaction];
    NSInteger lastRow;
    
    BOOL result = [database executeUpdate:@"INSERT INTO pedidos (fecha, id_cliente) VALUES (?, ?)",[NSDate date] , [NSNumber numberWithInteger:order.clientIdentifier], nil];
    if (result) {
        NSArray *allProductIdentifiers = [order.products allKeys];
        for (int i = 0; i < allProductIdentifiers.count; i++) {
            
            result = [database executeUpdate:@"INSERT INTO pedido_productos (id_pedido, id_producto, cantidad) VALUES (?, ?, ?)",[NSNumber numberWithInteger:lastRow], [allProductIdentifiers objectAtIndex:i], [order.products objectForKey:[allProductIdentifiers objectAtIndex:i]], nil];
            
            if (!result) {
                [database rollback];
                [database close];
                *error = [[NSError alloc] initWithDomain:@"insertError" code:1000 userInfo:nil];
                return 0;
            }
        }
        if (result) {
            [database commit];
        }
    } else {
        [database rollback];
        [database close];
        *error = [[NSError alloc] initWithDomain:@"insertError" code:1000 userInfo:nil];
        return 0;
    }
    
    [database close];
    return lastRow;
}


- (void)update:(Order *)order error:(NSError **)error{
    FMDatabase *database = [self getDB];
    [database open];
    [database beginTransaction];
    NSInteger lastRow = order.identifier;
    
    BOOL result = [database executeUpdate:[NSString stringWithFormat:@"Delete from pedido_productos where id_pedido = %i", order.identifier], nil];
    if (result) {
        lastRow = order.identifier;
        NSArray *allProductIdentifiers = [order.products allKeys];
        for (int i = 0; i < allProductIdentifiers.count; i++) {
            NSNumber *orderId = [NSNumber numberWithInteger:lastRow];
            NSNumber *productId = [allProductIdentifiers objectAtIndex:i];
            NSNumber *quantity = [order.products objectForKey:[allProductIdentifiers objectAtIndex:i]];
            
            result = [database executeUpdate:@"INSERT INTO pedido_productos (id_pedido, id_producto, cantidad) VALUES (?, ?, ?)", orderId,productId ,quantity , nil];
            
            if (!result) {
                [database rollback];
                [database close];
                *error = [[NSError alloc] initWithDomain:@"updateError" code:1000 userInfo:nil];
                return;
            }
        }
        if (result) {
            [database commit];
        }
    } else {
        [database rollback];
        [database close];
        *error = [[NSError alloc] initWithDomain:@"updateError" code:1000 userInfo:nil];
        return ;
    }
    
    [database close];
}
@end

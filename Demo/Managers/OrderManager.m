//
//  OrderManager.m
//  Demo
//
//  Created by German Pereyra on 12/15/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import "OrderManager.h"
#import "Order.h"

@implementation OrderManager

- (NSMutableDictionary *)getAll {
    FMDatabase *database = [self getDB];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT p.id_cliente, p.fecha, p.* from pedidos p inner join pedido_productos pp on (pp.id_pedido = p.id)", nil];
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

- (void)insert:(Order *)order Error:(NSError **)error {
    
    if (order.clientIdentifier == 0)
        return;
    
    FMDatabase *database = [self getDB];
    [database open];
    
    BOOL result = [database executeUpdate:@"INSERT INTO pedidos (fecha, id_cliente) VALUES (?, ?)",[NSDate date] , [NSNumber numberWithInteger:order.clientIdentifier], nil];
    if (!result) {
        [database close];
        @throw [[NSException alloc] initWithName:kGenericError reason:@"Enable to save the data" userInfo:nil];
    }
    
    NSInteger lastRow = (NSInteger)[database lastInsertRowId] ;
    self.identifier = (lastRow);
    [database close];
    

}
@end

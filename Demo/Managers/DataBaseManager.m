//
//  DataBaseManager.m
//  Demo
//
//  Created by German Pereyra on 12/15/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#define kDataBaseName @"mydatabase.sqlite"

#import "sqlite3.h"
#import "DataBaseManager.h"

@implementation DataBaseManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self SCHEME];
        [self initializeDB];
    }
    return self;
}

- (void)initializeDB {
    FMDatabase *database = [self getDB];
    [database open];
    NSString* path = nil;
    NSString* content = nil;
    path = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"sql"];
    content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSArray *sentences = [content componentsSeparatedByString:@";"];
    for (NSString *query in sentences) {
        if (query.length > 0)
            [database executeUpdate:query];
    }
    
    [database close];
}

- (void)SCHEME {
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:kDataBaseName];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT name, sql FROM sqlite_master WHERE type='table' ORDER BY name", [NSNumber numberWithBool:NO], nil];
    while([results next]) {
        
        NSLog(@"%@",[results stringForColumn:@"name"]);
        NSLog(@"%@",[results stringForColumn:@"sql"]);
    }
    [database close];
}

- (FMDatabase *)getDB {
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:kDataBaseName];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    return database;
}


@end

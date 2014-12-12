//
//  DataBaseManager.m
//  Demo
//
//  Created by German Pereyra on 12/12/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#define kDataBaseName @"mydatabase.sqlite"

#import "sqlite3.h"
#import "FMDatabase.h"
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

- (void)initializeDB{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:kDataBaseName];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
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

- (void)SCHEME{
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

/*
- (void)insert{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:kDataBaseName];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    BOOL result = [database executeUpdate:@"INSERT INTO Patients (createdAt, lastName, name, doctor) VALUES (?, ?, ?, ?)",[NSDate date], self.lastName, self.name, [NSNumber numberWithInteger:self.doctor.identifier], nil];
    if (!result) {
        [database close];
        @throw [[NSException alloc] initWithName:kGenericError reason:@"Enable to save the data" userInfo:nil];
    }
    
    NSInteger lastRow = (NSInteger)[database lastInsertRowId] ;
    self.identifier = (lastRow);
    [database close];

}
*/

@end

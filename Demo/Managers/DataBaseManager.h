//
//  DataBaseManager.h
//  Demo
//
//  Created by German Pereyra on 12/12/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataBaseManager : NSObject
@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
- (void)loadDB;
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;
@end

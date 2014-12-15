//
//  DataBaseManager.h
//  Demo
//
//  Created by German Pereyra on 12/15/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DataBaseManager : NSObject
- (FMDatabase *)getDB;
@end

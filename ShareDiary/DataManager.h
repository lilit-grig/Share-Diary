//
//  DataManager.h
//  ShareDiary
//
//  Created by macbook on 10.11.16.
//  Copyright © 2016 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (instancetype)sharedManager;

- (void)saveContext;

- (NSManagedObjectContext *)context;

@end

//
//  DLAppDelegate.h
//  Delayed
//
//  Created by Win Raguini on 9/6/14.
//  Copyright (c) 2014 Win Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

//
//  SMDatabaseManager.m
//  Smart Manager
//
//  Created by Ketan Nandha on 15/03/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import "SMDatabaseManager.h"

#define kVideoEntity @"VideoDetail"

@implementation SMDatabaseManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(SMDatabaseManager *) theSingleTon{
    static SMDatabaseManager *theSingleTon = nil;
    
    if (!theSingleTon) {
        
        theSingleTon = [[super allocWithZone:nil] init
                        ];
    }
    return theSingleTon;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    
    return [self theSingleTon];
}

-(id)init {
    
    self = [super init];
    if (self) {
        // Set Variables
        [self managedObjectContext];
    }
    
    return self;
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ImageDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ImageDataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)insertImageDetailsInDatabase:(NSMutableArray*)arrmImageDetails
{
    
    for (NSDictionary *dictProduct in arrmImageDetails) {
        NSManagedObjectContext *moc =
        self.managedObjectContext;
        
        ImageDetails *objImageDetail = [NSEntityDescription
                               insertNewObjectForEntityForName:@"ImageDetails"
                               inManagedObjectContext:moc];
        [objImageDetail setClientID:dictProduct[@"ClientID"]];
        [objImageDetail setImageFileName:dictProduct[@"ImageFileName"]];
        [objImageDetail setImagePath:dictProduct[@"ImagePath"]];
        [objImageDetail setImagePriority:dictProduct[@"ImagePriority"]];
        [objImageDetail setModuleIdentifier:dictProduct[@"ModuleIdentifier"]];
        [objImageDetail setMemberID:dictProduct[@"MemberID"]];
        [objImageDetail setVehicleStockID:dictProduct[@"StockID"]];
      
        NSError *mocSaveError = nil;
        
        if (![moc save:&mocSaveError])
        {
            NSLog(@"Save did not complete successfully. Error: %@",
                  [mocSaveError localizedDescription]);
        }
        else
        {
            NSLog(@"Saved successfully");
        }
        
    }
    
}

-(void)insertVideosDetailsInDatabase:(NSMutableArray*)arrmImageDetails
{
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:kVideoEntity inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:productEntity];
    
    for (NSDictionary *dictProduct in arrmImageDetails) {
        
        NSPredicate *p=[NSPredicate predicateWithFormat:@"videoFullPath == %@", dictProduct[@"VideoFullPath"]];
        [fetch setPredicate:p];
        NSError *fetchError;
        NSArray *fetchedData=[[self managedObjectContext] executeFetchRequest:fetch error:&fetchError];
        
        if (fetchedData.count == 0) {

        NSManagedObjectContext *moc =        self.managedObjectContext;
        
        
        
        VideoDetail *objVideoDetails = [NSEntityDescription
                                        insertNewObjectForEntityForName:kVideoEntity
                                        inManagedObjectContext:moc];
        
        [objVideoDetails setClientID:dictProduct[@"ClientID"]];
        [objVideoDetails setMemberID:dictProduct[@"MemberID"]];
        [objVideoDetails setVideoFullPath:dictProduct[@"VideoFullPath"]];
        [objVideoDetails setVariantId:dictProduct[@"VariantId"]];
        [objVideoDetails setVideoTitle:dictProduct[@"VideoTitle"]];
        [objVideoDetails setVideoDescription:dictProduct[@"VideoDescription"]];
        [objVideoDetails setVideoTags:dictProduct[@"VideoTags"]];
        [objVideoDetails setSearchable:dictProduct[@"Searchable"]];
        [objVideoDetails setModuleIdentifier:dictProduct[@"ModuleIdentifier"]];
        [objVideoDetails setYoutubeID:dictProduct[@"YoutubeID"]];
        
        NSError *mocSaveError = nil;
            
            if (![moc save:&mocSaveError])
            {
                NSLog(@"Save did not complete successfully. Error: %@",
                      [mocSaveError localizedDescription]);
            }
            else
            {
                NSLog(@"Saved successfully");
            }
        }
 
    }
    
}
#pragma mark -  Fetch cart products

-(NSMutableArray*)fetchImageDetails {
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc]init];
    
    //setting the predicate format so that we can get the child name by supplying the mother name
    
    [fetchReq setEntity:[NSEntityDescription entityForName:@"ImageDetails" inManagedObjectContext:self.managedObjectContext]];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]initWithArray:[self.managedObjectContext executeFetchRequest:fetchReq error:nil]];
    
    
    return resultArray;
    
}

-(NSMutableArray*)fetchVideoDetails {
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc]init];
    
    //setting the predicate format so that we can get the child name by supplying the mother name
    
    [fetchReq setEntity:[NSEntityDescription entityForName:kVideoEntity inManagedObjectContext:self.managedObjectContext]];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]initWithArray:[self.managedObjectContext executeFetchRequest:fetchReq error:nil]];
    
    
    return resultArray;
    
}


#pragma mark -  Delete data

-(void) removeAllRecords
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ImageDetails"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    [_persistentStoreCoordinator executeRequest:delete withContext:self.managedObjectContext error:&deleteError];
    NSLog(@"All records deleted");

}

-(void) removeAllRecordsForVideos
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kVideoEntity];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    [_persistentStoreCoordinator executeRequest:delete withContext:self.managedObjectContext error:&deleteError];
    NSLog(@"All videos records deleted");
    
}

-(void)removeUploadedImageFromDatabase:(NSString*)imageNameToBeDeleted {
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"ImageDetails" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:productEntity];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"imageFileName == %@", imageNameToBeDeleted];
    [fetch setPredicate:p];
    NSError *fetchError;
    
    NSArray *fetchedData=[[self managedObjectContext] executeFetchRequest:fetch error:&fetchError];
    
    
    for (NSManagedObject *imageObj in fetchedData) {
        [[self managedObjectContext] deleteObject:imageObj];
    }
    NSError *mocSaveError = nil;
    
    if (![[self managedObjectContext] save:&mocSaveError]) {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
    else
    {
        NSLog(@"uploaded image-%@ deleted successfully",imageNameToBeDeleted);
    }
    
}

-(void)removeUploadedVideoFromDatabase:(NSString*)videoYoutubeIDToBeDeleted {
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:kVideoEntity inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:productEntity];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"videoFullPath == %@", videoYoutubeIDToBeDeleted];
    [fetch setPredicate:p];
    NSError *fetchError;
    
    NSArray *fetchedData=[[self managedObjectContext] executeFetchRequest:fetch error:&fetchError];
    
    for (NSManagedObject *imageObj in fetchedData) {
        [[self managedObjectContext] deleteObject:imageObj];
    }
    NSError *mocSaveError = nil;
    
    if (![[self managedObjectContext] save:&mocSaveError]) {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
    else
    {
        NSLog(@"uploaded image-%@ deleted successfully",videoYoutubeIDToBeDeleted);
    }
    
}


@end

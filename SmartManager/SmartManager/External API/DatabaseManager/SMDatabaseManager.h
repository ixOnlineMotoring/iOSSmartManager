//
//  SMDatabaseManager.h
//  Smart Manager
//
//  Created by Ketan Nandha on 15/03/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDetails+CoreDataClass.h"
#import "VideoDetail+CoreDataClass.h"


@interface SMDatabaseManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(SMDatabaseManager *) theSingleTon;;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)insertImageDetailsInDatabase:(NSMutableArray*)arrmImageDetails;
-(NSMutableArray*)fetchImageDetails;
-(void) removeAllRecords;
-(void)removeUploadedImageFromDatabase:(NSString*)imageNameToBeDeleted;

-(void)insertVideosDetailsInDatabase:(NSMutableArray*)arrmImageDetails;
-(NSMutableArray*)fetchVideoDetails;
-(void) removeAllRecordsForVideos;
-(void)removeUploadedVideoFromDatabase:(NSString*)videoYoutubeIDToBeDeleted;

@end

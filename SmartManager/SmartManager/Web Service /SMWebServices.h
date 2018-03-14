//
//  SMWebServices.h
//  SmartManager
//
//  Created by Liji Stephen on 05/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMWebServices : NSObject

// added by ketan to make constant string

+ (NSString*) WEBSERVICEAUTHENTICATEURI;
+ (NSString*) WEBSERVICETRADEURI;
+ (NSString*) WEBSERVICEISTOCKURI;
+ (NSString*) WEBSERVICEBLOGURI;
+ (NSString*) WEBSERVICEPLANNERURI;
+ (NSString*) uploadVideosWebserviceUrl;

+(NSString *) activeSpecailListingImage;

+(NSString*)blogImageUrl;
+(NSString*)blogWebserviceUrl;
+(NSMutableURLRequest*)loginWithUsername:(NSString*)userName andPassword:(NSString*)password;

+(NSMutableURLRequest*)getAllBlogTypesCorrespondingToUserHash:(NSString*)userHash;

+ (NSMutableURLRequest*)getAllImpersonateClientWithUserHash:(NSString*)userHash;

+(NSMutableURLRequest*)SaveDeviceTokenOfOneSignalWithUserHash:(NSString*)userHash andCodeType:(int)codeType andDeviceCode:(NSString*) deviceCode;

+(NSMutableURLRequest*)getAllAppNotifications:(NSString*)userHash andPageSize:(int)pageSize andPageNum:(int) pageNum;

+(NSMutableURLRequest*)markNotificationAsRead:(NSString*)userHash andNotificationID:(int)notificationId;

+(NSMutableURLRequest*)searchAppNotifications:(NSString*)userHash andSearchKey:(NSString*)searchKey andPageSize:(int)pageSize andPageNum:(int) pageNum;

+(NSMutableURLRequest*)saveTheBlogDataWithUserHashValue:(NSString*)userHash andBlogPostTypeID:(int)blogPostTypeID andBlogTitle:(NSString*)title andBlogDetails:(NSString*)blogDetails andStartDate:(NSString*)startDate andEndDate:(NSString*)endDate andAuthor:(NSString*)authorName andActiveStatus:(BOOL)activeStatus andUserID:(NSString*)userID andClientID:(NSString*)clientID andBlogPostID:(int)blogPostID;

+(NSMutableURLRequest*)saveTheImagesToTheServerWithUserHashValue:(NSString*)userHash andClientID:(int)clientID andBlogPostID:(int)blogPostID andUserID:(int)userID andPriority:(int)priority andOriginalFileName:(NSString*)originalFileName andEncodedImage:(NSString*)encodedImage;

+(NSMutableURLRequest*)searchForTheActiveBlogWithUserHash:(NSString*)userHash andClientID:(int)clientID andSearchText:(NSString*)searchText andStartDate:(NSString*)startDate andEndDate:(NSString*)endDate andStartIndex:(int)startIndex andPageSize:(int)npageSize;

+(NSMutableURLRequest*)searchForTheInactiveBlogWithUserHash:(NSString*)userHash andClientID:(int)clientID andSearchText:(NSString*)searchText andStartDate:(NSString*)startDate andEndDate:(NSString*)endDate andStartIndex:(int)startIndex;;

+(NSMutableURLRequest*)getTheBlogToEditCorrespondingToUserHash:(NSString*)userHash andBlogPostId:(int)blogPostID;

+(NSMutableURLRequest*)getTheBlogImagesToEditCorrespondingToUserHash:(NSString*)userHash andBlogPostId:(int)blogPostID;

+(NSMutableURLRequest*)deleteTheBlogImageCorrespondingToUserHash:(NSString*)userHash andBlogPostId:(int)blogPostID;

+(NSMutableURLRequest*)endTheBlogCorrespondingToUserHash:(NSString*)userHash andBlogPostId:(int)blogPostID;

+(NSMutableURLRequest*)updateBlogImagePriorityCorrespondingToUserHash:(NSString*)userHash andBlogImageID:(int)blogImageID andPriority:(int)priority;

+(NSMutableURLRequest*)updateBlogImagePriorityWithImageNameCorrespondingToUserHash:(NSString*)userHash andBlogPostID:(int)blogPostID andPriority:(int)priority andImageName:(NSString*)imageName;


+(NSMutableURLRequest*)getAllTheClientsAtTheLocationWithUserHashValue:(NSString*)hashValue andLatitude:(double)latitude andLongitude:(double)longitude;

+(NSMutableURLRequest*)getAllThePlannerTypeCorrespondingToUserHash:(NSString*)hashValue andClientID:(int)clientID;

+(NSMutableURLRequest*)getAllTheAvailableClientsCorrespondingToUserHash:(NSString*)hashValue;

+(NSMutableURLRequest*)getAllTheMembersForNewTaskModuleCorrespondingToUserHash:(NSString*)hashValue;

+(NSMutableURLRequest*)saveTHeLogActivityDataToTheserverWithUserHash:(NSString*)userHash andClientID:(int)clientID andPlannerTypeID:(int)plannerTypeID andDetails:(NSString*)details andIsInternal:(BOOL)isInternal andTimeSpent:(int)timeSpentInMinutes andIsToday:(BOOL)isToday andAlternateDate:(NSString*)alternateDate andLocationLatitude:(double)locationLatitude andLocationLongitude:(double)locationLongitude andLocationAddress:(NSString*)locationAddress andClientName:(NSString*)contactPerson;

+(NSMutableURLRequest*)saveTheNewTaskDataToTheserverWithUserHash:(NSString*)userHash andClientID:(int)clientID andPlannerTypeID:(int)plannerTypeID andRecepientID:(int)recipientID andTitle:(NSString*)title andDetails:(NSString*)details andDate:(NSString*)date andIsCalender:(BOOL)isCalender;

+(NSMutableURLRequest*)saveAllImagesOfNewTaskWithUserHash:(NSString*)userHash andTaskID:(int)taskID andImageDescription:(NSString*)imageDesc andImageFileName:(NSString*)imgFileName andImgBase64String:(NSString*)baseString;

+(NSMutableURLRequest*)getAllTheToDoMembersForLocationWithUserHash:(NSString*)userHash andCoreMemberID:(int)memberID andLatitude:(double)latitude andLogitude:(double)longitude;

+(NSMutableURLRequest*)getAllTheToDoMembersWithPeriodWithUserHash:(NSString*)userHash andCoreMemberID:(int)memberID andFromDate:(NSString*)fromDate andToDate:(NSString*)toDate;

+(NSMutableURLRequest*)getAllTheToDoMembersWithUserHash:(NSString*)userHash andCoreMemberID:(int)memberID;

+(NSMutableURLRequest*)acceptPlannerToDoTaskWithUserHash:(NSString*)hashValue andTaskID:(int)taskID andOptionalComment:(NSString*)comment;

+(NSMutableURLRequest*)rejectPlannerToDoTaskWithUserHash:(NSString*)hashValue andTaskID:(int)taskID andOptionalReason:(NSString*)reason;

+(NSMutableURLRequest*)saveCommentOfPlannerToDoTaskWithUserHash:(NSString*)hashValue andTaskID:(int)taskID andOptionalComment:(NSString*)comment;

+(NSMutableURLRequest*)getTheDetailsOfToDosTaskWithUserHash:(NSString*)hashValue andTaskID:(int)taskID;

+(NSMutableURLRequest*)closeThePlannerToDoTaskWithUserHash:(NSString*)hashValue andTaskID:(int)taskID andOptionalReason:(NSString*)reason;

+(NSMutableURLRequest*)getTheNewTaskImagesWithUserHash:(NSString*)hashValue andTaskID:(int)taskID;

+(NSMutableURLRequest*)getTheTasksByMeCorrespondingToUserHash:(NSString*)hashValue andCoreMemberID:(int)memberID;

+(NSMutableURLRequest*)NoCanDoTaskWithUserHash:(NSString*)hashValue andPlannerTaskId:(int)taskID andOptionalComment:(NSString*)comment;

+(NSMutableURLRequest*)filterThePhotosNExtrasBasedOnSearchWithUserHash:(NSString*)hashValue andClientID:(int)clientID andsearchKeyword:(NSString*)searchText andPageSize:(int)pageSize andPageNumber:(int)pageNumber andSortText:(NSString*)sortText;

+(NSMutableURLRequest*)filterThePhotosNExtrasBasedOnSearchWithUserHash:(NSString*)hashValue andClientID:(int)clientID andsearchKeyword:(NSString*)searchText andPageSize:(int)pageSize andPageNumber:(int)pageNumber andStatus:(int)status andSortText:(NSString*)sortText andNewUsed:(NSString*) newUsed;

+(NSMutableURLRequest*) gettingAllVarintsvaluesForSpecials:(NSString *) userHash
                                                      Year:(NSString*)year
                                                   modelId:(int)modelId;

// =================================== End of Liji's Module =====================================================================
+(NSMutableURLRequest*) gettingAllMakevalues:(NSString *) userHash;
// for getting all Make Values

+(NSMutableURLRequest*) gettingAllMakevaluesForSpecials:(NSString *) userHash
                                                   Year:(NSString*)year;

+(NSMutableURLRequest*) gettingAllModelsvaluesForSpecials:(NSString *) userHash
                                                     Year:(NSString*)year
                                                   makeId:(int)makeId;

+(NSMutableURLRequest*) gettingAllVarinatsValues:(NSString *) strUserHash withModel:(int) iModelId;
+(NSMutableURLRequest*) gettingAllListingForVehicle:(NSString *) userHash withClientID:(int) iClientID withPageSize:(int) iPageSize withPageNumber:(int) iPageNumber;

+(NSMutableURLRequest *) gettingSelectedVehicleInformation:(NSString *) strUserHash withClientID:(NSString *) strClientID withSelectedVehicleID:(NSString *) strVehicleID;

// ***********************************FOR TRADER MODULE *******************************

// ****FOR VEHICLES MODULE

+(NSMutableURLRequest*) gettingAllMakevaluesForVehicles:(NSString *) userHash
                                                  Year:(NSString*)year;
+(NSMutableURLRequest*) gettingAllModelsvaluesForVehicles:(NSString *) userHash
                                                    Year:(NSString*)year
                                                  makeId:(int)makeId;
+(NSMutableURLRequest*) gettingAllVarintsvaluesForVehicles:(NSString *) userHash
                                                     Year:(NSString*)year
                                                  modelId:(int)modelId;
+(NSMutableURLRequest*) gettingDetailsOfVINForVehicles:(NSString *) userHash
                                            variantId:(int)variantId;

+(NSMutableURLRequest*) gettingDetailsForEditStockVehicles:(NSString *) userHash
                                                 variantId:(int)variantId;

+(NSMutableURLRequest*) gettingVINScanForVehicles:(NSString* ) userHash
                                        clientID:(int)clientID
                                             vin:(NSString*)vin
                                    registration:(NSString*)registration
                                          makeId:(NSString*)makeId
                                         modelId:(NSString*)modelId;

+(NSMutableURLRequest*) SavedVinScanForLater:(NSString *) userHash
                                    clientID:(int)clientID
                                         vin:(NSString*)vin
                                registration:(NSString*)registration
                                       shape:(NSString*)shape
                                        year:(NSString*)year
                                      makeId:(NSString*)makeId
                                     modelId:(NSString*)modelId
                                     variant:(NSString*)variant
                                      colour:(NSString*)colour
                                    engineNo:(NSString*)engineNo
                                  kilometers:(NSString*)kiloMeters
                                  extrasCost:(NSString*)extrasCost
                                   condition:(NSString*)condition
                                   licExpiry:(NSString*)licExpiry
                                    variantid:(NSString*)variantId;

+(NSMutableURLRequest*) ValidateVINForVehicles:(NSString *) userHash
                                          vin:(NSString*)vin;
+(NSMutableURLRequest*)gettingSavedVINForVehicles:(NSString *) userHash
                                         clientID:(NSString*)clientID;
+(NSMutableURLRequest*) fectchListVehicleTypeForUserhash:(NSString *) userHash;
+(NSMutableURLRequest*) AddVehicleFoUserhash:(NSString *) userHash
                                    ClientID:(int) iClientID
                                     Colour:(NSString *) Colour
                                   Comments:(NSString *) Comments
                                  Condition:(NSString *) Condition
                               DeleteReason:(NSString *) DeleteReason
                               DepartmentID:(int) DepartmentID
                                   EngineNo:(NSString *) EngineNo
                                     Extras:(NSString *) Extras
                         FullServiceHistory:(Boolean) FullServiceHistory
                               IgnoreImport:(Boolean) IgnoreImport
                               InternalNote:(NSString *) InternalNote
                                  IsDeleted:(Boolean) IsDeleted
                                  IsProgram:(Boolean) IsProgram
                                   IsRetail:(Boolean) IsRetail
                                   IsTender:(Boolean) IsTender
                                    IsTrade:(Boolean ) IsTrade
                                   Location:(NSString *) Location
                                     MMCode:(NSString *) MMCode
                      ManufacturerModelCode:(NSString *) ManufacturerModelCode
                                    Mileage:(int) Mileage
                               OriginalCost:(double) OriginalCost
                                   Override:(Boolean) Override
                             OverrideReason:(NSString *) OverrideReason
                            PlusAccessories:(double ) PlusAccessories
                                  PlusAdmin:(double ) PlusAdmin
                                PlusMileage:(double) PlusMileage
                                  PlusRecon:(double ) PlusRecon
                                      Price:(double) Price
                                ProgramName:(NSString *) ProgramName
                               Registration:(NSString *) Registration
                        ShowErrorDisclaimer:(Boolean) ShowErrorDisclaimer
                                    Standin:(double) Standin
                                  StockCode:(NSString *) StockCode
                                TouchMethod:(NSString *) TouchMethod
                                 TradePrice:(double) TradePrice
                                       Trim:(NSString *) Trim
                         UsedVehicleStockID:(int) UsedVehicleStockID
                                   UsedYear:(int) UsedYear
                                        VIN:(NSString *) VIN;

+(NSMutableURLRequest*) updateVehicleInfomationIfAlreadyInStock:(NSString *) userHash
                                                         Colour:(NSString *) Colour
                                                       Comments:(NSString *) Comments
                                                      Condition:(NSString *) Condition
                                                   DeleteReason:(NSString *) DeleteReason
                                                   DepartmentID:(int) DepartmentID
                                                       EngineNo:(NSString *) EngineNo
                                                         Extras:(NSString *) Extras
                                             FullServiceHistory:(Boolean) FullServiceHistory
                                                   IgnoreImport:(Boolean) IgnoreImport
                                                   InternalNote:(NSString *) InternalNote
                                                      IsDeleted:(Boolean) IsDeleted
                                                      IsProgram:(Boolean) IsProgram
                                                       IsRetail:(Boolean) IsRetail
                                                       IsTender:(Boolean) IsTender
                                                        IsTrade:(Boolean ) IsTrade
                                                       Location:(NSString *) Location
                                                         MMCode:(NSString *) MMCode
                                          ManufacturerModelCode:(NSString *) ManufacturerModelCode
                                                        Mileage:(int) Mileage
                                                   OriginalCost:(double) OriginalCost
                                                       Override:(Boolean) Override
                                                 OverrideReason:(NSString *) OverrideReason
                                                PlusAccessories:(double ) PlusAccessories
                                                      PlusAdmin:(double ) PlusAdmin
                                                    PlusMileage:(double) PlusMileage
                                                      PlusRecon:(double ) PlusRecon
                                                          Price:(double) Price
                                                    ProgramName:(NSString *) ProgramName
                                                   Registration:(NSString *) Registration
                                            ShowErrorDisclaimer:(Boolean) ShowErrorDisclaimer
                                                        Standin:(double) Standin
                                                      StockCode:(NSString *) StockCode
                                                    TouchMethod:(NSString *) TouchMethod
                                                     TradePrice:(double) TradePrice
                                                           Trim:(NSString *) Trim
                                             UsedVehicleStockID:(int) UsedVehicleStockID
                                                       UsedYear:(int) UsedYear
                                                            VIN:(NSString *) VIN;

+(NSMutableURLRequest*) lisAddToTenderForUserhash:(NSString* ) userHash;



+(NSMutableURLRequest*) removeVINscan:(NSString *) strUserHash withClientID:(int) strClientID withSaveScanID:(int) strsaveScanID;


#pragma mark - Special

+(NSMutableURLRequest *) gettingALlSpeacialTypeListing:(NSString *) strUserHash withClientID:(int) iClientID;

+(NSMutableURLRequest *) getSpecialVehiclesListing:(NSString *) strUserHash withClientID:(int) iClientID withVehicleType:(NSString*)vehicleType;

+(NSMutableURLRequest *) gettingAllActiveSpecialListing:(NSString *) strUserHash withClientID:(int) iClientID withStartAt:(int) iStartAt withTake:(int)iTake;

+(NSMutableURLRequest *) gettingAllExpiredSpecialListing:(NSString *) strUserHash withClientID:(int) iClientID withStartAt:(int) iStartAt withTake:(int)iTake;

+(NSMutableURLRequest *) gettingAllUnPublishedSpecialListing:(NSString *) strUserHash withClientID:(int) iClientID withStartAt:(int) iStartAt withTake:(int)iTake;

+(NSMutableURLRequest *) getAllListOfUsedVechicleInStock:(NSString *) strUserHash withClientID:(int) iclientID wihtMakeID:(int) iMakeID withModelId:(int) iModelId withVariantID:(int) iVariantID withSpecialTypeLoaded:(NSString *) strLoadedSpecialType;

+(NSMutableURLRequest *) editSpecial:(NSString *) strUserHash withClientID:(int) iClientID withSpecialID:(int)specialID;

+(NSMutableURLRequest *) deleteSpecial:(NSString *) strUserHash withSpecialID:(int)specialID withIsExpired:(BOOL) isExpired;

+(NSMutableURLRequest *) publishSpecial:(NSString *) strUserHash withClientID:(int) iClientID withSpecialID:(int)specialID;

+(NSMutableURLRequest *) deleteSpecial:(NSString *) strUserHash withClientID:(NSString *)strClientID withSpecialID:(NSString *) specialID withCurrentUserID:(NSString *)strCurrentID;

+(NSMutableURLRequest *) deleteSpecialImage:(NSString *) strUserHash withSpecialID:(int) specialImageID;

+(NSMutableURLRequest *) updateSpecialImagePriority:(NSString* ) strUserHash withSpecialImageID:(int)specialImageID withLinkImagePriority:(int)linkImagePriority;
+(NSMutableURLRequest *) GetSpecialBySpecialID:(NSString *) strUserHash withClientID:(int)intClientID withSpecialID:(int)specialID;

+(NSMutableURLRequest *)  SaveSpecialWithImage:(NSString *) struserHash
                                  withClientID:(int) iClientID
                                 withspecialID:(int) iSpeciaID
                          withoriginalFileName:(NSString *) strFileName
                        withBaseEncodingString:(NSString *) strbase64ImageString;


// **** END FOR VEHICLES MODULE

// *********************************** START FOR PHOTOS & EXTRAS MODULE *******************************Sandeep*****

//  START FOR PHOTOS & EXTRAS MODULE Sandeep*

+(NSMutableURLRequest *) gettingVehiclePhotosAndExtrasList:(NSString *) strUserHash withstatusID :(int) iStatusID withClientID:(int) iClientID withPageSize:(int) iPageSize withPageNumber:(int) iPageNumber sort:(NSString *)sort andNewUsed:(NSString *) newUsedVehicle;


+(NSMutableURLRequest *)addImageToVehicleBase64ForUserHash:(NSString *)userHash usedVehicleStockID:(int)usedVehicleStockID imageBase64:(NSString *)imageBase64 imageName:(NSString *)imageName imageTitle:(NSString *)imageTitle imageSource:(NSString *)imageSource imagePriority:(int)imagePriority imageIsEtched:(BOOL)imageIsEtched imageIsBranded:(BOOL)imageIsBranded imageAngle:(NSString *)imageAngle;

+(NSMutableURLRequest *)gettingListOfVehiclesImagesBase64ForUserHash:(NSString *)userHash usedVehicleStockID:(int)usedVehicleStockID imageBase64:(NSString *)imageBase64 imageName:(NSString *)imageName imageTitle:(NSString *)imageTitle imageSource:(NSString *)imageSource imagePriority:(int)imagePriority imageIsEtched:(BOOL)imageIsEtched imageIsBranded:(BOOL)imageIsBranded imageAngle:(NSString *)imageAngle;

+(NSMutableURLRequest *)gettingListOfVehiclesImagesListForUserHash:(NSString *)userHash usedVehicleStockID:(int)usedVehicleStockID;

+(NSMutableURLRequest *)changeVehicleImagePriorityForUserHash:(NSString *)userHash usedVehicleStockID:(int)usedVehicleStockID imageID:(int)imageID newPriorityID:(int)newPriorityID;


+(NSMutableURLRequest *)removeCommentImageFromVehicleWithUserHash:(NSString *)userHash usedVehicleStockID:(int)usedVehicleStockID imageID:(int)imageID;

+(NSMutableURLRequest *)updateVehicleExtrasAndCommentsForUserHash:(NSString *)userHash usedVehicleStockID:(int)usedVehicleStockID comments:(NSString *)comments extras:(NSString *)extras;

+(NSMutableURLRequest *)gettingLoadVehiclesImagesListForUserHash:(NSString *)userHash usedVehicleStockID:(int)usedVehicleStockID;

+(NSMutableURLRequest *)  createSpecial:(NSString *)        struserHash
                           withClientID:(int)                iClientID
                      withSpecialTypeID:(int)           iSpecialTypeId
                   withDateSpecialStart:(NSString *) strDateSpecialStart
                      withendSpecialEnd:(NSString *)    strEndendSpecialEnd
                             withItemID:(int)                  iStrItemID
                          withvariantID:(int)               ivariantID
                            withModelID:(int)                 iModelID
                             withMakeID:(int)                  iMakeID
                       withspecialPrice:(NSString *)         specialPrice
                        withnormalPrice:(NSString *)      normalPrice
                            withDetails:(NSString *)          strdetails
                            withSummary:(NSString *)          strsummary
                         withallowGroup:(Boolean)             strallowGroup
                         withcorrection:(Boolean)             withcorrection
                          withSpecailID:(int)               withspecialId
                          withItemValue:(NSString *)          strItemValue
                               withYear:(NSString*)                      strYear;

+(NSMutableURLRequest *)getSpecialImagesBySpecialIDWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withSpecailID:(int)specialID;

// **** END FOR PHOTOS & EXTRAS MODULE

#pragma mark - Start of Trader Sell Module

// added by ketan

// ********** Start of Trader Sell Module *******

#pragma mark - Get Search List For Vehicle Web Service

+(NSMutableURLRequest*) gettingSearchListingVehicle:(NSString *) strUserHash withClientID:(int) iClientId withMinYear:(int) iMinYear withMaxYear:(int) iMaxYear withMakeId:(int) iMakeId withModelID:(int) iModelID withVariant:(int) iVariantID withCount:(int) iCount withPage:(int) iPage withIsTrade:(BOOL) isTrade isTender:(BOOL)isTender isPrivate:(BOOL)isPrivate isFactory:(BOOL) isFactory andSortText:(NSString*)sortText;

#pragma mark - LoadVehicle Web Service

+(NSMutableURLRequest *) gettingDetailsVehicleImages:(NSString *) strUserHash withClientID:(int) iClientId withVehicleId:(int) iVehicleID;

#pragma mark - Buy Vehicle Web Service

+(NSMutableURLRequest *) buyVehicle:(NSString *) strUserHash withClientId:(int) iClientID withUserID:(int) userId withVehicleID:(int) iVehicleID strAmount:(NSString *) strAmount;

#pragma mark - Place Bid For Trader Web Service

+(NSMutableURLRequest *) placeBid:(NSString *) strUserHash withClientID:(int) iClientID withUserID:(int) userId withVehicleID:(int) iVehicleID withAmount:(NSString *) strAmount;

#pragma mark - Place Automated Bidding For Trader Web Service

+(NSMutableURLRequest * ) placeAutomatedBidding:(NSString *) strUserHash withClientID:(int) iClientID withUserID:(int) userId withVehicleID:(int) iVehicleID withAmount:(int) strAmount withBidLimit:(int) bidLimit;

#pragma mark - RemoveAutoBids For Trader Web Service

+(NSMutableURLRequest *)removingAutoBidCapWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withVehicleID:(int)iVehicleID;

#pragma mark - For Get Counts For Sells in Trader

+(NSMutableURLRequest *)getCountsWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID;

#pragma mark - For AcceptBid For Sells in Trader

+(NSMutableURLRequest *)acceptBidTradeUserHash:(NSString *)strUserHash withClientID:(int)iClientID withVehicleID:(int)iVehicleID withBidValue:(int)iBidValue;

#pragma mark - For ActionRequired For Sells in Trader

+(NSMutableURLRequest *)actionRequiredWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID;

#pragma mark - For AvailableToTrade For Sells in  Trader

+(NSMutableURLRequest *)availableToTradeUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize;

#pragma mark - For ExtendBidding For Sells in Trader

+(NSMutableURLRequest *)extendBiddingUserHash:(NSString *)strUserHash withClientID:(int)iClientID withVehicleID:(int)iVehicleID;

#pragma mark - For ListBids For Sells in Trader

+(NSMutableURLRequest *)listBidsWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withVehicleID:(int)iVehicleID;

#pragma mark - For NotAvailableToTrade For Sells in Trader

+(NSMutableURLRequest *)notAvailableToTradeUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize;

#pragma mark - For RejectBid For Sells in Trader

+(NSMutableURLRequest *)rejectBidTradeUserHash:(NSString *)strUserHash withClientID:(int)iClientID withVehicleID:(int)iVehicleID withBidValue:(int)iBidValue;

#pragma mark - For ListActiveBids For Sells in Trader

+(NSMutableURLRequest *)listActiveBidsWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize;

#pragma mark - For TradePeriodEnded For Sells in Trader

+(NSMutableURLRequest *)tradePeriodEndedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize;

#pragma mark - For Get BuyingCounts for Sells For Trader

+(NSMutableURLRequest *)getBuyingCountsWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate;

#pragma mark - For WinningBids For My Bids in Trader

+(NSMutableURLRequest *)winningBidsPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize;

#pragma mark - For LosingBids For My Bids in Trader

+(NSMutableURLRequest *)losingBidsPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize;

#pragma mark - For BidsWonPaged For My Bids in Trader

+(NSMutableURLRequest *)bidsWonPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate withPage:(int)page withPageSize:(int)pageSize;

#pragma mark - For BidsLostPaged For My Bids in Trader

+(NSMutableURLRequest *)bidsLostPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate withPage:(int)page withPageSize:(int)pageSize;

+(NSMutableURLRequest *)bidsPrivatePagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate withPage:(int)page withPageSize:(int)pageSize;

+(NSMutableURLRequest *)bidsCancelledPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate withPage:(int)page withPageSize:(int)pageSize;

+(NSMutableURLRequest *)bidsWithdrawnPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate withPage:(int)page withPageSize:(int)pageSize;

+(NSMutableURLRequest *)AutomatedBidsPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize;

+(NSMutableURLRequest *)bidsLostCountWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate;

+(NSMutableURLRequest *)bidsWonCountWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate;

+(NSMutableURLRequest *)bidsLoosingCountWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID;

+(NSMutableURLRequest *)bidsWinningCountWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID;

#pragma mark - Get Make For Wanted

+(NSMutableURLRequest *)getMakeWithUserHash:(NSString *)strUserHash withFromYear:(int)fromYear withToYear:(int)toYear;

#pragma mark - Get Model For Wanted

+(NSMutableURLRequest *)getModelWithUserHash:(NSString *)strUserHash withMakeID:(int)makeID withFromYear:(int)fromYear withToYear:(int)toYear;

#pragma mark - Get Variant For Wanted

+(NSMutableURLRequest *)getVariantWithUserHash:(NSString *)strUserHash withModelID:(int)modelID withFromYear:(int)fromYear withToYear:(int)toYear;

#pragma mark - ListActiveWantedSearch

+(NSMutableURLRequest *)listActiveWantedSearchWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID;

#pragma mark - ListActiveWantedSearchWithCountXML

+(NSMutableURLRequest *)listActiveWantedSearchWithCountXMLWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID;

#pragma mark - SearchResultCount

+(NSMutableURLRequest *)searchResultCountWithUserHash:(NSString *)strUserHash withWantedSearchID:(int)wantedSearchID;

#pragma mark - WantedSearchResultXML

+(NSMutableURLRequest *)wantedSearchResultXMLWithUserHash:(NSString *)strUserHash withWantedSearchID:(int)wantedSearchID withPageNo:(int)pageNo withCountNo:(int)countNo;

#pragma mark - RegionList

+(NSMutableURLRequest *)getRegionListWithUserHash:(NSString *)strUserHash;

#pragma mark - RemoveWanted

+(NSMutableURLRequest *)removeWantedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withWantedSearchID:(int)wantedSearchID;

#pragma mark - AddToWantedList

+(NSMutableURLRequest *)addToWantedListWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withMakeID:(int)makeID withModelID:(int)modelID withVariantID:(NSString*)strVariant withProvincesID:(NSString*)strProvinces withMaxYear:(int)maxYear withMinYear:(int)minYear;

+(NSMutableURLRequest *)loadAllActivitieswithusehas:(NSString *) userHash withClientID:(int) iClientId withLeadId:(int)iLeadID;

+(NSMutableURLRequest *)addThePhoneOrEmailActivitywithUserHash:(NSString*) userHash withClientID:(int)clientID withLeadID:(int)leadID withActivity:(int)activity withChangeStatus:(BOOL)changeStatus andWithComment:(NSString *)comment;

+(NSMutableURLRequest *)addNewActivity:(NSString *) userHash withClientID:(int) iClientId withLeadId:(int)iLeadID withActivityID:(int) iactivityID withChaangeStatus:(int) istatus withComment:(NSString *) strComment invoiceNum:(NSString*) invoiceNum inVoiceDate:(NSString*) invoiceDate invoiceAmount:(float)invoiceAmount invoiceTo:(NSString*) invoiceTo Salesperson:(NSString*) salesPerson stockNum:(NSString*) stockNum departmentID:(int) deptID typeID:(int) typeID GenderID:(int) genderID RaceID:(int) raceID Age:(int) age;


#pragma mark - Leads list

+(NSMutableURLRequest *)getTheLeadsListWithUserHash:(NSString*)userHash andClientID:(int)clientID andKeyword:(NSString*)searchKey andOrder:(int)order andPageNum:(int)pageNum andPageSize:(int)pageSize andSeenStatus:(int) iSeenStatus;


+(NSMutableURLRequest *)loadTheLeadDetailWithUserHash:(NSString*)userHash andClientID:(int)clientID andLeadID:(int)leadID;



+(NSMutableURLRequest *)getTheCustomerDetailsDLScanWithUserHash:(NSString*)userHash andClientID:(int)clientID andBase64LicenseString:(NSString*)base64String;



+(NSMutableURLRequest *)getTheNecessaryStockAuditListWithUserHash:(NSString*)userHash andIsDone:(BOOL)isDone andIsUnmatched:(BOOL)isUnMatched andIsNotDone:(BOOL)isNotDone andClientID:(int)clientID andPageNumber:(int)pageNumber andRecordCount:(int)recordCount;


+(NSMutableURLRequest *)saveStockAuditWithUserHash:(NSString*)userHash andClientID:(int)clientID andVin:(NSString*)vin andRegistration:(NSString*)registration andMake:(NSString*)make andModel:(NSString*)model andColor:(NSString*)color andEngineNum:(NSString*)engineNum andLatitude:(double)latitide andLongitude:(double)longitude andBase64VinImage:(NSString*)vinImage andBase64VehicleImage:(NSString*)vehicleImage;

+(NSMutableURLRequest *)sendTheBrochureWithUserHash:(NSString*)userHash andStockID:(int)StockID andEmailToAddress:(NSString*)emailAddress andComment:(NSString*)comment;


+(NSMutableURLRequest*)listGroupStockVehiclesWithUserHash:(NSString*)hashValue andClientID:(int)clientID andStatus:(int)status andPageSize:(int)pageSize andPageNumber:(int)pageNumber andSortText:(NSString*)sortText andNewUsed:(NSString*) newUsed;

+(NSMutableURLRequest*)listGroupStockVehiclesWithSearch_UserHash:(NSString *)hashValue andClientID:(int)clientID andSearchKey:(NSString *)searchKey andPageSize:(int)pageSize andPageNumber:(int)pageNumber andStatus:(int)status andSortText:(NSString *)sortText andNewUsed:(NSString*) newUsed;

+(NSMutableURLRequest*)getClientCorporateGroupsCorrespondingToUserHash:(NSString*)hashValue andClientId:(int)clientID;

+(NSMutableURLRequest*)getTheAuditHistoryListWithUserHash:(NSString*)hashValue andClientId:(int)clientID andPageNumber:(int)pageNum andRecordCount:(int)recordCount;

+(NSMutableURLRequest*)getTheAuditHistoryDetailstWithUserHash:(NSString*)hashValue andClientId:(int)clientID andDay:(NSString*)selectedDay andPageNumber:(int)pageNum andRecordCount:(int)recordCount;

+(NSMutableURLRequest*)sendAuditHistoryItemsCorrespondingToUserHash:(NSString*)hashValue andClientID:(int)clientID andDay:(NSString*)selectedDay andEmailAddress:(NSString*)emailAddress andAuditedFlag:(BOOL)isAudited andNotAuditedFlag:(BOOL)isNotAudited andNotMatchedFlag:(BOOL)isNotMatched;

+(NSMutableURLRequest*)saveTheDLScanDataWithUserHash:(NSString*)hashValue andClientID:(int)clientID andScanID:(int)scanID andEmailAddress:(NSString*)emailAddress andPhoneNumber:(NSString*)phoneNum;

+(NSMutableURLRequest*)listTheDriverLicencesWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPageNumber:(int)pageNum andRecordCount:(int)recordCnt;


+(NSMutableURLRequest*)removeTheSelectedDriverLicenceWithUserHash:(NSString*)hashValue andClientID:(int)clientID andScanID:(int)scanID;

+(NSMutableURLRequest*)uploadTheVideoFileWithInput:(NSString*)base64VideoChunk;

+(NSMutableURLRequest*)removeTheVideoLinkWithUserHash:(NSString *)hashValue andClientID:(int)clientID andVideoLinkID:(int)videoLinkID;

+(NSMutableURLRequest*)canUserUploadVideoWithUserHash:(NSString *)hashValue andClientID:(int)clientID;

#pragma mark - Vehicle Alert module services;

+(NSMutableURLRequest*)listTheTradeMissingPriceWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPageNumber:(int)pageNum andPageSize:(int)pageSize;

+(NSMutableURLRequest*)listTheTradeActivateRetailWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPageNumber:(int)pageNum andPageSize:(int)pageSize;

+(NSMutableURLRequest*)listTheTradeMissingInfoWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPageNumber:(int)pageNum andPageSize:(int)pageSize;

+(NSMutableURLRequest*)activateTheVehicleWithUserHash:(NSString*)hashValue andClientID:(int)clientID andStockID:(int)stockID andIsTrade:(BOOL)isTrade andTradePrice:(int)tradePrice;


+(NSMutableURLRequest*)setTradeReadinessWithUserHash:(NSString*)hashValue andClientID:(int)clientID andNewDay:(int)newDay andUsedRetailDay:(int)usedRetailDay andUsedDemoDay:(int)usedDemoDay;

+(NSMutableURLRequest*)getTradeReadinessWithUserHash:(NSString*)hashValue andClientID:(int)clientID;

+(NSMutableURLRequest*)setTradeDisplayWithUserHash:(NSString*)hashValue andClientID:(int)clientID andTradePrice:(BOOL)tradePrice andDaysInStock:(BOOL)daysInStock andAppraisal:(BOOL)appraisal;

+(NSMutableURLRequest*)getTradeDisplayWithUserHash:(NSString*)hashValue andClientID:(int)clientID;

+(NSMutableURLRequest*)setTradeAuctionsWithUserHash:(NSString*)hashValue andClientID:(int)clientID andisAcceptBids:(BOOL)acceptBids minBidPercent:(int)minBidPercent minBidIncrease:(int)minBidIncrease buyNowPrice:(int)buyNowPrice availableFrom:(int)availableFrom availableFor:(int)availableFor noBidsExtend:(BOOL)isNoBidExtend extendPeriod:(int)extendPeriod;

+(NSMutableURLRequest*)getTradeAuctionsWithUserHash:(NSString*)hashValue andClientID:(int)clientID
;

+(NSMutableURLRequest *)setSaveTradeCustomMessagesWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPurchase:(NSString *)purchase andOffer:(NSString *)offer andTender:(NSString *)tender;
+(NSMutableURLRequest*)getSaveTradeCustomMessagesWithUserHash:(NSString*)hashValue andClientID:(int)clientID;

+(NSMutableURLRequest*)setTradePriceWithUserHash:(NSString*)hashValue andClientID:(int)clientID andIncrementalPercentage:(float)percentage;

+(NSMutableURLRequest*)getTradePriceWithUserHash:(NSString*)hashValue andClientID:(int)clientID;

/*=====================================================================*/
+(NSMutableURLRequest*)getListTradeMembersWithUserHash:(NSString*)hashValue andClientID:(int)clientID;
+(NSMutableURLRequest*)getLoadTradeMemberWithUserHash:(NSString*)hashValue andClientID:(int)clientID andMemberID:(int)memberID;

+(NSMutableURLRequest *)setSaveTradeMemberWithUserHash:(NSString*)hashValue andClientID:(int)clientID andTradeMemberID:(int)tradeMemberID andMemberID:(int)memberID andMemberName:(NSString *)memberName andCanBuy:(BOOL)canBuy andCanSell:(BOOL)canSell andCanAccept:(BOOL)canAccept andCanDecline:(BOOL)canDecline andIsManager:(BOOL)isManager andIsAuditor:(BOOL)isAuditor;


+(NSMutableURLRequest*)getTradeMyBuyersWithUserHash:(NSString*)hashValue andClientID:(int)clientID;
+(NSMutableURLRequest*)getMySellersWithUserHash:(NSString*)hashValue andClientID:(int)clientID;

+(NSMutableURLRequest*)removeTradeMemberWithUserHash:(NSString*)hashValue andClientID:(int)clientID andTradeMemberID:(int)tradeMemberID andMemberID:(int)memberID;

+(NSMutableURLRequest*)SaveTradePartnerWithUserHash:(NSString*)hashValue andClientID:(int)clientID andSettingID:(int)settingID andTraderPeriod:(int)traderPeriod andAuctionAccess:(int)auctionAccess andTenderAccess:(int)tenderAccess andId:(int)ID andName:(NSString *)name andType:(NSString *)type andTypeID:(int)typeID;

+(NSMutableURLRequest*)SaveTradePartnerSettingWithUserHash:(NSString*)hashValue andClientID:(int)clientID andEveryone:(int)everyone;

+(NSMutableURLRequest*)getListTradePartnersWithUserHash:(NSString*)hashValue andClientID:(int)clientID;

+(NSMutableURLRequest*)removeTradePartnerWithUserHash:(NSString*)hashValue andClientID:(int)clientID andSettingID:(int)settingID andTraderPeriod:(int)traderPeriod andAuctionAccess:(int)auctionAccess andTenderAccess:(int)tenderAccess andId:(int)ID andName:(NSString *)name andType:(NSString *)type andTypeID:(int)typeID;

+(NSMutableURLRequest *)getFromDaysWithUserHash:(NSString*)hashValue;

+(NSMutableURLRequest *)listTradeSalesWithUserHash:(NSString*)hashValue andClientID:(int)clientID andDateTimeFrom:(NSString*)dateTimeFrom andDateTimeTo:(NSString*)dateTimeTo andPage:(int)page andPageSize:(int)pageSize;

+(NSMutableURLRequest *)listTradeSalesSummaryWithUserHash:(NSString*)hashValue andClientID:(int)clientID andDateTimeFrom:(NSString*)dateTimeFrom andDateTimeTo:(NSString*)dateTimeTo;

+(NSMutableURLRequest *)getTradeVehiclesListWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPage:(int)page andPageSize:(int)pageSize;

+(NSMutableURLRequest *)getLoadTradePartnerWithUserHash:(NSString*)hashValue andType:(NSString *)type andSettingsID:(int)settingsID;

+(NSMutableURLRequest *)getAvailableToTradePagedWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPage:(int)page andPageSize:(int)pageSize;

+(NSMutableURLRequest*)getAllTheMembersForSettingsMembersToUserHash:(NSString*)hashValue andClientID:(int)clientID;

+(NSMutableURLRequest*)listBidsForTradeVehicleWithUserHash:(NSString*)hashValue andClientID:(int)clientID andVehicleID:(int)vehicleID;

+(NSMutableURLRequest*)getAllListBuyerRatingQuestionsWithUserHash:(NSString*)hashValue;

+(NSMutableURLRequest*)getAllListSellerRatingQuestionsWithUserHash:(NSString*)hashValue;

+(NSMutableURLRequest*)setAddBuyerRatingWithUserHash:(NSString*)hashValue andUsedVehicleStockID:(int)usedVehicleStockID andTradeOfferID:(int)tradeOfferID andCoreClientID:(int)coreClientID andRatingQuestionID:(int)ratingQuestionID andRatingValue:(int)ratingValue;

+(NSMutableURLRequest*)getRatingQuestionsForBuyerWithUserHash:(NSString*)hashValue andBuyerClientID:(int)buyerClientID andStockID:(int)stockID andTradeOfferID:(int)tradeOfferID andRatingClientID:(int)ratingClientID andRatingMemberID:(int)ratingMemberID;

+(NSMutableURLRequest*)getRatingQuestionsForSellerWithUserHash:(NSString*)hashValue andBuyerClientID:(int)buyerClientID andStockID:(int)stockID andTradeOfferID:(int)tradeOfferID andRatingClientID:(int)ratingClientID andRatingMemberID:(int)ratingMemberID;

+(NSMutableURLRequest*)GetRatingForBuyerWithUserHash:(NSString*)hashValue andBuyerClientID:(int)buyerClientID;

+(NSMutableURLRequest*)GetRatingForSellerWithUserHash:(NSString*)hashValue andSellerClientID:(int)sellerClientID;

+(NSMutableURLRequest*)listMessagesForVehicleWithUserHash:(NSString*)hashValue andUsedVehicleStockID:(int)vehicleStockID;

+(NSMutableURLRequest*)addMessageToVehicleWithUserHash:(NSString*)hashValue andUsedVehicleStockID:(int)vehicleStockID andMessage:(NSString*)message;

+(NSMutableURLRequest*)setAddSellerRatingWithUserHash:(NSString*)hashValue andUsedVehicleStockID:(int)usedVehicleStockID andTradeOfferID:(int)tradeOfferID andCoreClientID:(int)coreClientID andRatingQuestionID:(int)ratingQuestionID andRatingValue:(int)ratingValue;

+(NSMutableURLRequest*)fetchBackTheSellerRatingQuestionsWithUserHash:(NSString*)hashValue WithBuyerClientID:(int)buyerClientID andStockID:(int)stockID andOfferID:(int)offerID andRatingClientID:(int)ratingClientID andRatingMemberID:(int)ratingMemberID;

+(NSMutableURLRequest*)fetchBackTheBuyerRatingQuestionsWithUserHash:(NSString*)hashValue WithBuyerClientID:(int)buyerClientID andStockID:(int)stockID andOfferID:(int)offerID andRatingClientID:(int)ratingClientID andRatingMemberID:(int)ratingMemberID;

+(NSMutableURLRequest*)sendBrochureWithImagesAndIsSendPhotos:(BOOL)sendPhotos andIsSendVideos:(BOOL)sendVideos withUserHash:(NSString*)userHash andUsedVehicleStockId:(int)stockID andClientID:(int)ClientID withVideoDetails1:(NSArray*)array1 withVideoDetails2:(NSArray*)array2 WithEmail:(NSString*)email WithFirstName:(NSString*)firstName WithMobile:(NSString*)mobileNum WithLastName:(NSString*)lastName withComments:(NSString*)comments withImageToken:(NSString*)imageToken andIsVariant:(BOOL) isVariant;

+(NSMutableURLRequest*)sendBrochureWithoutImagesAndIsSendPhotos:(BOOL)sendPhotos andIsSendVideos:(BOOL)sendVideos withUserHash:(NSString*)userHash andUsedVehicleStockId:(int)stockID andClientID:(int)ClientID withVideoDetails1:(NSArray*)array1 withVideoDetails2:(NSArray*)array2 WithEmail:(NSString*)email WithFirstName:(NSString*)firstName WithMobile:(NSString*)mobileNum WithLastName:(NSString*)lastName withComments:(NSString*)comments andIsVariant:(BOOL) isVariant;

+(NSMutableURLRequest*)uploadPersonalizedImageWithImageToken:(NSString*)imageToken andVehicleStockID:(NSString *)strVehicleStockID andBase64String:(NSString*)base64String;

+(NSMutableURLRequest*)uploadVariantPersonalizedImageWithImageToken:(NSString*)imageToken andVariantID:(NSString *)strVariantID andBase64String:(NSString*)base64String;

+(NSMutableURLRequest*)endThePersonalizedImageListWithToken:(NSString*)personalizedImageToken;

+(NSMutableURLRequest*)beginThePersonalizedImageList;

+(NSMutableURLRequest *)listVariantsWithFlagForUserHash:(NSString *)userHash andClientID:(int) clientID andYear:(int) year andModelID:(int) modelID;

#pragma mark - Synopsis services.


#pragma mark - Synopsis module services

+(NSMutableURLRequest*)getSynopsisSummaryWithUserHash:(NSString*)userHash andYear:(int)year andMakeId:(int)makeId andModelId:(int)modelId andVariantId:(int)variantId andVIN:(NSString*)vinNumber andKiloMeters:(NSString*)kilometers andExtrasCost:(NSString*)extraCost andCondition:(NSString*)condition;

+(NSMutableURLRequest*)getSynopsisSummaryByIxCodeWithUserHash:(NSString*)userHash andYear:(int)year andiXCode:(NSString*)ixCode;

+(NSMutableURLRequest*)getSynopsisSummaryByMMCodeCodeWithUserHash:(NSString*)userHash andYear:(int)makeId andMMCode:(NSString*)mmCode withKiloMeters:(NSString*)kiloMeters andVIN:(NSString*)VinNumber andExtrasCost:(NSString*)extrasCost andCondition:(NSString*)condition;

+(NSMutableURLRequest*)getSynopsisSummaryByVinNumberWithUserHash:(NSString*)userHash andYear:(int)year andVinNumber:(NSString*)vinNumber withKiloMeters:(NSString*)kiloMeters andExtrasCost:(NSString*)extrasCost andCondition:(NSString*)condition;

+(NSMutableURLRequest*) gettingOEMSpecsDetails:(NSString *) userHash
                                          Year:(NSString *)year
                                     variantID:(NSString *)variantID;

+(NSMutableURLRequest*) gettingLoadVINHistory:(NSString *) userHash                                                                            VIN:(NSString *)VIN;
+(NSMutableURLRequest*)listDealerMakesOpenXML:(NSString*)userHash andClientID:(int)clientID;
+(NSMutableURLRequest*)listDealerMakesJSON:(NSString*)userHash andClientID:(int)clientID year:(NSString*)year;
+(NSMutableURLRequest*)listDealerModelOpenJSON:(NSString*)userHash andClientID:(int)clientID makeID:(int)makeID;
+(NSMutableURLRequest*)listDealerModelJSON:(NSString*)userHash andClientID:(int)clientID year:(int)year makeID:(int)makeID;
+(NSMutableURLRequest*)listDealerVariantOpenJSON:(NSString*)userHash andClientID:(int)clientID modelID:(int)modelID;
+(NSMutableURLRequest*)listDealerVariantJSON:(NSString*)userHash andClientID:(int)clientID year:(int)year modelID:(int)modelID;

+(NSMutableURLRequest*)getAvaibilityWithUserHash:(NSString*)userHash  andModelID:(NSString *)strModelId andClientID:(NSString *)strClientID andGroupId:(NSString *)strGroupId;

+(NSMutableURLRequest*)getAverageDaysWithUserHash:(NSString*)userHash andYear:(NSString *)year  andVariantID:(NSString *)strVariantId;
+(NSMutableURLRequest*)getLeadPoolsWithUserHash:(NSString*)userHash andYear:(NSString *)year  andVariantID:(NSString *)strVariantId;

+(NSMutableURLRequest*)getSalesHistoryWithUserHash:(NSString*)userHash andYear:(NSString *)year  andVariantID:(NSString *)strVariantId;
+(NSMutableURLRequest*)getReviewsWithUserHash:(NSString*)userHash andVariantId:(NSString*)strVariantId;
+(NSMutableURLRequest*)getReviewsForModelIDExcludeVariantWithUserHash:(NSString*)userHash andModelID:(int) modelID andVariantId:(int) variantId;

+(NSMutableURLRequest*)getDemandsWithUserHash:(NSString*)userHash andVariantID:(NSString *)strVariantId andClientId:(NSString *)strClientId;

+(NSMutableURLRequest*)listDealerStockVariants:(NSString *)userHash clientID:(int)clientID modelID:(int)modelID;

+(NSMutableURLRequest*)getSimilarVehiclesWithUserHash:(NSString*)userHash andYear:(NSString *)year  andVariantID:(NSString *)strVariantId;

+(NSMutableURLRequest*)getNewPricePlotterWithUserHash:(NSString*)userHash andYear:(NSString *)year  andVariantID:(NSString *)strVariantId;

+(NSMutableURLRequest*)getReviewsByModelWithUserHash:(NSString*)userHash  andModelID:(NSString *)strModelId;
+(NSMutableURLRequest*)getReviewDetailsWithUserHash:(NSString*)userHash  andReviewID:(int)strReviewId;

#pragma mark - Pricing sections

+(NSMutableURLRequest*)getAdvertRegionsList:(NSString*)userHash  andClientID:(int)clientID;

+(NSMutableURLRequest*)loadRetailPricingForCity:(NSString*)userHash andVariantID:(int)variantID year:(int)year cityID:(int) cityID;

+(NSMutableURLRequest*)loadRetailPricingForNational:(NSString*)userHash andVariantID:(int)variantID year:(int)year;

+(NSMutableURLRequest*)loadRetailPricingForProvince:(NSString*)userHash andVariantID:(int)variantID year:(int)year provinceID:(int) provinceID;

+(NSMutableURLRequest*)loadRetailPricingForGroup:(NSString*)userHash andVariantID:(int)variantID year:(int)year groupID:(int) groupID;

+(NSMutableURLRequest*)loadRetailPricingForGroupCity:(NSString*)userHash andVariantID:(int)variantID year:(int)year groupID:(int) groupID cityID:(int) cityID;

+(NSMutableURLRequest*)loadRetailPricingForGroupProvince:(NSString*)userHash andVariantID:(int)variantID year:(int)year groupID:(int) groupID provinceID:(int) provinceID;

+(NSMutableURLRequest*)getAverageDaysWithUserHash:(NSString*)userHash andModelId:(NSString *)strModelId  andClientID:(NSString *)strClientId;

+(NSMutableURLRequest*)loadPrivatePricingForNational:(NSString*)userHash andVariantID:(int)variantID year:(int)year;
+(NSMutableURLRequest*)loadiXTraderPricingForNational:(NSString*)userHash andVariantID:(int)variantID year:(int)year;

+(NSMutableURLRequest*)getSimpleLogicForVehicleInStock:(NSString*)userHash andusedVehicleStockID:(NSString *)strUsedVehicleStockID;

+(NSMutableURLRequest*)getSimpleLogicForVariant:(NSString*)userHash andYear:(NSString *)year  andVariantID:(NSString *)strVariantId andMileage:(NSString *)strMileage;

+(NSMutableURLRequest*)getLeadPoolSummary:(NSString*)userHash andModelId:(NSString*)strModelId andYear:(NSString*)strYear andClientId:(NSString*)strClientId andGroupId:(NSString*)strGroupId;

+(NSMutableURLRequest*)getLeadPoolForClient:(NSString*)userHash andModelId:(NSString*)strModelId andYear:(NSString*)strYear andClientId:(NSString*)strClientId andLeadStatusId:(NSString*)strLeadStatusId;

+(NSMutableURLRequest*)getLeadPoolForGroupExcludeClient:(NSString*)userHash andModelId:(NSString*)strModelId andYear:(NSString*)strYear andGroupID:(NSString *)strGroupId andClientId:(NSString*)strClientId andLeadStatusId:(NSString*)strLeadStatusId;


+(NSMutableURLRequest*)loadTransUnionPricing:(NSString*)userHash andVINNum:(NSString*)strVinNum andYear:(NSString*)strYear andRegNumber:(NSString*)regNum andMMCode:(NSString *)strMMCode andMileage:(NSString*)strMileage;


//////////////////////////    VIN Verification     //////////////////////////////////////

+(NSMutableURLRequest*)loadFullVerificationDetails:(NSString*)userHash andVINNum:(NSString*)strVinNum andYear:(NSString*)strYear andRegNumber:(NSString*)regNum andMMCode:(NSString *)strMMCode andMileage:(NSString*)strMileage;

+(NSMutableURLRequest*)loadVINVerificationDetails:(NSString*)userHash andVINNum:(NSString*)strVinNum andYear:(NSString*)strYear andRegNumber:(NSString*)regNum andMMCode:(NSString *)strMMCode andMileage:(NSString*)strMileage;

# pragma mark - Do Appraisal section

+(NSMutableURLRequest*)loadAppraisalSellerDetails:(NSString*)userHash andAppraisalID:(int)appraisalID andVinNum:(NSString*) vinNum;

+(NSMutableURLRequest*)loadAppraisalPurchaseDetails:(NSString*)userHash andAppraisalID:(int)appraisalID andVinNum:(NSString*) vinNum;

+(NSMutableURLRequest*)loadInteriorReconditioning:(NSString*)userHash andAppraisalID:(int)appraisalID andVin:(NSString*) vinNum;

+(NSMutableURLRequest*)loadLoadEngineDrivetrain:(NSString*)userHash andAppraisalID:(int)appraisalID andVinNum:(NSString*) vinNum;

+(NSMutableURLRequest*)loadVehicleCondition:(NSString*)userHash andAppraisalID:(int)appraisalID andVinNum:(NSString*) vinNum;

+(NSMutableURLRequest*)saveVehicleCondition:(NSString*)userHash andConditionsArray:(NSMutableArray*) arrmOfConditions andRootConditionID:(NSString*) rootConditionID  andAppraisalID:(NSString*) appraisalID andOverallConditionID:(NSString*) overallConditionID andComments:(NSString*) comments andClientID:(NSString*) clientID andVin:(NSString*) vinNum;

+(NSMutableURLRequest*)savePurchaseDetails:(NSString*)userHash andPurchaseDetailsId:(NSString*) strPurchaseDetailID andAccountNum:(NSString*) accountNum andAppraisalID:(NSString*) appraisalID andBoughtFrom:(NSString*) boughtFrom andComments:(NSString*) comments andDate:(NSString*) date andDetails:(NSString*) details andFinanceHouse:(NSString*) financeHouse andSettlementR:(NSString*) settlementR andClientID:(NSString*) clientID andVinNum:(NSString*) vinNum;

+(NSMutableURLRequest*)saveInteriorReconditioning:(NSString*)userHash andIRArray:(NSMutableArray*) arrmInteriorR andInteriorReconditioningID:(NSString*) InteriorReconditioningID  andAppraisalID:(NSString*) appraisalID andComments:(NSString*) comments andClientID:(NSString*) clientID andVinNumber:(NSString*) vinNum;

+(NSMutableURLRequest*)saveEngineDriveTrain:(NSString*)userHash andIRArray:(NSMutableArray*) arrmEngineD andEngineDriveTrainID:(NSString*) engineDriveTrainID  andAppraisalID:(NSString*) appraisalID andComments:(NSString*) comments andClientID:(NSString*) clientID andVinNum:(NSString*) vinNum;

+(NSMutableURLRequest*)loadAppraisalInfo:(NSString*)userHash andVIN:(NSString *) vinNumber andClientID:(int)clientID;

+(NSMutableURLRequest*)loadAppraisalVehicleExtras:(NSString*)userHash andAppraisalID:(int)appraisalID andVinNum:(NSString*) vinNum;


// Images uploading background data

+(NSData*)saveTheImageDataToTheServerWithUserHashValue:(NSString*)userHash andClientID:(int)clientID andBlogPostID:(int)blogPostID andUserID:(int)userID andPriority:(int)priority andOriginalFileName:(NSString*)originalFileName andEncodedImage:(NSString*)encodedImage;


+(NSMutableURLRequest*)saveExteriorReconditioning:(NSString*)userHash andExteriorTypeID:(NSString *) exteriorTypeID andIsRepair:(NSString *) isRepair andIsReplace: (NSString *) isReplace andPriceValue:(NSString *) priceValue andComments:(NSString *) comments andAppraisalID:(NSString*) AppraisalID andClientID:(NSString*) clientID andVIN: (NSString*) vinNum;

+(NSMutableURLRequest*)saveSelectedExteriorReconditioning:(NSString*)userHash andERArray:(NSMutableArray*) arrmExteriorR andAppraisalID:(NSString*) AppraisalID  andClientID:(NSString*) ClientID andVinNum:(NSString*) vinNum andComments:(NSString*) comments;


+(NSMutableURLRequest*)loadExterior:(NSString*)userHash andAppraisalID:(NSString*) AppraisalID andVin:(NSString*) vinNum;

+(NSMutableURLRequest*)deleteSelectedExteriorReconditioning:(NSString*)userHash andExteriorTypeID:(NSString *) exteriorTypeID andAppraisalID:(NSString*) AppraisalID andClientID:(NSString*) clientID andVIN: (NSString*) vinNum;

+(NSMutableURLRequest*)sendForwardAppraisalEmailsWithUserHash:(NSString*)userHash andAppraisalID:(NSString*) AppraisalID andEmailIDs:(NSString*) emailIDs andVin:(NSString*) vinNum;

+(NSMutableURLRequest*)saveExteriorImages:(NSString*)userHash andImagesArray:(NSMutableArray*) arrmExteriorImages andAppraisalID:(NSString*) AppraisalID  andClientID:(NSString*) ClientID andVinNum:(NSString*) vinNum andExteriorVaueID:(NSString*) exteriorValueID;

+(NSMutableURLRequest*)sendOfferGetDetailsWithUserHash:(NSString*)userHash andYear:(int)year andMakeID:(int)makeID andModelID:(int)modelID andVariantID:(int)variantID andAppraisalID:(int)appraisalID andSendOfferID:(int) sendOfferID andVinNum:(NSString*) vinNum;

+(NSMutableURLRequest*)saveAndSendOfferWith:(NSString*)userHash andYear:(NSString*) year andMakeID:(NSString*) makeID andModelID:(NSString*) modelID andVariantId:(NSString*) variantId andSellerName:(NSString*) sellerName andSellerSurname:(NSString*) sellerSurname andCompany:(NSString*) company andEmailID:(NSString*) emailID andMobileNum:(NSString*) mobileNum andOffer:(NSString*) offer andExpiresIn:(NSString*) expiresIn andSubjectArray:(NSMutableArray*) arrmSubject andSMSNumbers:(NSString*) smsNums andSMSFlag:(NSString*) smsFlag andEmailIDs:(NSString*) emailIDs andEmailSendOfferFlag:(NSString*) emailSendOfferFlag andEmailSendCopyFlag:(NSString*) emailSendCopyFlag andAppraisalID:(NSString*) AppraisalID  andClientID:(NSString*) ClientID andVinNum:(NSString*) vinNum;

+(NSMutableURLRequest*)getTheValuationPriceDetailsWithUserHash:(NSString*)userHash andAppraisalID:(int)appraisalID andVIN:(NSString*) vinNum;

+(NSMutableURLRequest*)isGivenVINVerifiedWithUserHash:(NSString*)userHash andVIN:(NSString*) vinNum;

+(NSMutableURLRequest*)saveVehicleExtras:(NSString*)userHash andExtrasArray:(NSMutableArray*) arrmExtrasArray andAppraisalID:(NSString*) AppraisalID  andClientID:(NSString*) ClientID andVinNum:(NSString*) vinNum andVehicleExtraID:(int) vehicleExtraID andComments:(NSString*) comments;

+(NSMutableURLRequest*)saveSellerInfoWithUserHash:(NSString*)userHash andAppraisalID:(int) appraisalID andCompany:(NSString*) company andEmailAddress:(NSString*) emailID andIDNumber:(NSString*) idNumber andMobileNum:(NSString*) mobileNum andName:(NSString*) name andSurname:(NSString*) surname andSellerID:(int) sellerID andClientID:(int) clientID andVIN:(NSString*) vinNum andStreetAddrs:(NSString*) streetAddress;

+(NSMutableURLRequest*)listMakesForNewVehicle:(NSString*)userHash andClientID:(int)clientID year:(int)year;

+(NSMutableURLRequest*) listModelsForNewVehicles:(NSString *) userHash
                                            Year:(int)year
                                          makeId:(int)makeId;

+(NSMutableURLRequest*) listVariantsForNewVehicles:(NSString *) strUserHash Year:(int)year withModel:(int) iModelId;

+(NSMutableURLRequest*) listActiveModelsForNewVehicles:(NSString *) userHash
                                                  Year:(int)year
                                                makeId:(int)makeId;

+(NSMutableURLRequest *)getTheStockSummaryWith:(NSString*)userHash andClientID:(int) clientID;

+(NSMutableURLRequest *)sendStockSummaryEmailsWith:(NSString*)userHash andclientID:(int) clientID andusedExcluded:(BOOL) usedExcluded andusedInvalid:(BOOL) usedInvalid andnewExcluded:(BOOL) newExcluded andnewInvailid:(BOOL) newInvailid andrecipientslist:(NSString*) recipientslist;


/////////////////////////////Monami///////////////////////////////////////////////////
+(NSMutableURLRequest *)UpdateProfileImageWith:(NSString*)userHash andimageFilename:(NSString*) imageFilename andbase64EncodedString:(NSString*) base64EncodedString;
+(NSMutableURLRequest *)ImageAvailableOrNot:(NSString*)userHash;
+(NSMutableURLRequest *)GetProfileImage:(NSString*)userHash;
+ (NSMutableURLRequest*)loadRequestType:(NSString*)userHash;
+ (NSMutableURLRequest*)logNewSupportRequestWith:(NSString*)userHash andRequestType:(int) requestID andRequestTitle:(NSString*) requestTitle andRequestDetails:(NSString*) requestDetails;
+ (NSMutableURLRequest*)saveTheSupportRequestDocumentsWith:(NSString*)userHash andbase64DocString:(NSString*) base64String andFileName:(NSString*) fileName andPlanTaskID:(int) planTaskID;


///////////////////////////////////////////////////////////////////////////////////////////////


@end

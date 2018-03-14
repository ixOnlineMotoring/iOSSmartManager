//
//  Constant.h
//  SmartManager
//
//  Created by Jignesh on 06/03/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#ifndef SmartManager_Constant_h
#define SmartManager_Constant_h



// ******* Application Alert**********************

#define SMAlert(TITLE,MSG) [[[UIAlertView alloc] initWithTitle:(TITLE) \
message:(MSG) \
delegate:nil \
cancelButtonTitle:@"Ok" \
otherButtonTitles:nil] show]


// ******** System Version Constant *****************

#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))


#ifdef DEBUG_MODE
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif


// ************* Enumeration Constants ********************

typedef enum  : NSUInteger {
    kListingTypeMake,
    kListingTypeModel,
    kListingTypeVariant
} kListSelectionType;



// ***************Alert Message Vehicle, Trader Module Alert Message Constants*********************//


#define kVehicleStockSuccess            @"Stock saved successfully"
#define kVehicleUpdatedSuccessfully     @"Vehicle updated successfully"

#define KErrorInSavingStcok             @"Error in saving stock,try again.\nValue was either too large or too small"
#define KNoimagesFound                  @"No images found"
#define KNoInfoarmationLoaded           @"No information loaded"
#define KEmailsentSuccess               @"You sent the email"
#define KEmailSavedDrafts               @"You saved a draft of this email"
#define KEmailCancel                    @"You cancelled sending this email"
#define KEmailErrorOccured              @"An error occurred when trying to compose this email"
#define KEmailComposedError             @"An error occurred when trying to compose this email"
#define kEmailCanNotSend                @"This device cannot send email"

#define KDuplicateStockCode             @"Error,unable to save vehicle - duplicate stock code"

#define KMakeSelection                  @"Please select make"
#define KModelSelection                 @"Please select model"
#define KVariantSelection               @"Please select variant"
#define KConditionSelection             @"Please select Condition"
#define kKilometerSelection             @"Please enter kilometers"
#define kVINNoSelection                 @"Please enter VIN No."
#define kStockNumberSelection           @"Please select stock no"
#define KNorecordsFousnt                @"No record(s) found."
#define KNoStockAvailable               @"No stock is available"
#define KVariantsNotFound               @"No variant(s) found"
#define KNoTenderAvailable              @"No tender available"
#define KCameraNotAvailable             @"Camera not available"
#define KNoGroupDataFound               @"No associated group found."
#define KyearSelection                  @"Please select year"
#define KRemovedVINScan                 @"Unable to remove saved vin scan"
#define KStartYearSelection             @"Please select start year"
#define KNoYearsLoadedForSelectedModel  @"No year(s) loaded for selected model"
#define kMMCodeORIXCode                 @"Please enter M&M code"

#define KEndYearSelection               @"Please select end year"
#define KRegionSelection                @"Please select region"
#define KProperYear                     @"Please select your year properly"
#define KStartGreaterEnd                @"Start date must be greater than end date"
#define KSelectType                     @"Please select type"
#define KStartDate                      @"Please select start date first"

#define KScanSavedSuccess               @"Scan saved successfully"
#define KVehicleDiscardedSuccessfully   @"Vehicle is discarded successfully"
#define KStartGreaterEnd                @"Start date must be greater than end date"
#define KSelectType                     @"Please select type"
#define KStartDate                      @"Please select start date first"
#define KDateEnd                        @"Please select end date"
#define KDateStart                      @"Please select start date"
#define KRejectBid                      @"Please select bid to reject"
#define KAcceptBid                      @"Please select bid to accept"
#define KTradePrice                      @"Please enter the trade price"

#define kSelectFromGallry               @"Select from library"
#define kSelectFromCamera               @"Camera"
#define KSelecTheImahe                  @"Select the picture"


#define kSelectPhoneNUmber              @"Please enter phone number"
#define kEnterYourEmail                 @"Please enter your email"
#define kEnterValidEmail                 @"Please enter valid email"
#define KWSCrashMessage                 @"Error while loading data. Please try again later."

// Special Module
#define kSpecialImageDeletedFailed      @"Image cannot deleted,please try again"
#define kSpecialImageUploadFailed       @"Image cannot uploaded, please try again"
#define kSpecialDeleted                 @"Special deleted successfully"

#define kSpecialExpired                 @"Special expired successfully"
#define kSpecialPublished               @"Special published successfully"
#define KspecialUpdated                 @"Special updated successfully"
#define kspcialSaved                    @"Special saved successfully"
#define KSpecialDeltedImage             @"Are you sure you want to delete this image?"
#define KSpecialDeltedPermission        @"Are you sure you want to delete this special?"
#define KSPecilaMoved                   @"Special moved to expired successfully"
#define KspecialMovedPermission         @"Are you sure you want to move this special to expired?"

#define KvehicleInStcokNeedUpdate       @"This vehicle is already in stock.Would you like to update it?"
#define KWantToDiscard                  @"Are you sure you want to discard?"
#define KSaveScanLater                  @"Do you want to save this scan for later?"

///////// ************** Planner Module Constant *********** /////////
#define KSelectPlannerType                  @"Please select the planner type"
#define KSelectDate                         @"Please select the date"
#define KEnterDetails                       @"Please enter the details"
#define KSpecialCharcter                    @"Special characters are not allowed in the title"
#define KSelectClient                       @"Please select the client"

#define KDeleteImageAlert                   @"Are you sure you want to delete?"


#define KblogEndAlert                       @"Are you sure you want to end this blog?"
#define KLogActivitySaved                   @"Log activity saved successfully"
#define KNotSavedLogActivity                @"Could not save the log activity"

#define KSelectPlannerType                  @"Please select the planner type"
#define kTitle                              @"Smart Manager"

#define kNOVINPresent                       @"Please add a VIN."
#define kLeadUpdateSuccess                  @"Lead updated successfully"

#define kLeadUpdateSuccess                  @"Lead updated successfully"
#define kFetchTUAPricing                    @"Fetch TUA pricing"
#define kUpdate                             @"Update"
#define kAlertUpdatePricing                 @"Are you sure you want to make changes? Please note you will be charged again."
#define kAlertUpdateVerification            @"Please note you will be invoiced by iX for either of the below verifications."
#define ifIphone    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)


#endif

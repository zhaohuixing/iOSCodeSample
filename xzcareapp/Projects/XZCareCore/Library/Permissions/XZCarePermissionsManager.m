 // 
//  APCPermissionsManager.m 
//  APCAppCore 
// 
// Copyright (c) 2015, Apple Inc. All rights reserved. 
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// 
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// 
// 2.  Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation and/or 
// other materials provided with the distribution. 
// 
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors 
// may be used to endorse or promote products derived from this software without 
// specific prior written permission. No license is granted to the trademarks of 
// the copyright holders even if such marks are included in this software. 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
// 
 
//#import "XZCarePermissionsManager.h"
//#import "XZCareUserInfoConstants.h"
//#import "XZCareTasksReminderManager.h"
//#import "XZCareCoreAppDelegate.h"
#import <XZCareCore/XZCareCore.h>


#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <HealthKit/HealthKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

static NSArray *healthKitTypesToRead;
static NSArray *healthKitTypesToWrite;

static NSString * const XZCarePermissionsManagerErrorDomain = @"XZCarePermissionsManagerErrorDomain";

typedef NS_ENUM(NSUInteger, XZCarePermissionsErrorCode)
{
    kPermissionsErrorAccessDenied = -100,
};

@interface XZCarePermissionsManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CMMotionActivityManager *motionActivityManager;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) XZCarePermissionStatus coreMotionPermissionStatus;
@property (nonatomic, copy) XZCarePermissionsBlock completionBlock;

@end

@implementation XZCarePermissionsManager

+ (void)setHealthKitTypesToRead:(NSArray *)types
{
    healthKitTypesToRead = types;
}

+ (void)setHealthKitTypesToWrite:(NSArray *)types
{
    healthKitTypesToWrite = types;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _motionActivityManager = [[CMMotionActivityManager alloc] init];
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidRegisterForRemoteNotifications:) name:XZCareAppDidRegisterUserNotification object:nil];
        _coreMotionPermissionStatus = kPermissionStatusNotDetermined;
                
    }
    return self;
}

- (HKHealthStore *)healthStore
{
    return [[(XZCareCoreAppDelegate*) ([UIApplication sharedApplication].delegate) dataSubstrate] healthStore];
}

- (BOOL)isPermissionsGrantedForType:(XZCareSignUpPermissionsType)type
{
    BOOL isGranted = NO;
    [[NSUserDefaults standardUserDefaults]synchronize];
    switch (type)
    {
        case kXZCareSignUpPermissionsTypeHealthKit:
        {
            HKCharacteristicType *dateOfBirth = [HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
            HKAuthorizationStatus status = [self.healthStore authorizationStatusForType:dateOfBirth];

            isGranted = (status == HKAuthorizationStatusSharingAuthorized);
        }
            break;
        case kXZCareSignUpPermissionsTypeLocation:
        {
#if TARGET_IPHONE_SIMULATOR
            isGranted = YES;
#else
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            
            if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
            {
                isGranted = YES;
            }
            
            if (status == kCLAuthorizationStatusAuthorizedAlways)
            {
                isGranted = YES;
            }
#endif
        }
            break;
        case kXZCareSignUpPermissionsTypeLocalNotifications:
        {
            isGranted = [[UIApplication sharedApplication] currentUserNotificationSettings].types != 0;
        }
            break;
        case kXZCareSignUpPermissionsTypeCoremotion:
        {
#if TARGET_IPHONE_SIMULATOR
            isGranted = YES;
#else
            isGranted = self.coreMotionPermissionStatus == kPermissionStatusAuthorized;
#endif
        }
            break;
        case kXZCareSignUpPermissionsTypeMicrophone:
        {
#if TARGET_IPHONE_SIMULATOR
            isGranted = YES;
#else
            isGranted = ([[AVAudioSession sharedInstance] recordPermission] == AVAudioSessionRecordPermissionGranted);
#endif
        }
            break;
        case kXZCareSignUpPermissionsTypeCamera:
        {
#if TARGET_IPHONE_SIMULATOR
            isGranted = YES;
#else
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            isGranted = status == AVAuthorizationStatusAuthorized;  
#endif
        }
            break;
        case kXZCareSignUpPermissionsTypePhotoLibrary:
        {
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            isGranted = status == PHAuthorizationStatusAuthorized;
            break;
        }
        default:
        {
            isGranted = NO;
        }
            break;
    }
    
    return isGranted;
}

- (void)requestForPermissionForType:(XZCareSignUpPermissionsType)type
                     withCompletion:(XZCarePermissionsBlock)completion
{
    
    self.completionBlock = completion;
    __weak typeof(self) weakSelf = self;
    switch (type)
    {
        case kXZCareSignUpPermissionsTypeHealthKit:
        {
            //------READ TYPES--------
            NSMutableArray *dataTypesToRead = [NSMutableArray new];
            
            // Add Characteristic types
            NSDictionary *initialOptions = ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).initializationOptions;
            NSArray *profileElementsList = initialOptions[kAppProfileElementsListKey];
            
            for (NSNumber *profileType in profileElementsList)
            {
                XZCareUserInfoItemType type = profileType.integerValue;
                switch (type)
                {
                    case kXZCareUserInfoItemTypeBiologicalSex:
                        [dataTypesToRead addObject:[HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex]];
                        break;
                    case kXZCareUserInfoItemTypeDateOfBirth:
                        [dataTypesToRead addObject:[HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth]];
                        break;
                    case kXZCareUserInfoItemTypeBloodType:
                        [dataTypesToRead addObject:[HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBloodType]];
                        break;
                    default:
                        break;
                }
            }
            
            //Add other quantity types
            
            for (id typeIdentifier in healthKitTypesToRead)
            {
                if ([typeIdentifier isKindOfClass:[NSString class]])
                {
                    [dataTypesToRead addObject:[HKQuantityType quantityTypeForIdentifier:typeIdentifier]];
                }
                else if ([typeIdentifier isKindOfClass:[NSDictionary class]])
                {
                    if (typeIdentifier[kHKWorkoutTypeKey])
                    {
                        [dataTypesToRead addObject:[HKObjectType workoutType]];
                    }
                    else
                    {
                        [dataTypesToRead addObject:[self objectTypeFromDictionary:typeIdentifier]];
                    }
                }
            }
            
            //-------WRITE TYPES--------
            NSMutableArray *dataTypesToWrite = [NSMutableArray new];
            
            for (id typeIdentifier in healthKitTypesToWrite)
            {
                if ([typeIdentifier isKindOfClass:[NSString class]])
                {
                    [dataTypesToWrite addObject:[HKQuantityType quantityTypeForIdentifier:typeIdentifier]];
                }
                else if ([typeIdentifier isKindOfClass:[NSDictionary class]])
                {
                    [dataTypesToWrite addObject:[self objectTypeFromDictionary:typeIdentifier]];
                }
            }
            
            [self.healthStore requestAuthorizationToShareTypes:[NSSet setWithArray:dataTypesToWrite] readTypes:[NSSet setWithArray:dataTypesToRead] completion:^(BOOL success, NSError *error) {
                if (completion)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    completion(success, error);
                    });
                }
            }];

            
        }
            break;
        case kXZCareSignUpPermissionsTypeLocation:
        {
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            
            if (status == kCLAuthorizationStatusNotDetermined)
            {
                [self.locationManager requestAlwaysAuthorization];
                [self.locationManager requestWhenInUseAuthorization];
                
            }
            else
            {
                if (weakSelf.completionBlock)
                {
                    weakSelf.completionBlock(NO, [self permissionDeniedErrorForType:kXZCareSignUpPermissionsTypeLocation]);
                    weakSelf.completionBlock = nil;
                }
            }
        }
            break;
        case kXZCareSignUpPermissionsTypeLocalNotifications:
        {
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone)
            {
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert
                                                                                                     |UIUserNotificationTypeBadge
                                                                                                     |UIUserNotificationTypeSound)
																						 categories:[XZCareTasksReminderManager taskReminderCategories]];
                
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                [[NSUserDefaults standardUserDefaults]synchronize];
                /*in the case of notifications, callbacks are used to fire the completion block. Callbacks are delivered to appDidRegisterForRemoteNotifications:.
                 */
            }
        }
            break;
        case kXZCareSignUpPermissionsTypeCoremotion:
        {
            [self.motionActivityManager queryActivityStartingFromDate:[NSDate date] toDate:[NSDate date] toQueue:[NSOperationQueue new] withHandler:^(NSArray * __unused activities, NSError *error) {
                if (!error)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.coreMotionPermissionStatus = kPermissionStatusAuthorized;
                    weakSelf.completionBlock(YES, nil);
                    weakSelf.completionBlock = nil;
                    });
                }
                else if (error != nil && error.code == CMErrorMotionActivityNotAuthorized)
                {
                    weakSelf.coreMotionPermissionStatus = kPermissionStatusDenied;
                    
                    if (weakSelf.completionBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.completionBlock(NO, [self permissionDeniedErrorForType:kXZCareSignUpPermissionsTypeCoremotion]);
                        weakSelf.completionBlock = nil;
                        });
                    }
                    
                }
            }];
            
        }
            break;
        case kXZCareSignUpPermissionsTypeMicrophone:
        {
            
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                if (granted)
                {
                    weakSelf.completionBlock(YES, nil);
                    weakSelf.completionBlock = nil;
                }
                else
                {
                    if (weakSelf.completionBlock)
                    {
                        weakSelf.completionBlock(NO, [self permissionDeniedErrorForType:kXZCareSignUpPermissionsTypeMicrophone]);
                        weakSelf.completionBlock = nil;
                    }
                }
            }];
        }
            break;
        case kXZCareSignUpPermissionsTypeCamera:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted)
                {
                    weakSelf.completionBlock(YES, nil);
                    weakSelf.completionBlock = nil;
                }
                else
                {
                    if (weakSelf.completionBlock)
                    {
                        weakSelf.completionBlock(NO, [self permissionDeniedErrorForType:kXZCareSignUpPermissionsTypeCamera]);
                        weakSelf.completionBlock = nil;
                    }
                }
            }];
        }
            break;
        case kXZCareSignUpPermissionsTypePhotoLibrary:
        {
            ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
            
            [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL * __unused stop) {
                if (group == nil)
                {
                    // end of enumeration
                    weakSelf.completionBlock(YES, nil);
                    weakSelf.completionBlock = nil;
                }
                
            } failureBlock:^(NSError *error)
            {
                if (error.code == ALAssetsLibraryAccessUserDeniedError)
                {
                    if (weakSelf.completionBlock)
                    {
                        weakSelf.completionBlock(NO, [self permissionDeniedErrorForType:kXZCareSignUpPermissionsTypePhotoLibrary]);
                        weakSelf.completionBlock = nil;
                    }
                }
            }];

//            PHPhotoLibrary *lib = [[PHPhotoLibrary alloc] init];
            
            
        }
            break;
        default:
            break;
    }
}

- (HKObjectType*) objectTypeFromDictionary: (NSDictionary*) dictionary
{
    NSString * key = [[dictionary allKeys] firstObject];
    HKObjectType * retValue;
    if ([key isEqualToString:kHKQuantityTypeKey])
    {
        retValue = [HKQuantityType quantityTypeForIdentifier:dictionary[key]];
    }
    else if ([key isEqualToString:kHKCategoryTypeKey])
    {
        retValue = [HKCategoryType categoryTypeForIdentifier:dictionary[key]];
    }
    else if ([key isEqualToString:kHKCharacteristicTypeKey])
    {
        retValue = [HKCharacteristicType characteristicTypeForIdentifier:dictionary[key]];
    }
    else if ([key isEqualToString:kHKCorrelationTypeKey])
    {
        retValue = [HKCorrelationType correlationTypeForIdentifier:dictionary[key]];
    }
    return retValue;
}

- (NSError *)permissionDeniedErrorForType:(XZCareSignUpPermissionsType)type
{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *message;
    
    switch (type)
    {
        case kXZCareSignUpPermissionsTypeHealthKit:
        {
            message = [NSString localizedStringWithFormat:NSLocalizedString(@"Please go to Settings -> Privacy -> Health -> %@ to re-enable.", nil), appName];
        }
            break;
        case kXZCareSignUpPermissionsTypeLocalNotifications:
        {
            message = [NSString localizedStringWithFormat:NSLocalizedString(@"Tap on Settings -> Notifications and enable 'Allow Notifications'", nil), appName];
        }
            break;
        case kXZCareSignUpPermissionsTypeLocation:
        {
            message = [NSString localizedStringWithFormat:NSLocalizedString(@"Tap on Settings -> Location and check 'Always'", nil), appName];
        }
            break;
        case kXZCareSignUpPermissionsTypeCoremotion:
        {
            message = [NSString localizedStringWithFormat:NSLocalizedString(@"Tap on Settings and enable Motion Activity.", nil), appName];
        }
            break;
        case kXZCareSignUpPermissionsTypeMicrophone:
        {
            message = [NSString localizedStringWithFormat:NSLocalizedString(@"Tap on Settings and enable Microphone", nil), appName];
        }
            break;
        case kXZCareSignUpPermissionsTypeCamera:
        {
            message = [NSString localizedStringWithFormat:NSLocalizedString(@"Tap on Settings and enable Camera", nil), appName];
        }
            break;
        case kXZCareSignUpPermissionsTypePhotoLibrary:
        {
            message = [NSString localizedStringWithFormat:NSLocalizedString(@"Tap on Settings and enable Photos", nil), appName];
        }
            break;
            
        default:
            message = @"";
            break;
    }
    
    NSError *error = [NSError errorWithDomain:XZCarePermissionsManagerErrorDomain code:kPermissionsErrorAccessDenied userInfo:@{NSLocalizedDescriptionKey:message}];
    
    return error;
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *) __unused error
{
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *) __unused manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            [self.locationManager stopUpdatingLocation];
            if (self.completionBlock) {
                self.completionBlock(YES, nil);
            }
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            [self.locationManager stopUpdatingLocation];
            if (self.completionBlock)
            {
                self.completionBlock(YES, nil);
            }
        }
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        {
            [self.locationManager stopUpdatingLocation];
            if (self.completionBlock)
            {
                self.completionBlock(NO, [self permissionDeniedErrorForType:kXZCareSignUpPermissionsTypeLocation]);
                self.completionBlock = nil;
            }
            break;
        }
    }
    
    self.completionBlock = nil;
}

#pragma mark - Remote notifications methods

- (void)appDidRegisterForRemoteNotifications: (NSNotification *)notification
{
    UIUserNotificationSettings *settings = (UIUserNotificationSettings *)notification.object;
    
    if (settings.types != 0)
    {
        XZCareCoreAppDelegate * delegate = (XZCareCoreAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.tasksReminder setReminderOn:YES];
        
        if (self.completionBlock)
        {
            self.completionBlock(YES, nil);
            self.completionBlock = nil;
        }
    }
	else
    {
        if (self.completionBlock)
        {
            self.completionBlock(NO, [self permissionDeniedErrorForType:kXZCareSignUpPermissionsTypeLocalNotifications]);
            self.completionBlock = nil;
        }
    }
}

#pragma mark - Dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _locationManager.delegate = nil;
}

@end

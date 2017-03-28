// 
//  XZCareUser.h
//
 
#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "XZCareConstants.h"
#import <XZCareBase/XZBaseUserProfile.h>

@interface XZCarePatient : NSObject

/*********************************************************************************/
#pragma mark - Designated Intializer
/*********************************************************************************/
- (instancetype)initWithContext: (NSManagedObjectContext*) context;

/*********************************************************************************/
#pragma mark - Stored Properties in Keychain
/*********************************************************************************/

//@property (nonatomic, strong) NSString * name;  //merge to userProfile.firstName and userProfile.lastName
//@property (nonatomic, strong) NSString * firstName DEPRECATED_ATTRIBUTE; //merge to userProfile.firstName
//@property (nonatomic, strong) NSString * lastName DEPRECATED_ATTRIBUTE;  //merge to userProfile.lastName
@property (nonatomic, strong) NSString * email;                     //merge to userProfile.email
@property (nonatomic, strong) NSString * password;                  //merge to userProfile.password


//@property (nonatomic, strong)XZBaseUserProfile*     userProfile;


@property (nonatomic, strong) NSString * sessionToken;

/*********************************************************************************/
#pragma mark - Stored Properties in Core Data
/*********************************************************************************/
@property (nonatomic) XZCareUserConsentSharingScope sharingScope;      // NOT stored to CoreData, reflected in "sharedOptionSelection"
@property (nonatomic) NSNumber *sharedOptionSelection;
@property (nonatomic, strong) NSData *profileImage;

@property (nonatomic, getter=isConsented) BOOL consented; //Confirmation that server is consented. Should be used in the app to test for user consent.
@property (nonatomic, getter=isUserConsented) BOOL userConsented; //User has consented though not communicated to the server.

@property (nonatomic, strong) NSDate * taskCompletion;
@property (nonatomic) NSInteger hasHeartDisease;
@property (nonatomic) NSInteger dailyScalesCompletionCounter;
@property (nonatomic, strong) NSString *customSurveyQuestion;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic) BOOL allowContact;
@property (nonatomic, strong) NSString * medicalConditions;
@property (nonatomic, strong) NSString * medications;
@property (nonatomic, strong) NSString *ethnicity;

@property (nonatomic, strong) NSDate *sleepTime;
@property (nonatomic, strong) NSDate *wakeUpTime;

@property (nonatomic, strong) NSString *glucoseLevels;

@property (nonatomic, strong) NSString *homeLocationAddress; //merge to userProfile.address
@property (nonatomic, strong) NSNumber *homeLocationLat;     //merge to userProfile.address
@property (nonatomic, strong) NSNumber *homeLocationLong;    //merge to userProfile.address

//@property (nonatomic, strong) NSString *consentSignatureName;
@property (nonatomic, retain) NSString * consentSignatureLastName;
@property (nonatomic, retain) NSString * consentSignatureFirstName;
@property (nonatomic, retain) NSString * patientXZCareID;
@property (nonatomic, strong) NSString * lastName ;  //merge to userProfile.lastName

@property (nonatomic, strong) NSDate *consentSignatureDate;
@property (nonatomic, strong) NSData *consentSignatureImage;

@property (nonatomic, getter=isSecondaryInfoSaved) BOOL secondaryInfoSaved;

/*********************************************************************************/
#pragma mark - Simulated Properties using HealthKit
/*********************************************************************************/
@property (nonatomic, strong) NSDate * birthDate;         //merge to userProfile.birthday
@property (nonatomic) HKBiologicalSex biologicalSex;      //merge to userProfile.gender
@property (nonatomic) HKBloodType bloodType;


@property (nonatomic, strong) HKQuantity * height;
@property (nonatomic, strong) HKQuantity * weight;
@property (nonatomic, strong) HKQuantity * systolicBloodPressure;
@property (nonatomic, strong) HKQuantity * diastolicBloodPressure;
@property (nonatomic, strong) HKQuantity * glucoseLevel;

/*********************************************************************************/
#pragma mark - NSUserDefaults Simulated Properties
/*********************************************************************************/
@property (nonatomic, getter=isSignedUp) BOOL signedUp;
@property (nonatomic, getter=isSignedIn) BOOL signedIn;

- (BOOL) isLoggedOut;

@end

// 
//  APCUser.m 
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
#import <XZCareCore/XZCareCore.h>


static NSString *const kNamePropertytName = @"name";
static NSString *const kFirstNamePropertytName = @"firstName";
static NSString *const kLastNamePropertyName = @"lastName";
static NSString *const kEmailPropertyName = @"email";
static NSString *const kPasswordPropertyName = @"password";
static NSString *const kSessionTokenPropertyName = @"sessionToken";

static NSString *const kSharedOptionSelection = @"sharedOptionSelection";
static NSString *const kTaskCompletion = @"taskCompletion";
static NSString *const kHasHeartDisease = @"hasHeartDisease";
static NSString *const kDailyScalesCompletionCounterPropertyName = @"dailyScalesCompletionCounter";
static NSString *const kCustomSurveyQuestionPropertyName = @"customSurveyQuestion";
static NSString *const kPhoneNumberPropertyName = @"phoneNumber";
static NSString *const kAllowContactPropertyName = @"allowContact";
static NSString *const kProfileImagePropertyName = @"profileImage";
static NSString *const kBirthDatePropertyName = @"birthDate";
static NSString *const kBiologicalSexPropertyName = @"BiologicalSex";
static NSString *const kBloodTypePropertyName = @"bloodType";
static NSString *const kConsentedPropertyName = @"serverConsented";
static NSString *const kUserConsentedPropertyName = @"userConsented";
static NSString *const kMedicalConditionsPropertyName = @"medicalConditions";
static NSString *const kMedicationsPropertyName = @"medications";
static NSString *const kWakeUpTimePropertyName = @"wakeUpTime";
static NSString *const kSleepTimePropertyName = @"sleepTime";
static NSString *const kEthnicityPropertyName = @"ethnicity";
static NSString *const kGlucoseLevelsPropertyName = @"glucoseLevels";

static NSString *const kHomeLocationAddressPropertyName = @"homeLocationAddress";
static NSString *const kHomeLocationLatPropertyName = @"homeLocationLat";
static NSString *const kHomeLocationLongPropertyName = @"homeLocationLong";

static NSString *const kSecondaryInfoSavedPropertyName = @"secondaryInfoSaved";

static NSString *const kConsentSignatureLastNamePropertyName = @"consentSignatureLastName";
static NSString *const kConsentSignatureFirstNamePropertyName = @"consentSignatureFirstName";
static NSString *const kPatientXZCareIDPropertyName = @"patientXZCareID";
static NSString *const kConsentSignatureDatePropertyName = @"consentSignatureDate";
static NSString *const kConsentSignatureImagePropertyName = @"consentSignatureImage";

static NSString *const kSignedUpKey = @"SignedUp";
static NSString *const kSignedInKey = @"SignedIn";

@interface XZCarePatient ()
{
    NSDate *_birthDate;
    HKBiologicalSex _biologicalSex;
    HKBloodType _bloodType;
}
@property (nonatomic, readonly) HKHealthStore *healthStore;
@end


@implementation XZCarePatient

/*********************************************************************************/
#pragma mark - Initialization Methods
/*********************************************************************************/

- (instancetype)initWithContext:(NSManagedObjectContext*)context
{
    self = [super init];
    [self loadStoredUserData:context];
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\
            First Name : %@\n\
            Last Name : %@\n\
            Patient ID : %@\n\
            Email : %@\n\
            DOB : %@\n\
            Biological Sex : %d\n\
            -----------------------\n\
            SignedUp? :%@\n\
            UserConsented? : %@\n\
            LoggedIn? :%@\n\
            serverConsented? : %@\n\
            -----------------------\n\
            Medical Conditions : %@\n\
            Medications : %@\n\
            Blood Type : %d\n\
            Height : %@ \n\
            Weight : %@ \n\
            Systolic Blood Pressure : %@\n\
            Diastolic Blood Pressure : %@\n\
            Glucose Level : %@\n\
            Wake Up Time : %@ \n\
            Sleep time : %@ \n\
            -----------------------\n\
            Home Address : %@ \n\
            Home Location Lat : %@ \n\
            Home Location Long : %@ \n\
            ", self.consentSignatureFirstName, self.consentSignatureLastName, self.patientXZCareID, self.email, self.birthDate, (int) self.biologicalSex, @(self.isSignedUp), @(self.isUserConsented), @(self.isSignedIn), @(self.isConsented), self.medicalConditions, self.medications, (int) self.bloodType, self.height, self.weight, self.systolicBloodPressure, self.diastolicBloodPressure, self.glucoseLevel, self.wakeUpTime, self.sleepTime, self.homeLocationAddress, self.homeLocationLat, self.homeLocationLong];
}

- (void)loadStoredUserData:(NSManagedObjectContext *)context
{
    [context performBlockAndWait:^{
        XZCareCoreDBStoredUserData * storedUserData = [self loadStoredUserDataInContext:context];
        [self copyPropertiesFromStoredUserData:storedUserData];
    }];
}

- (XZCareCoreDBStoredUserData *)loadStoredUserDataInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [XZCareCoreDBStoredUserData request];
    NSError *error;
    XZCareCoreDBStoredUserData *storedUserData = [[context executeFetchRequest:request error:&error] firstObject];
    XZCareLogError2 (error);
    if (!storedUserData)
    {
        storedUserData = [XZCareCoreDBStoredUserData newObjectForContext:context];
        NSError * saveError;
        [storedUserData saveToPersistentStore:&saveError];
        XZCareLogError2 (saveError);
    }
    return storedUserData;
}

- (void)copyPropertiesFromStoredUserData:(XZCareCoreDBStoredUserData*)storedUserData
{
    _profileImage = [storedUserData.profileImage copy];
    _birthDate = [storedUserData.birthDate copy];
    _biologicalSex = (HKBiologicalSex)[storedUserData.biologicalSex integerValue];
    _bloodType = (HKBloodType) [storedUserData.bloodType integerValue];
    _consented = [storedUserData.serverConsented boolValue];
    _userConsented = [storedUserData.userConsented boolValue];
    _medicalConditions = [storedUserData.medicalConditions copy];
    _medications = [storedUserData.medications copy];
    _wakeUpTime = [storedUserData.wakeUpTime copy];
    _sleepTime = [storedUserData.sleepTime copy];
    _ethnicity = [storedUserData.ethnicity copy];
    _glucoseLevels = [storedUserData.glucoseLevels copy];
    _homeLocationAddress = [storedUserData.homeLocationAddress copy];
    _homeLocationLat = [storedUserData.homeLocationLat copy];
    _homeLocationLong = [storedUserData.homeLocationLong copy];
    _secondaryInfoSaved = [storedUserData.secondaryInfoSaved boolValue];
    
    _consentSignatureLastName = [storedUserData.consentSignatureLastName copy];
    _consentSignatureFirstName = [storedUserData.consentSignatureFirstName copy];
    _patientXZCareID = [storedUserData.patientXZCareID copy];
    _consentSignatureDate = [storedUserData.consentSignatureDate copy];
    _consentSignatureImage = [storedUserData.consentSignatureImage copy];
    
    _dailyScalesCompletionCounter = [[storedUserData.dailyScalesCompletionCounter copy] integerValue];
    _customSurveyQuestion = [storedUserData.customSurveyQuestion copy];
    _hasHeartDisease = [[storedUserData.hasHeartDisease copy] integerValue];
    _taskCompletion = [storedUserData.taskCompletion copy];
    _sharedOptionSelection = [storedUserData.sharedOptionSelection copy];
}

- (void)updateStoredProperty:(NSString *)propertyName withValue:(id)value
{
    NSManagedObjectContext * context = [(XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate dataSubstrate].persistentContext;
    [context performBlockAndWait:^{
        XZCareCoreDBStoredUserData *storedUserData = [self loadStoredUserDataInContext:context];
        [storedUserData setValue:value forKey:propertyName];
        NSError *saveError;
        [storedUserData saveToPersistentStore:&saveError];
        XZCareLogError2(saveError);
    }];
}

- (HKHealthStore *)healthStore
{
    return [[(XZCareCoreAppDelegate*) ([UIApplication sharedApplication].delegate) dataSubstrate] healthStore];
}

/*********************************************************************************/
#pragma mark - Properties from Key Chain
/*********************************************************************************/
/*
- (NSString *)name
{
    return [XZBaseKeychainStore stringForKey:kNamePropertytName];
}

- (void)setName:(NSString *)name
{
    if (name != nil)
    {
        [XZBaseKeychainStore setString:name forKey:kNamePropertytName];
    }
    else
    {
        [XZBaseKeychainStore removeValueForKey:kNamePropertytName];
    }
}

- (NSString *)firstName
{
    return [XZBaseKeychainStore stringForKey:kFirstNamePropertytName];
}

- (void)setFirstName:(NSString *)firstName
{
    if (firstName != nil)
    {
        [XZBaseKeychainStore setString:firstName forKey:kFirstNamePropertytName];
    }
    else
    {
        [XZBaseKeychainStore removeValueForKey:kFirstNamePropertytName];
    }
}

- (NSString *)lastName
{
    return [XZBaseKeychainStore stringForKey:kLastNamePropertyName];
}

- (void)setLastName:(NSString *)lastName
{
    if (lastName != nil)
    {
        [XZBaseKeychainStore setString:lastName forKey:kLastNamePropertyName];
    }
    else
    {
        [XZBaseKeychainStore removeValueForKey:kLastNamePropertyName];
    }
}
*/

- (NSString *)email
{
      return [XZBaseKeychainStore stringForKey:kEmailPropertyName];
}

-(void)setEmail:(NSString *)email
{
    [XZBaseKeychainStore setString:email forKey:kEmailPropertyName];
}

- (NSString *)password
{
    return [XZBaseKeychainStore stringForKey:kPasswordPropertyName];
}

-(void)setPassword:(NSString *)password
{
    [XZBaseKeychainStore setString:[self hashIfNeeded:password] forKey:kPasswordPropertyName];
}

- (NSString*) hashIfNeeded: (NSString*) password
{
    //TODO: Implement hashing method
    return password;
}


/*********************************************************************************/
#pragma mark - Setters for Properties in Core Data
/*********************************************************************************/

- (void)setSharingScope:(XZCareUserConsentSharingScope)sharingScope
{
    _sharingScope = sharingScope;
    switch (sharingScope)
    {
        case XZCareUserConsentSharingScopeNone:
            self.sharedOptionSelection = [NSNumber numberWithInteger:0];    // SBBConsentShareScopeNone
            break;
        case XZCareUserConsentSharingScopeStudy:
            self.sharedOptionSelection = [NSNumber numberWithInteger:1];    // SBBConsentShareScopeStudy
            break;
        case XZCareUserConsentSharingScopeAll:
            self.sharedOptionSelection = [NSNumber numberWithInteger:2];    // SBBConsentShareScopeAll
            break;
    }
}

- (void)setSharedOptionSelection:(NSNumber *)sharedOptionSelection
{
    switch (sharedOptionSelection.integerValue)
    {
        case 0:
            _sharingScope = XZCareUserConsentSharingScopeNone;
            break;
        case 1:
            _sharingScope = XZCareUserConsentSharingScopeStudy;
            break;
        case 2:
            _sharingScope = XZCareUserConsentSharingScopeAll;
            break;
    }
    
    _sharedOptionSelection = sharedOptionSelection;
    [self updateStoredProperty:kSharedOptionSelection withValue:sharedOptionSelection];
}

- (void)setTaskCompletion:(NSDate *)taskCompletion
{
    _taskCompletion = taskCompletion;
    [self updateStoredProperty:kTaskCompletion withValue:taskCompletion];
}

- (void)setHasHeartDisease:(NSInteger)hasHeartDisease
{
    _hasHeartDisease = hasHeartDisease;
    [self updateStoredProperty:kHasHeartDisease withValue:@(hasHeartDisease)];
}

- (void)setAllowContact:(BOOL)allowContact
{
    _allowContact = allowContact;
    [self updateStoredProperty:kAllowContactPropertyName withValue:@(allowContact)];
}

- (void)setCustomSurveyQuestion:(NSString *)customSurveyQuestion
{
    _customSurveyQuestion = customSurveyQuestion;
    [self updateStoredProperty:kCustomSurveyQuestionPropertyName withValue:customSurveyQuestion];
}

- (void)setDailyScalesCompletionCounter:(NSInteger)dailyScalesCompletionCounter
{
    _dailyScalesCompletionCounter = dailyScalesCompletionCounter;
    [self updateStoredProperty:kDailyScalesCompletionCounterPropertyName withValue:@(dailyScalesCompletionCounter)];
}

- (void)setPhoneNumber:(NSString *)phoneNumber
{
    _phoneNumber = phoneNumber;
    [self updateStoredProperty:kPhoneNumberPropertyName withValue:phoneNumber];
}

- (void)setProfileImage:(NSData *)profileImage
{
    _profileImage = profileImage;
    [self updateStoredProperty:kProfileImagePropertyName withValue:profileImage];
}

- (void)setConsented:(BOOL)consented
{
    _consented = consented;
    [self updateStoredProperty:kConsentedPropertyName withValue:@(consented)];
    if (consented) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XZCareUserDidConsentNotification object:nil];
    }
}

- (void)setUserConsented:(BOOL)userConsented
{
    _userConsented = userConsented;
    [self updateStoredProperty:kUserConsentedPropertyName withValue:@(userConsented)];
}

- (void)setMedicalConditions:(NSString *)medicalConditions
{
    _medicalConditions = medicalConditions;
    [self updateStoredProperty:kMedicalConditionsPropertyName withValue:medicalConditions];
}

- (void)setMedications:(NSString *)medications
{
    _medications = medications;
    [self updateStoredProperty:kMedicationsPropertyName withValue:medications];
}

- (void)setWakeUpTime:(NSDate *)wakeUpTime{
    _wakeUpTime = wakeUpTime;
    [self updateStoredProperty:kWakeUpTimePropertyName withValue:wakeUpTime];
}

- (void)setSleepTime:(NSDate *)sleepTime
{
    _sleepTime = sleepTime;
    [self updateStoredProperty:kSleepTimePropertyName withValue:sleepTime];
}

- (void)setEthnicity:(NSString *)ethnicity
{
    _ethnicity = ethnicity;
    [self updateStoredProperty:kEthnicityPropertyName withValue:ethnicity];
}

- (void)setGlucoseLevels:(NSString *)glucoseLevels
{
    _glucoseLevels = glucoseLevels;
    [self updateStoredProperty:kGlucoseLevelsPropertyName withValue:glucoseLevels];
}

- (void)setHomeLocationAddress:(NSString *)homeLocationAddress
{
    _homeLocationAddress = homeLocationAddress;
    [self updateStoredProperty:kHomeLocationAddressPropertyName withValue:homeLocationAddress];
}

- (void)setHomeLocationLat:(NSNumber *)homeLocationLat
{
    _homeLocationLat = homeLocationLat;
    [self updateStoredProperty:kHomeLocationLatPropertyName withValue:homeLocationLat];
}

- (void)setHomeLocationLong:(NSNumber *)homeLocationLong
{
    _homeLocationLong = homeLocationLong;
    [self updateStoredProperty:kHomeLocationLongPropertyName withValue:homeLocationLong];
    
}

- (void)setSecondaryInfoSaved:(BOOL)secondaryInfoSaved
{
    _secondaryInfoSaved = secondaryInfoSaved;
    [self updateStoredProperty:kSecondaryInfoSavedPropertyName withValue:@(secondaryInfoSaved)];
}

- (void)setConsentSignatureLastName:(NSString *)consentSignatureLastName
{
    _consentSignatureLastName = consentSignatureLastName;
    [self updateStoredProperty:kConsentSignatureLastNamePropertyName withValue:consentSignatureLastName];
}

- (void)setConsentSignatureFirstName:(NSString *)consentSignatureFirstName
{
    _consentSignatureFirstName = consentSignatureFirstName;
    [self updateStoredProperty:kConsentSignatureFirstNamePropertyName withValue:consentSignatureFirstName];
}

- (void)setPatientXZCareID:(NSString *)patientXZCareID
{
    _patientXZCareID = patientXZCareID;
    [self updateStoredProperty:kPatientXZCareIDPropertyName withValue:patientXZCareID];
}

- (void)setConsentSignatureDate:(NSDate *)consentSignatureDate
{
    _consentSignatureDate = consentSignatureDate;
    [self updateStoredProperty:kConsentSignatureDatePropertyName withValue:consentSignatureDate];
}

- (void)setConsentSignatureImage:(NSData *)consentSignatureImage
{
    _consentSignatureImage = consentSignatureImage;
    [self updateStoredProperty:kConsentSignatureImagePropertyName withValue:consentSignatureImage];
}

/*********************************************************************************/
#pragma mark - Simulated Properties using HealthKit
/*********************************************************************************/

- (NSDate *)birthDate
{
    NSError *error;
    NSDate *dateOfBirth = [self.healthStore dateOfBirthWithError:&error];
    XZCareLogError2 (error);
    return dateOfBirth ?: _birthDate;
}

- (void)setBirthDate:(NSDate *)birthDate
{
    _birthDate = birthDate;
    [self updateStoredProperty:kBirthDatePropertyName withValue:birthDate];
}

- (HKBiologicalSex)biologicalSex
{
    NSError *error;
    HKBiologicalSexObject * sexObject = [self.healthStore biologicalSexWithError:&error];
    XZCareLogError2 (error);
    return sexObject.biologicalSex?:_biologicalSex;
}

- (void)setBiologicalSex:(HKBiologicalSex)biologicalSex
{
    _biologicalSex = biologicalSex;
    [self updateStoredProperty:kBiologicalSexPropertyName withValue:@(biologicalSex)];
}

- (HKBloodType)bloodType
{
    NSError *error;
    HKBloodTypeObject * bloodObject = [self.healthStore bloodTypeWithError:&error];
    XZCareLogError2 (error);
    return bloodObject.bloodType?: _bloodType;
}

- (void)setBloodType:(HKBloodType)bloodType
{
    _bloodType = bloodType;
    [self updateStoredProperty:kBloodTypePropertyName withValue:@(bloodType)];
}

/******************************************************************************/
/*                                                                            */
/* Height                                                                     */
/*                                                                            */
/******************************************************************************/
- (HKQuantity *)height
{
    //???????????????????
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block HKQuantity * height;
    [self.healthStore mostRecentQuantitySampleOfType:heightType predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        XZCareLogError2 (error);
        height = mostRecentQuantity;
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    sema = NULL;
    return height;
    
}

- (void)setHeight:(HKQuantity *)height
{
    
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    NSDate *now = [NSDate date];
    
    HKQuantitySample *heightSample = [HKQuantitySample quantitySampleWithType:heightType quantity:height startDate:now endDate:now];
    
    [self.healthStore saveObject:heightSample withCompletion:^(BOOL __unused success, NSError *error) {
        XZCareLogError2 (error);
    }];
}

/******************************************************************************/
/*                                                                            */
/* Weight                                                                     */
/*                                                                            */
/******************************************************************************/
- (HKQuantity *)weight
{
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block HKQuantity * weight;
    [self.healthStore mostRecentQuantitySampleOfType:weightType predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        XZCareLogError2 (error);
        weight = mostRecentQuantity;
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    sema = NULL;
    return weight;
}

- (void)setWeight:(HKQuantity *)weight
{
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    NSDate *now = [NSDate date];
    
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weight startDate:now endDate:now];
    
    [self.healthStore saveObject:weightSample withCompletion:^(BOOL __unused success, NSError *error) {
        XZCareLogError2 (error);
    }];
}

/******************************************************************************/
/*                                                                            */
/* Systolic Blood Pressure                                                    */
/*                                                                            */
/******************************************************************************/
- (HKQuantity *)systolicBloodPressure
{
    HKQuantityType *bloodPressureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block HKQuantity *systolicBloodPressure;
    [self.healthStore mostRecentQuantitySampleOfType:bloodPressureType predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        XZCareLogError2 (error);
        systolicBloodPressure = mostRecentQuantity;
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    sema = NULL;
    return systolicBloodPressure;
}

- (void)setSystolicBloodPressure:(HKQuantity *)systolicBloodPressure
{
    HKQuantityType *bloodPressureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    NSDate *now = [NSDate date];
    
    HKQuantitySample *systolicBloodPressureSample = [HKQuantitySample quantitySampleWithType:bloodPressureType quantity:systolicBloodPressure startDate:now endDate:now];
    
    [self.healthStore saveObject:systolicBloodPressureSample withCompletion:^(BOOL __unused success, NSError *error) {
        XZCareLogError2 (error);
    }];
}

/******************************************************************************/
/*                                                                            */
/* Diastolic Blood Pressure                                                   */
/*                                                                            */
/******************************************************************************/
- (HKQuantity *)diastolicBloodPressure
{
    HKQuantityType *bloodPressureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block HKQuantity *diastolicBloodPressure;
    [self.healthStore mostRecentQuantitySampleOfType:bloodPressureType predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        XZCareLogError2 (error);
        diastolicBloodPressure = mostRecentQuantity;
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    sema = NULL;
    return diastolicBloodPressure;
}

-(void)setDiastolicBloodPressure:(HKQuantity *)diastolicBloodPressure
{
    HKQuantityType *bloodPressureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    NSDate *now = [NSDate date];
    
    HKQuantitySample *diastolicBloodPressureSample = [HKQuantitySample quantitySampleWithType:bloodPressureType quantity:diastolicBloodPressure startDate:now endDate:now];
    
    [self.healthStore saveObject:diastolicBloodPressureSample withCompletion:^(BOOL __unused success, NSError *error) {
        XZCareLogError2 (error);
    }];
}

/******************************************************************************/
/*                                                                            */
/* Glucose Level                                                              */
/*                                                                            */
/******************************************************************************/
- (HKQuantity *)glucoseLevel
{
    HKQuantityType *glucoseLevelType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block HKQuantity *glucoseLevel;
    [self.healthStore mostRecentQuantitySampleOfType:glucoseLevelType predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        XZCareLogError2 (error);
        glucoseLevel = mostRecentQuantity;
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    sema = NULL;
    return glucoseLevel;
}

-(void)setGlucoseLevel:(HKQuantity *)glucoseLevel
{
    HKQuantityType *glucoseLevelType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    NSDate *now = [NSDate date];
    
    HKQuantitySample *glucoseLevelSample = [HKQuantitySample quantitySampleWithType:glucoseLevelType quantity:glucoseLevel startDate:now endDate:now];
    
    [self.healthStore saveObject:glucoseLevelSample withCompletion:^(BOOL __unused success, NSError *error) {
        XZCareLogError2 (error);
    }];
}


/*********************************************************************************/
#pragma mark - NSUserDefault Simulated Methods
/*********************************************************************************/
- (void)setSignedUp:(BOOL)signedUp
{
    [[NSUserDefaults standardUserDefaults] setBool:signedUp forKey:kSignedUpKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (signedUp)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)XZCareUserSignedUpNotification object:nil];
    }
}

- (BOOL)isSignedUp
{
#ifdef __BYPASS_SIGNIN__
    return YES;
#else
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSignedUpKey];
#endif
}

- (void)setSignedIn:(BOOL)signedIn
{
    [[NSUserDefaults standardUserDefaults] setBool:signedIn forKey:kSignedInKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (signedIn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)XZCareUserSignedInNotification object:nil];
    }
}

- (BOOL)isSignedIn
{
#ifdef __BYPASS_SIGNIN__
    return YES;
#else
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSignedInKey];
#endif
}

- (BOOL)isLoggedOut
{
    return self.email.length && !self.isSignedIn && !self.isSignedUp;
}

@end

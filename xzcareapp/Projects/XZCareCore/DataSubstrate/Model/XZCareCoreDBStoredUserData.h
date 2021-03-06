//
//  XZCareCoreDBStoredUserData.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-09-28.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface XZCareCoreDBStoredUserData : NSManagedObject

@property (nonatomic, retain) NSNumber * allowContact;
@property (nonatomic, retain) NSNumber * biologicalSex;
@property (nonatomic, retain) NSDate * birthDate;
@property (nonatomic, retain) NSNumber * bloodType;
@property (nonatomic, retain) NSDate * consentSignatureDate;
@property (nonatomic, retain) NSData * consentSignatureImage;
@property (nonatomic, retain) NSString * consentSignatureLastName;
@property (nonatomic, retain) NSString * consentSignatureFirstName;
@property (nonatomic, retain) NSString * patientXZCareID;
@property (nonatomic, retain) NSString * customSurveyQuestion;
@property (nonatomic, retain) NSNumber * dailyScalesCompletionCounter;
@property (nonatomic, retain) NSString * ethnicity;
@property (nonatomic, retain) NSString * glucoseLevels;
@property (nonatomic, retain) NSNumber * hasHeartDisease;
@property (nonatomic, retain) NSString * homeLocationAddress;
@property (nonatomic, retain) NSNumber * homeLocationLat;
@property (nonatomic, retain) NSNumber * homeLocationLong;
@property (nonatomic, retain) NSString * medicalConditions;
@property (nonatomic, retain) NSString * medications;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSData * profileImage;
@property (nonatomic, retain) NSNumber * secondaryInfoSaved;
@property (nonatomic, retain) NSNumber * serverConsented;
@property (nonatomic, retain) NSNumber * sharedOptionSelection;
@property (nonatomic, retain) NSDate * sleepTime;
@property (nonatomic, retain) NSDate * taskCompletion;
@property (nonatomic, retain) NSNumber * userConsented;
@property (nonatomic, retain) NSDate * wakeUpTime;

@end

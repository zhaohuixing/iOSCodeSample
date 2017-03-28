//
//  XZCarePatient+Cloud.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-08-20.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <XZCareCore/XZCarePatient.h>

@interface XZCarePatient (Cloud)

/* Signup, Signin*/
- (BOOL) isConnectCloud;
- (void) signUpOnCompletion:(void (^)(NSError * error))completionBlock;
- (void) signInOnCompletion:(void (^)(NSError * error))completionBlock;
- (void) signOutOnCompletion:(void (^)(NSError * error))completionBlock;
- (void) updateProfileOnCompletion:(void (^)(NSError * error))completionBlock;
//- (void) updateCustomProfile:(SBBUserProfile*)profile onCompletion:(void (^)(NSError * error))completionBlock;
- (void) updateCustomProfile:(id)profile onCompletion:(void (^)(NSError * error))completionBlock;
- (void) getProfileOnCompletion:(void (^)(NSError *error))completionBlock;
//- (void) sendUserConsentedToBridgeOnCompletion: (void (^)(NSError * error))completionBlock;
- (void) sendUserConsentedToCloudServiceOnCompletion: (void (^)(NSError * error))completionBlock;
- (void) retrieveConsentOnCompletion:(void (^)(NSError *error))completionBlock;
- (void) withdrawStudyOnCompletion:(void (^)(NSError *error))completionBlock;
- (void) resumeStudyOnCompletion:(void (^)(NSError *error))completionBlock;
- (void) resendEmailVerificationOnCompletion:(void (^)(NSError *))completionBlock;
- (void) changeDataSharingTypeOnCompletion:(void (^)(NSError *))completionBlock;


@end

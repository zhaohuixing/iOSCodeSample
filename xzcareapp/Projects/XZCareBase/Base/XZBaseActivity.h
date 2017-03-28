//
//  XZBaseActivity.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>

#import "XZBaseGuidCreatedOnVersionHolder.h"

@interface XZBaseActivity : XZBaseObject

@property (nonatomic, strong) NSString* activityType;
@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) NSString* ref;
@property (nonatomic, strong) XZBaseGuidCreatedOnVersionHolder* survey;

#ifdef DEBUG
- (void)DebugLog;
#endif

@end

//
//  XZBaseSurveyResponse.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>
#import "XZBaseSurvey.h"

@interface XZBaseSurveyResponse : XZBaseObject

@property (nonatomic, strong) NSArray* answers;
@property (nonatomic, strong) NSDate* completedOn;
@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSDate* startedOn;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) XZBaseSurvey* survey;

#ifdef DEBUG
-(void)DebugLog;
#endif

@end

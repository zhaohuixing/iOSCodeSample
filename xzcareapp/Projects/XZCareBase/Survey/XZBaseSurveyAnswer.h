//
//  XZBaseSurveyAnswer.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>
#import "XZBaseSurveyAnswerBase.h"

@interface XZBaseSurveyAnswer : XZBaseObject

@property (nonatomic, strong) NSDate* answeredOn;
//@property (nonatomic, strong) NSArray* answers;
@property (nonatomic, strong) id<XZBaseSurveyAnswerBase> answer;

@property (nonatomic, strong) NSString* client;
@property (nonatomic, strong) NSNumber* declined;
@property (nonatomic, assign) BOOL declinedValue;
@property (nonatomic, strong) NSString* questionGuid;

#ifdef DEBUG
-(void)DebugLog;
#endif

@end

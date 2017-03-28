//
//  XZBaseDateTimeConstraints.h
//

#import <Foundation/Foundation.h>
#import "XZBaseSurveyConstraints.h"

@interface XZBaseDateTimeConstraints : XZBaseSurveyConstraints

@property (nonatomic, strong) NSNumber* allowFuture;
@property (nonatomic, assign) BOOL allowFutureValue;
@property (nonatomic, strong) NSDate* earliestValue;
@property (nonatomic, strong) NSDate* latestValue;

#ifdef DEBUG
- (void)DebugLog;
#endif

@end

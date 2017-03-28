//
//  XZBaseDurationConstraints.h
//

#import <Foundation/Foundation.h>
#import "XZBaseSurveyConstraints.h"

@interface XZBaseDurationConstraints : XZBaseSurveyConstraints

@property (nonatomic, strong) NSString* unit;

#ifdef DEBUG
- (void)DebugLog;
#endif

@end

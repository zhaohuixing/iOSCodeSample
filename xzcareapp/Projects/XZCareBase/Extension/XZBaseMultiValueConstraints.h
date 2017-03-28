//
//  XZBaseMultiValueConstraints.h
//

#import <Foundation/Foundation.h>
#import "XZBaseSurveyConstraints.h"

@interface XZBaseMultiValueConstraints : XZBaseSurveyConstraints

@property (nonatomic, strong) NSNumber* allowMultiple;
@property (nonatomic, assign) BOOL allowMultipleValue;
@property (nonatomic, strong) NSNumber* allowOther;
@property (nonatomic, assign) BOOL allowOtherValue;
@property (nonatomic, strong) NSArray* enumeration;

#ifdef DEBUG
- (void)DebugLog;
#endif

@end

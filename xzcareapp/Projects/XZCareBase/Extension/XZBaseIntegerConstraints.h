//
//  XZBaseIntegerConstraints.h
//

#import <Foundation/Foundation.h>
#import "XZBaseSurveyConstraints.h"

@interface XZBaseIntegerConstraints : XZBaseSurveyConstraints

@property (nonatomic, strong) NSNumber* maxValue;
@property (nonatomic, assign) int64_t maxValueValue;
@property (nonatomic, strong) NSNumber* minValue;
@property (nonatomic, assign) int64_t minValueValue;
@property (nonatomic, strong) NSNumber* step;
@property (nonatomic, assign) int64_t stepValue;
@property (nonatomic, strong) NSString* unit;

#ifdef DEBUG
- (void)DebugLog;
#endif
@end

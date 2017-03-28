//
//  XZBaseDecimalConstraints.h
//

#import <Foundation/Foundation.h>
#import "XZBaseSurveyConstraints.h"

@interface XZBaseDecimalConstraints : XZBaseSurveyConstraints

@property (nonatomic, strong) NSNumber* maxValue;
@property (nonatomic, assign) double maxValueValue;
@property (nonatomic, strong) NSNumber* minValue;
@property (nonatomic, assign) double minValueValue;
@property (nonatomic, strong) NSNumber* step;
@property (nonatomic, assign) double stepValue;
@property (nonatomic, strong) NSString* unit;

#ifdef DEBUG
- (void)DebugLog;
#endif

@end

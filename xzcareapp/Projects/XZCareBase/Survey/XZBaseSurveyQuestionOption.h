//
//  XZBaseSurveyQuestionOption.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>
#import "XZBaseImage.h"

@interface XZBaseSurveyQuestionOption : XZBaseObject

@property (nonatomic, strong) NSString* detail;
@property (nonatomic, strong) XZBaseImage* image;
@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) NSString* value;

#ifdef DEBUG
-(void)DebugLog;
#endif

@end

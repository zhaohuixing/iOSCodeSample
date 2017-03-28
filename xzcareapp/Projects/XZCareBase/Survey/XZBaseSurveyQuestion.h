//
//  XZBaseSurveyQuestion.h
//

#import <Foundation/Foundation.h>
#import "XZBaseSurveyElement.h"
#import "XZBaseSurveyConstraints.h"

@interface XZBaseSurveyQuestion : XZBaseSurveyElement

@property (nonatomic, strong) XZBaseSurveyConstraints* constraints;
@property (nonatomic, strong) NSString* uiHint;
@property (nonatomic, strong) NSString* detail;

#ifdef DEBUG
-(void)DebugLog;
#endif

@end

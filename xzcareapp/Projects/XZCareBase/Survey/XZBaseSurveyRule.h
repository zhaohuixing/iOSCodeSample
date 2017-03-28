//
//  XZBaseSurveyRule.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>

@interface XZBaseSurveyRule : XZBaseObject

@property (nonatomic, strong) NSString* operator;
@property (nonatomic, strong) NSString* skipTo;
@property (nonatomic, strong) id value;   //NSNumber or NSString object

#ifdef DEBUG
-(void)DebugLog;
#endif

@end

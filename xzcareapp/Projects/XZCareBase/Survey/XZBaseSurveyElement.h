//
//  XZBaseSurveyElement.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>

@interface XZBaseSurveyElement : XZBaseObject

@property (nonatomic, strong) NSString* guid;
@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSString* prompt;
@property (nonatomic, strong) NSString* promptDetail;

#ifdef DEBUG
-(void)DebugLog;
#endif

@end

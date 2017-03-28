//
//  XZBaseSurveyInfoScreen.h
//

#import <Foundation/Foundation.h>
#import "XZBaseSurveyElement.h"
#import "XZBaseImage.h"

@interface XZBaseSurveyInfoScreen : XZBaseSurveyElement

@property (nonatomic, strong) XZBaseImage*  image;
@property (nonatomic, strong) NSString*     title;

#ifdef DEBUG
-(void)DebugLog;
#endif

@end

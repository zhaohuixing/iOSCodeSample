//
//  XZBaseImage.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>

@interface XZBaseImage : XZBaseObject

@property (nonatomic, strong) NSNumber* height;
@property (nonatomic, assign) double heightValue;
@property (nonatomic, strong) NSString* source;
@property (nonatomic, strong) NSNumber* width;
@property (nonatomic, assign) double widthValue;

#ifdef DEBUG
- (void)DebugLog;
#endif

@end

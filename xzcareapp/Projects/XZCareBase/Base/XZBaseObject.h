//
//  XZBaseObject.h
//
//

#import <Foundation/Foundation.h>
#import <XZCareBase/ModelObject.h>

@interface XZBaseObject : ModelObject

@property (nonatomic, strong, readonly) NSString* type;

+(void)RegisterClassType;

#ifdef DEBUG
- (void)DebugLog;
#endif

@end

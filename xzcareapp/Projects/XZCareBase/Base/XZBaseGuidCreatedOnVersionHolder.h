//
//  XZBaseGuidCreatedOnVersionHolder.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>

@interface XZBaseGuidCreatedOnVersionHolder : XZBaseObject

@property (nonatomic, strong) NSDate* createdOn;
@property (nonatomic, strong) NSString* guid;
@property (nonatomic, strong) NSNumber* version;
@property (nonatomic, assign) int64_t versionValue;

#ifdef DEBUG
- (void)DebugLog;
#endif

@end

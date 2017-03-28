//
//  XZBaseIdentifierHolder.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>

@interface XZBaseIdentifierHolder : XZBaseObject

@property (nonatomic, strong) NSString* identifier;

#ifdef DEBUG
- (void)DebugLog;
#endif

@end

//
//  XZBaseResourceList.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>

@interface XZBaseResourceList : XZBaseObject

@property (nonatomic, strong) NSArray* items;  //XZBaseSchedule object list
@property (nonatomic, strong) NSNumber* total;
@property (nonatomic, assign) int64_t totalValue;

#ifdef DEBUG
- (void)DebugLog;
#endif

@end

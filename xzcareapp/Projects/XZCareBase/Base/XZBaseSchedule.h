//
//  XZBaseSchedule.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>

@interface XZBaseSchedule : XZBaseObject

@property (nonatomic, strong) NSArray* activities; //XZBaseActivity object list
@property (nonatomic, strong) NSString* cronTrigger;
@property (nonatomic, strong) NSDate* endsOn;
@property (nonatomic, strong) NSString* expires;
@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) NSString* scheduleType;
@property (nonatomic, strong) NSDate* startsOn;

#ifdef DEBUG
- (void)DebugLog;
#endif

@end

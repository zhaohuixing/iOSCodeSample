//
//  XZBaseSurvey.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>


@interface XZBaseSurvey : XZBaseObject

@property (nonatomic, strong) NSDate* createdOn;
@property (nonatomic, strong) NSArray* elements;
@property (nonatomic, strong) NSString* guid;
@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSDate* modifiedOn;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* published;
@property (nonatomic, assign) BOOL publishedValue;
@property (nonatomic, strong) NSNumber* version;
@property (nonatomic, assign) double versionValue;

@property (nonatomic, strong) NSArray* questions;


#ifdef DEBUG
- (void)DebugLog;
#endif

@end

//
//  NSDate+XZCareBase.h
//

#import <Foundation/Foundation.h>

@interface NSDate (XZCareBase)

+ (instancetype)dateWithISO8601String:(NSString *)iso8601string;

- (NSString *)ISO8601String;
- (NSString *)ISO8601StringUTC;

@end

//
//  XZBaseAddress.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>

@interface XZBaseAddress : XZBaseObject

@property (nonatomic, strong) NSNumber* streetNumber;
@property (nonatomic, strong) NSString* streetName;
@property (nonatomic, strong) NSNumber* aptNumber;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* province;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* postcode;
@property (nonatomic, strong) NSNumber* addressLatitue;             //Can be empty
@property (nonatomic, strong) NSNumber* addressLongitude;           //Can be empty

@property (nonatomic, readonly, getter=GetLatitude) double      latitudeValue;
@property (nonatomic, readonly, getter=GetLongitude) double     longitudeValue;

@end

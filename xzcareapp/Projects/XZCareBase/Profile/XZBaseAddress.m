//
//  XZBaseAddress.m
//

#import "XZBaseAddress.h"

@implementation XZBaseAddress

- (id)init
{
	if((self = [super init]))
	{
	}

	return self;
}

#pragma mark Scalar values

- (double)latitudeValue
{
	return [self.addressLatitue doubleValue];
}

- (void)setLatitudeValue:(double)value_
{
	self.addressLatitue = [NSNumber numberWithDouble:value_];
}

- (double)longitudeValue
{
	return [self.addressLongitude doubleValue];
}

- (void)setLongitudeValue:(double)value_
{
	self.addressLongitude = [NSNumber numberWithDouble:value_];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
        self.streetNumber = [dictionary objectForKey:@"streetNumber"];
        self.streetName = [dictionary objectForKey:@"streetName"];
        self.aptNumber = [dictionary objectForKey:@"aptNumber"];
        self.city = [dictionary objectForKey:@"city"];
        self.province = [dictionary objectForKey:@"province"];
        self.country = [dictionary objectForKey:@"country"];
        self.postcode = [dictionary objectForKey:@"postcode"];
        self.addressLatitue = [dictionary objectForKey:@"addressLatitue"];
        self.addressLongitude = [dictionary objectForKey:@"addressLongitude"];
        if(self.addressLatitue)
            self.latitudeValue = [self.addressLatitue doubleValue];
        if(self.addressLongitude)
            self.longitudeValue = [self.addressLongitude doubleValue];
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.streetNumber = [dictionary objectForKey:@"streetNumber"];
    self.streetName = [dictionary objectForKey:@"streetName"];
    self.aptNumber = [dictionary objectForKey:@"aptNumber"];
    self.city = [dictionary objectForKey:@"city"];
    self.province = [dictionary objectForKey:@"province"];
    self.country = [dictionary objectForKey:@"country"];
    self.postcode = [dictionary objectForKey:@"postcode"];
    self.addressLatitue = [dictionary objectForKey:@"addressLatitue"];
    self.addressLongitude = [dictionary objectForKey:@"addressLongitude"];
    if(self.addressLatitue)
        self.latitudeValue = [self.addressLatitue doubleValue];
    if(self.addressLongitude)
        self.longitudeValue = [self.addressLongitude doubleValue];
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.streetNumber forKey:@"streetNumber"];
    [dict setObjectIfNotNil:self.streetName forKey:@"streetName"];
    [dict setObjectIfNotNil:self.aptNumber forKey:@"aptNumber"];
    [dict setObjectIfNotNil:self.city forKey:@"city"];
    [dict setObjectIfNotNil:self.province forKey:@"province"];
    [dict setObjectIfNotNil:self.country forKey:@"country"];
    [dict setObjectIfNotNil:self.postcode forKey:@"postcode"];
    if(self.addressLatitue != nil)
        [dict setObjectIfNotNil:self.addressLatitue forKey:@"addressLatitue"];
    if(self.addressLongitude != nil)
        [dict setObjectIfNotNil:self.addressLongitude forKey:@"addressLongitude"];
	
    return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.

	[super awakeFromDictionaryRepresentationInit];
}

-(double)GetLatitude
{
    return self.latitudeValue;
}

-(double)GetLongitude
{
    return self.longitudeValue;
}

#pragma mark Direct access

@end

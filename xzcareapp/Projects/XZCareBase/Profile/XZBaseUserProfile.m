//
//  SBBUserProfile.m
//

#import "XZBaseUserProfile.h"
#import "NSDate+XZCareBase.h"

@interface XZBaseUserProfile()

@end

@implementation XZBaseUserProfile

- (id)init
{
	if((self = [super init]))
	{
        self.userID = [XZBaseUserProfile CreateDefaultUserID];
        self.address = nil;
	}

	return self;
}

#pragma mark Scalar values

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
        self.userID = [dictionary objectForKey:@"userID"];
        self.firstName = [dictionary objectForKey:@"firstName"];
        self.lastName = [dictionary objectForKey:@"lastName"];
        self.email = [dictionary objectForKey:@"email"];
        self.username = [dictionary objectForKey:@"username"];
        self.password = [dictionary objectForKey:@"password"];
        self.phonenumber = [dictionary objectForKey:@"phonenumber"];
        self.gender = [dictionary objectForKey:@"gender"];
        self.birthday = [NSDate dateWithISO8601String:[dictionary objectForKey:@"birthday"]];
        NSDictionary* addressPresentation = [dictionary objectForKey:@"address"];
        if(self.address == nil)
        {
            self.address = [[XZBaseAddress alloc] initWithDictionaryRepresentation:addressPresentation];
        }
        else
        {
            [self.address initializeFromDictionaryRepresentation:addressPresentation];
        }
    }

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.userID = [dictionary objectForKey:@"userID"];
    self.firstName = [dictionary objectForKey:@"firstName"];
    self.lastName = [dictionary objectForKey:@"lastName"];
    self.email = [dictionary objectForKey:@"email"];
    self.username = [dictionary objectForKey:@"username"];
    self.password = [dictionary objectForKey:@"password"];
    self.phonenumber = [dictionary objectForKey:@"phonenumber"];
    self.gender = [dictionary objectForKey:@"gender"];
    self.birthday = [NSDate dateWithISO8601String:[dictionary objectForKey:@"birthday"]];
    NSDictionary* addressPresentation = [dictionary objectForKey:@"address"];
    if(self.address == nil)
    {
        self.address = [[XZBaseAddress alloc] initWithDictionaryRepresentation:addressPresentation];
    }
    else
    {
        [self.address initializeFromDictionaryRepresentation:addressPresentation];
    }
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];

    [dict setObjectIfNotNil:self.userID forKey:@"userID"];
    [dict setObjectIfNotNil:self.firstName forKey:@"firstName"];
    [dict setObjectIfNotNil:self.lastName forKey:@"lastName"];
    [dict setObjectIfNotNil:self.email forKey:@"email"];
    [dict setObjectIfNotNil:self.username forKey:@"username"];
    [dict setObjectIfNotNil:self.password forKey:@"password"];
    [dict setObjectIfNotNil:self.phonenumber forKey:@"phonenumber"];
    [dict setObjectIfNotNil:self.gender forKey:@"gender"];
    [dict setObjectIfNotNil:[self.birthday ISO8601String] forKey:@"birthday"];

    if(self.address)
    {
        NSDictionary* addressPresentation = [self dictionaryRepresentation];
        [dict setObjectIfNotNil:addressPresentation forKey:@"address"];
    }
   
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.

	[super awakeFromDictionaryRepresentationInit];
}

+ (NSString*)CreateDefaultUserID
{
    NSString* newUserID = [NSString stringWithFormat:@"XZCareUser_%@", [[NSUUID UUID] UUIDString]];
    
    return newUserID;
}

#pragma mark Direct access

@end

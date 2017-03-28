//
//  XZBaseUserProfile.h
//

#import <Foundation/Foundation.h>
#import <XZCareBase/XZBaseObject.h>
#import "XZBaseAddress.h"

@interface XZBaseUserProfile : XZBaseObject

@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* phonenumber;
@property (nonatomic, strong) NSNumber* gender;
@property (nonatomic, strong) NSDate*   birthday;
@property (nonatomic, strong) XZBaseAddress*   address;


+(NSString*)CreateDefaultUserID;

@end

//
//  BTFilePlayerData.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BTFileConstant.h"
#import "GameMessage.h"

@interface BTFilePlayerData : NSObject<CLLocationManagerDelegate>
{
    NSString*   m_Auther;
    NSString*   m_Email;
    NSString*   m_GameCenterPlayerID;
    BOOL        m_bLocationEnable;
    float       m_fLatitude;
    float       m_fLongitude;
  
@private
    CLLocationManager*  m_LocationManager;

}

@property (nonatomic, readwrite, retain)NSString*   m_Auther;
@property (nonatomic, readwrite, retain)NSString*   m_Email;
@property (nonatomic, readwrite, retain)NSString*   m_GameCenterPlayerID;
@property (nonatomic)BOOL                           m_bLocationEnable;
@property (nonatomic)float                          m_fLatitude;
@property (nonatomic)float                          m_fLongitude;

-(void)Reset;
-(BOOL)FetchLocation;
-(void)DisableLocation;
-(void)SaveAutherToMessage:(GameMessage*)msg withKey:(NSString*)szKey;
-(void)SaveEmailToMessage:(GameMessage*)msg withKey:(NSString*)szKey;
-(void)SaveGameCenterPlayerIDToMessage:(GameMessage*)msg withKey:(NSString*)szKey;
-(void)SaveLocationEnableToMessage:(GameMessage*)msg withKey:(NSString*)szKey;
-(void)SaveLatitudeToMessage:(GameMessage*)msg withKey:(NSString*)szKey;
-(void)SaveLongitudeToMessage:(GameMessage*)msg withKey:(NSString*)szKey;
-(void)LoadAutherFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey;
-(void)LoadEmailFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey;
-(void)LoadGameCenterPlayerIDFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey;
-(void)LoadLocationEnableToMessage:(NSDictionary*)msgData withKey:(NSString*)szKey;
-(void)LoadLatitudeFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey;
-(void)LoadLongitudeFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey;
-(BOOL)IsLocationEnable;
-(void)SetLocationEnable:(BOOL)bEnable;
@end

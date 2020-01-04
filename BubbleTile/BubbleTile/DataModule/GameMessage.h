//
//  GameMessage.h
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface GameMessage : NSObject 
{
//The game message is formatted into JSON string    
@public
    NSString*                   _m_GameMessage;
@private
    NSMutableDictionary*        m_MessageStream;
}
@property(nonatomic, readonly)NSString*         m_GameMessage;

-(id)init;
-(void)Reset;
-(void)FormatMessage;
-(void)AddMessage:(NSString*)szKey withString:(NSString*)szText;
-(void)AddMessage:(NSString*)szKey withNumber:(NSNumber*)number;
-(void)AddMessage:(NSString*)szKey withArray:(NSArray*)Array;
-(void)AddMessage:(NSString*)szKey withDictionary:(NSDictionary*)dict;

@end

//
//  NYCCommunicationManager.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-03-30.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYCCommunicationManager : NSObject

+(NYCCommunicationManager*)GetCommunicationManager;

-(void)DirectSendMessageToContainerApp:(NSDictionary*)messageData withActionKey:(NSString*)szActionID;
-(void)SendActionToMainApp:(int)nAction withChoice:(int)nChoice withOption:(int)nOption;
-(void)SendCurrentLocationRequestToMainApp;
-(void)SendGeneralRequestToMainApp;

-(void)RegisterWatchController:(id)wkController;
-(void)BroadcastRemoveAllAnnotations;

@end

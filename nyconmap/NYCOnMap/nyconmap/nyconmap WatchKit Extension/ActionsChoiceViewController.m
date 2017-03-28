//
//  ActionsChoiceViewController.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-03-29.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "ActionsChoiceViewController.h"
#import "NYCCommunicationManager.h"
#import "NOMAppWatchDataHelper.h"
#import "NOMAppWatchConstants.h"
#import "InterfaceController.h"

@interface ActionsChoiceViewController()
{
    int16_t             m_nAction;
}

- (IBAction)onActionTrafficEvent;
- (IBAction)onActionSpotEvent;
- (IBAction)onActionTaxiEvent;

@end


@implementation ActionsChoiceViewController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    m_nAction = 0;
    // Configure interface objects here.
    if(context != nil && [context isKindOfClass:[NSNumber class]] == YES)
    {
        NSNumber* pAction = (NSNumber*)context;
        m_nAction = (int16_t)[pAction intValue];
    }
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)HandleActionChoiceEvent:(int16_t)nChoice
{
    if([NOMAppWatchDataHelper IsSimpleSearchMode] == NO || m_nAction == NOM_WATCH_ACTION_POST /*|| nChoice == NOM_WATCH_ACTION_CHOICE_SPOT*/)
    {
        NSNumber* pAction = [[NSNumber alloc] initWithInt:m_nAction];
        NSNumber* pChoice = [[NSNumber alloc] initWithInt:nChoice];
    
        NSDictionary *actionContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                        pAction, EMSG_KEY_ACTION,
                                        pChoice, EMSG_KEY_ACTIONCHOICE,
                                        nil];
    
        [self pushControllerWithName:@"optionsListViewController" context:actionContext];
    }
    else
    {
        if(m_nAction == NOM_WATCH_ACTION_SEARCH)
        {
            [InterfaceController SetForceCleanupMapViewFlag:YES];
        }
        [[NYCCommunicationManager GetCommunicationManager] SendActionToMainApp:m_nAction withChoice:nChoice withOption:-1];
        [self popToRootController];
    }
}

- (IBAction)onActionTrafficEvent
{
    [self HandleActionChoiceEvent:NOM_WATCH_ACTION_CHOICE_TRAFIC];
}

- (IBAction)onActionSpotEvent
{
    [self HandleActionChoiceEvent:NOM_WATCH_ACTION_CHOICE_SPOT];
}

- (IBAction)onActionTaxiEvent
{
    [self HandleActionChoiceEvent:NOM_WATCH_ACTION_CHOICE_TAXI];
}

@end




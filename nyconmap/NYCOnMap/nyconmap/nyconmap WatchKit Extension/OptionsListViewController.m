//
//  OptionsListViewController.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-03-30.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "OptionsListViewController.h"
#import "OptionItemTableRowController.h"
#import "NOMAppWatchConstants.h"
#import "NOMAppWatchDataHelper.h"
#import "NYCCommunicationManager.h"
#import "InterfaceController.h"
#import "UIInterfaceKeys.h"

@interface OptionsListViewController()
{
    int16_t             m_nAction;
    int16_t             m_nChoice;
}

@property (weak, nonatomic) IBOutlet WKInterfaceTable *m_OptionListTable;

-(void)LoadOptionListTable;

@end


@implementation OptionsListViewController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        //[self LoadOptionListTable];
    }
    
    return self;
}


- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    m_nAction = 0;
    m_nChoice = 0;
    
    if(context != nil && [context isKindOfClass:[NSDictionary class]] == YES)
    {
        NSDictionary* actionContext = (NSDictionary*)context;
        
        NSNumber* pAction = [actionContext objectForKey:EMSG_KEY_ACTION];
        NSNumber* pChoice = [actionContext objectForKey:EMSG_KEY_ACTIONCHOICE];

        m_nAction = [pAction intValue];
        m_nChoice = [pChoice intValue];
    }
    
    [self LoadOptionListTable];
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

-(void)SendActionToMainApp:(int16_t)nOption
{
    [[NYCCommunicationManager GetCommunicationManager] SendActionToMainApp:m_nAction withChoice:m_nChoice withOption:nOption];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    if(m_nAction == NOM_WATCH_ACTION_SEARCH)
    {
        [self SendActionToMainApp:(int16_t)(rowIndex -1)];
    }
    else if(m_nAction == NOM_WATCH_ACTION_POST)
    {
        [self SendActionToMainApp:(int16_t)rowIndex];
    }
    if(m_nAction == NOM_WATCH_ACTION_SEARCH)
    {
        [InterfaceController SetForceCleanupMapViewFlag:YES];
    }
    [self popToRootController];
}

-(void)RemoveTableItems
{
    if(0 < self.m_OptionListTable.numberOfRows)
    {
        NSRange indexValue = NSMakeRange(0, self.m_OptionListTable.numberOfRows);
        NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:indexValue];
        [self.m_OptionListTable removeRowsAtIndexes:indexSet];
    }
}

-(void)CreateSearchTrafficActionTableRows
{
    int16_t nRowCount = (NOM_WATCH_LOCALTRAFFIC_LASTID - NOM_WATCH_LOCALTRAFFIC_FIRSTID) + 1;
    [self.m_OptionListTable setNumberOfRows:nRowCount withRowType:OPTIONSTABLEROWCONTROLLER_ID];
    for(int16_t i = 0; i < nRowCount; ++i)
    {
        OptionItemTableRowController* optionRow = [self.m_OptionListTable rowControllerAtIndex:i];
        NSString* szLable = [NOMAppWatchDataHelper GetWatchTrafficChoiceTitle:(i - 1)];
        [optionRow SetOptionLabel:szLable];
    }
}

-(void)CreateSearchSpotActionTableRows
{
    int16_t nRowCount = (NOM_WATCH_TRAFFICSPOT_LASTID - NOM_WATCH_TRAFFICSPOT_FIRSTID) + 1;
    [self.m_OptionListTable setNumberOfRows:nRowCount withRowType:OPTIONSTABLEROWCONTROLLER_ID];
    for(int16_t i = 0; i < nRowCount; ++i)
    {
        OptionItemTableRowController* optionRow = [self.m_OptionListTable rowControllerAtIndex:i];
        NSString* szLable = [NOMAppWatchDataHelper GetWatchSpotChoiceTitle:(i - 1)];
        [optionRow SetOptionLabel:szLable];
    }
}

-(void)CreateSearchTaxiActionTableRows
{
    int16_t nRowCount = (NOM_WATCH_TAXI_LASTID - NOM_WATCH_TAXI_FIRSTID) + 1;
    [self.m_OptionListTable setNumberOfRows:nRowCount withRowType:OPTIONSTABLEROWCONTROLLER_ID];
    for(int16_t i = 0; i < nRowCount; ++i)
    {
        OptionItemTableRowController* optionRow = [self.m_OptionListTable rowControllerAtIndex:i];
        NSString* szLable = [NOMAppWatchDataHelper GetWatchTaxiChoiceTitle:(i - 1)];
        [optionRow SetOptionLabel:szLable];
    }
}

-(void)CreateSearchActionTableRows
{
    if(m_nChoice == NOM_WATCH_ACTION_CHOICE_TRAFIC)
    {
        [self CreateSearchTrafficActionTableRows];
    }
    else if(m_nChoice == NOM_WATCH_ACTION_CHOICE_SPOT)
    {
        [self CreateSearchSpotActionTableRows];
    }
    else if(m_nChoice == NOM_WATCH_ACTION_CHOICE_TAXI)
    {
        [self CreateSearchTaxiActionTableRows];
    }
}

-(void)CreatePostTrafficActionTableRows
{
    int16_t nRowCount = (NOM_WATCH_LOCALTRAFFIC_LASTID - NOM_WATCH_LOCALTRAFFIC_FIRSTID);
    [self.m_OptionListTable setNumberOfRows:nRowCount withRowType:OPTIONSTABLEROWCONTROLLER_ID];
    for(int16_t i = 0; i < nRowCount; ++i)
    {
        OptionItemTableRowController* optionRow = [self.m_OptionListTable rowControllerAtIndex:i];
        NSString* szLable = [NOMAppWatchDataHelper GetWatchTrafficChoiceTitle:i];
        [optionRow SetOptionLabel:szLable];
    }
}

-(void)CreatePostSpotActionTableRows
{
    int16_t nRowCount = (NOM_WATCH_TRAFFICSPOT_LASTID - NOM_WATCH_TRAFFICSPOT_FIRSTID);
    [self.m_OptionListTable setNumberOfRows:nRowCount withRowType:OPTIONSTABLEROWCONTROLLER_ID];
    for(int16_t i = 0; i < nRowCount; ++i)
    {
        OptionItemTableRowController* optionRow = [self.m_OptionListTable rowControllerAtIndex:i];
        NSString* szLable = [NOMAppWatchDataHelper GetWatchSpotChoiceTitle:i];
        [optionRow SetOptionLabel:szLable];
    }
}

-(void)CreatePostTaxiActionTableRows
{
    int16_t nRowCount = (NOM_WATCH_TAXI_LASTID - NOM_WATCH_TAXI_FIRSTID);
    [self.m_OptionListTable setNumberOfRows:nRowCount withRowType:OPTIONSTABLEROWCONTROLLER_ID];
    for(int16_t i = 0; i < nRowCount; ++i)
    {
        OptionItemTableRowController* optionRow = [self.m_OptionListTable rowControllerAtIndex:i];
        NSString* szLable = [NOMAppWatchDataHelper GetWatchTaxiChoiceTitle:i];
        [optionRow SetOptionLabel:szLable];
    }
}

-(void)CreatePostActionTableRows
{
    if(m_nChoice == NOM_WATCH_ACTION_CHOICE_TRAFIC)
    {
        [self CreatePostTrafficActionTableRows];
    }
    else if(m_nChoice == NOM_WATCH_ACTION_CHOICE_SPOT)
    {
        [self CreatePostSpotActionTableRows];
    }
    else if(m_nChoice == NOM_WATCH_ACTION_CHOICE_TAXI)
    {
        [self CreatePostTaxiActionTableRows];
    }
}

-(void)LoadOptionListTable
{
    [self RemoveTableItems];

    if(m_nAction == NOM_WATCH_ACTION_SEARCH)
    {
        [self CreateSearchActionTableRows];
    }
    else if(m_nAction == NOM_WATCH_ACTION_POST)
    {
        [self CreatePostActionTableRows];
    }
/*
    [self.m_OptionListTable setNumberOfRows:20 withRowType:@"optionItemRow"];

    //int nTest = self.m_OptionListTable.numberOfRows;
    
    for(int i = 0; i < 20; ++i)
    {
        OptionItemTableRowController* optionRow = [self.m_OptionListTable rowControllerAtIndex:i];
        
        [optionRow SetOptionLabel:[NSString stringWithFormat:@"Option %i", (i+1)]];
        //This is crash
        //[optionRow.m_OptionLabel setText:[NSString stringWithFormat:@"Option %i", (i+1)]];
        
    }
*/
}

@end




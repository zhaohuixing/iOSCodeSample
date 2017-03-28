//
//  NOMTrafficSpotQueryService.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-10-14.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import "NOMTrafficSpotQueryService.h"
#import "AmazonClientManager.h"
#import "NOMSystemConstants.h"
#import "AWSSimpleDBUtilities.h"

@interface NOMTrafficSpotQueryService ()  //NSOperation<AmazonServiceRequestDelegate>
{
@private
    NSString*                           m_DBDomain;                //Region DB domain name
    AmazonSimpleDBClient*               m_SDbClient;
    NSMutableArray*                     m_ItemList;
    NSString*                           m_QueryStatement;
    NSString*                           m_QueryNextToken;
    id<INOMTrafficSpotQueryDelegate>    m_Delegate;
    int16_t                             m_nSpotType;
}

@end

@implementation NOMTrafficSpotQueryService

-(void)SetSpotType:(int16_t)nType
{
    m_nSpotType = nType;
}

-(int16_t)GetSpotType
{
    return m_nSpotType;
}

-(void)RegisterDelegate:(id<INOMTrafficSpotQueryDelegate>)delegate
{
    m_Delegate = delegate;
}

-(id)initWithDomain:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd
{
    self = [super init];
    if(self != nil)
    {
        m_nSpotType = 0;
        m_Delegate = nil;
        m_ItemList = [[NSMutableArray alloc] init];
        m_DBDomain = [domain copy];
            
        m_QueryStatement = [AWSSimpleDBUtilities FormatTrafficQuery:m_DBDomain fromLantitude:latStart toLantitude:latEnd fromLongitude:lonStart toLongitude:lonEnd];
            
            //m_QueryStatement =@"select * from xxxxxxxxxxxxxxxxxxxxxx_ts_gs_0";
            
        m_SDbClient = [AmazonClientManager CreateSimpleDBClient];
        m_QueryNextToken = nil;
    }
    return self;
}

-(id)initWithDomain:(NSString*)domain fromLantitude:(double)latStart toLantitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withSubType:(int16_t)nSubType
{
    self = [super init];
    if(self != nil)
    {
        m_nSpotType = 0;
        m_Delegate = nil;
        m_ItemList = [[NSMutableArray alloc] init];
        m_DBDomain = [domain copy];
            
        m_QueryStatement = [AWSSimpleDBUtilities FormatTrafficQuery:m_DBDomain fromLantitude:latStart toLantitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withSubType:nSubType];
            
        m_SDbClient = [AmazonClientManager CreateSimpleDBClient];
        m_QueryNextToken = nil;
    }
    return self;
}


-(id)initWithDomain:(NSString *)domain wittQuery:(NSString*)query
{
    self = [super init];
    if(self != nil)
    {
        m_nSpotType = 0;
        m_Delegate = nil;
        m_ItemList = [[NSMutableArray alloc] init];
        m_DBDomain = domain;
            
        m_QueryStatement = query;
            
        m_SDbClient = [AmazonClientManager CreateSimpleDBClient];
        m_QueryNextToken = nil;
    }
    return self;
}

-(id)init
{
    assert(NO);
    return nil;
}

-(NSArray*)GetItemList
{
    return (NSArray*)m_ItemList;
}

-(void)ServiceSucceeded
{
    m_QueryNextToken = nil;
    if(m_Delegate != nil)
    {
        [m_Delegate NOMTrafficSpotQueryTaskDone:self result:YES];
    }
}

-(void)ServiceFailed
{
    m_QueryNextToken = nil;
    if(m_Delegate != nil)
    {
        [m_Delegate NOMTrafficSpotQueryTaskDone:self result:NO];
    }
}

/*
 * Extracts the value for the given attribute from the list of attributes.
 * Extracted value is returned as a NSString.
 */
-(NSString *)getStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (AWSSimpleDBAttribute *attribute in attributeList)
    {
        if ( [attribute.name isEqualToString:theAttribute])
        {
            return attribute.value;
        }
    }

    return @"";
}

/*
 * Extracts the value for the given attribute from the list of attributes.
 * Extracted value is returned as an int.
 */
-(int)getIntValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (AWSSimpleDBAttribute *attribute in attributeList)
    {
        if ( [attribute.name isEqualToString:theAttribute])
        {
            return [attribute.value intValue];
        }
    }

    return -1;
}

/*
 * Extracts the value for the given attribute from the list of attributes.
 * Extracted value is returned as a double.
 */
-(double)getDoubleValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (AWSSimpleDBAttribute *attribute in attributeList)
    {
        if ( [attribute.name isEqualToString:theAttribute])
        {
            return [attribute.value doubleValue];
        }
    }

    return 0;
}

/*
 * Extracts the value for the given attribute from the list of attributes.
 * Extracted value is returned as a double.
 */
-(int64_t)getInt64ValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (AWSSimpleDBAttribute *attribute in attributeList)
    {
        if ( [attribute.name isEqualToString:theAttribute])
        {
            return (int64_t)[attribute.value longLongValue];
        }
    }

    return -1;
}

/*
 * Converts a single SimpleDB Item into a HighScore object.
 */


-(NOMTrafficSpotRecord *)convertSimpleDBItemToTrafficSpotRecord:(AWSSimpleDBItem *)theItem
{
    NSString* spotID = [theItem.name copy];
    NSString* spotName = [self getStringValueForAttribute:NOM_TRAFFICSPOT_NAME_KEY fromList:theItem.attributes];
    double fLat = [self getDoubleValueForAttribute:NOM_TRAFFICSPOT_LATITUDE_KEY fromList:theItem.attributes];
    double fLong= [self getDoubleValueForAttribute:NOM_TRAFFICSPOT_LONGITUDE_KEY fromList:theItem.attributes];
    int16_t nType = [self getIntValueForAttribute:NOM_TRAFFICSPOT_TYPE_KEY fromList:theItem.attributes];
    double dPrice = [self getDoubleValueForAttribute:NOM_TRAFFICSPOT_PRICE_KEY fromList:theItem.attributes];
    int64_t nTime = [self getInt64ValueForAttribute:NOM_TRAFFICSPOT_PRICETIME_KEY fromList:theItem.attributes];
    int16_t nUnit = [self getIntValueForAttribute:NOM_TRAFFICSPOT_PRICEUNIT_KEY fromList:theItem.attributes];
    
    int16_t nSubType = [self getIntValueForAttribute:NOM_TRAFFICSPOT_SUBTYPE_KEY fromList:theItem.attributes];
    
    int16_t nThirdType = [self getIntValueForAttribute:NOM_TRAFFICSPOT_THIRDTYPE_KEY fromList:theItem.attributes];

    int16_t nFourType = [self getIntValueForAttribute:NOM_TRAFFICSPOT_FOURTHTYPE_KEY fromList:theItem.attributes];
    
    NSString* address = [self getStringValueForAttribute:NOM_TRAFFICSPOT_ADDRESS_KEY fromList:theItem.attributes];
    
    NOMTrafficSpotRecord *pRecord = nil;
    if(spotName == nil || spotName.length <= 0)
    {
        pRecord = [[NOMTrafficSpotRecord alloc] initWithID:spotID withLatitude:fLat withLongitude:fLong withType:nType withPrice:dPrice withTime:nTime withUnit:nUnit];
    }
    else
    {
        pRecord = [[NOMTrafficSpotRecord alloc] initWithID:spotID withName:spotName withLatitude:fLat withLongitude:fLong withType:nType withPrice:dPrice withTime:nTime withUnit:nUnit];
    }
    
    if(address != nil && 0 < address.length)
    {
        pRecord.m_SpotAddress = address;
    }
    if(0 <= nSubType)
    {
        pRecord.m_SubType = nSubType;
    }
    
    if(0 <= nThirdType)
    {
        pRecord.m_ThirdType = nThirdType;
    }
    
    if(0 <= nFourType)
    {
        pRecord.m_FourType = nFourType;
    }
    
    return pRecord;
}


/*
 * Converts an array of Items into an array of HighScore objects.
 */
-(void)convertItemsToTrafficSpotRecords:(NSArray *)theItems
{
    //[m_ItemList removeAllObjects];
    for (AWSSimpleDBItem *item in theItems)
    {
        NOMTrafficSpotRecord* pRecord = [self convertSimpleDBItemToTrafficSpotRecord:item];
        if(pRecord != nil)
            [m_ItemList addObject:pRecord];
    }

}

-(void)ContiuneSelectionQuery:(NSString*)nextToken
{
    AWSSimpleDBSelectRequest *selectRequest = [AWSSimpleDBSelectRequest new];
    selectRequest.selectExpression = m_QueryStatement;
    selectRequest.consistentRead = [NSNumber numberWithInt:1];
    selectRequest.nextToken = nextToken;
    
    [[[m_SDbClient select:selectRequest] continueWithBlock:^id(BFTask *task)
      {
          if (task.error)
          {
#ifdef DEBUG
              NSLog(@"NOMTrafficSpotQueryService SyncQueryMessage error : %@\n", task.error);
#endif
              [self ServiceFailed];
              return nil;
          }
          if (task.result)
          {
              if([task.result isKindOfClass:[AWSSimpleDBSelectResult class]] == YES)
              {
                  AWSSimpleDBSelectResult *selectResponse = task.result;
                  
                  if(selectResponse && selectResponse.items && 0 < [selectResponse.items count])
                  {
                      [self convertItemsToTrafficSpotRecords:selectResponse.items];
                  }
                  m_QueryNextToken = selectResponse.nextToken;
               /*   if(m_QueryNextToken != nil && 0 < m_QueryNextToken.length)
                  {
                      sleep(1);
                  } */
              }
          }
          return nil;
      }] waitUntilFinished];
    
    if(m_QueryNextToken == nil || m_QueryNextToken.length <= 0)
    {
        [self ServiceSucceeded];
        return;
    }
    else
    {
        [self ContiuneSelectionQuery:m_QueryNextToken];
    }
}

-(void)StartSelectionQuery
{
    m_QueryNextToken = nil;
    AWSSimpleDBSelectRequest *selectRequest = [AWSSimpleDBSelectRequest new];
    selectRequest.selectExpression = m_QueryStatement;
    selectRequest.consistentRead = [NSNumber numberWithInt:1];
    selectRequest.nextToken = nil;
    
    [[[m_SDbClient select:selectRequest] continueWithBlock:^id(BFTask *task)
    {
        if (task.error)
        {
#ifdef DEBUG
            NSLog(@"NOMTrafficSpotQueryService SyncQueryMessage error : %@\n", task.error);
#endif
            [self ServiceFailed];
            return nil;
        }
        if (task.result)
        {
            if([task.result isKindOfClass:[AWSSimpleDBSelectResult class]] == YES)
            {
                AWSSimpleDBSelectResult *selectResponse = task.result;
                
                if(selectResponse && selectResponse.items && 0 < [selectResponse.items count])
                {
                    [self convertItemsToTrafficSpotRecords:selectResponse.items];
                }
                m_QueryNextToken = selectResponse.nextToken;
                if(m_QueryNextToken != nil && 0 < m_QueryNextToken.length)
                {
                    sleep(1);
                }
            }
        }
        return nil;
    }] waitUntilFinished];
    
    if(m_QueryNextToken == nil || m_QueryNextToken.length <= 0)
    {
        [self ServiceSucceeded];
        return;
    }
    else
    {
        [self ContiuneSelectionQuery:m_QueryNextToken];
    }
}

- (void)start
{
    [m_ItemList removeAllObjects];
//    m_bSuccess = NO;
    if(m_DBDomain == nil)
    {
        [self ServiceFailed];
        return;
    }
    
    if([m_DBDomain length] <= 0)
    {
        [self ServiceFailed];
        return;
    }
    
    if(m_SDbClient == nil)
    {
        [self ServiceFailed];
        return;
    }
    
    if(m_QueryStatement == nil)
    {
        [self ServiceFailed];
        return;
    }
    
    if([m_QueryStatement length] <= 0)
    {
        [self ServiceFailed];
        return;
    }
   
    [self StartSelectionQuery];
}

-(void)StartQuery
{
    m_QueryNextToken = nil;
    [self start];
}

@end

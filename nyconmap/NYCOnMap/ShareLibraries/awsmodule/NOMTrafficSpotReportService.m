//
//  NOMTrafficSpotReportService.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-10-14.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import "NOMTrafficSpotReportService.h"
#import "NOMSystemConstants.h"

@interface NOMTrafficSpotReportService ()
{
    AmazonSimpleDBClient*                   m_SDBClient;
    NSString*                               m_DBDomain;                //Region DB domain name
    NOMTrafficSpotRecord*                   m_SpotData;
    id<INOMTrafficSpotReportDelegate>       m_Delegate;
}

@end


@implementation NOMTrafficSpotReportService

-(id)initWith:(NSString*)domain WithSpotData:(NOMTrafficSpotRecord*)data
{
    self = [super init];
    if(self != nil)
    {
        m_SDBClient = [AmazonClientManager CreateSimpleDBClient];
        m_DBDomain = domain;
        m_SpotData = data;
        m_Delegate = nil;
    }
    
    return self;
}

-(void)RegisterDelegate:(id<INOMTrafficSpotReportDelegate>)delegate
{
    m_Delegate = delegate;
}

-(id)init
{
    assert(NO);
    return nil;
}

-(void)ServiceSucceeded
{
    if(m_Delegate != nil)
    {
        [m_Delegate NOMTrafficSpotReportTaskDone:self result:YES];
    }
}

-(void)ServiceFailed
{
    if(m_Delegate != nil)
    {
        [m_Delegate NOMTrafficSpotReportTaskDone:self result:NO];
    }
}

-(void)HandleAsyncPosting
{
    NSMutableArray               *attributes = [[NSMutableArray alloc] init];
    AWSSimpleDBReplaceableAttribute *pNameAttribute = nil;
    
    if(m_SpotData.m_SpotName != nil && 0 < m_SpotData.m_SpotName.length)
    {
        pNameAttribute = [AWSSimpleDBReplaceableAttribute new];
        pNameAttribute.name = NOM_TRAFFICSPOT_NAME_KEY;
        pNameAttribute.value = m_SpotData.m_SpotName;
        pNameAttribute.replace = [NSNumber numberWithInt:1];
        [attributes addObject:pNameAttribute];
    }
    
    AWSSimpleDBReplaceableAttribute *latAttribute = [AWSSimpleDBReplaceableAttribute new];
    latAttribute.replace = [NSNumber numberWithInt:1];
    latAttribute.name = NOM_TRAFFICSPOT_LATITUDE_KEY;
    latAttribute.value = [NSString stringWithFormat:@"%f",m_SpotData.m_SpotLatitude];
    [attributes addObject:latAttribute];
    
    AWSSimpleDBReplaceableAttribute *lonAttribute = [AWSSimpleDBReplaceableAttribute new];
    lonAttribute.replace = [NSNumber numberWithInt:1];
    lonAttribute.name = NOM_TRAFFICSPOT_LONGITUDE_KEY;
    lonAttribute.value = [NSString stringWithFormat:@"%f",m_SpotData.m_SpotLongitude];
    [attributes addObject:lonAttribute];
    

    AWSSimpleDBReplaceableAttribute *typeAttribute = [AWSSimpleDBReplaceableAttribute new];
    typeAttribute.replace = [NSNumber numberWithInt:1];
    typeAttribute.name = NOM_TRAFFICSPOT_TYPE_KEY;
    typeAttribute.value = [NSString stringWithFormat:@"%i", m_SpotData.m_Type];
    [attributes addObject:typeAttribute];
    
    AWSSimpleDBReplaceableAttribute *priceAttribute = nil;
    AWSSimpleDBReplaceableAttribute *priceTimeAttribute = nil;
    AWSSimpleDBReplaceableAttribute *priceUnitAttribute = nil;

    if(0.0 < m_SpotData.m_Price)
    {
        priceAttribute = [AWSSimpleDBReplaceableAttribute new];
        priceAttribute.replace = [NSNumber numberWithInt:1];
        priceAttribute.name = NOM_TRAFFICSPOT_PRICE_KEY;
        priceAttribute.value = [NSString stringWithFormat:@"%f",m_SpotData.m_Price];
        [attributes addObject:priceAttribute];
        
        if(0 < m_SpotData.m_PriceTime)
        {
            priceTimeAttribute = [AWSSimpleDBReplaceableAttribute new];
            priceTimeAttribute.replace = [NSNumber numberWithInt:1];
            priceTimeAttribute.name = NOM_TRAFFICSPOT_PRICETIME_KEY;
            priceTimeAttribute.value = [NSString stringWithFormat:@"%i", m_SpotData.m_PriceUnit];
            [attributes addObject:priceTimeAttribute];
        }

        priceUnitAttribute = [AWSSimpleDBReplaceableAttribute new];
        priceUnitAttribute.replace = [NSNumber numberWithInt:1];
        priceUnitAttribute.name = NOM_TRAFFICSPOT_PRICEUNIT_KEY;
        priceUnitAttribute.value = [NSString stringWithFormat:@"%i", m_SpotData.m_PriceUnit];
        [attributes addObject:priceUnitAttribute];
    }
 
    AWSSimpleDBReplaceableAttribute *subTypeAttribute = nil;
    if(0 <= m_SpotData.m_SubType)
    {
        subTypeAttribute = [AWSSimpleDBReplaceableAttribute new];
        subTypeAttribute.replace =  [NSNumber numberWithInt:1];
        subTypeAttribute.name = NOM_TRAFFICSPOT_SUBTYPE_KEY;
        subTypeAttribute.value = [NSString stringWithFormat:@"%i", m_SpotData.m_SubType];
        [attributes addObject:subTypeAttribute];
    }
 
    AWSSimpleDBReplaceableAttribute *thirdTypeAttribute = nil;
    if(0 <= m_SpotData.m_ThirdType)
    {
        thirdTypeAttribute = [AWSSimpleDBReplaceableAttribute new];
        thirdTypeAttribute.replace = [NSNumber numberWithInt:1];
        thirdTypeAttribute.name = NOM_TRAFFICSPOT_THIRDTYPE_KEY;
        thirdTypeAttribute.value = [NSString stringWithFormat:@"%i", m_SpotData.m_ThirdType];
        [attributes addObject:thirdTypeAttribute];
    }
    

    AWSSimpleDBReplaceableAttribute *fourTypeAttribute = nil;
    if(0 <= m_SpotData.m_FourType)
    {
        fourTypeAttribute = [AWSSimpleDBReplaceableAttribute new];
        fourTypeAttribute.replace = [NSNumber numberWithInt:1];
        fourTypeAttribute.name = NOM_TRAFFICSPOT_FOURTHTYPE_KEY;
        fourTypeAttribute.value = [NSString stringWithFormat:@"%i", m_SpotData.m_FourType];
        [attributes addObject:fourTypeAttribute];
    }
    
    AWSSimpleDBReplaceableAttribute *addressAttribute = nil;
    if(m_SpotData.m_SpotAddress != nil && 0 < m_SpotData.m_SpotAddress.length)
    {
        addressAttribute = [AWSSimpleDBReplaceableAttribute new];
        addressAttribute.replace = [NSNumber numberWithInt:1];
        addressAttribute.name = NOM_TRAFFICSPOT_ADDRESS_KEY;
        addressAttribute.value = m_SpotData.m_SpotAddress;
        [attributes addObject:addressAttribute];
    }
    
    AWSSimpleDBPutAttributesRequest *putAttributesRequest = [AWSSimpleDBPutAttributesRequest new];
    putAttributesRequest.domainName = m_DBDomain;
    putAttributesRequest.itemName = m_SpotData.m_SpotID;
    putAttributesRequest.attributes = attributes;

    [[[m_SDBClient putAttributes:putAttributesRequest] continueWithBlock:^id(BFTask *task)
    {
        if (task.error)
        {
#ifdef DEBUG
            NSLog(@"NOMTrafficSpotReportService HandleAsyncPosting error : %@\n", task.error);
#endif
            [self ServiceFailed];
        }
        else
        {
#ifdef DEBUG
            NSLog(@"NOMTrafficSpotReportService HandleAsyncPosting succeeded\n");
#endif
            [self ServiceSucceeded];
        }
        
        return nil;
    }] waitUntilFinished];
}

-(void)start
{
    if(m_SDBClient == nil || m_DBDomain == nil || [m_DBDomain length] <= 0 || m_SpotData == nil || m_SpotData.m_SpotID == nil || [m_SpotData.m_SpotID length] <= 0)
    {
        [self ServiceFailed];
        return;
    }
    
    [self HandleAsyncPosting];
/*
    //Makes sure that start method always runs on the main thread.
    //if (![NSThread isMainThread])
    //{
    //    [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
    //    return;
    //}
    
    [self willChangeValueForKey:@"isExecuting"];
    m_bExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    @try
    {
        AmazonSimpleDBClient* sdbClient = [AmazonClientManager CreateSimpleDBClient];
        if(sdbClient == nil)
            return;
        SimpleDBCreateDomainRequest *createDomain = [[SimpleDBCreateDomainRequest alloc] initWithDomainName:m_DBDomain];
        [sdbClient createDomain:createDomain];
            
        NSMutableArray               *attributes = [[NSMutableArray alloc] init];
        
        SimpleDBReplaceableAttribute *pNameAttribute = nil;
        
        if(m_SpotData.m_SpotName != nil && 0 < m_SpotData.m_SpotName.length)
        {
            pNameAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:NOM_TRAFFICSPOT_NAME_KEY andValue:m_SpotData.m_SpotName andReplace:YES];
        }
   
        SimpleDBReplaceableAttribute *latAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:NOM_TRAFFICSPOT_LATITUDE_KEY andValue:[NSString stringWithFormat:@"%f",m_SpotData.m_SpotLatitude] andReplace:YES];
        
        SimpleDBReplaceableAttribute *lonAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:NOM_TRAFFICSPOT_LONGITUDE_KEY andValue:[NSString stringWithFormat:@"%f",m_SpotData.m_SpotLongitude] andReplace:YES];
        
        SimpleDBReplaceableAttribute *typeAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:NOM_TRAFFICSPOT_TYPE_KEY andValue:[NSString stringWithFormat:@"%i", m_SpotData.m_Type] andReplace:YES];

        SimpleDBReplaceableAttribute *priceAttribute = nil;
        SimpleDBReplaceableAttribute *priceTimeAttribute = nil;
        SimpleDBReplaceableAttribute *priceUnitAttribute = nil;
        
        if(0.0 < m_SpotData.m_Price)
        {
            priceAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:NOM_TRAFFICSPOT_PRICE_KEY andValue:[NSString stringWithFormat:@"%f",m_SpotData.m_Price] andReplace:YES];
            if(0 < m_SpotData.m_PriceTime)
            {
                priceTimeAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:NOM_TRAFFICSPOT_PRICETIME_KEY andValue:[NSString stringWithFormat:@"%2lld",m_SpotData.m_PriceTime] andReplace:YES];
            }
            
            priceUnitAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:NOM_TRAFFICSPOT_PRICEUNIT_KEY andValue:[NSString stringWithFormat:@"%i", m_SpotData.m_PriceUnit] andReplace:YES];
        }
        
        SimpleDBReplaceableAttribute *subTypeAttribute = nil;
        if(0 <= m_SpotData.m_SubType)
        {
            subTypeAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:NOM_TRAFFICSPOT_SUBTYPE_KEY andValue:[NSString stringWithFormat:@"%i", m_SpotData.m_SubType] andReplace:YES];
        }

        SimpleDBReplaceableAttribute *thirdTypeAttribute = nil;
        if(0 <= m_SpotData.m_ThirdType)
        {
            thirdTypeAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:NOM_TRAFFICSPOT_THIRDTYPE_KEY andValue:[NSString stringWithFormat:@"%i", m_SpotData.m_ThirdType] andReplace:YES];
        }

        SimpleDBReplaceableAttribute *fourTypeAttribute = nil;
        if(0 <= m_SpotData.m_FourType)
        {
            fourTypeAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:NOM_TRAFFICSPOT_FOURTHTYPE_KEY andValue:[NSString stringWithFormat:@"%i", m_SpotData.m_FourType] andReplace:YES] ;
        }
        
        SimpleDBReplaceableAttribute *addressAttribute = nil;
        if(m_SpotData.m_SpotAddress != nil && 0 < m_SpotData.m_SpotAddress.length)
        {
            addressAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:NOM_TRAFFICSPOT_ADDRESS_KEY andValue:m_SpotData.m_SpotAddress andReplace:YES];
        }

        SimpleDBPutAttributesRequest *putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:m_DBDomain andItemName:m_SpotData.m_SpotID andAttributes:attributes];

        if(pNameAttribute != nil)
            [attributes addObject:pNameAttribute];
        
        if(addressAttribute != nil)
            [attributes addObject:addressAttribute];
        
        [attributes addObject:latAttribute];
        [attributes addObject:lonAttribute];
        [attributes addObject:typeAttribute];

        if(subTypeAttribute != nil)
            [attributes addObject:subTypeAttribute];
        
        if(thirdTypeAttribute != nil)
            [attributes addObject:thirdTypeAttribute];
        
        if(fourTypeAttribute != nil)
            [attributes addObject:fourTypeAttribute];
        
        if(priceAttribute != nil)
        {
            [attributes addObject:priceAttribute];
            if(priceTimeAttribute != nil)
                [attributes addObject:priceTimeAttribute];
            if(priceUnitAttribute != nil)
                [attributes addObject:priceUnitAttribute];
        }

        putAttributesRequest.delegate = self;
        [sdbClient putAttributes:putAttributesRequest];
            
    }
    @catch (NSException *exception)
    {
        NSLog(@"NOMTrafficSpotReportService Exception : [%@]", exception);
        m_bSuccess = NO;
        return;
    }
    m_bSuccess = YES;
*/
}

/*
-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    NSLog(@"NOMTrafficSpotReportService request succeed");
    m_bSuccess = YES;
    [self Finish];
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"NOMTrafficSpotReportService request failed error: %@", error);
    m_bSuccess = NO;
    [self Finish];
}

-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)exception
{
    NSLog(@"NOMTrafficSpotReportService request failed exception: %@", exception);
    m_bSuccess = NO;
    [self Finish];
}
*/

-(void)DeleteSpot
{
#ifdef DEBUG
/*    @try
    {
        AmazonSimpleDBClient* sdbClient = [AmazonClientManager CreateSimpleDBClient];
        if(sdbClient == nil)
            return;
        SimpleDBDeleteAttributesRequest *deleteItem = [[SimpleDBDeleteAttributesRequest alloc] initWithDomainName:m_DBDomain andItemName:m_SpotData.m_SpotID];
        
        [sdbClient deleteAttributes:deleteItem];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"NOMTrafficSpotReportService Exception : [%@]", exception);
        m_bSuccess = NO;
        return;
    }*/
#endif
}

-(NOMTrafficSpotRecord*)GetSpotData
{
    return m_SpotData;
}

-(void)StartPost
{
    [self start];
}

@end

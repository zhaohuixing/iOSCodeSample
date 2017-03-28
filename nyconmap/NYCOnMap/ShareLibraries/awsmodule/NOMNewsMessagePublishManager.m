//
//  NOMNewsMessagePublishManager.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMNewsMessagePublishManager.h"

@interface NOMNewsMessagePublishManager ()
{
    NSMutableArray*                                     m_MessageProcessList;
    id<INOMNewsMessagePublishManagerDelegate>           m_Delegate;
    
    NSString*                                           m_TopicARN;
}

@end

@implementation NOMNewsMessagePublishManager

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_MessageProcessList = [[NSMutableArray alloc] init];
        m_Delegate = nil;
        m_TopicARN = nil;
    }
    
    return self;
}

-(void)RegisterDelegate:(id<INOMNewsMessagePublishManagerDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)NOMNewsPublishTashDone:(id)task result:(BOOL)bSuceeded
{
    if(task != nil && [task isKindOfClass:[NOMNewsPublishTask class]])
    {
        if(m_Delegate != nil)
        {
            [m_Delegate NOMTrafficMessagePublishDone:[(NOMNewsPublishTask*)task GetNewsData] result:bSuceeded];
        }
        int nIndex = -1;
        for(int i = 0; i < m_MessageProcessList.count; ++i)
        {
            NOMNewsPublishTask* pUnit = (NOMNewsPublishTask*)[m_MessageProcessList objectAtIndex:i];
            if(pUnit != nil && pUnit == task)
            {
                nIndex = i;
                break;
            }
        }
        if(0 <= nIndex)
        {
            [m_MessageProcessList removeObjectAtIndex:nIndex];
        }
    }
}


-(void)StartPostNews:(NOMNewsMetaDataRecord*)pNewsMetaData
         withSubject:(NSString*)szSubject
            withPost:(NSString*)szPost
         withKeyWord:(NSString*)szKeyWord
       withCopyRight:(NSString*)szCopyRight
             withKML:(NSString*)szKML
           withImage:(UIImage*)pImage
{

    NOMNewsPublishTask* pProcessor = [[NOMNewsPublishTask alloc] init];
    [pProcessor RegisterDelegate:self];
    [m_MessageProcessList addObject:pProcessor];
    [pProcessor StartPostNews:pNewsMetaData
                  withSubject:szSubject
                     withPost:szPost
                  withKeyWord:szKeyWord
                withCopyRight:szCopyRight
                      withKML:szKML
                    withImage:pImage];
 
}

-(void)DirectPostNews:(NOMNewsMetaDataRecord*)pNewsMetaData
{
    NOMNewsPublishTask* pProcessor = [[NOMNewsPublishTask alloc] init];
    [pProcessor RegisterDelegate:self];
    [m_MessageProcessList addObject:pProcessor];
    [pProcessor DirectPostNews:pNewsMetaData];
}

-(NSString*)GetTopicARN
{
    return m_TopicARN;
}

-(void)SetTopicARN:(NSString*)topicARN
{
    m_TopicARN = topicARN;
}

@end

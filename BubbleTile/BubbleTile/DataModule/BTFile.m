//
//  BTFile.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "BTFileManager.h"
#import "DebogConsole.h"
#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"
#import "NSData-Base64.h"

@implementation BTFile
@synthesize             m_FileHeader;
@synthesize             m_PlayRecordList;
@synthesize             m_Delegate;
@synthesize             _FileURL = m_FileURL;


+(id)CreateEmptyFile
{
    BTFile* pFile = [[BTFile alloc] init];
    return pFile;
}

+(id)CreateFileFromSource:(NSDictionary*)msgData
{
    BTFile* pFile = [[BTFile alloc] init];
    [pFile LoadFromMessage:msgData];
    return pFile;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        m_FileHeader = nil;
        m_PlayRecordList = [[NSMutableArray alloc] init];
        m_FileURL = [[BTFileManager GetBTGameCacheDataFilePath] copy];
    }
    return self;
}

-(void)SetFileURL:(NSURL*)fileURL
{
    m_FileURL = [fileURL copy];
    //m_FileURL = fileURL;
}

-(void)SaveDocument
{
    //[self closeWithCompletionHandler:^(BOOL success) 
    //{
    //    if(m_Delegate != nil)
    //    {
    //        [m_Delegate DocumentClosed:self];
    //    }
    //}];
    GameMessage* msg = [[[GameMessage alloc] init] autorelease];
    [self SaveToMessage:msg];
    [msg FormatMessage];
    NSData* data = [msg.m_GameMessage dataUsingEncoding:NSUTF8StringEncoding];
    NSError *errorInfo = nil;
    BOOL bRet = [data writeToURL:m_FileURL options:NSDataWritingAtomic|NSDataWritingFileProtectionNone error:&errorInfo];    
    //[data release];
#ifdef DEBUG
    NSLog(@"write data to file %@", [m_FileURL absoluteString]);
    if(bRet == NO)
    {
        NSLog(@"Failed to write data to file");
    }
    if(errorInfo && [errorInfo description])
    {
        NSLog(@"%@", [errorInfo description]);
    }
#endif
}

-(BOOL)LoadDocument
{
    if(m_FileURL == nil)
        return NO;
    
    BOOL bRet = YES;
    NSError *errorInfo = nil;
    NSData* data = [NSData dataWithContentsOfURL:m_FileURL options:NSDataReadingMappedIfSafe error:&errorInfo];
    if(data == nil)
    {
#ifdef DEBUG
        [DebogConsole ShowDebugMsg:@"BTFile LoadDocument is failed to read data from file"];
#endif        
        return NO;
    }
    if(errorInfo && [errorInfo localizedDescription])
    {
#ifdef DEBUG
        [DebogConsole ShowDebugMsg:[errorInfo localizedDescription]];
#endif        
    }
    NSError *outError = nil;
	NSDictionary* msgData = [[CJSONDeserializer deserializer] deserialize:data error:&outError];
    if(outError != nil && [outError description] != nil)
    {
#ifdef DEBUG
        NSLog(@"loadFromContents error:%@", [outError description]);
        [DebogConsole ShowDebugMsg:[outError description]];
#endif    
        return NO;
    }
    if(msgData == nil)
    {
#ifdef DEBUG
        NSLog(@"loadFromContents error:msgData is nil");
        [DebogConsole ShowDebugMsg:@"loadFromContents error:msgData is nil"];
#endif    
        return NO;
    }
    [self LoadFromMessage:msgData];
    bRet = [self IsValid];
    
    return bRet;
}


-(void)dealloc
{
    if(m_FileHeader)
    {
        [m_FileHeader release];
    }
    if(m_PlayRecordList)
    {
        [m_PlayRecordList removeAllObjects];
        [m_PlayRecordList release];
    }
    //if(m_FileURL)
    ///{
    //    [m_FileURL release];
    ///}
    [super dealloc];
}

-(int)GetAvailabeIndex
{
    int nRet = -1;
    
    if(m_PlayRecordList)
    {
        nRet = [m_PlayRecordList count];
    }
    
    return nRet;
}

-(int)CompletedGamePlaysNumber
{
    int nRet = 0;
    
    if(m_PlayRecordList && 0 < [m_PlayRecordList count])
    {
        for(int i = 0; i < [m_PlayRecordList count]; ++i)
        {    
            BTFilePlayRecord* pRecord = [m_PlayRecordList objectAtIndex:i];
            if(pRecord && pRecord.m_bCompleted == YES)
                ++nRet;
        }    
    }
    
    return nRet;
}

-(void)SetFileHeader:(BTFileHeader*)pHeader
{
    if(m_FileHeader != nil)
    {
        [m_FileHeader release];
        m_FileHeader =nil;
    }
    m_FileHeader = pHeader;
}

-(void)AddPlayRecord:(BTFilePlayRecord*)pRecord
{
    [m_PlayRecordList addObject:pRecord];
}

-(void)SaveToMessage:(GameMessage*)msg
{
    if(m_FileHeader == nil)
        return;
    
    [m_FileHeader SaveToMessage:msg];
    int nCount = [m_PlayRecordList count];
    NSNumber* msgCount = [[[NSNumber alloc] initWithInt:nCount] autorelease];
    [msg AddMessage:BTF_RECORD_PLAY_COUNT_KEY withNumber:msgCount];
    for (int i = 0; i < nCount; ++i) 
    {
        BTFilePlayRecord* pRecord = [m_PlayRecordList objectAtIndex:i];
        if(pRecord)
            [pRecord SaveToMessage:msg withIndex:i];
    }
}

-(void)LoadFromMessage:(NSDictionary*)msgData
{
    if(m_FileHeader != nil)
    {
        [m_FileHeader release];
        m_FileHeader =nil;
    }
    [m_PlayRecordList removeAllObjects];
    
    m_FileHeader = [BTFileHeader CreateFileHeaderFromSource:msgData];
    NSNumber* msgCount = [msgData valueForKey:BTF_RECORD_PLAY_COUNT_KEY];
    if(msgCount)
    {
        int nCount = [msgCount intValue];
        if(0 < nCount)
        {
            for(int i = 0; i < nCount; ++i)
            {
                BTFilePlayRecord* pRecord = [[BTFilePlayRecord CreatePlayRecordFromSource:msgData withIndex:i] autorelease];
                [m_PlayRecordList addObject:pRecord];
            }
        }
    }
}

-(void)AddGamePlayRecordFromGameMessage:(NSDictionary*)dataDict
{
    int nLastIndex = [m_PlayRecordList count];
    BTFilePlayRecord* pRecord = [[BTFilePlayRecord CreatePlayRecordFromSource:dataDict withIndex:nLastIndex] autorelease];
    [m_PlayRecordList addObject:pRecord];
}

-(BOOL)IsValid
{
    BOOL bRet = (m_FileHeader != nil && [m_FileHeader IsVaid]);
    return bRet;
}

-(BOOL)CurrentDocumentIsCacheFile
{
    NSString* szCurrentFile = [m_FileURL absoluteString];
    NSString* szCacheFilePath = [[BTFileManager GetBTGameCacheDataFilePath] absoluteString];
    BOOL bRet = [szCacheFilePath isEqualToString:szCurrentFile];
    return bRet;
}

-(void)CheckCacheFileInfoAndSwitchToOriginalFilePath
{
    if ([self CurrentDocumentIsCacheFile]) 
    {
        if(m_FileHeader.m_OriginalFileName != nil && ![m_FileHeader.m_OriginalFileName isEqualToString:BT_GAMECACHE_FILENAME])
        {
            NSString* newFileNoExt = m_FileHeader.m_OriginalFileName;
            NSString* newFile = [NSString stringWithFormat:@"%@.%@", newFileNoExt, [BTFileManager GetBTFileExtension]];
            NSURL* appFolder = [BTFileManager GetAppGameFilesFolderPath];
            NSURL* newFileURL = [appFolder URLByAppendingPathComponent:newFile isDirectory:NO];
            [self SetFileURL:newFileURL];
        }
    }
}

//UIDocument method
-(id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
#ifdef DEBUG
    NSLog(@"contentsForType:%@", typeName);
#endif    
    
    if([typeName isEqualToString:BT_GAMEFILE_EXTENSION])
        return nil;
    
    GameMessage* msg = [[[GameMessage alloc] init] autorelease];
    [self SaveToMessage:msg];
    [msg FormatMessage];
    NSData* data = [msg.m_GameMessage dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
#ifdef DEBUG
    NSLog(@"loadFromContents:%@", typeName);
#endif    
    if([typeName isEqualToString:BT_GAMEFILE_EXTENSION])
        return NO;
    
    BOOL bRet = NO;
    if(![contents isKindOfClass:[NSData class]])
        return bRet;
    
	NSDictionary* msgData = [[CJSONDeserializer deserializer] deserialize:contents error:outError];
    if(*outError != nil && [(*outError) description] != nil)
    {
#ifdef DEBUG
        NSLog(@"loadFromContents error:%@", [(*outError) description]);
#endif    
        return bRet;
    }
    if(msgData == nil)
    {
#ifdef DEBUG
        NSLog(@"loadFromContents error:msgData is nil");
#endif    
        return bRet;
    }
    [self LoadFromMessage:msgData];
    bRet = [self IsValid];
    return bRet;
}

@end

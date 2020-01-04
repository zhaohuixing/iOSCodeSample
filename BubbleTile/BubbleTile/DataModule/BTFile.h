//
//  BTFile.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BTFileHeader.h"
#import "BTFilePlayRecord.h"

@class BTFile;

@protocol BTFileDelegate <NSObject>

-(void)DocumentClosed:(BTFile*)file;
-(void)CacheFileLoaded;
-(void)CacheFileCreated;

@end

@interface BTFile : NSObject//UIDocument
{
    BTFileHeader*           m_FileHeader;
    NSMutableArray*         m_PlayRecordList;
    id<BTFileDelegate>      m_Delegate;
    NSURL*                  m_FileURL;
}

@property (nonatomic, readonly, retain)BTFileHeader*            m_FileHeader;
@property (nonatomic, readonly, retain)NSMutableArray*          m_PlayRecordList;
@property (nonatomic, weak)id<BTFileDelegate>                   m_Delegate;
@property (readonly)NSURL*                                      _FileURL;

-(void)SetFileURL:(NSURL*)fileURL;
-(void)SaveDocument;
-(BOOL)LoadDocument;

-(int)GetAvailabeIndex;

-(void)SetFileHeader:(BTFileHeader*)pHeader;
-(void)AddPlayRecord:(BTFilePlayRecord*)pRecord;

-(void)SaveToMessage:(GameMessage*)msg;
-(void)LoadFromMessage:(NSDictionary*)msgData;
-(void)AddGamePlayRecordFromGameMessage:(NSDictionary*)dataDict;
-(BOOL)IsValid;

-(BOOL)CurrentDocumentIsCacheFile;
-(void)CheckCacheFileInfoAndSwitchToOriginalFilePath;

-(int)CompletedGamePlaysNumber;


//UIDocument method
-(id)contentsForType:(NSString *)typeName error:(NSError **)outError;
-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError; 

//Class methods
+(id)CreateEmptyFile;
+(id)CreateFileFromSource:(NSDictionary*)msgData;
@end

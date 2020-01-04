//
//  BTFileManager.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BTFile.h"

@protocol BTFileManageDelegate <NSObject>

-(void)PostFileSavingHandle;
-(void)StartGameWithoutCacheData;
-(void)StartGameWithCacheData;

@end

@interface BTFileManager : NSObject<BTFileDelegate>
{
    BTFile*                                 m_PlayingFile;
    NSURL*                                  m_iCloudAccess;
    id<BTFileManageDelegate>                m_Delegate;
    
}

@property (nonatomic, readonly, retain)BTFile*                      m_PlayingFile;
@property (nonatomic, weak)id<BTFileManageDelegate>                 m_Delegate;

+(NSString*)GetAppRootFolder;
+(NSString*)GetAppGameFilesFolder;
+(NSString*)GetAppGameCacheFolder;
+(NSString*)GetAppInboxFolder;
+(NSURL*)GetAppRootFolderPath;
+(NSURL*)GetAppGameFilesFolderPath;
+(NSURL*)GetAppGameCacheFolderPath;
+(NSURL*)GetAppInboxFolderPath;

+(NSString*)GetBTFileExtension;
+(NSString*)GetBTGameCacheDataFileName;

+(NSURL*)GetBTGameCacheDataFilePath;

+(BOOL)CacheFileExist;
+(void)DeleteCacheFile;
+(void)ReleaseArrayObjectsInDictionary:(NSMutableDictionary**)ppDict;
+(void)ClearInboxFolder;
+(NSURL*)CopyLaunchFileToBTFileSystem:(NSURL*)url saveToCache:(BOOL)bCopyToCache;

+(NSString*)GetFileNameFromURL:(NSURL*)url;
+(BOOL)FileExist:(NSURL*)url;
+(NSString*)GetAvaliableLocalFileName:(NSString*)fileName withFileExtenson:(BOOL)bHaveFileExt;
+(BOOL)LocalFileExist;
+(NSArray*)GetFileList;
+(BOOL)CopyFile:(NSURL*)srcFile To:(NSURL*)destFile;

//+(NSString*)GetAvaliableiCloudFileName:(NSString*)fileNameWithoutExt iCloudAccess:(NSURL*)iCloud;



-(void)InitializeiCloundAccess;
-(BOOL)CanAccessiClound;
-(NSURL*)GetiCloudAccess;
-(void)Reset;
-(void)LoadGameFromGameMessage:(NSDictionary*)msgData;
-(void)AddGamePlayRecordFromGameMessage:(NSDictionary*)dataDict;
-(BOOL)IsFileValid;

-(BOOL)NewGameFromPath:(NSURL*)path;

-(void)SaveAndCloseGameToCacheFile;
-(BOOL)CurrentDocumentIsCacheFile;
-(void)LoadCacheFileData;

//BTFileDelegate methods
-(void)DocumentClosed:(BTFile*)file;
-(void)CacheFileLoaded;
-(void)CacheFileCreated;

@end

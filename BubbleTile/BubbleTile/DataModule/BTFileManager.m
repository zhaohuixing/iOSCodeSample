//
//  BTFileManager.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "BTFileManager.h"
#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"
#import "NSData-Base64.h"
#import "DebogConsole.h"

#ifndef DEBUG
#define DEBUG
#endif

@implementation BTFileManager
@synthesize m_PlayingFile;
@synthesize m_Delegate;

+(NSString*)GetAppRootFolder
{
    NSArray *sandBoxFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get document folder from snadbox directories
    NSString *documentFolder = [sandBoxFolders objectAtIndex:0];
#ifdef DEBUG
    NSLog(@"root folder:%@", documentFolder);
#endif    
    return documentFolder;
}

+(NSString*)GetAppGameFilesFolder
{
    NSString *documentFolder = [BTFileManager GetAppRootFolder];
    
    NSString *filesFolder = [documentFolder stringByAppendingPathComponent:BT_GAMESAVEDFILE_FOLDER];
#ifdef DEBUG
    NSLog(@"game files folder:%@", filesFolder);
#endif    
    return filesFolder;
}

+(NSString*)GetAppGameCacheFolder
{
    NSString *documentFolder = [BTFileManager GetAppRootFolder];
    
    NSString *cacheFolder = [documentFolder stringByAppendingPathComponent:BT_GAMEUNCOMPLETEDFILE_FOLDER];
#ifdef DEBUG
    NSLog(@"game data cached folder:%@", cacheFolder);
#endif    
    return cacheFolder;
}

+(NSString*)GetAppInboxFolder
{
    NSString *documentFolder = [BTFileManager GetAppRootFolder];
    
    NSString *inboxFolder = [documentFolder stringByAppendingPathComponent:BT_INBOX_FOLDER ];
#ifdef DEBUG
    NSLog(@"game data inbox folder:%@", inboxFolder);
#endif    
    return inboxFolder;
}

+(NSURL*)GetAppRootFolderPath
{
    NSArray *sandBoxFolders = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    // Get document folder from snadbox directories
    NSURL* documentFolder = [sandBoxFolders objectAtIndex:0];
#ifdef DEBUG
    NSLog(@"root folder path:%@", [documentFolder absoluteString]);
    NSString* szTest = [BTFileManager GetAppRootFolder];
    NSURL* testPath = [NSURL fileURLWithPath:szTest];
    NSLog(@"root folder path convert from strng:%@", [testPath absoluteString]);
#endif    
    return documentFolder;
    
}

+(NSURL*)GetAppGameFilesFolderPath
{
    NSURL *documentFolder = [BTFileManager GetAppRootFolderPath];
    
    NSURL *filesFolder = [documentFolder URLByAppendingPathComponent:BT_GAMESAVEDFILE_FOLDER];
#ifdef DEBUG
    NSLog(@"game files folder path:%@", [filesFolder absoluteString]);
#endif    
    return filesFolder;
}

+(NSURL*)GetAppGameCacheFolderPath
{
    NSURL *documentFolder = [BTFileManager GetAppRootFolderPath];
    
    NSURL *cacheFolder = [documentFolder URLByAppendingPathComponent:BT_GAMEUNCOMPLETEDFILE_FOLDER];
#ifdef DEBUG
    NSLog(@"game cache folder path:%@", [cacheFolder absoluteString]);
#endif    
    return cacheFolder;
}

+(NSURL*)GetAppInboxFolderPath
{
    NSURL *documentFolder = [BTFileManager GetAppRootFolderPath];
    
    NSURL *inboxFolder = [documentFolder URLByAppendingPathComponent:BT_INBOX_FOLDER];
#ifdef DEBUG
    NSLog(@"game inbox folder path:%@", [inboxFolder absoluteString]);
#endif    
    return inboxFolder;
}

+(NSString*)GetBTFileExtension
{
    return BT_GAMEFILE_EXTENSION;
}

+(NSString*)GetBTGameCacheDataFileName
{
    return BT_GAMECACHE_FILENAME;
}

+(NSURL*)GetBTGameCacheDataFilePath
{
    NSURL* cacheFolder = [BTFileManager GetAppGameCacheFolderPath];
    NSURL* cacheFile = [cacheFolder URLByAppendingPathComponent:[BTFileManager GetBTGameCacheDataFileName] isDirectory:NO];
#ifdef DEBUG
    NSLog(@"game cache file path:%@", [cacheFile absoluteString]);
#endif    
    return cacheFile;
}

+(BOOL)CacheFileExist
{
    NSString* cacheFile = [[BTFileManager GetBTGameCacheDataFilePath] path];
    BOOL bRet = [[NSFileManager defaultManager] fileExistsAtPath:cacheFile];
    return bRet;
}

+(void)DeleteCacheFile
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if(!fileManager)
        return;
    NSURL* cacheFilePath = [BTFileManager GetBTGameCacheDataFilePath];

//#ifdef DEBUG
//    NSString* szFile = [BTFileManager GetFileNameFromURL:cacheFilePath];
//    NSLog(@"game cache file name:%@", szFile);
//#endif        
    
    if([fileManager fileExistsAtPath:[cacheFilePath path]])
    {
#ifdef DEBUG
        [DebogConsole ShowDebugMsg:@"DeleteCacheFile"];
#endif        
        NSError* anError;
        [fileManager removeItemAtURL:cacheFilePath error:&anError]; 
    }
}

+(void)ClearInboxFolder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* inboxPath = [BTFileManager GetAppInboxFolder];
    NSError* error = nil;
    NSArray*  inboxContents = [fileManager subpathsAtPath:inboxPath];
    
    if(inboxContents) 
    {	
        for (int i = 0; i < [inboxContents count]; ++i) 
        {
            NSString *tempFile = [inboxContents objectAtIndex:i];
            [fileManager removeItemAtPath:tempFile error:(NSError **)&error];
        }    
    }    
}

+(NSString*)GetFileNameFromURL:(NSURL*)url
{
    NSArray *parts = [[url path] componentsSeparatedByString:@"/"];
    NSString *filename = [parts lastObject];
    return filename;
}

+(BOOL)FileExist:(NSURL*)url
{
    NSString* file = [url path];
    BOOL bRet = [[NSFileManager defaultManager] fileExistsAtPath:file];
    return bRet;
}

+(NSString*)GetAvaliableLocalFileName:(NSString*)fileName withFileExtenson:(BOOL)bHaveFileExt
{
    BOOL bRet = YES;
    int nCount = 0;
    NSString* newFile = @"";
    NSString* fileNameWithoutExt = fileName;
    if(bHaveFileExt)
    {
        NSArray *parts = [fileName componentsSeparatedByString:@"."];
        fileNameWithoutExt = [parts objectAtIndex:0];
    }
    do 
    {
        ++nCount;
        newFile = [NSString stringWithFormat:@"%@-%i", fileNameWithoutExt, nCount];
        NSString* newFullFileName = [NSString stringWithFormat:@"%@.%@", newFile, [BTFileManager GetBTFileExtension]];
        NSURL* localFolder = [BTFileManager GetAppGameFilesFolderPath];
        NSURL* localFile = [localFolder URLByAppendingPathComponent:newFullFileName isDirectory:NO];
        bRet = [BTFileManager FileExist:localFile];
    } while (bRet);
    return newFile;
}

+(BOOL)LocalFileExist
{
    BOOL bRet = NO;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if(!fileManager)
        return bRet;
    NSURL* localFolder = [BTFileManager GetAppGameFilesFolderPath];
    NSArray* array = [fileManager contentsOfDirectoryAtPath:[localFolder path] error:nil];
    if(array && 0 < [array count])
        bRet = YES;
    
    return bRet;
}

+(NSArray*)GetFileList
{
    NSArray* pArray = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if(!fileManager)
        return pArray;
    NSURL* localFolder = [BTFileManager GetAppGameFilesFolderPath];
    pArray = [fileManager contentsOfDirectoryAtPath:[localFolder path] error:nil];
    return pArray;
}

+(NSURL*)CopyLaunchFileToBTFileSystem:(NSURL*)url saveToCache:(BOOL)bCopyToCache
{
    NSURL* newFileURL = nil;
    
    NSString* fileName = [BTFileManager GetFileNameFromURL:url];
    
    NSURL* localFolder = [BTFileManager GetAppGameFilesFolderPath];
    newFileURL = [localFolder URLByAppendingPathComponent:fileName isDirectory:NO];
   
    BOOL bRet = [BTFileManager CopyFile:url To:newFileURL];
    if(bRet == NO)
    {
        newFileURL = nil;
        return newFileURL;
    }
    
    if(bCopyToCache)
    {
        NSURL* cacheURL = [BTFileManager GetBTGameCacheDataFilePath];
        bRet = [BTFileManager CopyFile:url To:cacheURL];
        if(bRet == NO)
        {
            newFileURL = nil;
            return newFileURL;
        }
    } 
    return newFileURL;
}

/*+(NSString*)GetAvaliableiCloudFileName:(NSString*)fileNameWithoutExt iCloudAccess:(NSURL*)iCloud
{
    if(iCloud == nil)
        return @"";
    
    BOOL bRet = YES;
    int nCount = 0;
    NSString* newFile = @"";
    do 
    {
        ++nCount;
        newFile = [NSString stringWithFormat:@"%@(%i)", fileNameWithoutExt, nCount];
        NSString* newFullFileName = [NSString stringWithFormat:@"%@.%@", newFile, [BTFileManager GetBTFileExtension]];
        NSURL* localFile = [iCloud URLByAppendingPathComponent:newFullFileName isDirectory:NO];
        bRet = [BTFileManager FileExist:localFile];
    } while (bRet);
    return newFile;
}*/

+(void)ReleaseArrayObjectsInDictionary:(NSMutableDictionary**)ppDict
{
    if(ppDict && *ppDict)
    {
        NSMutableArray* msgGameSet = [*ppDict valueForKey:BTF_GAME_GAMESET];
        if(msgGameSet)
        {
            [msgGameSet removeAllObjects];
            [msgGameSet release];
        }
        NSMutableArray* msgEasySolution = [*ppDict valueForKey:BTF_GAME_GAMEEASYSOLUTION];
        if(msgEasySolution)
        {
            [msgEasySolution removeAllObjects];
            [msgEasySolution release];
        }
        NSNumber* msgCount = [*ppDict valueForKey:BTF_RECORD_PLAY_COUNT_KEY];
        if(msgCount)
        {
            int nCount = [msgCount intValue];
            for(int i = 0; i < nCount; ++i)
            {
                NSString* szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_PLAYING_STEPS_PREFIX, i];
                NSMutableArray* tempArray = [*ppDict valueForKey:szKey];
                if(tempArray)
                {
                    [tempArray removeAllObjects];
                    [tempArray release];
                }
            }
        }
        
    }
}

+(BOOL)CopyFile:(NSURL*)srcFile To:(NSURL*)destFile
{
    __block BOOL bRet = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), 
    ^{
        NSFileManager* theFM = [NSFileManager defaultManager];
        NSError* anError;
        // Just try to copy the directory.
        if (![theFM copyItemAtURL:srcFile toURL:destFile error:&anError]) 
        {
            bRet = NO;
            if ([theFM removeItemAtURL:destFile error:&anError]) 
            {
                // If the operation failed again, abort for real.
                bRet = [theFM copyItemAtURL:srcFile toURL:destFile error:&anError];
            }   
        }
    });    
    
    return bRet;
}

-(void)InitializeiCloundAccess
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        m_iCloudAccess = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
#ifdef DEBUG
        if(m_iCloudAccess != nil)
        {    
            NSLog(@"iCloud access at %@", m_iCloudAccess);
        }    
        else
        {    
            NSLog(@"iCloud is not available.\n");
        }   
#endif        
    });     
}

-(BOOL)CanAccessiClound
{
    BOOL bRet = (m_iCloudAccess != nil);
    return bRet;
}

-(NSURL*)GetiCloudAccess
{
    return m_iCloudAccess;
}

-(void)CheckLocalFolders
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if(!fileManager)
        return;
    
    NSString* gameFileFolder = [BTFileManager GetAppGameFilesFolder];

    //If directory is not exited, create it
    if(![fileManager fileExistsAtPath:gameFileFolder])
    {
        [fileManager createDirectoryAtPath:gameFileFolder withIntermediateDirectories:YES attributes:NULL error:NULL];
    }
    NSString* gameCacheFolder = [BTFileManager GetAppGameCacheFolder];
    if(![fileManager fileExistsAtPath:gameCacheFolder])
    {
        [fileManager createDirectoryAtPath:gameCacheFolder withIntermediateDirectories:YES attributes:NULL error:NULL];
    }
}


-(id)init
{
    self = [super init];
    if(self)
    {
        m_PlayingFile = nil;
        [self CheckLocalFolders];
        [self InitializeiCloundAccess];
#ifdef DEBUG
        [BTFileManager GetAppRootFolder];
        [BTFileManager GetAppGameFilesFolder];
        [BTFileManager GetAppGameCacheFolder];
        [BTFileManager GetAppRootFolderPath];
        [BTFileManager GetAppGameFilesFolderPath];
        [BTFileManager GetAppGameCacheFolderPath];
#endif        
    }
    return self;
}

-(void)dealloc
{
    if(m_PlayingFile)
    {
        m_PlayingFile.m_Delegate = nil;
        [m_PlayingFile release];
    }
    if(m_iCloudAccess)
    {
        [m_iCloudAccess release];
    }
    [super dealloc];
}

-(void)Reset
{
    if(m_PlayingFile)
    {
        m_PlayingFile.m_Delegate = nil;
        [m_PlayingFile release];
        m_PlayingFile = nil;
    }
}

-(void)LoadGameFromGameMessage:(NSDictionary*)msgData
{
    if(m_PlayingFile == nil)
    {
        m_PlayingFile = [[BTFile alloc] init];
        m_PlayingFile.m_Delegate = self;
    }
    [m_PlayingFile LoadFromMessage:msgData];
}

-(void)AddGamePlayRecordFromGameMessage:(NSDictionary*)dataDict
{
    if(m_PlayingFile != nil)
    {
        [m_PlayingFile AddGamePlayRecordFromGameMessage:dataDict];
    }
}

-(BOOL)NewGameFromPath:(NSURL*)path
{
    BOOL bRet = NO;
    
    // If the file exists, open it; otherwise, create it.
    [self Reset];
    m_PlayingFile = [[BTFile alloc] init];
    m_PlayingFile.m_Delegate = self;
    [m_PlayingFile SetFileURL:path];
    [m_PlayingFile LoadDocument];
    bRet = [m_PlayingFile IsValid];
    
    return bRet;
}

-(BOOL)IsFileValid
{
    BOOL bRet = (m_PlayingFile != nil && [m_PlayingFile IsValid]);
    return bRet;
}

-(void)CopyCurrentDataToCacheFile:(NSURL*)fileURL
{
    NSURL* cacheURL = [BTFileManager GetBTGameCacheDataFilePath];
    // Perform the copy asynchronously.
    BOOL bRet = [BTFileManager CopyFile:fileURL To:cacheURL];
    if(bRet)
    {
        if(m_Delegate)
        {
            [m_Delegate PostFileSavingHandle];
        }
    }
}

-(void)DirectSaveAndCloseCacheFile
{
    [m_PlayingFile SaveDocument];
    //m_PlayingFile = nil;
    if(m_Delegate)
    {
        [m_Delegate PostFileSavingHandle];
    }
}

-(void)SaveAndCloseCurentDocumentAndCopyToCacheFile
{
    NSURL* curURL = [m_PlayingFile._FileURL copy];
    [m_PlayingFile SaveDocument];
    m_PlayingFile = nil;
    [self CopyCurrentDataToCacheFile:curURL];
    if(m_Delegate)
    {
        [m_Delegate PostFileSavingHandle];
    }
    [curURL release];
}

-(void)SaveAndCloseGameToCacheFile
{
    if(m_PlayingFile == nil || m_PlayingFile._FileURL == nil)
        return;
    
    //[m_PlayingFile updateChangeCount:UIDocumentChangeDone];
    
    if([m_PlayingFile CurrentDocumentIsCacheFile]) //Current document is cache file
    {
        [self DirectSaveAndCloseCacheFile];
    }
    else //not cache file
    {
        [self SaveAndCloseCurentDocumentAndCopyToCacheFile];
    }
}

-(BOOL)CurrentDocumentIsCacheFile
{
    BOOL bRet = (m_PlayingFile != nil && [m_PlayingFile CurrentDocumentIsCacheFile]);
    return bRet;
}

-(void)LoadCacheFileData
{
    //[self closeWithCompletionHandler:nil];
    if(m_PlayingFile != nil)
    {    
        m_PlayingFile.m_Delegate = nil;
        [m_PlayingFile release];
        m_PlayingFile = nil;
    }
    
    NSURL* cacheFilePath = [BTFileManager GetBTGameCacheDataFilePath];
    m_PlayingFile = [[BTFile alloc] init];
    m_PlayingFile.m_Delegate = self;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:[cacheFilePath path]])
    {    
        
        BOOL success = [m_PlayingFile LoadDocument];
        if(success)
        {
            if(m_Delegate)
            {
#ifdef DEBUG
                [DebogConsole ShowDebugMsg:@"Cache file loaded m_Delegate StartGameWithCacheData"];
#endif        
                [m_PlayingFile CheckCacheFileInfoAndSwitchToOriginalFilePath];
                [m_Delegate StartGameWithCacheData];
                
            }
        }
        else
        {
            if(m_Delegate)
            {
#ifdef DEBUG
                [DebogConsole ShowDebugMsg:@"Cache file does not loaded m_Delegate StartGameWithoutCacheData"];
#endif        
                [m_Delegate StartGameWithoutCacheData];
            }
        }
    }
    else
    {    
        // Save the new document to disk.
        if(m_Delegate)
        {
#ifdef DEBUG
            [DebogConsole ShowDebugMsg:@"Cache file is not existed: m_Delegate StartGameWithoutCacheData"];
#endif        
            [m_Delegate StartGameWithoutCacheData];
        }
    }    
}

//BTFileDelegate methods
-(void)DocumentClosed:(BTFile*)file
{
/*    if(file)
    {
        file.m_Delegate = nil;
        [file release];
    }*/
#ifdef DEBUG
    NSURL* cacheFilePath = [BTFileManager GetBTGameCacheDataFilePath];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:[cacheFilePath absoluteString]])
    {
        [DebogConsole ShowDebugMsg:@"Document is closed with cache file saved"];
    }    
    else
    {
        [DebogConsole ShowDebugMsg:@"Document is closed with cache file losted"];
    }
#endif    
}

-(void)CacheFileLoaded
{
    if(m_Delegate)
    {
#ifdef DEBUG
        [DebogConsole ShowDebugMsg:@"CacheFileLoaded  m_Delegate StartGameWithCacheData"];
#endif        
        [m_Delegate StartGameWithCacheData];
    }
}

-(void)CacheFileCreated
{
    if(m_Delegate)
    {
#ifdef DEBUG
        [DebogConsole ShowDebugMsg:@"CacheFileCreated  m_Delegate StartGameWithoutCacheData"];
#endif        
        [m_Delegate StartGameWithoutCacheData];
    }
}

@end

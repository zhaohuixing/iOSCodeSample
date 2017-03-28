//
//  NOMFileManager.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-08.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMFile.h"
#import "NOMFileManager.h"
#import "NOMSystemConstants.h"
#import "NOMOperationManager.h"

static NOMFileManager*      g_FileManager = nil;

@interface NOMFileManager ()
{
    id<NOMFileManagerDelegate>                  m_Delegate;
    NOMOperationManager*                        m_FileOperationManager;
    NOMFile*                                    m_File;
}

@end

@implementation NOMFileManager

+(NOMFileManager*)sharedFileManager
{
    if(g_FileManager == nil)
    {
        @synchronized (self)
        {
            g_FileManager = [[NOMFileManager alloc] init];
            assert(g_FileManager != nil);
        }
    }
    
    return g_FileManager;
}

+(NSString*)GetAppTempFolder
{
    NSString* appTemp = NSTemporaryDirectory();
    
    if(appTemp == nil || appTemp.length <= 0)
    {
        appTemp = [NOMFileManager GetAppRootFolder];
    }
    
    return appTemp;
}

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

+(NSString*)GetAppSubFolder:(NSString*)subFolderName
{
    NSString* strFolder = [NSString stringWithFormat:@"%@/%@", [NOMFileManager GetAppRootFolder], subFolderName];
    return strFolder;
}

+(void)CheckAndCreateAppSubFolder:(NSString*)subFolder
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if(!fileManager)
        return;
    
    //If directory is not exited, create it
    if(![fileManager fileExistsAtPath:subFolder])
    {
        [fileManager createDirectoryAtPath:subFolder withIntermediateDirectories:YES attributes:NULL error:NULL];
    }
}

+(NSURL*)GetAppRootFolderPath
{
    NSArray *sandBoxFolders = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    // Get document folder from snadbox directories
    NSURL* documentFolder = [sandBoxFolders objectAtIndex:0];
#ifdef DEBUG
    NSLog(@"root folder path:%@", [documentFolder absoluteString]);
    NSString* szTest = [NOMFileManager GetAppRootFolder];
    NSURL* testPath = [NSURL fileURLWithPath:szTest];
    NSLog(@"root folder path convert from strng:%@", [testPath absoluteString]);
#endif
    return documentFolder;
}

+(NSURL*)GetFilePath:(NSString*)fileKey
{
    NSURL *documentFolder = [NOMFileManager GetAppRootFolderPath];
    
    NSURL *fileURL = [documentFolder URLByAppendingPathComponent:fileKey isDirectory:NO];
    
#ifdef DEBUG
    NSLog(@"NOMFileManager GetFilePath:%@", [fileURL absoluteString]);
#endif
    return fileURL;
}

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_Delegate = nil;
        m_File = nil;
        m_FileOperationManager = [[NOMOperationManager alloc] init];
        [m_FileOperationManager SetOperationDelegate:self];
    }
    return self;
}

-(id)initNoneOperationFileManager
{
    self = [super init];
    if(self != nil)
    {
        m_Delegate = nil;
        m_FileOperationManager = nil;
        m_File = [[NOMFile alloc] init];
    }
    return self;
}

-(void)AssignDelegate:(id<NOMFileManagerDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)FileSaveCompleted:(NOMFileSaveOperation*)saveOperation
{
    if(saveOperation != nil)
    {
        BOOL bRet = [saveOperation IsSucceed];
        if(m_Delegate != nil)
        {
            [m_Delegate NOMFileSaveDone:bRet forFile:[saveOperation GetFileURL]];
        }
    }
    else
    {
        if(m_Delegate != nil)
        {
            [m_Delegate NOMFileSaveDone:NO forFile:[saveOperation GetFileURL]];
        }
    }
}

-(void)FileLoadCompleted:(NOMFileLoadOperation*)loadOperation
{
    if(loadOperation != nil)
    {
        BOOL bRet = [loadOperation IsSucceed];
        if(m_Delegate != nil)
        {
            if(bRet)
            {
                NSURL* fileURL = [loadOperation GetFileURL];
                NSData* data = [loadOperation GetData];
                [m_Delegate NOMFileLoadDone:data forFile:fileURL];
            }
            else
            {
                [m_Delegate NOMFileLoadFailed];
            }
        }
    }
    else
    {
        if(m_Delegate != nil)
            [m_Delegate NOMFileLoadFailed];
    }
}

-(void)JsonFileLoadCompleted:(NOMFileLoadOperation*)loadOperation
{
    if(loadOperation != nil)
    {
        BOOL bRet = [loadOperation IsSucceed];
        if(m_Delegate != nil)
        {
            if(bRet)
            {
                NSURL* fileURL = [loadOperation GetFileURL];
                NSData* data = [loadOperation GetData];
                [m_Delegate NOMJsonFileLoadDone:data forFile:fileURL];
            }
            else
            {
                [m_Delegate NOMFileLoadFailed];
            }
        }
    }
    else
    {
        if(m_Delegate != nil)
            [m_Delegate NOMFileLoadFailed];
    }
}

-(void)ImageFileLoadCompleted:(NOMFileLoadOperation*)loadOperation
{
    if(loadOperation != nil)
    {
        BOOL bRet = [loadOperation IsSucceed];
        if(m_Delegate != nil)
        {
            if(bRet)
            {
                NSURL* fileURL = [loadOperation GetFileURL];
                NSData* data = [loadOperation GetData];
                [m_Delegate NOMImageFileLoadDone:data forFile:fileURL];
            }
            else
            {
                [m_Delegate NOMFileLoadFailed];
            }
        }
    }
    else
    {
        if(m_Delegate != nil)
            [m_Delegate NOMFileLoadFailed];
    }
}

-(void)OperationDone:(NSOperation *)operation
{
    if(operation != nil && [operation isKindOfClass:[NOMFileSaveOperation class]] == YES)
    {
        [self FileSaveCompleted:(NOMFileSaveOperation*)operation];
    }
    else if(operation != nil && [operation isKindOfClass:[NOMFileLoadOperation class]] == YES)
    {
        NOMFileLoadOperation* loadOperation = (NOMFileLoadOperation*)operation;
        if([loadOperation GetFileType] == NOM_FILETYPE_KML)
        {
            //???????????????????????????????????
            //???????????????????????????????????
            //???????????????????????????????????
            //???????????????????????????????????
            //???????????????????????????????????
            //???????????????????????????????????
            [self FileLoadCompleted:loadOperation];
        }
        else if([loadOperation GetFileType] == NOM_FILETYPE_JSON)
        {
            [self JsonFileLoadCompleted:loadOperation];
        }
        else if([loadOperation GetFileType] == NOM_FILETYPE_IMAGE)
        {
            [self ImageFileLoadCompleted:loadOperation];
        }
        else
        {
            [self FileLoadCompleted:loadOperation];
        }
    }
}

-(void)GDPSaveFileSucceeded
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(GDPSaveFileSucceeded) withObject:nil waitUntilDone:NO];
        return;
    }

    if(m_Delegate != nil)
    {
        [m_Delegate NOMFileSaveDone:YES forFile:m_File.m_FileURL];
    }
}

-(void)GDPSaveFileFailed
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(GDPSaveFileFailed) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if(m_Delegate != nil)
    {
        [m_Delegate NOMFileSaveDone:NO forFile:m_File.m_FileURL];
    }
}

-(void)SaveFileByGDP:(NSURL*)fileURL withData:(NSData*)data
{
    if(m_File == nil)
    {
        m_File = [[NOMFile alloc] init];
    }
    m_File.m_FileURL = fileURL;
    m_File.m_FileData = data;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void)
    {
        BOOL bSucceed = [m_File SaveFile];
        if(bSucceed == YES)
        {
            [self GDPSaveFileSucceeded];
        }
        else
        {
            [self GDPSaveFileFailed];
        }
    });
}

-(void)SaveFile:(NSURL*)fileURL withData:(NSData*)data
{
    if(m_FileOperationManager == nil)
    {
        [self SaveFileByGDP:fileURL withData:data];
        return;
    }
    NOMFileSaveOperation* saveOperation = [[NOMFileSaveOperation alloc] initFile:fileURL withData:data];
    [m_FileOperationManager addOperation:saveOperation];
}

-(void)GDPLoadFileSucceeded
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(GDPLoadFileSucceeded) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if(m_Delegate && m_File)
    {
        [m_Delegate NOMFileLoadDone:m_File.m_FileData forFile:m_File.m_FileURL];
    }
}

-(void)GDPLoadFileFailed
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(GDPLoadFileFailed) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if(m_Delegate)
    {
        [m_Delegate NOMFileLoadFailed];
    }
}

-(void)LoadFileByGDP:(NSURL*)fileURL
{
    if(m_File == nil)
    {
        m_File = [[NOMFile alloc] init];
    }
    [m_File Reset];
    m_File.m_FileURL = fileURL;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^(void)
    {
        BOOL bSucceed = [m_File LoadFile];
        if(bSucceed == YES)
        {
            [self GDPLoadFileSucceeded];
        }
        else
        {
            [self GDPLoadFileFailed];
        }
    });
}

-(void)LoadFile:(NSURL*)fileURL
{
    if(m_FileOperationManager == nil)
    {
        [self LoadFileByGDP:fileURL];
        return;
    }
    NOMFileLoadOperation* loadOperation = [[NOMFileLoadOperation alloc] initFile:fileURL];
    [m_FileOperationManager addOperation:loadOperation];
}

-(void)LoadJsonFile:(NSURL*)fileURL
{
    NOMFileLoadOperation* loadOperation = [[NOMFileLoadOperation alloc] initFile:fileURL];
//???    [[NOMOperationManager sharedOperationManager] addOperation:loadOperation finishedTarget:self action:@selector(JsonFileLoadCompleted:)];
    [m_FileOperationManager addOperation:loadOperation];
}

-(void)LoadImageFile:(NSURL*)fileURL
{
    NOMFileLoadOperation* loadOperation = [[NOMFileLoadOperation alloc] initFile:fileURL];
//???    [[NOMOperationManager sharedOperationManager] addOperation:loadOperation finishedTarget:self action:@selector(ImageFileLoadCompleted:)];
    [m_FileOperationManager addOperation:loadOperation];
}

-(BOOL)FileExistByURL:(NSURL*)url
{
    NSString* file = [url path];
    BOOL bRet = [[NSFileManager defaultManager] fileExistsAtPath:file];
    return bRet;
}

-(BOOL)FileExistByFileName:(NSString*)fileName
{
    BOOL bRet = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
    return bRet;
}

@end

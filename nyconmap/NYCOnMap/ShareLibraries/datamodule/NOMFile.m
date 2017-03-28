//
//  NOMFile.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-08.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMFile.h"

@implementation NOMFile

@synthesize m_FileData = _m_FileData;
@synthesize m_FileURL = _m_FileURL;
@synthesize m_NOMFileType = _m_NOMFileType;


-(id)init
{
    self = [super init];
    if(self != nil)
    {
        _m_FileData = nil;
        _m_FileURL = nil;
        _m_NOMFileType = 0;
    }
    return self;
}

-(void)dealloc
{
}

-(void)Reset
{
    _m_FileData = nil;
    _m_FileURL = nil;
    _m_NOMFileType = 0;
}

-(void)SetFileType:(int16_t)nFileType
{
    _m_NOMFileType = nFileType;
}

-(int16_t)GetFileType
{
    return _m_NOMFileType;
}

-(BOOL)SaveFile
{
    BOOL bRet = NO;
    if(_m_FileURL != nil && _m_FileData != nil)
    {
        NSString* testString = [[NSString alloc] initWithData:_m_FileData encoding:NSUTF8StringEncoding];
        NSLog(@"SaveFile DATA string:%@", testString);
        
        //NSData* data = [testString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *errorInfo = nil;
        bRet = [_m_FileData writeToURL:_m_FileURL options:NSDataWritingAtomic|NSDataWritingFileProtectionNone error:&errorInfo];
        //bRet = [data writeToURL:_m_FileURL options:NSDataWritingAtomic|NSDataWritingFileProtectionNone error:&errorInfo];
        if(errorInfo != nil)
        {
            NSLog(@"SaveFile error info:%@", errorInfo);
        }
    }
    
    return bRet;
}

-(BOOL)LoadFile
{
    BOOL bRet = NO;
    if(_m_FileURL != nil)
    {
        NSError *errorInfo = nil;
        _m_FileData = [NSData dataWithContentsOfURL:_m_FileURL options:NSDataReadingMappedIfSafe error:&errorInfo];
        if(_m_FileData == nil)
        {
            bRet = NO;
        }
        else
        {
            bRet = YES;
        }
    }
    
    return bRet;
}

@end

@implementation NOMFileSaveOperation

- (void)main
{
    if(m_File != nil)
    {
        m_bSucceed = [m_File SaveFile];
    }
}

-(id)initFile:(NSURL*)fileURL withData:(NSData*)data
{
    self = [super init];
    if(self != nil)
    {
        m_File = [[NOMFile alloc] init]; //[[[NOMFile alloc] init] autorelease];
        m_File.m_FileData = data;
        m_File.m_FileURL = fileURL;
        m_bSucceed = NO;
    }
    return self;
}

-(void)dealloc
{
}

-(BOOL)IsSucceed
{
    return m_bSucceed;
}

-(NSURL*)GetFileURL
{
    if(m_File != nil)
    {
        return m_File.m_FileURL;
    }
    return nil;
}

-(int16_t)GetFileType
{
    int16_t nFileType = 0;
    
    if(m_File != nil)
    {
        nFileType = [m_File GetFileType];
    }
    
    return nFileType;
}

@end

@implementation NOMFileLoadOperation

- (void)main
{
    if(m_File != nil)
    {
        m_bSucceed = [m_File LoadFile];
    }
}

-(id)initFile:(NSURL*)fileURL
{
    self = [super init];
    if(self != nil)
    {
        m_File = [[NOMFile alloc] init];//[[[NOMFile alloc] init] autorelease];
        m_File.m_FileURL = fileURL;
        m_bSucceed = NO;
    }
    return self;
}

-(BOOL)IsSucceed
{
    return m_bSucceed;
}

-(NSData*)GetData
{
    if(m_File != nil)
    {
        return m_File.m_FileData;
    }
    return nil;
}

-(NSURL*)GetFileURL
{
    if(m_File != nil)
    {
        return m_File.m_FileURL;
    }
    return nil;
}

-(int16_t)GetFileType
{
    int16_t nFileType = 0;
    
    if(m_File != nil)
    {
        nFileType = [m_File GetFileType];
    }
    
    return nFileType;
}

@end


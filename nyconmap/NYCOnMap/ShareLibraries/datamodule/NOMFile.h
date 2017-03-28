//
//  NOMFile.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-08.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOMFile : NSObject
{
@private
    NSData*                     _m_FileData;
    NSURL*                      _m_FileURL;
    int16_t                     _m_NOMFileType;
}

@property (nonatomic)NSData*                     m_FileData;
@property (nonatomic)NSURL*                      m_FileURL;
@property (nonatomic)int16_t                     m_NOMFileType;

-(BOOL)SaveFile;
-(BOOL)LoadFile;
-(void)SetFileType:(int16_t)nFileType;
-(int16_t)GetFileType;
-(void)Reset;

@end

@interface NOMFileSaveOperation : NSOperation
{
@private
    NOMFile*            m_File;
    BOOL                m_bSucceed;
}

-(id)initFile:(NSURL*)fileURL withData:(NSData*)data;
-(BOOL)IsSucceed;
-(int16_t)GetFileType;
-(NSURL*)GetFileURL;

@end

@interface NOMFileLoadOperation : NSOperation
{
@private
    NOMFile*            m_File;
    BOOL                m_bSucceed;
}

-(id)initFile:(NSURL*)fileURL;
-(BOOL)IsSucceed;
-(NSData*)GetData;
-(NSURL*)GetFileURL;
-(int16_t)GetFileType;

@end
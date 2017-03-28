//
//  NOMFileManager.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-08.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOMOperationCompleteDelegate.h"

@protocol NOMFileManagerDelegate <NSObject>
-(void)NOMFileSaveDone:(BOOL)bSucceed forFile:(NSURL*)fileURL;
-(void)NOMFileLoadDone:(NSData*)data forFile:(NSURL*)fileURL;
-(void)NOMJsonFileLoadDone:(NSData*)data forFile:(NSURL*)fileURL;
-(void)NOMImageFileLoadDone:(NSData*)data forFile:(NSURL*)fileURL;

-(void)NOMFileLoadFailed;

@end

@interface NOMFileManager : NSObject<NOMOperationCompleteDelegate>

+(NOMFileManager*)sharedFileManager;

+(NSString*)GetAppTempFolder;

+(NSString*)GetAppRootFolder;
+(NSString*)GetAppSubFolder:(NSString*)subFolderName;

+(void)CheckAndCreateAppSubFolder:(NSString*)subFolder;

+(NSURL*)GetAppRootFolderPath;

+(NSURL*)GetFilePath:(NSString*)fileKey;

-(id)initNoneOperationFileManager;
-(void)AssignDelegate:(id<NOMFileManagerDelegate>)delegate;
-(void)SaveFile:(NSURL*)fileURL withData:(NSData*)data;
-(void)LoadFile:(NSURL*)fileURL;
-(void)LoadJsonFile:(NSURL*)fileURL;
-(void)LoadImageFile:(NSURL*)fileURL;
-(BOOL)FileExistByURL:(NSURL*)url;
-(BOOL)FileExistByFileName:(NSString*)fileName;



@end

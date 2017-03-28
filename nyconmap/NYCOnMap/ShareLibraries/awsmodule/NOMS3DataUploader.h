//
//  NOMS3DataUploader.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-09.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NOMAWSMergeModule.h"
#import "NOMAWSServiceProtocols.h"

@interface NOMS3DataUploaderAsyn : NSObject

-(void)AssignDelegate:(id<INOMS3DataUploaderDelegate>)delegate;
-(void)SetSource:(NSData*)data withContentType:(NSString*)type withS3Bucket:(NSString*)bucket withS3Key:(NSString*)fileKey;
-(BOOL)IsNewsMainFile;
-(void)SetAsNewsMainFile:(BOOL)bMainFile;

/*
-(BOOL)IsSuccess;
-(BOOL)IsFinished;
*/
 

-(void)Start;
-(NSString*)GetFileKey;
-(NSString*)GetBucket;
-(NSString*)GetContentType;

@end
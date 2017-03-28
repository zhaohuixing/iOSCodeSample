//
//  NOMS3DataDownloader.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-11.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOMAWSMergeModule.h"
#import "NOMAWSServiceProtocols.h"


@interface NOMS3DataDownloader : NSObject

-(void)AssignDelegate:(id<INOMS3DataDownloaderDelegate>)delegate;
-(void)SetSource:(NSString*)contentType withS3Bucket:(NSString*)bucket withS3Key:(NSString*)fileKey withDestination:(NSURL*)destFile;
-(NSString*)GetFileKey;
-(NSString*)GetContentType;
-(NSString*)GetBucket;
-(NSData*)GetData;

-(void)Start;

@end

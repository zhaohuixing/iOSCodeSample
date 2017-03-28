//
//  NOMNewsPublishTask.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-21.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOMAWSMergeModule.h"
#import "NOMAWSServiceProtocols.h"
#import "NOMNewsMetaDataRecord.h"

@interface NOMNewsPublishTask : NSObject<INOMS3DataUploaderDelegate, INOMTopicPostServiceDelegate>

-(void)RegisterDelegate:(id<INOMNewsPublishTaskDelegate>)delegate;

-(NOMNewsMetaDataRecord*)GetNewsData;

-(void)StartPostNews:(NOMNewsMetaDataRecord*)pNewsMetaData
         withSubject:(NSString*)szSubject
            withPost:(NSString*)szPost
         withKeyWord:(NSString*)szKeyWord
       withCopyRight:(NSString*)szCopyRight
             withKML:(NSString*)szKML
           withImage:(UIImage*)pImage;

-(void)DirectPostNews:(NOMNewsMetaDataRecord*)pNewsMetaData;

//
//INOMS3DataUploaderDelegate methods
//
-(void)NOMS3DataUploadDone:(id)dataUploader withResult:(BOOL)bSucceed;

//
//INOMTopicPostServiceDelegate methods
//
-(void)NOMPostServiceDone:(id)postService withResult:(BOOL)bSucceed;

@end

//
//  NOMAWSServiceProtocols.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-11-22.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#ifndef __NOMAWSSERVICEPROTOCOLS_H__
#define __NOMAWSSERVICEPROTOCOLS_H__

//
@protocol NOMNewsMessageManagerDelegate <NSObject>

@optional

-(void)NewsMessageQueueInitialized:(id)msgMan result:(BOOL)bNeedSubcribe;
-(void)NewsMessageQueryCompleted:(id)msgMan;
-(void)NewsMessageQueryFailed:(id)msgMan;
-(void)QueryAllDataFromNewsSQS:(id)msgMan;


@end

//
@protocol INOMNewsMessageQCreationDelegate <NSObject>

@optional

-(void)MessageQCreationDone:(id)Qservice result:(BOOL)bOK;

@end

//
@protocol INOMNewsMessageQSubscribeDelegate <NSObject>

@optional
-(void)MessageQSubscribeDone:(id)Qservice result:(BOOL)bOK;

@end

//
@protocol INOMNewsMessageQFindDelegate <NSObject>

-(void)MessageQFindDone:(id)QFinder result:(BOOL)bSucceed;

@end

//
@protocol INOMNewsQueryTaskDelegate <NSObject>

@optional
-(void)NOMNewsQueryTaskDone:(id)task result:(BOOL)bSuceeded;

@end

//
//
@protocol INOMTrafficSpotQueryDelegate <NSObject>

@optional
-(void)NOMTrafficSpotQueryTaskDone:(id)task result:(BOOL)bSuceeded;

@end
//

//
//
@protocol INOMTrafficSpotReportDelegate <NSObject>

@optional
-(void)NOMTrafficSpotReportTaskDone:(id)task result:(BOOL)bSuceeded;

@end
//

@protocol INOMMobileEndPointARNCreationDelegate <NSObject>

@optional

-(void)MobileEndPointARNCreation:(id)ARNCreation result:(BOOL)bOK;

@end

@protocol INOMMobileDeviceSubscribeDelegate <NSObject>

@optional

-(void)NewsMobileDeviceSubscribeCreation:(id)subrciption result:(BOOL)bOK;

@end


@protocol INOMNewsTopicSearchDelegate <NSObject>

@optional

-(void)NewsTopicSearchCompletion:(id)search result:(BOOL)bOK;

@end


@protocol INOMNewsTopicCreateDelegate <NSObject>

@optional

-(void)NewsTopicCreateCompletion:(id)creation result:(BOOL)bOK;

@end

@protocol INOMNewsPublishTaskDelegate <NSObject>

@optional
-(void)NOMNewsPublishTashDone:(id)task result:(BOOL)bSuceeded;
-(NSString*)GetTopicARN;

@end

@protocol INOMTopicPostServiceDelegate <NSObject>

-(void)NOMPostServiceDone:(id)postService withResult:(BOOL)bSucceed;

@end

@protocol INOMS3DataUploaderDelegate <NSObject>

-(void)NOMS3DataUploadDone:(id)dataUploader withResult:(BOOL)bSucceed;

@end

@protocol INOMS3DataDownloaderDelegate <NSObject>

-(void)NOMS3DataDownloadDone:(id)dataDownloader withResult:(BOOL)bSucceed;

@end

#endif

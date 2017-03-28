//
//  NOMNewsMessagePublishManager.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
//#import "NOMNewsMetaDataRecord.h"
#import "NOMNewsPublishTask.h"

@protocol INOMNewsMessagePublishManagerDelegate <NSObject>

@optional
-(void)NOMTrafficMessagePublishDone:(NOMNewsMetaDataRecord*)pData result:(BOOL)bSuceeded;

@end


@interface NOMNewsMessagePublishManager : NSObject<INOMNewsPublishTaskDelegate>

-(void)RegisterDelegate:(id<INOMNewsMessagePublishManagerDelegate>)delegate;

-(void)StartPostNews:(NOMNewsMetaDataRecord*)pNewsMetaData
         withSubject:(NSString*)szSubject
            withPost:(NSString*)szPost
         withKeyWord:(NSString*)szKeyWord
       withCopyRight:(NSString*)szCopyRight
             withKML:(NSString*)szKML
           withImage:(UIImage*)pImage;

-(void)DirectPostNews:(NOMNewsMetaDataRecord*)pNewsMetaData;

-(void)NOMNewsPublishTashDone:(id)task result:(BOOL)bSuceeded;

-(void)SetTopicARN:(NSString*)topicARN;

@end

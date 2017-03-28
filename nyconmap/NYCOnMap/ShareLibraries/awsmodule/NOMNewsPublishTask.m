//
//  NOMNewsPublishTask.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-21.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMNewsPublishTask.h"
#import "NOMNewsServiceHelper.h"
#import "NOMSystemConstants.h"
#import "AmazonClientManager.h"
#import "NOMJSONDataBuilder.h"
#import "NOMS3DataUploader.h"
#import "NOMTopicPostService.h"
#import "NOMAppInfo.h"

@interface NOMNewsPublishTask ()
{
    id<INOMNewsPublishTaskDelegate>             m_Delegate;
    NOMS3DataUploaderAsyn*                      m_KMLUploader;
    NOMS3DataUploaderAsyn*                      m_MainFileUploader;
    NOMS3DataUploaderAsyn*                      m_ImageUploader;
    NOMTopicPostService*                        m_NewsPoster;
    
    BOOL                                        m_bKMLUploadDone;
    BOOL                                        m_bMainFileUploadDone;
    BOOL                                        m_bImageUploadDone;
    
    BOOL                                        m_bNewsDataPostingDone;
    BOOL                                        m_bNewsDataPostedSucceed;
    
    NOMNewsMetaDataRecord*                                  m_NewsMetaData;
    
    UIImage*                                                m_Image;
    NSString*                                               m_ImageFileKey;
    
    NSString*                                               m_KMLString;
    NSString*                                               m_KMLFileKey;
    
    NSString*                                               m_NewsTitle;
    NSString*                                               m_NewsBody;
    NSString*                                               m_NewsKeyWords;
    NSString*                                               m_CopyRight;
    
    NSString*                                               m_TimeStampeKey;
}

-(void)PublishTaskDone:(BOOL)bSucceeded;

@end

@implementation NOMNewsPublishTask

-(void)Reset
{
    m_KMLUploader = nil;
    m_MainFileUploader = nil;
    m_ImageUploader = nil;
    m_NewsPoster = nil;
    m_bKMLUploadDone = NO;
    m_bMainFileUploadDone = NO;
    m_bImageUploadDone = NO;
    m_bNewsDataPostingDone = NO;
    m_bNewsDataPostedSucceed = NO;
    
    m_NewsMetaData = nil;
    
    m_Image = nil;
    m_ImageFileKey = nil;
    
    m_KMLString = nil;
    m_KMLFileKey = nil;
    
    m_NewsTitle = nil;
    m_NewsBody = nil;
    m_NewsKeyWords = nil;
    m_CopyRight = nil;
    
    m_TimeStampeKey = nil;
}

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_Delegate = nil;
        m_KMLUploader = nil;
        m_MainFileUploader = nil;
        m_ImageUploader = nil;
        m_NewsPoster = nil;
        m_bKMLUploadDone = NO;
        m_bMainFileUploadDone = NO;
        m_bImageUploadDone = NO;
        m_bNewsDataPostingDone = NO;
        m_bNewsDataPostedSucceed = NO;
        
        m_NewsMetaData = nil;
        
        m_Image = nil;
        m_ImageFileKey = nil;
        
        m_KMLString = nil;
        m_KMLFileKey = nil;
        
        m_NewsTitle = nil;
        m_NewsBody = nil;
        m_NewsKeyWords = nil;
        m_CopyRight = nil;
        m_TimeStampeKey = nil;
    }
    
    return self;
}

-(NOMNewsMetaDataRecord*)GetNewsData
{
    return m_NewsMetaData;
}

-(void)RegisterDelegate:(id<INOMNewsPublishTaskDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)HandleKMLResource:(BOOL)bSucceed
{
    m_bKMLUploadDone = YES;
    [self UpdateUploadingState];
}

-(void)HandleImageResource:(BOOL)bSucceed
{
    m_bImageUploadDone = YES;
    [self UpdateUploadingState];
}

-(void)HandleMainFileResource:(BOOL)bSucceed
{
    m_bMainFileUploadDone = YES;
    [self PostNewsRecord];
}

-(void)UpdateUploadingState
{
    if(m_bNewsDataPostingDone == YES && m_bMainFileUploadDone == YES && m_bImageUploadDone == YES && m_bKMLUploadDone == YES)
    {
        [self PublishTaskDone:m_bNewsDataPostedSucceed];
    }
}

//
//INOMS3DataUploaderDelegate methods
//
-(void)NOMS3DataUploadDone:(id)dataUploader withResult:(BOOL)bSucceed
{
    if(dataUploader == m_KMLUploader && m_KMLUploader != nil)
    {
        [self HandleKMLResource:bSucceed];
    }
    else if(dataUploader == m_ImageUploader && m_ImageUploader != nil)
    {
        [self HandleImageResource:bSucceed];
    }
    else if(dataUploader == m_MainFileUploader && m_MainFileUploader != nil)
    {
        [self HandleMainFileResource:bSucceed];
    }
}


//
//INOMTopicPostServiceDelegate methods
//
-(void)NOMPostServiceDone:(id)postService withResult:(BOOL)bSucceed
{
    if(postService == nil || bSucceed == NO)
    {
        m_bNewsDataPostedSucceed = NO;
    }
    else
    {
        m_bNewsDataPostedSucceed = YES;
    }
    m_bNewsDataPostingDone = YES;
    [self UpdateUploadingState];
}


-(void)PublishTaskDone:(BOOL)bSucceeded
{
    if(m_Delegate != nil)
    {
        [m_Delegate NOMNewsPublishTashDone:self result:bSucceeded];
    }
}

-(void)PostNewsRecord
{
    NSString* topicARN = [m_Delegate GetTopicARN];
    NSString* message = [m_NewsMetaData FormatToJSONString];
    AmazonSNSClient* snsClient = [AmazonClientManager CreateSNSClient];
    m_NewsPoster = [[NOMTopicPostService alloc] initWithSNSClient:snsClient withTopicARN:topicARN withMessage:message];
    [m_NewsPoster RegisterDelegate:self];
    [m_NewsPoster StartPost];
}

-(void)UploadKML
{
    NSString* appDomain = [NOMAppInfo GetAppKey];
    
    if(m_TimeStampeKey == nil || m_TimeStampeKey.length <= 0)
        m_TimeStampeKey = [NOMNewsServiceHelper GetCurrentYearMonthDayKey];
    
    m_KMLFileKey = [NOMNewsServiceHelper GetAppNewsKMLResourceKey:m_NewsMetaData.m_NewsID withTimeStampe:m_TimeStampeKey withAppDomain:appDomain];
    m_NewsMetaData.m_NewsLoactionKmlURL = m_KMLFileKey;
    NSString* s3Bucket = [NOMNewsServiceHelper GetNewsResourceS3Bucket];
    NSData* data = [NOMNewsServiceHelper ConvertStringToData:m_KMLString];
    m_KMLUploader = [[NOMS3DataUploaderAsyn alloc] init];
    [m_KMLUploader AssignDelegate:self];
    [m_KMLUploader SetAsNewsMainFile:NO];
    [m_KMLUploader SetSource:data withContentType:NOM_NEWSKML_CONTENTTYPE withS3Bucket:s3Bucket withS3Key:m_KMLFileKey];
    [m_KMLUploader Start];
}

-(void)UploadImage
{
    NSString* appDomain = [NOMAppInfo GetAppKey];

    if(m_TimeStampeKey == nil || m_TimeStampeKey.length <= 0)
        m_TimeStampeKey = [NOMNewsServiceHelper GetCurrentYearMonthDayKey];
    
    m_ImageFileKey = [NOMNewsServiceHelper GetAppNewsImageResourceKey:m_NewsMetaData.m_NewsID imageIndex:0 withTimeStampe:m_TimeStampeKey withAppDomain:appDomain];
    m_NewsMetaData.m_NewsImageURL = m_ImageFileKey;
    NSString* s3Bucket = [NOMNewsServiceHelper GetNewsResourceS3Bucket];
    NSData* data = [NOMNewsServiceHelper ConvertImageToJpegData:m_Image];
    m_ImageUploader = [[NOMS3DataUploaderAsyn alloc] init];
    [m_ImageUploader AssignDelegate:self];
    [m_ImageUploader SetAsNewsMainFile:NO];
    [m_ImageUploader SetSource:data withContentType:NOM_NEWSIMAGE_CONTENTTYPE withS3Bucket:s3Bucket withS3Key:m_ImageFileKey];
    [m_ImageUploader Start];
}

-(NSData*)CreateNewsMainJSONData
{
    NSData* pJSON = nil;
    
    NOMJSONDataBuilder* jsonBuilder = [[NOMJSONDataBuilder alloc] init];
    NSNumber* newLantitude = [[NSNumber alloc] initWithDouble:m_NewsMetaData.m_NewsLatitude];
    NSNumber* newLongitude = [[NSNumber alloc] initWithDouble:m_NewsMetaData.m_NewsLongitude];
    NSNumber* newTime = [[NSNumber alloc] initWithLongLong:(long long)m_NewsMetaData.m_nNewsTime];
    NSNumber* newCategory = [[NSNumber alloc] initWithInt:m_NewsMetaData.m_NewsMainCategory];
    NSNumber* newSubCategory = [[NSNumber alloc] initWithInt:m_NewsMetaData.m_NewsSubCategory];
    NSNumber* newThirdCategory = [[NSNumber alloc] initWithInt:m_NewsMetaData.m_NewsThirdCategory];
    int nImageCount = 1;
    if(m_Image == 0)
        nImageCount = 0;
    NSNumber* newImageCount = [[NSNumber alloc] initWithInt:nImageCount];
    
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWID withObject:m_NewsMetaData.m_NewsID];
    if(m_NewsMetaData.m_NewsPosterDisplayName != nil && 0 < m_NewsMetaData.m_NewsPosterDisplayName.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_PUBLISHERDISPLAYNAME withObject:m_NewsMetaData.m_NewsPosterDisplayName];
    if(m_NewsMetaData.m_NewsPosterEmail != nil && 0 < m_NewsMetaData.m_NewsPosterEmail.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_PUBLISHEREMAIL withObject:m_NewsMetaData.m_NewsPosterEmail];
    
    if(m_NewsTitle != nil && 0 < m_NewsTitle.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSTITLE withObject:m_NewsTitle];
    if(m_NewsBody != nil && 0 < m_NewsBody.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSBODY withObject:m_NewsBody];
    
    if(m_NewsKeyWords != nil && 0 < m_NewsKeyWords.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSKEYWORDS withObject:m_NewsKeyWords];
    
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSLATITUDE withObject:newLantitude];
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSLONGITUDE withObject:newLongitude];
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSTIME withObject:newTime];
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSCATEGORY withObject:newCategory];
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSSUBCATEGORY withObject:newSubCategory];
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSTHIRDCATEGORY withObject:newThirdCategory];
    
    if(m_CopyRight != nil && 0 < m_CopyRight.length)
        [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSCOPYRIGHT withObject:m_CopyRight];
    
    [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSIMAGECOUNT withObject:newImageCount];
 
    if(m_TimeStampeKey == nil || m_TimeStampeKey.length <= 0)
        m_TimeStampeKey = [NOMNewsServiceHelper GetCurrentYearMonthDayKey];
   
    NSString* appDomain = [NOMAppInfo GetAppKey];
    
    if(0 < nImageCount )
    {
        NSString* sImageKey = [NSString stringWithFormat:@"%@%i", NOM_NEWSJSON_TAG_NEWSIMAGEKEYPREFIX, 0];
        if(m_ImageFileKey == nil || m_ImageFileKey.length <= 0)
            m_ImageFileKey = [NOMNewsServiceHelper GetAppNewsImageResourceKey:m_NewsMetaData.m_NewsID imageIndex:0 withTimeStampe:m_TimeStampeKey withAppDomain:appDomain];
        [jsonBuilder Add:sImageKey withObject:m_ImageFileKey];
        m_NewsMetaData.m_NewsImageURL = m_ImageFileKey;
    }
    
    if(m_KMLString != nil && 0 < m_KMLString.length)
    {
        if(m_KMLFileKey == nil || m_KMLFileKey.length <= 0)
            m_KMLFileKey = [NOMNewsServiceHelper GetAppNewsKMLResourceKey:m_NewsMetaData.m_NewsID withTimeStampe:m_TimeStampeKey withAppDomain:appDomain];
        m_NewsMetaData.m_NewsLoactionKmlURL = m_KMLFileKey;
        [jsonBuilder Add:NOM_NEWSJSON_TAG_NEWSKMLURL withObject:m_KMLFileKey];
    }
    
    pJSON = [jsonBuilder CreateJSONData];
    
    return pJSON;
}

-(void)UploadMainFile
{
    NSString* appDomain = [NOMAppInfo GetAppKey];
    
    if(m_TimeStampeKey == nil || m_TimeStampeKey.length <= 0)
        m_TimeStampeKey = [NOMNewsServiceHelper GetCurrentYearMonthDayKey];
    
    NSString* newsJSONFileKey = [NOMNewsServiceHelper GetMainNewsJSONFileTimeStampeResourceKey:appDomain mainCate:m_NewsMetaData.m_NewsMainCategory subCate:m_NewsMetaData.m_NewsSubCategory thirdCate:m_NewsMetaData.m_NewsThirdCategory newsID:m_NewsMetaData.m_NewsID timeStampe:m_TimeStampeKey];
    
    m_NewsMetaData.m_NewsResourceURL = newsJSONFileKey;
    NSData* jsonData = [self CreateNewsMainJSONData];
    NSString* s3Bucket = [NOMNewsServiceHelper GetNewsResourceS3Bucket];
    m_MainFileUploader = [[NOMS3DataUploaderAsyn alloc] init];
    [m_MainFileUploader AssignDelegate:self];
    [m_MainFileUploader SetAsNewsMainFile:YES];
    [m_MainFileUploader SetSource:jsonData withContentType:NOM_NEWSJSON_CONTENTTYPE withS3Bucket:s3Bucket withS3Key:newsJSONFileKey];
    [m_MainFileUploader Start];
}


-(void)StartPostNews:(NOMNewsMetaDataRecord*)pNewsMetaData
         withSubject:(NSString*)szSubject
            withPost:(NSString*)szPost
         withKeyWord:(NSString*)szKeyWord
       withCopyRight:(NSString*)szCopyRight
             withKML:(NSString*)szKML
           withImage:(UIImage*)pImage
{
    [self Reset];
    if(m_Delegate == nil || pNewsMetaData == nil)
        return;
    
    m_NewsMetaData = pNewsMetaData;
    
    m_Image = pImage;
    
    m_KMLString = szKML;
    
    m_NewsTitle = szSubject;
    m_NewsBody = szPost;
    m_NewsKeyWords = szKeyWord;
    m_CopyRight = szCopyRight;
    
    m_NewsMetaData.m_NewsTitleSource = m_NewsTitle;
    m_NewsMetaData.m_NewsBodySource = m_NewsBody;
    m_NewsMetaData.m_NewsCopyRightSource = m_CopyRight;
    m_NewsMetaData.m_NewsKeywordSource = m_NewsKeyWords;
    m_NewsMetaData.m_NewsKMLSource = m_KMLString;
    
    m_TimeStampeKey = [NOMNewsServiceHelper GetCurrentYearMonthDayKey];
    
    if(m_Image == nil &&
       (m_KMLString == nil || m_KMLString.length <= 0) &&
       (m_NewsTitle == nil || m_NewsTitle.length <= 0) &&
       (m_NewsBody == nil || m_NewsBody.length <= 0))
    {
        m_bKMLUploadDone = YES;
        m_bMainFileUploadDone = YES;
        m_bImageUploadDone = YES;
        [self PostNewsRecord];
        return;
    }

    if(m_Image == nil)
    {
        m_bImageUploadDone = YES;
    }
    
    if(m_KMLString == nil || m_KMLString.length <= 0)
    {
        m_bKMLUploadDone = YES;
    }
    
    if((m_KMLString != nil && 0 < m_KMLString.length)|| m_Image != nil)
    {
        if((m_KMLString != nil && 0 < m_KMLString.length))
            [self UploadKML];
        if(m_Image != nil)
            [self UploadImage];
    }

    [self UploadMainFile];
}

-(void)DirectPostNews:(NOMNewsMetaDataRecord*)pNewsMetaData
{
    [self Reset];
    if(m_Delegate == nil || pNewsMetaData == nil)
        return;
    
    m_NewsMetaData = pNewsMetaData;
    
    m_bKMLUploadDone = YES;
    m_bMainFileUploadDone = YES;
    m_bImageUploadDone = YES;
    [self PostNewsRecord];
}

@end

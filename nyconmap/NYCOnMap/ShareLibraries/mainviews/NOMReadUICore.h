//
//  NOMReadUICore.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NOMNewsMetaDataRecord.h"
#import "NOMAWSServiceProtocols.h"
#import "NOMFileManager.h"


@interface NOMReadUICore : UIView<UITextFieldDelegate, UITextViewDelegate, INOMS3DataDownloaderDelegate, NOMFileManagerDelegate>//!!, MKMapViewDelegate>

-(void)CleanControlState;
-(void)UpdateLayout;
-(float)GetReadViewHeight;

-(void)OpenView;

-(void)SetSubject:(NSString*)szTtiel;
-(void)SetAuthor:(NSString*)szAuthor;
-(void)SetPost:(NSString*)szPost;
-(void)SetKeywords:(NSString*)szKeywords;
-(void)SetCopyright:(NSString*)szCopyright;
-(void)SetGeographicKML:(NSString*)szKML;
-(void)SetImage:(UIImage*)image;

-(void)SetNewsData:(NOMNewsMetaDataRecord*)pData;
-(void)SetReferencePoint:(double)dLat withLongitude:(double)dLong withSpan:(double)Span;

////////////////////////////////////////////////////////////////////////
//
// INOMS3DataDownloaderDelegate method
//
////////////////////////////////////////////////////////////////////////
-(void)NOMS3DataDownloadDone:(id)dataDownloader withResult:(BOOL)bSucceed;
@end

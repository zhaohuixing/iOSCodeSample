//
//  NOMReadView.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NOMNewsMetaDataRecord.h"

@interface NOMReadView : UIView

+(double)GetDefaultBasicUISize;

-(void)OnViewClose;
-(void)OnViewOpen;
-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;

-(void)OnOKButtonClick;
-(void)OnCancelButtonClick;
-(void)OnReportButtonClick;

-(void)UpdateLayout;
-(void)CleanControlState;

-(void)SetSubject:(NSString*)szTtiel;
-(void)SetAuthor:(NSString*)szAuthor;
-(void)SetPost:(NSString*)szPost;
-(void)SetKeywords:(NSString*)szKeywords;
-(void)SetCopyright:(NSString*)szCopyright;
-(void)SetGeographicKML:(NSString*)szKML;
-(void)SetImage:(UIImage*)image;

-(void)SetNewsData:(NOMNewsMetaDataRecord*)pData;
-(void)SetReferencePoint:(double)dLat withLongitude:(double)dLong withSpan:(double)Span;

@end

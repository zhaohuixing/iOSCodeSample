//
//  HouseAdView.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-17.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseAdView : UIView
{
    NSURL*              m_adURL;
    CGImageRef          m_AppIcon[4];
    
    int                 m_nImage;
    int                 m_nShowTime;
    int                 m_nTimerCount;
}

-(void)SetURL:(NSString*)strURL;
-(void)LoadImages:(NSString*)file1 image2:(NSString*)file2 image3:(NSString*)file3 image4:(NSString*)file4;
-(void)OnTimerEvent;

@end

//
//  MapUIAnnotation.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapUIAnnotation : NSObject <MKAnnotation>
{
    UIImage*            m_Icon;
    NSString*           m_Title;
    NSString*           m_Text;
    float               m_fLatitude;
    float               m_fLongitude;
    int                 m_nAnnotionID;
    BOOL                m_bMaster;     //Yes: red pin. NO: green pin 
}

@property (nonatomic, retain)UIImage*       m_Icon;
@property (nonatomic, retain)NSString*      m_Title;
@property (nonatomic, retain)NSString*      m_Text;
@property (nonatomic)float                  m_fLatitude;
@property (nonatomic)float                  m_fLongitude;
@property (nonatomic)int                    m_nAnnotionID;
@property (nonatomic) BOOL                  m_bMaster;

@end

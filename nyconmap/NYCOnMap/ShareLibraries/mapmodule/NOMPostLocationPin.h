//
//  NOMPostLocationPin.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-06.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CustomImageButton.h"

@interface NOMPostLocationPin : MKAnnotationView
{
    CustomImageButton*       m_OKButton;
    CustomImageButton*       m_CancelButton;
    
    CGImageRef      m_PinImage;
    
    int             m_OKButtonID;
    int             m_CancelButtonID;
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withSize:(CGSize)size withOK:(int)nOKButtonID withCancel:(int)nCancelButtonID;

@end

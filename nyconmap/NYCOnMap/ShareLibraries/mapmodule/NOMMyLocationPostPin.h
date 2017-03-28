//
//  NOMMyLocationPostPin.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-30.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import <MapKit/MapKit.h>

@interface NOMMyLocationPostPin : MKAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withSize:(CGSize)size withOK:(int)nOKButtonID withCancel:(int)nCancelButtonID;

@end

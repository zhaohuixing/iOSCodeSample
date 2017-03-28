//
//  NOMGEOPlanAnnotationView.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <MapKit/MapKit.h>

@protocol IGEOPlanAnnotationViewHost <NSObject>

@optional
-(void)SetPinDragState:(BOOL)bYES;
-(double)GetZoomFactor;

@end


@interface NOMGEOPlanAnnotationView : MKAnnotationView


- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withSize:(CGSize)size withParent:(id<IGEOPlanAnnotationViewHost>)pParentView;

-(void)SetZoomThreshold:(double)minZoom maxZoom:(double)maxZoom;

@end

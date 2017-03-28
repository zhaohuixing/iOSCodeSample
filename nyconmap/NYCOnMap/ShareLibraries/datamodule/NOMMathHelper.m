//
//  NOMMathHelper.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-01.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMMathHelper.h"

@implementation NOMMathHelper

+(int)CounterClockwise:(CGFloat)x0 y0:(CGFloat)y0 x1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2
{
	CGFloat iX1, iX2, iY1, iY2;
    
	iX1 = x1 - x0;
    iY1 = y1 - y0;
	iX2 = x2 - x0;
    iY2 = y2 - y0;
    
	if(iX1*iY2 > iY1*iX2)
		return 1;
	
	if(iX1*iY2 < iY1*iX2)
		return -1;
    
	if((iX1*iX2 < 0) || (iY1*iY2 < 0))
		return -1;
    
	if((iX1*iX1 + iY1*iY1) < (iX2*iX2 + iY2*iY2))
		return 1;
    
	return 0;
}

+(int)CounterClockwise:(CLLocationCoordinate2D)pt0 point1:(CLLocationCoordinate2D)pt1 point2:(CLLocationCoordinate2D)pt2
{
	CLLocationDegrees iX1, iX2, iY1, iY2;
    
	iX1 = pt1.longitude - pt0.longitude;
    iY1 = pt1.latitude - pt0.latitude;
	iX2 = pt2.longitude - pt0.longitude;
    iY2 = pt2.latitude - pt0.latitude;
    
	if(iX1*iY2 > iY1*iX2)
		return 1;
	
	if(iX1*iY2 < iY1*iX2)
		return -1;
    
	if((iX1*iX2 < 0) || (iY1*iY2 < 0))
		return -1;
    
	if((iX1*iX1 + iY1*iY1) < (iX2*iX2 + iY2*iY2))
		return 1;
    
	return 0;
    
}

+(BOOL)Intersect:(CLLocationCoordinate2D)Line1Start line1End:(CLLocationCoordinate2D)Line1End line2Start:(CLLocationCoordinate2D)Line2Start line2End:(CLLocationCoordinate2D)Line2End
{
	int iCCW1 = [NOMMathHelper CounterClockwise:Line1Start point1:Line1End point2:Line2Start];
    int iCCW2 = [NOMMathHelper CounterClockwise:Line1Start point1:Line1End point2:Line2End];
	int iCCW3 = [NOMMathHelper CounterClockwise:Line2Start point1:Line2End point2:Line1Start];
    int iCCW4 = [NOMMathHelper CounterClockwise:Line2Start point1:Line2End point2:Line1End];
 
	return ((iCCW1*iCCW2 <= 0) && (iCCW3*iCCW4 <= 0));
}

@end

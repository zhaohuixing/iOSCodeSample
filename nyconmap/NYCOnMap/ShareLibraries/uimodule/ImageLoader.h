//
//  ImageLoader.h
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-08-04.
//  Copyright 2010 zhaohuixing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageLoader : NSObject 
{
}

+(CGImageRef)LoadResourceImage:(NSString*)imageName;
+(CGImageRef)LoadImageWithName:(NSString*)imageName; 	

+(CGImageRef)LoadImage:(NSString*)imageName withWidth:(float)width withHeight:(float)height; 	

@end

//
//  NOMImageHelper.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-17.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#ifndef __NOMIMAGEHELPER_H__
#define __NOMIMAGEHELPER_H__

@protocol IImageSelectorDelegate <NSObject>

@optional
-(void)SelectPicture;
-(void)TakePicture;

@end

@protocol IImageReceiverDelegate <NSObject>

@optional
-(void)ReceiveImage:(UIImage*)image;

@end


#endif

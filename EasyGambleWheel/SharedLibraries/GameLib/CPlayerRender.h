//
//  CPlayerRender.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-17.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@import UIKit;
@import CoreGraphics;

@interface CPlayerRender : NSObject

//-(id)CreateByType:(BOOL)bMySelf;
-(id)initWithType:(BOOL)bMySelf;
-(void)SetAvatarImage:(CGImageRef)image;


@end

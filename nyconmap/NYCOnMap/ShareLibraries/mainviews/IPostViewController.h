//
//  IPostViewController.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-17.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#ifndef __IPOSTVIEWCCONTROLLER_H__
#define __IPOSTVIEWCCONTROLLER_H__

@protocol IPostViewController <NSObject>

@optional
-(void)OnPostViewClosed:(BOOL)bOK;

@end


#endif

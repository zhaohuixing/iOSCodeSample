//
//  ISpotUIInterfaces.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-23.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#ifndef __NOM_ISPOTUIINTERFACES_H__
#define __NOM_ISPOTUIINTERFACES_H__

@protocol ISpotUIController <NSObject>

@optional
-(void)OnSpotUIClosed:(id)spotUI withResult:(BOOL)bOK;

#ifdef DEBUG
-(void)OnSpotUIDeleteEvent:(id)spotUI;
#endif

@end


#endif

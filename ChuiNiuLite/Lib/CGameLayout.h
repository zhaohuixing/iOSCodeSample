//
//  CGameLayout.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 10-11-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CGameLayout : NSObject 
{
}

+ (void)InitializeLayout;
+ (float)GameSceneToDeviceX:(float) measureX;
+ (float)GameSceneToDeviceY:(float) measureY;
+ (float)DeviceToGameSceneX:(float) x;
+ (float)DeviceToGameSceneY:(float) y;
+ (float)ObjectMeasureToDevice:(float) v;
+ (float)DeviceToObjectMeasure:(float) v;
+ (float)GetGameSceneOriginXInDevice;
+ (float)GetGameSceneOriginYInDevice;
+ (float)GetGameClientDeviceWidth;
+ (float)GetGameClientDeviceHeight;
+ (float)GetGameSceneDeviceWidth;
+ (float)GetGameSceneDeviceHeight;
+ (float)GetGameSceneWidth;
+ (float)GetGameSceneHeight;
+ (float)GetGameSceneDMScaleX;
+ (float)GetGameSceneDMScaleY;
+ (float)GetGameSceneDMScaleMin;

+ (float)GetCowHeight;
+ (float)GetCowWidth;
+ (float)GetDogHeight;
+ (float)GetDogWidth;

+ (float)GetPlayerBulletWidth;
+ (float)GetPlayerBulletHeight;
+ (float)GetPlayerBulletStartRatioX;
+ (float)GetPlayerBulletStartRatioY;
+ (float)GetPlayerBulletChangeRatioX;
+ (float)GetPlayerBulletChangeRatioY;

+ (float)GetTargetBulletWidth;
+ (float)GetTargetBulletHeight;
+ (float)GetTargetBulletStartRatioX;
+ (float)GetTargetBulletStartRatioY;
+ (float)GetTargetBulletChangeRatioX;
+ (float)GetTargetBulletChangeRatioY;
+ (float)GetRockSize;

+ (float)GetGameSceneWiningCenterY;
+ (float)GetRainBowWidth;
+ (float)GetClockRadius;


+ (float)GetRainBowSpeed;
+ (int)GetRainBowTimerStep;
+ (int)GetRainBowPlayTime;

+ (float)GetGrassUnitHeight;
+ (float)GetGrassUnitWidth;
+ (float)GetGrassUnitNumber;


@end

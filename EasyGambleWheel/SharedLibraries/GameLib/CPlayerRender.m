//
//  CPlayerRender.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-17.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "CPlayerRender.h"
#import "ImageLoader.h"


@interface CPlayerRender ()
{
@private
    CGImageRef          m_IdleImages[3];
    CGImageRef          m_PlayImages[3];
    CGImageRef          m_WinImages[3];
    CGImageRef          m_LoseImages[3];
    
    CGImageRef          m_Avatar; //Online avatar image;
    
    BOOL                m_bMyself;
}

@end

@implementation CPlayerRender

-(void)LoadIdleImages
{
    if(m_bMyself)
    {
        m_IdleImages[0] = [ImageLoader LoadImageWithName:@"meidleicon1.png"];
        m_IdleImages[1] = [ImageLoader LoadImageWithName:@"meidleicon2.png"];
        m_IdleImages[2] = [ImageLoader LoadImageWithName:@"meidleicon3.png"];
    }
    else
    {
        m_IdleImages[0] = [ImageLoader LoadImageWithName:@"ropaidleicon1.png"];
        m_IdleImages[1] = [ImageLoader LoadImageWithName:@"ropaidleicon2.png"];
        m_IdleImages[2] = [ImageLoader LoadImageWithName:@"ropaidleicon3.png"];
    }
}

-(void)LoadPlayImages
{
    if(m_bMyself)
    {
        m_PlayImages[0] = [ImageLoader LoadImageWithName:@"meplayicon1.png"];
        m_PlayImages[1] = [ImageLoader LoadImageWithName:@"meplayicon2.png"];
        m_PlayImages[2] = [ImageLoader LoadImageWithName:@"meplayicon3.png"];
    }
    else
    {
        m_PlayImages[0] = [ImageLoader LoadImageWithName:@"ropaplayicon1.png"];
        m_PlayImages[1] = [ImageLoader LoadImageWithName:@"ropaplayicon2.png"];
        m_PlayImages[2] = [ImageLoader LoadImageWithName:@"ropaplayicon3.png"];
    }
}

-(void)LoadWinImages
{
    if(m_bMyself)
    {
        m_WinImages[0] = [ImageLoader LoadImageWithName:@"mewinicon1.png"];
        m_WinImages[1] = [ImageLoader LoadImageWithName:@"mewinicon2.png"];
        m_WinImages[2] = [ImageLoader LoadImageWithName:@"mewinicon3.png"];
    }
    else
    {
        m_WinImages[0] = [ImageLoader LoadImageWithName:@"ropawinicon1.png"];
        m_WinImages[1] = [ImageLoader LoadImageWithName:@"ropawinicon2.png"];
        m_WinImages[2] = [ImageLoader LoadImageWithName:@"ropawinicon3.png"];
    }
}

-(void)LoadLoseImages
{
    if(m_bMyself)
    {
        m_LoseImages[0] = [ImageLoader LoadImageWithName:@"mecryicon1.png"];
        m_LoseImages[1] = [ImageLoader LoadImageWithName:@"mecryicon2.png"];
        m_LoseImages[2] = [ImageLoader LoadImageWithName:@"mecryicon3.png"];
    }
    else
    {
        m_LoseImages[0] = [ImageLoader LoadImageWithName:@"ropacryicon1.png"];
        m_LoseImages[1] = [ImageLoader LoadImageWithName:@"ropacryicon2.png"];
        m_LoseImages[2] = [ImageLoader LoadImageWithName:@"ropacryicon3.png"];
    }
}


-(void)LoadImages
{
    [self LoadIdleImages];
    [self LoadPlayImages];
    [self LoadWinImages];
    [self LoadLoseImages];
}

-(id)init
{
    self = [super init];
    if(self)
    {
        m_bMyself = NO;
        [self LoadImages];
        m_Avatar = NULL;
    }
    return self;
}

//-(id)CreateByType:(BOOL)bMySelf
-(id)initWithType:(BOOL)bMySelf
{
    self = [super init];
    if(self)
    {
        m_bMyself = bMySelf;
        [self LoadImages];
        m_Avatar = NULL;
    }
    return self;
}

-(void)SetAvatarImage:(CGImageRef)image
{
    if(m_Avatar)
        CGImageRelease(m_Avatar);
    
    m_Avatar = image;    
}

-(void)dealloc
{
    for(int i = 0; i < 3; ++i)
    {
        CGImageRelease(m_IdleImages[i]);
        CGImageRelease(m_PlayImages[i]);
        CGImageRelease(m_WinImages[i]);
        CGImageRelease(m_LoseImages[i]);
    }
    if(m_Avatar)
        CGImageRelease(m_Avatar);
}

@end

//
//  BubbleView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-09-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "BubbleView.h"
#import "GameConfiguration.h"
#import "GameLayout.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "ImageLoader.h"
#import "GUILayout.h"

@implementation BubbleView

- (void)OnColorIconClicked:(id)sender
{
    [m_ColorBubbleIcon SetSelected:YES];
    [m_StarBubbleIcon SetSelected:NO];
    [m_WoodBallIcon SetSelected:NO];
    [m_BlueBallIcon SetSelected:NO];
    [m_RedHeartBallIcon SetSelected:NO];

    [GameConfiguration SetBubbleType:PUZZLE_BUBBLE_COLOR];
}

- (void)OnStarIconClicked:(id)sender
{
    [m_ColorBubbleIcon SetSelected:NO];
    [m_StarBubbleIcon SetSelected:YES];
    [m_WoodBallIcon SetSelected:NO];
    [m_BlueBallIcon SetSelected:NO];
    [m_RedHeartBallIcon SetSelected:NO];
    
    [GameConfiguration SetBubbleType:PUZZLE_BUBBLE_STAR];
}

- (void)OnWoodIconClicked:(id)sender
{
    [m_ColorBubbleIcon SetSelected:NO];
    [m_StarBubbleIcon SetSelected:NO];
    [m_WoodBallIcon SetSelected:YES];
    [m_BlueBallIcon SetSelected:NO];
    [m_RedHeartBallIcon SetSelected:NO];
    
    [GameConfiguration SetBubbleType:PUZZLE_BUBBLE_FROG];
}

- (void)OnBlueIconClicked:(id)sender
{
    [m_ColorBubbleIcon SetSelected:NO];
    [m_StarBubbleIcon SetSelected:NO];
    [m_WoodBallIcon SetSelected:NO];
    [m_BlueBallIcon SetSelected:YES];
    [m_RedHeartBallIcon SetSelected:NO];
    
    [GameConfiguration SetBubbleType:PUZZLE_BUBBLE_BLUE];
}

- (void)OnRedHeartIconClicked:(id)sender
{
    [m_ColorBubbleIcon SetSelected:NO];
    [m_StarBubbleIcon SetSelected:NO];
    [m_WoodBallIcon SetSelected:NO];
    [m_BlueBallIcon SetSelected:NO];
    [m_RedHeartBallIcon SetSelected:YES];
    
    [GameConfiguration SetBubbleType:PUZZLE_BUBBLE_REDHEART];
}



- (CGRect)GetIconViewRect:(int)i
{
    float sx, sy;
    float fSize = [GameLayout GetBubbleIconViewSize];
    int nRow;
    int nCol;
    if([GUILayout IsProtrait])
    {
        nRow = (int)(((float)i)/2.0);
        nCol = i%2;
        float cx = (self.frame.size.width-fSize*2)/3.0;
        float cy = (self.frame.size.height - fSize*3)/4.0;
        float fStep = fSize+cy;
        float fStepX = cx+fSize;
        sy = fStep*nRow + cy;
        sx = cx + fStepX*nCol;
        if(nRow == 2)
        {
            sx = (self.frame.size.width - fSize)/2.0;
        }
    }
    else
    {
        nRow = (int)(((float)i)/3.0);
        nCol = i%3;
        float cy = (self.frame.size.height - fSize*2)/3.0;
        float fStep = cy+fSize;
        float cx = (self.frame.size.width-fSize*3)/4;
        float fStepX = cx+fSize;
        sy = fStep*nRow + cy;
        if(nRow == 0)
        {
            sx = cx+nCol*fStepX;
        }
        else
        {
            if(nCol == 0)
                sx = self.frame.size.width/2.0-fSize-cx/2.0;
            else
                sx = self.frame.size.width/2.0+cx/2.0;
        }
    }
    
    CGRect rect = CGRectMake(sx, sy, fSize, fSize);
    
    return rect;   
}

- (CGImageRef)CreateTemplateImage:(CGImageRef)bubbleImage
{
    float fSize = [GameLayout GetIconViewSize]*0.8;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fSize, fSize, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextSaveGState(bitmapContext);
    
    float imgSize = CGImageGetWidth(bubbleImage);

    if(0.6*fSize < imgSize)
        imgSize = 0.6*fSize; 
    
    float s = (fSize - imgSize)/2.0;
    CGRect rt = CGRectMake(s, s, imgSize, imgSize);
    CGContextDrawImage(bitmapContext, rt, bubbleImage);
    
    
    CGContextRestoreGState(bitmapContext);
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	return retImage;
}

- (void)LoadLayoutImage
{
    CGImageRef  srcImage = NULL;
    srcImage = [ImageLoader LoadImageWithName:@"bubble.png"];
    [m_ColorBubbleIcon SetIconImage:[self CreateTemplateImage:srcImage]];
    CGImageRelease(srcImage);    
    
    if([GameConfiguration IsValentineDay])
    {
        srcImage = [ImageLoader LoadImageWithName:@"heartball1.png"];
    }
    else
    {    
        srcImage = [ImageLoader LoadImageWithName:@"frogicon1.png"];
    }    
    [m_WoodBallIcon SetIconImage:[self CreateTemplateImage:srcImage]];
    CGImageRelease(srcImage);    
    
    srcImage = [ImageLoader LoadImageWithName:@"sbubble.png"];
    [m_StarBubbleIcon SetIconImage:[self CreateTemplateImage:srcImage]];
    CGImageRelease(srcImage);    


    srcImage = [ImageLoader LoadImageWithName:@"bbubble.png"];
    [m_BlueBallIcon SetIconImage:[self CreateTemplateImage:srcImage]];
    CGImageRelease(srcImage);

    srcImage = [ImageLoader LoadImageWithName:@"rbubble.png"];
    [m_RedHeartBallIcon SetIconImage:[self CreateTemplateImage:srcImage]];
    CGImageRelease(srcImage);
    
}

- (void)InitIconviews
{
    CGRect rect = [self GetIconViewRect:0];
    m_ColorBubbleIcon = [[IconView alloc] initWithFrame:rect];
    [m_ColorBubbleIcon RegisterEvent:GUIID_EVENT_COLORBUBBLEICONCLICK];
    [m_ColorBubbleIcon SetSelected:(m_ActiveType == PUZZLE_BUBBLE_COLOR)];
    [self addSubview:m_ColorBubbleIcon];
    [m_ColorBubbleIcon release];
        
    
    rect = [self GetIconViewRect:1];
    m_StarBubbleIcon = [[IconView alloc] initWithFrame:rect];
    [m_StarBubbleIcon RegisterEvent:GUIID_EVENT_STARBUBBLEICONCLICK];
    [m_StarBubbleIcon SetSelected:(m_ActiveType == PUZZLE_BUBBLE_STAR)];
    [self addSubview:m_StarBubbleIcon];
    [m_StarBubbleIcon release];
    
    rect = [self GetIconViewRect:2];
    m_WoodBallIcon = [[IconView alloc] initWithFrame:rect];
    [m_WoodBallIcon RegisterEvent:GUIID_EVENT_WOODBUBBLEICONCLICK];
    [m_WoodBallIcon SetSelected:(m_ActiveType == PUZZLE_BUBBLE_FROG)];
    [self addSubview:m_WoodBallIcon];
    [m_WoodBallIcon release];

    rect = [self GetIconViewRect:3];
    m_BlueBallIcon = [[IconView alloc] initWithFrame:rect];
    [m_BlueBallIcon RegisterEvent:GUIID_EVENT_BLUEBUBBLEICONCLICK];
    [m_BlueBallIcon SetSelected:(m_ActiveType == PUZZLE_BUBBLE_BLUE)];
    [self addSubview:m_BlueBallIcon];
    [m_BlueBallIcon release];

    rect = [self GetIconViewRect:4];
    m_RedHeartBallIcon = [[IconView alloc] initWithFrame:rect];
    [m_RedHeartBallIcon RegisterEvent:GUIID_EVENT_REDHEARTBUBBLEICONCLICK];
    [m_RedHeartBallIcon SetSelected:(m_ActiveType == PUZZLE_BUBBLE_REDHEART)];
    [self addSubview:m_RedHeartBallIcon];
    [m_RedHeartBallIcon release];
    
	[GUIEventLoop RegisterEvent:GUIID_EVENT_COLORBUBBLEICONCLICK eventHandler:@selector(OnColorIconClicked:) eventReceiver:self eventSender:m_ColorBubbleIcon];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_STARBUBBLEICONCLICK eventHandler:@selector(OnStarIconClicked:) eventReceiver:self eventSender:m_StarBubbleIcon];
	[GUIEventLoop RegisterEvent:GUIID_EVENT_WOODBUBBLEICONCLICK eventHandler:@selector(OnWoodIconClicked:) eventReceiver:self eventSender:m_WoodBallIcon];

	[GUIEventLoop RegisterEvent:GUIID_EVENT_BLUEBUBBLEICONCLICK eventHandler:@selector(OnBlueIconClicked:) eventReceiver:self eventSender:m_BlueBallIcon];

	[GUIEventLoop RegisterEvent:GUIID_EVENT_REDHEARTBUBBLEICONCLICK eventHandler:@selector(OnRedHeartIconClicked:) eventReceiver:self eventSender:m_RedHeartBallIcon];
    
    [self LoadLayoutImage];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_ActiveType = [GameConfiguration GetBubbleType];
        [self InitIconviews];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void)UpdateViewLayout
{
    CGRect rect = [self GetIconViewRect:0];
    [m_ColorBubbleIcon setFrame:rect];
    [m_ColorBubbleIcon setNeedsDisplay];
    
    rect = [self GetIconViewRect:1];
    [m_StarBubbleIcon setFrame:rect];
    [m_StarBubbleIcon setNeedsDisplay];
    
    rect = [self GetIconViewRect:2];
    [m_WoodBallIcon setFrame:rect];
    [m_WoodBallIcon setNeedsDisplay];
    
    rect = [self GetIconViewRect:3];
    [m_BlueBallIcon setFrame:rect];
    [m_BlueBallIcon setNeedsDisplay];
    
    rect = [self GetIconViewRect:4];
    [m_RedHeartBallIcon setFrame:rect];
    [m_RedHeartBallIcon setNeedsDisplay];
    
}


-(void)OpenView
{
    m_ActiveType = [GameConfiguration GetBubbleType];
    switch(m_ActiveType)
    {
        case PUZZLE_BUBBLE_COLOR:
            [m_ColorBubbleIcon SetSelected:YES];
            [m_StarBubbleIcon SetSelected:NO];
            [m_WoodBallIcon SetSelected:NO];
            [m_BlueBallIcon SetSelected:NO];
            [m_RedHeartBallIcon SetSelected:NO];
            break;
        case PUZZLE_BUBBLE_STAR:       
            [m_ColorBubbleIcon SetSelected:NO];
            [m_StarBubbleIcon SetSelected:YES];
            [m_WoodBallIcon SetSelected:NO];
            [m_BlueBallIcon SetSelected:NO];
            [m_RedHeartBallIcon SetSelected:NO];
            break;
        case PUZZLE_BUBBLE_FROG:
            [m_ColorBubbleIcon SetSelected:NO];
            [m_StarBubbleIcon SetSelected:NO];
            [m_WoodBallIcon SetSelected:YES];
            [m_BlueBallIcon SetSelected:NO];
            [m_RedHeartBallIcon SetSelected:NO];
            break;
        case PUZZLE_BUBBLE_BLUE:
            [m_ColorBubbleIcon SetSelected:NO];
            [m_StarBubbleIcon SetSelected:NO];
            [m_WoodBallIcon SetSelected:NO];
            [m_BlueBallIcon SetSelected:YES];
            [m_RedHeartBallIcon SetSelected:NO];
            break;
        case PUZZLE_BUBBLE_REDHEART:
            [m_ColorBubbleIcon SetSelected:NO];
            [m_StarBubbleIcon SetSelected:NO];
            [m_WoodBallIcon SetSelected:NO];
            [m_BlueBallIcon SetSelected:NO];
            [m_RedHeartBallIcon SetSelected:YES];
            break;
            
    }
}

@end

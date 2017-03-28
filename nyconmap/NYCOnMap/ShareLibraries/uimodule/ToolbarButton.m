//
//  ToolbarButton.m
//  KanKan
//
//  Created by Zhaohui Xing on 2013-05-05.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "ToolbarButton.h"
#import "ImageLoader.h"
#import "GUIEventLoop.h"

@implementation ToolbarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        size_t num_locations = 3;
        CGFloat locations[3] = {0.0, 0.5, 1.0};
        CGFloat colors[12] =
        {
            0.05, 0.05, 0.2, 0.8,
            0.2, 0.2, 0.6, 0.6,
            0.5, 0.5, 1.0, 0.2,
        };
        
        m_BlueColorspace = CGColorSpaceCreateDeviceRGB();
        m_BlueGradient = CGGradientCreateWithColorComponents (m_BlueColorspace, colors, locations, num_locations);
        m_TransparentPattern = [ImageLoader LoadImageWithName:@"bluepattern.png"];
        
        float size = frame.size.height*0.3;
        CGRect rt = CGRectMake(0, frame.size.height*0.7, size, size);
        m_StatusSign = [[UIImageView alloc] initWithFrame:rt];
        //m_StatusSign.backgroundColor = [UIColor greenColor];
        [m_StatusSign setImage:[UIImage imageNamed:@"find200.png"]];
        [self addSubview:m_StatusSign];
   
        rt = CGRectMake(size, 0, frame.size.width-size*1.5, frame.size.height);
        m_Label = [[UILabel alloc] initWithFrame:rt];
        m_Label.backgroundColor = [UIColor clearColor];
        [m_Label setTextColor:[UIColor whiteColor]];
        m_Label.font = [UIFont fontWithName:@"Times New Roman" size:frame.size.height*0.65];
        [m_Label setTextAlignment:NSTextAlignmentCenter];
        m_Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Label.adjustsFontSizeToFitWidth = YES;
        [m_Label setText:@"Test String"];
        [self addSubview:m_Label];
        
    }
    return self;
}

-(void)dealloc
{
    CGColorSpaceRelease(m_BlueColorspace);
    CGGradientRelease(m_BlueGradient);
    //CGImageRelease(m_TransparentPattern);
}

-(void)SetLabel:(NSString*)text
{
    [m_Label setText:text];
}

-(void)SetEventID:(int)nEventID
{
    m_nEventID = nEventID;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [GUIEventLoop SendEvent:m_nEventID eventSender:self];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x;
    pt2.y = pt1.y+rect.size.height;
    CGContextDrawLinearGradient (context, m_BlueGradient, pt1, pt2, 0);
/*
    CGContextSaveGState(context);
    
    CGContextSetAlpha(context, 0.4);
    
    float w = rect.size.width*0.96;
    float h = rect.size.height*.7;
    float sx = rect.origin.x + (rect.size.width-w)*0.5;
    float sy = 0;
    
    CGRect rt = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, rt, m_TransparentPattern);
    
    CGContextRestoreGState(context);
*/    
}


@end

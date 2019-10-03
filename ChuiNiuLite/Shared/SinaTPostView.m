//
//  SinaTPostView.m
//  LoveCompassZH
//
//  Created by Zhaohui Xing on 11-02-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "SinaTPostView.h"
#import "libinc.h"
#import "ApplicationResource.h"
#import "ApplicationConfigure.h"
#import "CustomModalAlertView.h"
#import "StringFactory.h"

static CGFloat kSTBlue[4] = {0.42578125, 0.515625, 0.703125, 1.0};
static CGFloat kSTGray[4] = {0.7, 0.7, 0.7, 0.8};
//static CGFloat kSTBlack[4] = {0.3, 0.3, 0.3, 1};
static CGFloat kSTBorderBlue[4] = {0.23, 0.35, 0.6, 1.0};

#define STLABELHEIGHT			30

@implementation SinaTPostView

@synthesize				m_GameTitle;
@synthesize				m_GameMsg;
@synthesize				m_GameIcon;
@synthesize				m_GameURL;

- (void)keyboardWillShow 
{
	if([ApplicationConfigure iPhoneDevice])
	{	
		[m_GameTweetView setAlpha:0.2];
		[m_GameIconView setAlpha:0.2];
		
		CGRect rect = m_CommentLabel.frame;
		rect.origin.y -= 90;
		[m_CommentLabel setFrame:rect];
		rect = m_GameCommentView.frame;
		rect.origin.y -= 90;
		[m_GameCommentView setFrame:rect];
		[m_CommentLabel setAlpha:0.9];
		[m_GameCommentView setAlpha:0.9];
	}
}

- (void)keyboardWillHide 
{
	if([ApplicationConfigure iPhoneDevice])
	{	
		[m_GameTweetView setAlpha:1.0];
		[m_GameIconView setAlpha:1.0];
		CGRect rect = m_CommentLabel.frame;
		rect.origin.y += 90;
		[m_CommentLabel setFrame:rect];
		rect = m_GameCommentView.frame;
		rect.origin.y += 90;
		[m_GameCommentView setFrame:rect];
		[m_CommentLabel setAlpha:1.0];
		[m_GameCommentView setAlpha:1.0];
	}
}

- (id)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		m_Draft = nil;
		m_bInitialized = NO;
		m_GameTitle = @"";
		m_GameMsg = @"";
		m_GameIcon = @"";
		m_GameURL = @"";
		m_fOldWidth = 0.0;
		
		
		//NSString* btnTitle = @"发布微博";
		float btnWidth = 100.0f;
		float btnHeight = 50.0f;
		float btnStartY = 15.0f;
        if([ApplicationConfigure iPhoneDevice])
		{
			btnStartY = 0.0f;
		}	
		btnStartY += STLABELHEIGHT;
		
		CGRect rect = CGRectMake(frame.origin.x+frame.size.width-150, btnStartY+9, 142, 32);
		
		//m_PostButton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
		m_PostButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, btnWidth, btnHeight)];
		
		// Set up the button aligment properties
		m_PostButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_PostButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_PostButton setBackgroundImage:[[UIImage imageNamed:@"green.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
		[m_PostButton setBackgroundImage:[[UIImage imageNamed:@"green2.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
		[m_PostButton setBackgroundImage:[[UIImage imageNamed:@"green1.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateDisabled];
		[m_PostButton setFrame:rect]; 
		//[m_PostButton setTitle:btnTitle forState:UIControlStateNormal];
		[m_PostButton addTarget:self action:@selector(PostButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_PostButton];
		[self bringSubviewToFront:m_PostButton];

		m_PostButton.enabled = YES;
		
		rect = CGRectMake(10, btnStartY, btnHeight, btnHeight);
		m_GameIconView = [[UIImageView alloc] initWithFrame:rect];
		m_GameIconView.backgroundColor = [UIColor lightGrayColor];
		m_GameIconView.userInteractionEnabled = NO;
		[self addSubview:m_GameIconView];
		[m_GameIconView release];
		
		float Height = 90.0f;
		float Width = frame.size.width;
		float cy = btnStartY+btnHeight;
		rect = CGRectMake(0, cy, Width, Height);
		
		m_GameTweetView = [[UITextView alloc] initWithFrame:rect];
		[m_GameTweetView setAutocorrectionType:UITextAutocorrectionTypeNo];
		[m_GameTweetView setEditable:NO];
		m_GameTweetView.backgroundColor = [UIColor clearColor];
		m_GameTweetView.font = [UIFont fontWithName:@"Georgia" size:10];
		
		[self addSubview:m_GameTweetView];
		[m_GameTweetView release];
		
		cy += Height;
        if(frame.size.height < frame.size.width)
            cy -= 20;
		rect = CGRectMake(10, cy, 160, 20);
		m_CommentLabel = [[UILabel alloc] initWithFrame:rect];
		m_CommentLabel.backgroundColor = [UIColor clearColor];
		[m_CommentLabel setTextColor:[UIColor redColor]];
		m_CommentLabel.font = [UIFont fontWithName:@"Georgia" size:18];
		[m_CommentLabel setText:@"评论(50字以内):"];
		[self addSubview:m_CommentLabel];
		[m_CommentLabel release];
		
		cy += 20;
		rect = CGRectMake(10, cy, Width-20, Height-20);
		m_GameCommentView = [[UITextView alloc] initWithFrame:rect];
		[m_GameCommentView setAutocorrectionType:UITextAutocorrectionTypeNo];
		[m_GameCommentView setEditable:YES];
		m_GameCommentView.backgroundColor = [UIColor whiteColor];
		m_GameCommentView.font = [UIFont fontWithName:@"Georgia" size:10];
		m_GameCommentView.delegate = self;
		[self addSubview:m_GameCommentView];
		[m_GameCommentView release];
	
		UIImage* iconImage = [UIImage imageNamed:@"sticon.png"];
		UIImage* closeImage = [UIImage imageNamed:@"stclose.png"];
		
		m_TitleIcon = [[UIImageView alloc] initWithImage:iconImage];
		[m_TitleIcon setFrame:CGRectMake(2, 2, STLABELHEIGHT-4, STLABELHEIGHT-4)];
		[self addSubview:m_TitleIcon];
		
		rect = CGRectMake(frame.origin.x+frame.size.width-32, 1, 28, 28);
		
		m_CloseButton = [[UIButton alloc] initWithFrame:rect];
		
		// Set up the button aligment properties
		m_CloseButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		m_CloseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		[m_CloseButton setBackgroundImage:closeImage forState:UIControlStateNormal];
		[m_CloseButton addTarget:self action:@selector(CloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_CloseButton];
		[self bringSubviewToFront:m_CloseButton];
		
        m_Spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
		m_Spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		[self addSubview:m_Spinner];
        
		m_bTextInput = NO;
        
        m_bStealthMode = NO;
    }
    return self;
}


- (void)focusInput 
{
	//[messageTextField becomeFirstResponder];
}

- (void)postStatusDidSucceed:(WeiboClient*)sender obj:(NSObject*)obj;
{
	m_PostButton.enabled = YES;
	Draft *sentDraft = nil;
	if (sender.context && [sender.context isKindOfClass:[Draft class]]) 
	{
		sentDraft = (Draft *)sender.context;
		[sentDraft autorelease];
	}
	
    if (sender.hasError) 
	{
        [sender alert];	
		[self DismissMe];
        return;
    }
    
    NSDictionary *dic = nil;
    if (obj && [obj isKindOfClass:[NSDictionary class]]) 
	{
        dic = (NSDictionary*)obj;    
    }
	
    if (dic) 
	{
        Status* sts = [Status statusWithJsonDictionary:dic];
		if (sts) 
		{
			//delete draft!
			if (sentDraft) 
			{
				
			}
		}
    }
    [CustomModalAlertView SimpleSay:@"新浪微博发布成功！" closeButton:[StringFactory GetString_Close]];
	[self DismissMe];
}

- (void)sendNewPost
{
    if(m_bStealthMode == NO)
    {    
        [m_Spinner sizeToFit];
        [m_Spinner startAnimating];
        m_Spinner.center = self.center;
    }
    
	WeiboClient *client = [[WeiboClient alloc] initWithTarget:self //m_Parent 
													   engine:[OAuthEngine currentOAuthEngine]
													   action:@selector(postStatusDidSucceed:obj:)];
	client.context = [m_Draft retain];
	m_Draft.draftStatus = DraftStatusSending;
	if (m_Draft.attachmentImage) 
	{
		[client upload:m_Draft.attachmentData status:m_Draft.text];
	}
	else 
	{
		[client post:m_Draft.text];
	}
}


- (void)PostSinaTweet:(NSString*)gameTitle
		  withMessage:(NSString*)gameMsg
			withImage:(NSString*)gameIcon
			  withURL:(NSString*)gameURL
{
	self.m_GameTitle = gameTitle;//[NSString stringWithFormat:@"%@", gameTitle];
	self.m_GameMsg = gameMsg;//[NSString stringWithFormat:@"%@", gameMsg];
	self.m_GameIcon = gameIcon;//[NSString stringWithFormat:@"%@", gameIcon];
	self.m_GameURL = gameURL;//[NSString stringWithFormat:@"%@", gameURL];
	
	m_GameTweetView.text = [NSString stringWithFormat:@"%@: %@", self.m_GameTitle, self.m_GameMsg];
	[m_GameIconView setImage:[UIImage imageWithContentsOfFile:self.m_GameIcon]];
	m_GameCommentView.text = @"";	
	m_bInitialized = NO;
	if(m_Draft != nil)
		[m_Draft release];

	
	m_Draft = nil;
}

- (void)SetInitialized
{
	m_bInitialized = YES;
}	

- (void)CloseButtonClick
{
	[self DismissMe];
}

- (void)PostButtonClick
{
	if(m_bTextInput == YES)
	{
		[m_GameCommentView resignFirstResponder];
	}
	
	if(m_bInitialized == NO)
	{
		//[ModalAlert say:@"还未登录新浪微博帐户,不能发布微博!"];
        [CustomModalAlertView SimpleSay:@"还未登录新浪微博帐户,不能发布微博!" closeButton:[StringFactory GetString_Close]];
		return;
	}
	
	if(m_Draft != nil)
		[m_Draft release];
	
	m_Draft = [[Draft alloc]initWithType:DraftTypeNewTweet];
	
	if(m_GameCommentView.text.length == 0)
	{	
		m_Draft.text = [NSString stringWithFormat:@"%@: %@", self.m_GameTitle, self.m_GameMsg];//@"非诚勿扰";
	}
	else 
	{
		m_Draft.text = [NSString stringWithFormat:@"%@: %@  [我的评论:%@.]", self.m_GameTitle, self.m_GameMsg, m_GameCommentView.text];//@"非诚勿扰";
	}

	//UIImage *pImage = [UIImage imageWithContentsOfFile:self.m_GameIcon];
	//m_Draft.attachmentImage = pImage;
	[self sendNewPost];
	m_PostButton.enabled = NO;
}	

- (void)DismissMe
{
    [m_Spinner stopAnimating];
	[self.superview sendSubviewToBack:self];
    self.hidden = YES;
}

- (void)DrawRect:(CGRect)rect fill:(const CGFloat*)fillColors
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	if (fillColors) 
	{
		CGContextSaveGState(context);
		CGContextSetFillColor(context, fillColors);
		CGContextFillRect(context, rect);
		CGContextRestoreGState(context);
	}
	
	CGColorSpaceRelease(space);
}

- (void)StrokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	CGContextSaveGState(context);
	CGContextSetStrokeColorSpace(context, space);
	CGContextSetStrokeColor(context, strokeColor);
	CGContextSetLineWidth(context, 1.0);
	
	{
		CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y-0.5},
			{rect.origin.x+rect.size.width, rect.origin.y-0.5}};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y+rect.size.height-0.5},
			{rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height-0.5}};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {{rect.origin.x+rect.size.width-0.5, rect.origin.y},
			{rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height}};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y},
			{rect.origin.x+0.5, rect.origin.y+rect.size.height}};
		CGContextStrokeLineSegments(context, points, 2);
	}
	
	CGContextRestoreGState(context);
	
	CGColorSpaceRelease(space);
}

- (void)AdjusetViewLocation:(float)nw withHeight:(float)nh
{
    if(m_bStealthMode == YES)
        return;
    
    CGRect rect = self.frame;
    rect.size.width = nw;
    rect.size.height = nh;
    [self setFrame:rect];
    
	rect = m_GameTweetView.frame;
	rect.size.width = nw-10;
	[m_GameTweetView setFrame:rect];
	
	rect = m_PostButton.frame;
	rect.origin.x = nw-180;
	[m_PostButton setFrame:rect];
	
	rect = m_GameCommentView.frame;
	rect.size.width = nw-20;
    if(nh < nw)
        rect.origin.y -= 20;
    else
        rect.origin.y += 20;
	[m_GameCommentView setFrame:rect];
    
	rect = m_CommentLabel.frame;
    if(nh < nw)
        rect.origin.y -= 20;
    else
        rect.origin.y += 20;
	[m_CommentLabel setFrame:rect];
	
	rect = m_CloseButton.frame;
	rect.origin.x = nw-32;
	[m_CloseButton setFrame:rect];
    
    [self setNeedsDisplay];
}	

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    if(m_bStealthMode == YES)
        return;
    
    // Drawing code.
	CGRect headerRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, STLABELHEIGHT);
	[self DrawRect:headerRect fill:kSTBlue];
	[self StrokeLines:headerRect stroke:kSTBorderBlue];
	
	CGRect webRect = CGRectMake(rect.origin.x, rect.origin.y+STLABELHEIGHT, rect.size.width, rect.size.height - STLABELHEIGHT);
	[self DrawRect:webRect fill:kSTGray];
}

- (void)dealloc
{
	if(m_Draft != nil)
		[m_Draft release];
	
	[m_Spinner release];
	[super dealloc];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[self keyboardWillHide];
	m_bTextInput = NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[self keyboardWillShow];
	m_bTextInput = YES;
}	

- (void)textViewDidChange:(UITextView *)textView
{
	if([textView hasText] == YES)
	{
		if(50 <= [textView.text length])
		{
			[textView resignFirstResponder];
		}	
	}	
}	

- (void)SetCloseButtonEnable:(BOOL)bYes
{
    if(m_bStealthMode)
        return;
    
	m_CloseButton.hidden = !(bYes);
}	

- (void)SetStealthMode
{
    m_bStealthMode = YES;
	m_PostButton.hidden = YES;
	
	m_GameTweetView.hidden = YES;
	m_GameIconView.hidden = YES;
	m_CommentLabel.hidden = YES;
	m_GameCommentView.hidden = YES;
	m_TitleIcon.hidden = YES;
	m_CloseButton.hidden = YES;
	m_Spinner.hidden = YES;

    CGRect frame = CGRectMake(0, 0, 1, 1);
    [self setFrame:frame];
    [self setAlpha:0.0];
}

- (void)StealthPostSinaTweet:(NSString*)gameTitle withMessage:(NSString*)gameMsg withImage:(NSString*)gameIcon withURL:(NSString*)gameURL
{
	self.m_GameTitle = gameTitle;//[NSString stringWithFormat:@"%@", gameTitle];
	self.m_GameMsg = gameMsg;//[NSString stringWithFormat:@"%@", gameMsg];
	self.m_GameIcon = gameIcon;//[NSString stringWithFormat:@"%@", gameIcon];
	self.m_GameURL = gameURL;//[NSString stringWithFormat:@"%@", gameURL];
	
	if(m_Draft != nil)
		[m_Draft release];
	m_Draft = nil;
    
	m_Draft = [[Draft alloc]initWithType:DraftTypeNewTweet];
	
    m_Draft.text = [NSString stringWithFormat:@"%@: %@", self.m_GameTitle, self.m_GameMsg];//@"非诚勿扰";
	//UIImage *pImage = [UIImage imageWithContentsOfFile:self.m_GameIcon];
	//m_Draft.attachmentImage = pImage;
	[self sendNewPost];
}
@end

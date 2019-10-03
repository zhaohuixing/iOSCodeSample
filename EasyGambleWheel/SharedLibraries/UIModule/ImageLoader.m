//
//  ImageLoader.m
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-08-04.
//  Copyright 2010 xgadget. All rights reserved.
//
#import "ImageLoader.h"
#include "drawhelper.h"
@import CoreText;
@import CoreFoundation;


#define DEFAULTAPLHA  0.4

#define  BACKGROUND_GRID_SIZE_IPAD   40.0
#define  BACKGROUND_GRID_SIZE_IPHONE 20.0


@implementation ImageLoader

+ (void)Initialize
{
}

+ (void)Release
{
}	

+ (CGImageRef)CreateTextImage:(NSString*)szText
{
    CGImageRef retImage = NULL;
    if(szText == nil || (int)szText.length <= 0)
        return retImage;
    
	CGFloat w = 200;
	CGFloat h = 200;
	CGRect rect = CGRectMake(0.0, 0.0, w, h);
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, w, h, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGFloat fFontSize = 32;
	CGFloat fCharspce = 2;
	const char *pText = [szText UTF8String];
	int nLength = (int)strlen(pText);
	CGPoint pt;
	CGContextSaveGState(bitmapContext);
	CGContextSetRGBStrokeColor(bitmapContext, 1, 0, 0, 1);
	
    //???CGContextSelectFont(bitmapContext, "Zapfino",  fFontSize, kCGEncodingMacRoman);
    
    CFStringRef fontName = CFSTR("Zapfino");
    CTFontRef font = CTFontCreateWithName(fontName, fFontSize, NULL);
    
    CFStringRef keys[] = { kCTFontAttributeName };
    CFTypeRef values[] = { font };
    
    const char *bytes = CFAllocatorAllocate(CFAllocatorGetDefault(), nLength+1, 0);
    strcpy((char*)bytes, pText);
    CFStringRef strNumber = CFStringCreateWithCStringNoCopy(NULL, bytes, kCFStringEncodingMacRoman, NULL);
    
    CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault,
                                                    (const void**)&keys,
                                                    (const void**)&values,
                                                    sizeof(keys) / sizeof(keys[0]),
                                                    &kCFTypeDictionaryKeyCallBacks,
                                                    &kCFTypeDictionaryValueCallBacks);
    
    CFAttributedStringRef attrNumberStr = CFAttributedStringCreate(kCFAllocatorDefault, strNumber, attributes);
    CFRelease(strNumber);
    CFRelease(attributes);
    CFRelease(font); ///????????????
    CTLineRef lineNumber = CTLineCreateWithAttributedString(attrNumberStr);
	
    CGContextSetCharacterSpacing(bitmapContext, fCharspce);
	CGContextSetTextDrawingMode(bitmapContext, kCGTextFillStroke);
	CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
	CGContextSetTextMatrix(bitmapContext, xform);
	
    //??CGContextShowTextAtPoint(bitmapContext, 0, 0, pText, nLength);
    CGContextSetTextPosition(bitmapContext, 0.0, 0.0);
    CTLineDraw(lineNumber, bitmapContext);
   
    pt = CGContextGetTextPosition(bitmapContext);
	CGContextRestoreGState(bitmapContext);

	CGImageRef srcImage = CGBitmapContextCreateImage(bitmapContext);
	if(pt.y == 0.0)
		pt.y = fFontSize;
	
	rect = CGRectMake(0.0, 0.0, pt.x, pt.y);
	retImage = CGImageCreateWithImageInRect(srcImage, rect);
   	
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	CGImageRelease(srcImage);
	
    CFRelease(lineNumber);
    
	return retImage;
	
}	

+ (CGPatternRef)CreateImageFillPattern:(NSString*)file withWidth:(CGFloat)w withHeight:(CGFloat)h isFlipped:(BOOL)bFlipped
{
	CGAffineTransform transform;
    CGPatternCallbacks callbacks;
	callbacks.version = 0;
	callbacks.drawPattern = &DrawPatternImage;
	callbacks.releaseInfo = &ReleasePatternImage;
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:file ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	CGImageRef image = CGImageRetain(orgImagge.CGImage);

	CGFloat width = CGImageGetWidth(image);
	CGFloat height = CGImageGetHeight(image);
	
	CGFloat xscale = w/width;
	CGFloat yscale = h/width;
	
	if(bFlipped)
		yscale *= -1.0;
	
	transform = CGAffineTransformMakeScale(xscale, yscale);
	
	CGPatternRef pattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
	return pattern;
}	

+ (UIColor*)GetDefaultViewBackgroundColor
{
	return [UIColor whiteColor];
}

+ (CGFloat)GetDefaultViewFillAlpha
{
	return 0.15;
}	

+(CGImageRef)LoadResourceImage:(NSString*)imageName
{
	CGImageRef cgImage = NULL;
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
	UIImage* uiImagge = [UIImage imageWithContentsOfFile:imagePath];
	
	if(uiImagge != nil)
		cgImage = CGImageRetain(uiImagge.CGImage);
	
	return cgImage;
}	

+(CGImageRef)LoadImageWithName:(NSString*)imageName
{
	CGImageRef cgImage = NULL;
	
	UIImage* uiImagge = [UIImage imageNamed:imageName];
	
	if(uiImagge != nil)
		cgImage = CGImageRetain(uiImagge.CGImage);
	
	return cgImage;
}

+(CGImageRef)getTransformResizImage:(CGImageRef)realImage subRect:(CGRect)rect
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, rect.size.width, rect.size.height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGContextDrawImage(bitmapContext, rect, realImage);
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
	return retImage;
}

+(CGImageRef)LoadImage:(NSString*)imageName withWidth:(float)width withHeight:(float)height
{
    CGImageRef srcImage = [ImageLoader LoadImageWithName:imageName];

	CGFloat imgWidth = CGImageGetWidth(srcImage);
	CGFloat imgHeight = CGImageGetHeight(srcImage);
    BOOL bRotate = NO;
    
    CGFloat fImgRatio = imgWidth/imgHeight;
    CGFloat fDstRatio = width/height;
    
    if((fImgRatio < 1.0 && 1.0 < fDstRatio) || (1.0 < fImgRatio && fDstRatio < 1.0))
        bRotate = YES;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextSaveGState(bitmapContext);
    CGRect rect = CGRectMake(0.0, 0.0, width, height);
    
    if(bRotate)
    {
		CGFloat cx = width/2;
        CGFloat cy = height/2;
        rect = CGRectMake((width-height)/2, (height-width)/2, height, width);
        CGContextTranslateCTM(bitmapContext, cx, cy);
        
		CGFloat angle = 90;
		CGContextRotateCTM(bitmapContext, angle*M_PI/180.0f);
		
		CGContextTranslateCTM(bitmapContext, -cx, -cy);
    }
    
	CGContextDrawImage(bitmapContext, rect, srcImage);
    CGContextRestoreGState(bitmapContext);
    
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    CGImageRelease(srcImage);
	return retImage;
}

+ (void)DrawNumber:(CGContextRef)context withNumber:(int)value inRect:(CGRect)rect
{
	NSNumber* nsValue = [NSNumber numberWithInt: value];
	NSString* sNumber = [nsValue stringValue];
	const char *sText = [sNumber UTF8String];
	if(sText == NULL)
		return;
	
	CGImageRef imgNumber = CreateNumericImage(sText);
	if(imgNumber == NULL)
		return;
	
	CGFloat imgWidth = CGImageGetWidth(imgNumber);
	CGFloat imgHeight = CGImageGetHeight(imgNumber);
	CGFloat maxWidth = rect.size.width;
	CGFloat maxHeight = rect.size.height;
	CGFloat width, height;
	height = maxHeight;
	width = height*imgWidth/imgHeight;
	
	if(maxWidth < width)
		width = maxWidth;
    
	CGContextSaveGState(context);
	
	CGFloat sx = (rect.size.width - width)/2.0;
	CGFloat sy = (rect.size.height - height)/2.0;
	
	CGRect imgRect = CGRectMake(sx, sy, width, height);
	
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
	shadowClrSpace = CGColorSpaceCreateDeviceRGB();
	shadowSize = CGSizeMake(4, 0);
	CGFloat clrvals[] = {0.3, 0.3, 0.3, 1};
	shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
	CGContextSetShadowWithColor(context, shadowSize, 6.0, shadowClrs);
	
	CGContextDrawImage(context, imgRect, imgNumber);
	
	CGImageRelease(imgNumber);
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
	
	CGContextRestoreGState(context);
}	

@end

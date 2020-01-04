//
//  ListCellData.m
//  testscollview
//
//  Created by Zhaohui Xing on 10-12-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ListCellData.h"


@implementation ListCellDataInt

@synthesize		m_nData;

-(enLISTCELLDATATYPE)GetDataType
{
	return enLISTCELLDATA_INT;
}

-(void)Destroy
{
	[self release];
}	

-(int)GetData
{
	return m_nData;
}	

@end


@implementation ListCellDataFloat

@synthesize		m_fData;

-(enLISTCELLDATATYPE)GetDataType
{
	return enLISTCELLDATA_FLOAT;
}

-(void)Destroy
{
	[self release];
}

-(float)GetData
{
	return m_fData;
}	

@end


@implementation ListCellDataString

@synthesize		m_sData;

-(enLISTCELLDATATYPE)GetDataType
{
	return enLISTCELLDATA_STRING;
}

-(void)Destroy
{
	[self release];
}

-(NSString*)GetData
{
	return m_sData;
}	

- (void)dealloc 
{
	if(m_sData != nil)
		[m_sData release];
    [super dealloc];
}

@end

@implementation ListCellDataObject

@synthesize		m_objData;

-(enLISTCELLDATATYPE)GetDataType
{
	return enLISTCELLTYPE_OBJECT;
}

-(void)Destroy
{
	[self release];
}

-(id)GetData
{
	return m_objData;
}	

- (void)dealloc 
{
	if(m_objData != nil)
		[m_objData release];
    [super dealloc];
}

@end



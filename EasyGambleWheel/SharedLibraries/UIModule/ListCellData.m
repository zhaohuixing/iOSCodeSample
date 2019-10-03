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
}

-(NSString*)GetData
{
	return m_sData;
}	

- (void)dealloc 
{
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
}

-(id)GetData
{
	return m_objData;
}	

- (void)dealloc 
{
}

@end



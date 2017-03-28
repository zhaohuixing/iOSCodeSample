//
//  XZBaseSurvey.m
//
//	Copyright (c) 2014, 2015 Sage Bionetworks
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without
//	modification, are permitted provided that the following conditions are met:
//	    * Redistributions of source code must retain the above copyright
//	      notice, this list of conditions and the following disclaimer.
//	    * Redistributions in binary form must reproduce the above copyright
//	      notice, this list of conditions and the following disclaimer in the
//	      documentation and/or other materials provided with the distribution.
//	    * Neither the name of Sage Bionetworks nor the names of BridgeSDk's
//		  contributors may be used to endorse or promote products derived from
//		  this software without specific prior written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBBSurvey.h instead.
//

#import "XZBaseSurvey.h"
#import "NSDate+XZCareBase.h"
#import "XZBaseSurveyElement.h"
#import "XZBaseSurveyQuestion.h"
#import "XZBaseClassFactory.h"

@implementation XZBaseSurvey

- (id)init
{
	if((self = [super init]))
	{
	}

	return self;
}

#pragma mark Scalar values

- (BOOL)publishedValue
{
	return [self.published boolValue];
}

- (void)setPublishedValue:(BOOL)value_
{
	self.published = [NSNumber numberWithBool:value_];
}

- (double)versionValue
{
	return [self.version doubleValue];
}

- (void)setVersionValue:(double)value_
{
	self.version = [NSNumber numberWithDouble:value_];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{

        self.createdOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"createdOn"]];
        //self.elements = [dictionary objectForKey:@"elements"];
        
        NSArray* elmArrays = [dictionary objectForKey:@"elements"];
        if(elmArrays == nil || elmArrays.count <= 0)
        {
            self.elements = elmArrays;
        }
        else
        {
            NSMutableArray* tempArray = [[NSMutableArray alloc] init];
            //for(id element in elmArrays)
            [elmArrays enumerateObjectsUsingBlock:^(id element, NSUInteger __unused idx, BOOL * __unused stop)
             {
                if(element != nil && [element isKindOfClass:[NSDictionary class]] == YES)
                {
                    XZBaseSurveyElement* pElement = [[XZBaseSurveyElement alloc] initWithDictionaryRepresentation:(NSDictionary *)element];
                    [tempArray addObject:pElement];
                }
             }];
            self.elements = [NSArray arrayWithArray:tempArray];
        }
        
        self.guid = [dictionary objectForKey:@"guid"];
        self.identifier = [dictionary objectForKey:@"identifier"];
        self.modifiedOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"modifiedOn"]];
        self.name = [dictionary objectForKey:@"name"];
        self.published = [dictionary objectForKey:@"published"];
        self.version = [dictionary objectForKey:@"version"];
        
        //self.questions = [dictionary objectForKey:@"questions"];
        NSArray* questArrays = [dictionary objectForKey:@"questions"];
        if(questArrays == nil || questArrays.count <= 0)
        {
            self.questions = nil;
        }
        else
        {
            NSMutableArray* tempArray = [[NSMutableArray alloc] init];
            [questArrays enumerateObjectsUsingBlock:^(id question, NSUInteger __unused idx, BOOL * __unused stop)
             {
                 if(question != nil && [question isKindOfClass:[NSDictionary class]] == YES)
                 {
                     XZBaseSurveyElement* pQuestion = [[XZBaseSurveyQuestion alloc] initWithDictionaryRepresentation:(NSDictionary *)question];
                     [tempArray addObject:pQuestion];
                 }
             }];
            self.questions = [NSArray arrayWithArray:tempArray];
        }
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.createdOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"createdOn"]];
    
    //self.elements = [dictionary objectForKey:@"elements"];
    NSArray* elmArrays = [dictionary objectForKey:@"elements"];
    if(elmArrays == nil || elmArrays.count <= 0)
    {
        self.elements = elmArrays;
    }
    else
    {
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        //for(id element in elmArrays)
        [elmArrays enumerateObjectsUsingBlock:^(id element, NSUInteger __unused idx, BOOL * __unused stop)
         {
             if(element != nil && [element isKindOfClass:[NSDictionary class]] == YES)
             {
                 XZBaseSurveyElement* pElement = [[XZBaseSurveyElement alloc] initWithDictionaryRepresentation:(NSDictionary *)element];
                 [tempArray addObject:pElement];
             }
         }];
        self.elements = [NSArray arrayWithArray:tempArray];
    }
    
    self.guid = [dictionary objectForKey:@"guid"];
    self.identifier = [dictionary objectForKey:@"identifier"];
    self.modifiedOn = [NSDate dateWithISO8601String:[dictionary objectForKey:@"modifiedOn"]];
    self.name = [dictionary objectForKey:@"name"];
    self.published = [dictionary objectForKey:@"published"];
    self.version = [dictionary objectForKey:@"version"];
    
    //self.questions = [dictionary objectForKey:@"questions"];
    NSArray* questArrays = [dictionary objectForKey:@"questions"];
    if(questArrays == nil || questArrays.count <= 0)
    {
        self.questions = nil;
    }
    else
    {
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        [questArrays enumerateObjectsUsingBlock:^(id question, NSUInteger __unused idx, BOOL * __unused stop)
         {
             if(question != nil && [question isKindOfClass:[NSDictionary class]] == YES)
             {
                 XZBaseSurveyQuestion* pQuestion = [[XZBaseSurveyQuestion alloc] initWithDictionaryRepresentation:(NSDictionary *)question];
                 [tempArray addObject:pQuestion];
             }
         }];
        self.questions = [NSArray arrayWithArray:tempArray];
    }
}

-(NSArray*)convertElementListToDictionaryList
{
    NSMutableArray* elemArray = nil;
    
    if(self.elements != nil && 0 < self.elements.count)
    {
        elemArray = [[NSMutableArray alloc] init];
        for(XZBaseSurveyElement* pElement in self.elements)
        {
            if(pElement != nil)
            {
                NSDictionary* pRepersentation = [pElement dictionaryRepresentation];
                [elemArray addObject:pRepersentation];
            }
        }
    }
    
    return elemArray;
}

-(NSArray*)convertQuestionListToDictionaryList
{
    NSMutableArray* elemArray = nil;
    
    if(self.questions != nil && 0 < self.questions.count)
    {
        elemArray = [[NSMutableArray alloc] init];
        for(XZBaseSurveyQuestion* pQuestion in self.questions)
        {
            if(pQuestion != nil)
            {
                NSDictionary* pRepersentation = [pQuestion dictionaryRepresentation];
                [elemArray addObject:pRepersentation];
            }
        }
    }
    
    return elemArray;
}


- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:[self.createdOn ISO8601String] forKey:@"createdOn"];
    
    //[dict setObjectIfNotNil:self.elements forKey:@"elements"];
    NSArray* pElements = [self convertElementListToDictionaryList];
    if(pElements != nil && 0 < pElements.count)
        [dict setObjectIfNotNil:pElements forKey:@"elements"];
    
    [dict setObjectIfNotNil:self.guid forKey:@"guid"];
    [dict setObjectIfNotNil:self.identifier forKey:@"identifier"];
    [dict setObjectIfNotNil:[self.modifiedOn ISO8601String] forKey:@"modifiedOn"];
    [dict setObjectIfNotNil:self.name forKey:@"name"];
    [dict setObjectIfNotNil:self.published forKey:@"published"];
    [dict setObjectIfNotNil:self.version forKey:@"version"];

    //[dict setObjectIfNotNil:self.questions forKey:@"questions"];
    NSArray* pQuestions = [self convertQuestionListToDictionaryList];
    if(pQuestions != nil && 0 < pQuestions.count)
        [dict setObjectIfNotNil:pQuestions forKey:@"questions"];
    
	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.

	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Direct access

#ifdef DEBUG
#pragma log debug information

- (void)DebugLog
{
    [super DebugLog];
    NSLog(@"XZBaseSurvey DebugLog createdOn:%@\n", [self.createdOn ISO8601String]);
   // NSLog(@"XZBaseSurvey elements:%@\n", [self.elements description]);
    NSLog(@"XZBaseSurvey DebugLog guid:%@\n", self.guid);
    NSLog(@"XZBaseSurvey DebugLog identifier:%@\n", self.identifier);
    NSLog(@"XZBaseSurvey DebugLog modifiedOn:%@\n", [self.modifiedOn ISO8601String]);
    NSLog(@"XZBaseSurvey DebugLog name:%@\n", self.name);
    NSLog(@"XZBaseSurvey DebugLog published:%@\n", [self.published description]);
    NSLog(@"XZBaseSurvey DebugLog version:%@\n", [self.version description]);
    //NSLog(@"XZBaseSurvey questions:%@\n", [self.questions description]);

    NSLog(@"XZBaseSurvey DebugLog questions *************begin*************\n");
    if(self.questions == nil || self.questions.count <= 0)
    {
        NSLog(@"XZBaseSurvey DebugLog does not have question\n");
    }
    else
    {
        for(XZBaseSurveyQuestion* question in self.questions)
        {
            if(question != nil)
            {
                [question DebugLog];
            }
        }
    }
    NSLog(@"XZBaseSurvey DebugLog questions **************end**************\n");

    NSLog(@"XZBaseSurvey DebugLog elements *************begin*************\n");
    if(self.elements == nil || self.elements.count <= 0)
    {
        NSLog(@"XZBaseSurvey DebugLog does not have elements\n");
    }
    else
    {
        for(XZBaseSurveyElement* element in self.elements)
        {
            if(element != nil)
            {
                [element DebugLog];
            }
        }
    }
    NSLog(@"XZBaseSurvey DebugLog elements **************end**************\n");
    
}

#endif


@end

//
//  SBBSurveyConstraints.m
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
// Make changes to SBBSurveyConstraints.h instead.
//

#import "XZBaseSurveyConstraints.h"
#import "XZBaseSurveyRule.h"
#import "XZBaseClassFactory.h"

@implementation XZBaseSurveyConstraints

- (id)init
{
	if((self = [super init]))
	{
	}

	return self;
}

#pragma mark Scalar values

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super initWithDictionaryRepresentation:dictionary]))
	{
        self.dataType = [dictionary objectForKey:@"dataType"];
        //self.rules = [dictionary objectForKey:@"rules"];
        NSArray* ruleRepresentations = [dictionary objectForKey:@"rules"];
        if(ruleRepresentations == nil || ruleRepresentations.count <= 0)
        {
#ifdef DEBUG
            NSLog(@"XZBaseSurveyConstraints initWithDictionaryRepresentation: The rule representation list does not have any data!\n");
#endif
        }
        else
        {
            NSMutableArray* tempRuleList = [[NSMutableArray alloc] init];
            for(NSDictionary* ruleRep in ruleRepresentations)
            {
                if(ruleRep)
                {
                    XZBaseSurveyRule* pRule = (XZBaseSurveyRule*)[XZBaseClassFactory  CreateSimpleBaseClassFromRepresentation:ruleRep];
                    if(pRule)
                    {
                        [tempRuleList addObject:pRule];
                    }
                    else
                    {
#ifdef DEBUG
                        NSLog(@"XZBaseSurveyConstraints initWithDictionaryRepresentation: failed to create rule object from representation data!\n");
#endif
                    }
                }
                else
                {
#ifdef DEBUG
                    NSLog(@"XZBaseSurveyConstraints initWithDictionaryRepresentation: rule representation object invalid!\n");
#endif
                }
            }
            if(tempRuleList.count <= 0)
            {
#ifdef DEBUG
                NSLog(@"XZBaseSurveyConstraints initWithDictionaryRepresentation: failed to load rule list from representation data list!\n");
#endif
            }
            else
            {
                self.rules = [NSArray arrayWithArray:tempRuleList];
            }
        }
	}

	return self;
}

- (void)initializeFromDictionaryRepresentation:(NSDictionary *)dictionary
{
    [super initializeFromDictionaryRepresentation:dictionary];
    self.dataType = [dictionary objectForKey:@"dataType"];
    //self.rules = [dictionary objectForKey:@"rules"];
    NSArray* ruleRepresentations = [dictionary objectForKey:@"rules"];
    if(ruleRepresentations == nil || ruleRepresentations.count <= 0)
    {
#ifdef DEBUG
        NSLog(@"XZBaseSurveyConstraints initializeFromDictionaryRepresentation: The rule representation list does not have any data!\n");
#endif
    }
    else
    {
        NSMutableArray* tempRuleList = [[NSMutableArray alloc] init];
        for(NSDictionary* ruleRep in ruleRepresentations)
        {
            if(ruleRep)
            {
                XZBaseSurveyRule* pRule = (XZBaseSurveyRule*)[XZBaseClassFactory  CreateSimpleBaseClassFromRepresentation:ruleRep];
                if(pRule)
                {
                    [tempRuleList addObject:pRule];
                }
                else
                {
#ifdef DEBUG
                    NSLog(@"XZBaseSurveyConstraints initializeFromDictionaryRepresentation: failed to create rule object from representation data!\n");
#endif
                }
            }
            else
            {
#ifdef DEBUG
                NSLog(@"XZBaseSurveyConstraints initializeFromDictionaryRepresentation: rule representation object invalid!\n");
#endif
            }
        }
        if(tempRuleList.count <= 0)
        {
#ifdef DEBUG
            NSLog(@"XZBaseSurveyConstraints initializeFromDictionaryRepresentation: failed to load rule list from representation data list!\n");
#endif
        }
        else
        {
            self.rules = [NSArray arrayWithArray:tempRuleList];
        }
    }
}

- (NSDictionary *)dictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.dataType forKey:@"dataType"];
    //[dict setObjectIfNotNil:self.rules forKey:@"rules"];
    if(self.rules != nil && 0 < self.rules.count)
    {
        NSMutableArray* tempRuleList = [[NSMutableArray alloc] init];
        for(XZBaseSurveyRule* pRule in self.rules)
        {
            if(pRule != nil)
            {
                NSDictionary* pRepresentation = [pRule dictionaryRepresentation];
                [tempRuleList addObject:pRepresentation];
            }
        }
        if(0 < tempRuleList.count)
        {
            [dict setObjectIfNotNil:tempRuleList forKey:@"rules"];
        }
    }

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
-(void)DebugLog
{
    [super DebugLog];
    NSLog(@"XZBaseSurveyConstraints DebugLog dataType:%@\n", self.dataType);
    NSLog(@"XZBaseSurveyConstraints DebugLog rules *************begin*************\n");
    if(self.rules == nil || self.rules.count <= 0)
    {
        NSLog(@"XZBaseSurveyConstraints DebugLog rules is null or no object\n");
    }
    else
    {
        for(XZBaseSurveyRule* rule in self.rules)
        {
            if(rule != nil)
            {
                [rule DebugLog];
            }
        }
    }
    NSLog(@"XZBaseSurveyConstraints DebugLog rules **************end**************\n");
}

#endif
@end

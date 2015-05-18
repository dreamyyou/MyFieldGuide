//
//  FGMainNode.h
//  FGNodeParser
//
//  Created by Dreamy on 15/5/13.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGNodeAttribute.h"
#import "FGNodeDescription.h"

@interface FGMainNode : NSObject

@property NSString * name;

@property NSMutableArray * attributes;

@property FGNodeDescription *nodeDescription;

@property NSMutableArray *sons;

@property NSMutableArray *owns;

-(instancetype)initWithName:(NSString *)name;

-(void)addSon:(NSString *) sonName;

-(void)addOwn:(NSString *) ownName;

-(void)addAttribute:(FGNodeAttribute *)attribute;

-(NSAttributedString *) toAttributedStringWithNodeDirectory:(NSString *) path;

@end

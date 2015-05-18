//
//  FGNode.h
//  FGNodeParser
//
//  Created by Dreamy on 15/5/13.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGNodeAttribute.h"
#import "FGNodeDescription.h"


@interface FGNode : NSObject

@property NSString * name;

@property NSString * father;

@property NSMutableArray * attributes;

@property FGNodeDescription *nodeDescription;

@property NSMutableArray *sons;

@property NSMutableArray *tags;

-(instancetype)initWithName:(NSString *)name;

-(void)addSon:(NSString *) sonName;

-(void)addAttribute:(FGNodeAttribute *)attribute;

-(void)addTag:(NSString *)tag;

-(NSAttributedString *) toAttributedStringWithNodeDirectory:(NSString *) path;

-(BOOL) isLeafNode;

@end

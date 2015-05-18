//
//  FGNode.m
//  FGNodeParser
//
//  Created by Dreamy on 15/5/13.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import "FGNode.h"

@implementation FGNode

-(NSString *)description
{
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendFormat:@"{\nThis is a node names %@:\n", self.name];
    [result appendFormat:@"\nThe father is %@\n", self.father];
    
    int count = 0;
    for (id items in self.attributes)
    {
        count++;
        [result appendFormat:@"the %d-th attribute is:\n%@\n", count, items];
    }
    
    [result appendFormat:@"\nthe Description is:\n%@\n", self.nodeDescription];
    [result appendFormat:@"\nThe sons are:\n"];
    
    for (id item in self.sons)
    {
        [result appendFormat:@"%@\n", item];
    }
    
    [result appendFormat:@"\nThe tags are:\n"];
    
    for (id item in self.tags)
    {
        [result appendFormat:@"%@\n", item];
    }
    
    return [[NSString alloc] initWithString:result];
}

-(instancetype) initWithName:(NSString *)name
{
    self = [super init];
    if (self != nil)
    {
        self.name = [[NSString alloc] initWithString: name];
    }
    return self;
}

-(void)addSon:(NSString *) sonName
{
    if (self.sons == nil)
    {
        self.sons = [[NSMutableArray alloc] init];
    }
    [self.sons addObject:sonName];
}

-(void)addAttribute:(FGNodeAttribute *)attribute
{
    if (self.attributes == nil)
    {
        self.attributes = [[NSMutableArray alloc] init];
    }
    [self.attributes addObject:attribute];
}

-(void)addTag:(NSString *)tag
{
    if (self.tags == nil)
    {
        self.tags = [[NSMutableArray alloc] init];
    }
    [self.tags addObject:tag];
}

-(BOOL) isLeafNode
{
    return (self.sons == nil);
}

-(NSAttributedString *) toAttributedStringWithNodeDirectory:(NSString *) path
{
    UIFontDescriptor *headLineFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    UIFontDescriptor *subheadlineFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline];
    UIFontDescriptor *bodyFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    
    NSDictionary *headLineAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithDescriptor:headLineFontDescriptor size:0] forKey:NSFontAttributeName];
    NSDictionary *subheadLineAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithDescriptor:subheadlineFontDescriptor size:0] forKey:NSFontAttributeName];
    NSDictionary *bodyFontAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithDescriptor:bodyFontDescriptor size:0] forKey:NSFontAttributeName];
    
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:[@"name: " stringByAppendingFormat:@"%@\n\n", self.name] attributes:headLineAttributes]];
    
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:[@"father: " stringByAppendingFormat:@"%@\n\n", self.father] attributes:subheadLineAttributes]];
    
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Properties:\n" attributes:bodyFontAttributes]];
    
    for (FGNodeAttribute *item in self.attributes)
    {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:[item.key stringByAppendingFormat:@": %@\n", item.value] attributes:bodyFontAttributes]];
    }
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:bodyFontAttributes]];

    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Descriptions:\n" attributes:headLineAttributes]];
    
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:bodyFontAttributes]];

    [result appendAttributedString: [self.nodeDescription toAttributedStringWithNodeDirectory:path]];
    
    [result appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n\n" attributes:bodyFontAttributes]];
    
    if (self.sons != nil && [self.sons count] > 0)
    {
        [result appendAttributedString: [[NSAttributedString alloc] initWithString:@"SONS:\n" attributes:headLineAttributes]];
        for (NSString *item in self.sons)
        {
            [result appendAttributedString: [[NSAttributedString alloc] initWithString:[item stringByAppendingString:@"\n"] attributes:bodyFontAttributes]];
        }
    }
    
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n" attributes:bodyFontAttributes]];

    if (self.tags != nil && [self.tags count] > 0)
    {
        [result appendAttributedString: [[NSAttributedString alloc] initWithString:@"TAGS:\n" attributes:headLineAttributes]];
        for (NSString *item in self.tags)
        {
            [result appendAttributedString: [[NSAttributedString alloc] initWithString:[item stringByAppendingString:@"\n"] attributes:bodyFontAttributes]];
        }
    }
             
    return result;
}
@end

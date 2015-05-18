//
//  FGNodeParser.m
//  FGNodeParser
//
//  Created by Dreamy on 15/5/13.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import "FGNodeParser.h"

@interface FGNodeParser()

@property FGNodeAttribute *currentAttribute;
@property FGNodeDescription *currentDescription;
@property NSSet *tagSet;
@property NSSet *writableTagSet;
@property NSMutableArray *nodeStack;
@property NSMutableString *currentContent;
@property BOOL storingCharacters;

@end

@implementation FGNodeParser


static NSString *kName_root = @"root";
static NSString *kName_Name = @"name";
static NSString *kName_Father = @"father";
static NSString *kName_Attribute = @"property";
static NSString *kName_Attribute_Key = @"key";
static NSString *kName_Attribute_Value = @"value";
static NSString *kName_Description = @"description";
static NSString *kName_Description_title = @"title";
static NSString *kName_Description_paragraph = @"paragraph";
static NSString *kName_Description_image = @"img";
static NSString *kName_Son = @"son";
static NSString *kName_Tag = @"tag";

-(FGNode *) performParseWithData:(NSData *) data
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    self.result = [[FGNode alloc] init];
    self.nodeStack = [[NSMutableArray alloc] init];
    self.tagSet = [NSSet setWithObjects:kName_root, kName_Name, kName_Father,
                   kName_Attribute, kName_Attribute_Key, kName_Attribute_Value,
                   kName_Description, kName_Description_title, kName_Description_paragraph,
                   kName_Description_image,
                   kName_Son, kName_Tag, nil];
    self.writableTagSet = [NSSet setWithObjects:kName_Name, kName_Father, kName_Attribute_Key, kName_Attribute_Value,
                           kName_Description_title, kName_Description_paragraph, kName_Description_image,
                           kName_Son, kName_Tag, nil];
    self.storingCharacters = NO;
    
    [parser setDelegate: self];
    [parser parse];
    //NSLog(@"XML parsing finished!");
    
    return self.result;
}



-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if ([self.tagSet containsObject:elementName])
    {
        [self.nodeStack addObject:[elementName copy]];
        
        if ([elementName isEqualToString:kName_Attribute])
        {
            self.currentAttribute = [[FGNodeAttribute alloc] init];
        }
        else if ([elementName isEqualToString:kName_Description])
        {
            self.currentDescription = [[FGNodeDescription alloc] init];
        }
        else if ([self.writableTagSet containsObject:elementName])
        {
            self.storingCharacters = YES;
            self.currentContent = [[NSMutableString alloc] initWithString:@""];
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([self.tagSet containsObject:elementName])
    {
        if ([self.writableTagSet containsObject:elementName])
        {
            
            if ([elementName isEqualToString:kName_Name])
            {
                self.result.name = [[NSString alloc] initWithString:self.currentContent];
            }
            else if ([elementName isEqualToString:kName_Father])
            {
                self.result.father = [[NSString alloc] initWithString:self.currentContent];
            }
            else if ([elementName isEqualToString: kName_Attribute_Key])
            {
                self.currentAttribute.key = [[NSString alloc] initWithString:self.currentContent];
            }
            else if ([elementName isEqualToString: kName_Attribute_Value])
            {
            [self.currentAttribute setStringValue:self.currentContent];
            }
            else if ([elementName isEqualToString:kName_Description_title])
            {
                [self.currentDescription addTitle:self.currentContent];
            }
            else if ([elementName isEqualToString:kName_Description_paragraph])
            {
                [self.currentDescription addParagraph:self.currentContent];
            }
            else if ([elementName isEqualToString:kName_Description_image])
            {
                [self.currentDescription addImageWithPath:self.currentContent];
            }
            else if ([elementName isEqualToString:kName_Son])
            {
                [self.result addSon:self.currentContent];
            }
            else if ([elementName isEqualToString:kName_Tag])
            {
                [self.result addTag:self.currentContent];
            }
            self.currentContent = nil;
            self.storingCharacters = NO;
        }
        else if ([elementName isEqualToString:kName_Attribute])
        {
            [self.result addAttribute:self.currentAttribute];
            self.currentAttribute = nil;
        }
        else if ([elementName isEqualToString:kName_Description])
        {
            self.result.nodeDescription = self.currentDescription;
            self.currentDescription = nil;
        }
        [self.nodeStack removeLastObject];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.storingCharacters)
    {
        [self.currentContent appendString:string];
    }
}




@end

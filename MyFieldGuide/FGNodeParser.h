//
//  FGNodeParser.h
//  FGNodeParser
//
//  Created by Dreamy on 15/5/13.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGNode.h"

@interface FGNodeParser : NSObject<NSXMLParserDelegate>

@property FGNode *result;

-(FGNode *) performParseWithData:(NSData *) data;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;


@end

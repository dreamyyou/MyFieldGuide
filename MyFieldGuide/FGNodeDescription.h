//
//  FGNodeDescription.h
//  FGNodeParser
//
//  Created by Dreamy on 15/5/13.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma FGDescriptionPartType

typedef NS_ENUM(NSInteger, FGDescriptionPartType)
{
    FGDescriptionTitle=0,
    FGDescriptionParagraph=1,
    FGDescriptionImage=2,
    FGDescriptionFile=3,
    FGDescriptionURL=4,
};

#pragma FGDescriptionPart

@interface FGDescriptionPart : NSObject

@property FGDescriptionPartType type;

@property NSObject * content;

-(instancetype) initWithTitle:(NSString*)title;

-(instancetype) initWithParagraph:(NSString*)paragraph;

-(instancetype) initWithImagePath:(NSString*)path;

-(BOOL) isTitle;

-(BOOL) isParagraph;

-(BOOL) isImage;

@end

#pragma FGNodeDescription

@interface FGNodeDescription : NSObject

@property NSMutableArray *parts;

-(void) addTitle:(NSString *)title;

-(void) addParagraph:(NSString *)paragraph;

-(void) addImageWithPath:(NSString *)path;

-(NSAttributedString *) toAttributedStringWithNodeDirectory:(NSString *) path;

@end

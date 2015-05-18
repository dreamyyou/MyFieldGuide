//
//  FGNodeDescription.m
//  FGNodeParser
//
//  Created by Dreamy on 15/5/13.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import "FGNodeDescription.h"

@implementation FGDescriptionPart

-(NSString *) description
{
    NSArray *PartTypeName = [[NSArray alloc] initWithObjects:@"Title",
                             @"Paragraph", @"Image", @"File", @"URL", nil];
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSInteger index = (NSInteger)self.type;
    [result appendFormat:@"\n%@:\n\t%@\n", PartTypeName[index], self.content];
    
    return [[NSString alloc] initWithString:result];
}

-(instancetype) initWithTitle:(NSString*)title
{
    self = [super init];
    if (self != nil)
    {
        self.type = FGDescriptionTitle;
        self.content = [[NSString alloc] initWithString:title];
    }
    return self;
}

-(instancetype) initWithParagraph:(NSString*)paragraph
{
    self = [super init];
    if (self != nil)
    {
        self.type = FGDescriptionParagraph;
        self.content = [[NSString alloc] initWithString:paragraph];
    }
    return self;
}

-(instancetype) initWithImagePath:(NSString*)path
{
    self = [super init];
    if (self != nil)
    {
        self.type = FGDescriptionImage;
        self.content = [[NSString alloc] initWithString:path];
    }
    return self;
}

-(BOOL) isTitle
{
    return (self.type == FGDescriptionTitle);
}

-(BOOL) isParagraph
{
    return (self.type == FGDescriptionParagraph);
}

-(BOOL) isImage
{
    return (self.type == FGDescriptionImage);
}
@end


@implementation FGNodeDescription

-(NSString *)description
{
    NSMutableString *result = [[NSMutableString alloc] init];
    
    [result setString:@"\nThe description is :\n"];
    
    int count = 0;
    for (id item in self.parts)
    {
        count++;
        [result appendFormat:@"The %d-th Part is:\n%@\n", count, item];
    }
    [result appendFormat:@"\n"];
    
    return [[NSString alloc] initWithString:result];
}

-(instancetype) init
{
    self = [super init];
    if (self != nil)
    {
        self.parts = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addTitle:(NSString *)title
{
    if (self.parts == nil)
    {
        self.parts = [[NSMutableArray alloc] init];
    }
    [self.parts addObject:[[FGDescriptionPart alloc] initWithTitle:title]];
}

-(void) addParagraph:(NSString *)paragraph
{
    if (self.parts == nil)
    {
        self.parts = [[NSMutableArray alloc] init];
    }
    [self.parts addObject:[[FGDescriptionPart alloc] initWithParagraph:paragraph]];
}

-(void) addImageWithPath:(NSString *)path
{
    if (self.parts == nil)
    {
        self.parts = [[NSMutableArray alloc] init];
    }
    [self.parts addObject:[[FGDescriptionPart alloc] initWithImagePath:path]];
}

-(NSAttributedString *) toAttributedStringWithNodeDirectory:(NSString *) path
{
    UIFontDescriptor *headLineFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    //UIFontDescriptor *subheadlineFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline];
    UIFontDescriptor *bodyFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    
    NSDictionary *headLineAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithDescriptor:headLineFontDescriptor size:0] forKey:NSFontAttributeName];
    //NSDictionary *subheadLineAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithDescriptor:subheadlineFontDescriptor size:0] forKey:NSFontAttributeName];
    NSDictionary *bodyFontAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithDescriptor:bodyFontDescriptor size:0] forKey:NSFontAttributeName];
    

    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    for (FGDescriptionPart *item in self.parts)
    {
        
        if ([item isTitle])
        {
            NSString *content = [[NSString alloc] initWithFormat:@"\n%@\n\n", item.content];
            [result appendAttributedString: [[NSAttributedString alloc] initWithString:content attributes:headLineAttributes]];
        }
        
        else if ([item isParagraph])
        {
            NSString *content = [[NSString alloc] initWithFormat:@"%@", item.content];
            [result appendAttributedString: [[NSAttributedString alloc] initWithString:content attributes:bodyFontAttributes]];
        }
        else if ([item isImage])
        {
            //NSLog(@"There is a image");
            if ([item.content isKindOfClass: [NSString class]])
            {
                NSString *imagePath = [path stringByAppendingPathComponent: (NSString *)item.content];
                //NSLog(@"%@\n", imagePath);
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                textAttachment.image = image;
                textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
                NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
                [result appendAttributedString:textAttachmentString];
            }
        }
    }
    return [[NSAttributedString alloc] initWithAttributedString:result];
}

@end

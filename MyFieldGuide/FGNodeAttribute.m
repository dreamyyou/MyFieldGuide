//
//  FGNodeAttribute.m
//  FGNodeParser
//
//  Created by Dreamy on 15/5/13.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import "FGNodeAttribute.h"

@implementation FGNodeAttribute

- (NSString *) description
{
    return [@"{\nThe Attribute is:\n" stringByAppendingFormat:@"key:\n\t%@\nvalue:\n\t%@\n}", self.key, self.value];
}

- (instancetype)initWithKey:(NSString *)key StringValue:(NSString *)value
{
    self = [super init];
    if (self != nil)
    {
        self.key = [[NSString alloc] initWithString: key];
        self.type = FGAttributeTypeString;
        self.value = [[NSString alloc] initWithString: value];
    }
    return self;
}

- (void)setStringValue:(NSString *)value
{
    self.type = FGAttributeTypeString;
    self.value = [[NSString alloc] initWithString:value];
}

- (NSString *)toNSString
{
    return self.value;
}

- (BOOL)isStringType
{
    return YES;
}

- (BOOL)isImageType
{
    return NO;
}

- (BOOL)isFileType
{
    return NO;
}

- (BOOL)isValueType
{
    return YES;
}


@end

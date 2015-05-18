//
//  FGNodeAttribute.h
//  FGNodeParser
//
//  Created by Dreamy on 15/5/13.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FGNodeAttributeType)
{
    FGAttributeTypeString = 0
};

@interface FGNodeAttribute : NSObject

@property NSString * key;
@property FGNodeAttributeType type;
@property NSString * value;

-(NSString *)toNSString;

-(instancetype) initWithKey:(NSString *)key StringValue:(NSString *)value;

-(void) setStringValue:(NSString *)value;

-(BOOL)isStringType;

-(BOOL)isImageType;

-(BOOL)isFileType;

-(BOOL)isValueType; //If the type is a value, then toNSString method returns a un-nil value



@end

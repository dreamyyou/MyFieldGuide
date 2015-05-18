//
//  FGTextViewController.h
//  MyFieldGuide_V0.1
//
//  Created by Dreamy on 15/5/15.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGNodeParser.h"

@interface FGTextViewController : UIViewController<UITextViewDelegate>

@property NSString * nodePath;
@property NSString * dataBasePath;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

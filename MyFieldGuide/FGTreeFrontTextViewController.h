//
//  FGTreeFrontTextViewController.h
//  MyFieldGuide
//
//  Created by Dreamy on 15/5/18.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGNode.h"

@interface FGTreeFrontTextViewController : UIViewController

@property FGNode * node;
@property NSString * nodeDirPath;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

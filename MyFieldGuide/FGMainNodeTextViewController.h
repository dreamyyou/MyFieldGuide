//
//  FGMainNodeTextViewController.h
//  MyFieldGuide_V0.1
//
//  Created by Dreamy on 15/5/15.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGMainNode.h"

@interface FGMainNodeTextViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *mainNodeTextView;

@property FGMainNode *mainNode;

@property NSString *dataBasePath;

@property NSString *mainNodeDirPath;

@end

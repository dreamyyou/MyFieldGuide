//
//  FGTreeBackTableViewController.h
//  MyFieldGuide
//
//  Created by Dreamy on 15/5/18.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGNode.h"
#import "FGNodeParser.h"
#import "FGTreeFrontTextViewController.h"


@interface FGTreeBackTableViewController : UITableViewController

@property FGNode *node;
@property NSString *dataBasePath;
@property NSString *nodePath;

@end

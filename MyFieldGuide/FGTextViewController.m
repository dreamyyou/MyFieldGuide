//
//  FGTextViewController.m
//  MyFieldGuide_V0.1
//
//  Created by Dreamy on 15/5/15.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import "FGTextViewController.h"

@interface FGTextViewController ()

@property NSString * nodeDirPath;

@property NSString * nodeFilePath;

@property FGNode *nodeContent;

@end

@implementation FGTextViewController

@synthesize nodePath;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureTextView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureTextView{
    
    UIFontDescriptor *bodyFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    self.textView.font = [UIFont fontWithDescriptor:bodyFontDescriptor size:0];
    
    self.textView.textColor = [UIColor blackColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollEnabled = YES;
    self.textView.editable = NO;
    //NSLog(@"%@", self.nodePath);
    
    if (self.nodePath != nil && self.dataBasePath != nil)
    {
        self.nodeDirPath = [self.dataBasePath stringByAppendingPathComponent:self.nodePath];
        self.nodeFilePath = [[self.nodeDirPath stringByAppendingPathComponent:self.nodePath] stringByAppendingPathExtension:@"xml"];
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    NSData *nodeData = [[NSData alloc] initWithContentsOfFile:self.nodeFilePath];
    FGNodeParser *nodeParser = [[FGNodeParser alloc] init];
    [nodeParser performParseWithData:nodeData];
    self.nodeContent = nodeParser.result;
    if (self.nodeContent != nil)
    {
        [attributedText appendAttributedString:[self.nodeContent toAttributedStringWithNodeDirectory:self.nodeDirPath]];
    }
    
    self.textView.attributedText = attributedText;
    //NSLog(@"%@", [attributedText attributesAtIndex:0 effectiveRange:NULL]);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

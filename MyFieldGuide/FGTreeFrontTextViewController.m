//
//  FGTreeFrontTextViewController.m
//  MyFieldGuide
//
//  Created by Dreamy on 15/5/18.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import "FGTreeFrontTextViewController.h"

@interface FGTreeFrontTextViewController ()

@end

@implementation FGTreeFrontTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTextView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureTextView
{
    UIFontDescriptor *bodyFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    self.textView.font = [UIFont fontWithDescriptor:bodyFontDescriptor size:0];
    
    self.textView.textColor = [UIColor blackColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollEnabled = YES;
    self.textView.editable = NO;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    if (self.node != nil)
    {
        [attributedText appendAttributedString:[self.node toAttributedStringWithNodeDirectory:self.nodeDirPath]];
    }
    
    self.textView.attributedText = attributedText;
    
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

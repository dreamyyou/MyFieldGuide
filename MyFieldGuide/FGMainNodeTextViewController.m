//
//  FGMainNodeTextViewController.m
//  MyFieldGuide_V0.1
//
//  Created by Dreamy on 15/5/15.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import "FGMainNodeTextViewController.h"

@interface FGMainNodeTextViewController ()

@end

@implementation FGMainNodeTextViewController

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
    self.mainNodeTextView.font = [UIFont fontWithDescriptor:bodyFontDescriptor size:0];
    
    self.mainNodeTextView.textColor = [UIColor blackColor];
    self.mainNodeTextView.backgroundColor = [UIColor whiteColor];
    self.mainNodeTextView.scrollEnabled = YES;
    self.mainNodeTextView.editable = NO;
    //NSLog(@"%@", self.nodePath);
    

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    if (self.mainNode != nil)
    {
        [attributedText appendAttributedString:[self.mainNode toAttributedStringWithNodeDirectory:self.mainNodeDirPath]];
    }
    
    self.mainNodeTextView.attributedText = attributedText;
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

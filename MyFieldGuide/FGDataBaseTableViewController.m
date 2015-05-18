//
//  FGDataBaseTableViewController.m
//  MyFieldGuide
//
//  Created by Dreamy on 15/5/16.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import "FGDataBaseTableViewController.h"
#import "AppDelegate.h"

@interface FGDataBaseTableViewController ()

@property NSMutableArray *dataBasePathes;

@end

@implementation FGDataBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataBasePathes = [self searchDataBase];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.currentWorkingDataBasePath == nil)
    {
        appDelegate.currentWorkingDataBasePath = [[NSString alloc] initWithString:[self.dataBasePathes firstObject]];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataBasePathes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FGDataBaseTableCell" forIndexPath:indexPath];
    
    NSString *currentCellNamePath = [self.dataBasePathes objectAtIndex:indexPath.row];
    cell.textLabel.text = [currentCellNamePath lastPathComponent];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate.currentWorkingDataBasePath isEqualToString:currentCellNamePath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    
    // Configure the cell...
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *choosedDataBase = [self.dataBasePathes objectAtIndex: indexPath.row];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.currentWorkingDataBasePath = choosedDataBase;
    //NSLog(@"the %@ is Choosed!\n", choosedDataBase);
    [self.tableView reloadData];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma FileManager

-(NSMutableArray *) searchDataBase
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@", documentsPath);
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm changeCurrentDirectoryPath:documentsPath];
    NSError *error;
    NSArray *documentDir = [fm contentsOfDirectoryAtPath:documentsPath error:&error];
    
    if (error == nil)
    {
        for (NSString *item in documentDir)
        {
            if ([item hasPrefix:@"."])
            {
                continue;
            }
            BOOL flag;
            BOOL resu = [fm fileExistsAtPath:item isDirectory:&flag];
            if (resu && flag)
            {
                NSString *mainNodeFilePath = [[item stringByAppendingPathComponent:item] stringByAppendingPathExtension:@"xml"];
                BOOL resu = [fm fileExistsAtPath:mainNodeFilePath];
                resu = YES;
                if (resu)
                {
                    [result addObject:[documentsPath stringByAppendingPathComponent:item]];
                }
            }
            //[result addObject:item];
        }
    }
    return result;
}


@end

//
//  FGTreeFrontTableViewController.m
//  MyFieldGuide
//
//  Created by Dreamy on 15/5/18.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import "FGTreeFrontTableViewController.h"
#import "AppDelegate.h"

@interface FGTreeFrontTableViewController ()

@property FGMainNodeParser *mainNodeParser;
@property FGMainNode *mainNode;
@property NSString *dataBasePath;

@property NSArray *tableContents;
@property NSString *fieldGuideName;
@property NSString *mainNodeFilePath;
@property NSDictionary *tableContentsImages;


@end

@implementation FGTreeFrontTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataBasePath = self.getCurrentDataBase;
    NSLog(@"%@", self.dataBasePath);
    if (self.dataBasePath != nil)
    {
        self.fieldGuideName = [self.dataBasePath lastPathComponent];
        NSLog(@"%@", self.fieldGuideName);
        self.mainNodeFilePath = [[self.dataBasePath stringByAppendingPathComponent:self.fieldGuideName] stringByAppendingPathExtension:@"xml"];
        //NSLog(@"%@", self.mainNodeFilePath);
        NSData *data = [[ NSData alloc] initWithContentsOfFile:self.mainNodeFilePath];
        
        self.mainNodeParser = [[FGMainNodeParser alloc] init];
        [self.mainNodeParser performParseWithData: data];
        self.mainNode = self.mainNodeParser.result;
        self.tableContents = [self loadSonNode];
        self.tableContentsImages = [self findContentsIcons:self.tableContents];

        //self.tableContents = self.mainNode.sons;
    }
}
- (IBAction)refreshButtonTapped:(id)sender {
    [self viewDidLoad];
    [self.tableView reloadData];

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
    return [self.tableContents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"What's going on?");
    
    FGNode *node =[self.tableContents objectAtIndex:indexPath.row];
    
    NSLog(@"%@", node.name);
    
    UITableViewCell *cell;
    if ([node isLeafNode])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"leafNode" forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"structureNode" forIndexPath:indexPath];
    }
    
    cell.textLabel.text = [[NSString alloc] initWithString:node.name];
    
    
    NSString *picPath;
    if ((picPath = [self.tableContentsImages objectForKey:cell.textLabel.text]) == nil)
    {
        picPath = @"pacman";
    }
    //NSLog(@"%@",picPath);
    cell.imageView.image = [UIImage imageNamed:picPath];

    
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destination = [segue destinationViewController];
    //NSLog(@"%@", segue.identifier);

    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    FGNode *aimNode = [self.tableContents objectAtIndex:indexPath.row];
    NSString *nodePath = [self.dataBasePath stringByAppendingPathComponent:aimNode.name];

    //NSLog(@"Before wind segue: %@", object);
    if ([destination respondsToSelector:@selector(setNode:)])
    {
        [destination setValue:aimNode forKey:@"node"];
    }
    if ([destination respondsToSelector:@selector(setNodeDirPath:)])
    {
        [destination setValue:nodePath forKey:@"nodeDirPath"];
    }
    if ([destination respondsToSelector:@selector(setDataBasePath:)])
    {
        [destination setValue:[[NSString alloc] initWithString:self.dataBasePath] forKey:@"dataBasePath"];
    }
}




#pragma PathProcessing

-(NSString *) getCurrentDataBase
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.currentWorkingDataBasePath != nil)
    {
        return [[NSString alloc] initWithString:appDelegate.currentWorkingDataBasePath];
    }
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@", documentsPath);
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm changeCurrentDirectoryPath:documentsPath];
    NSError *error;
    NSArray *documentDir = [fm contentsOfDirectoryAtPath:documentsPath error:&error];
    if (error == nil)
    {
        for (id item in documentDir)
        {
            BOOL flag;
            BOOL resu = [fm fileExistsAtPath:item isDirectory:&flag];
            if (resu && flag)
            {
                return [documentsPath stringByAppendingPathComponent:item];
            }
        }
    }
    return @"";
}

#pragma loadData

-(NSArray *) loadSonNode
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSString *item in self.mainNode.sons)
    {
        NSString *dirPath = [self.dataBasePath stringByAppendingPathComponent:item];
        NSString *filePath = [[dirPath stringByAppendingPathComponent:item] stringByAppendingPathExtension:@"xml"];
        NSData *data = [[ NSData alloc] initWithContentsOfFile:filePath];
        FGNodeParser *nodeParser = [[FGNodeParser alloc] init];
        [nodeParser performParseWithData:data];
        [result addObject:nodeParser.result];
    }
    return result;
}

-(NSDictionary *)findContentsIcons:(NSArray *)contents
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    for (FGNode *iteNodes in contents)
    {
        NSString *item = iteNodes.name;
        NSString *dir = [[self.dataBasePath stringByAppendingPathComponent:item] stringByAppendingPathComponent:item];
        NSString *picPath1 = [dir stringByAppendingPathExtension:@"jpg"];
        NSString *picPath2 = [dir stringByAppendingPathExtension:@"png"];
        
        if ([fm fileExistsAtPath:picPath1])
        {
            [result setObject:picPath1 forKey:item];
        }
        else if ([fm fileExistsAtPath:picPath2])
        {
            [result setObject:picPath2 forKey:item];
        }
    }
    return result;
}

@end

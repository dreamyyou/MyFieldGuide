//
//  FGNodeTableViewController.m
//  MyFieldGuide_V0.1
//
//  Created by Dreamy on 15/5/15.
//  Copyright (c) 2015年 Dreamy. All rights reserved.
//

#import "FGNodeTableViewController.h"
#import "AppDelegate.h"
#import "FGChinese.h"

@interface FGNodeTableViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property FGMainNodeParser *mainNodeParser;
@property FGMainNode *mainNode;
@property NSString *dataBasePath;

@property NSArray *tableContents;
@property NSDictionary *tableContentsImages;
@property NSMutableDictionary *tableSectionsContents;
@property NSArray *tableSectionsTitles;

@property NSString *fieldGuideName;
@property NSString *mainNodeFilePath;

@property NSArray *filteredList;

@property (strong, nonatomic) UISearchController *searchController;



-(NSString *) getCurrentDataBase;

@end

@implementation FGNodeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataBasePath = self.getCurrentDataBase;
    //NSLog(@"%@", self.dataBasePath);
    if (self.dataBasePath != nil)
    {
        self.fieldGuideName = [self.dataBasePath lastPathComponent];
        //NSLog(@"%@", self.fieldGuideName);
        self.mainNodeFilePath = [[self.dataBasePath stringByAppendingPathComponent:self.fieldGuideName] stringByAppendingPathExtension:@"xml"];
        //NSLog(@"%@", self.mainNodeFilePath);
        NSData *data = [[ NSData alloc] initWithContentsOfFile:self.mainNodeFilePath];
        
        self.mainNodeParser = [[FGMainNodeParser alloc] init];
        [self.mainNodeParser performParseWithData: data];
        //NSLog(@"%@", self.mainNodeParser.result);
        self.mainNode = self.mainNodeParser.result;
        self.tableContents = [self.mainNode.owns sortedArrayUsingSelector:@selector(compare:)];
        self.tableSectionsContents = [self organizeContents:self.tableContents];
        self.tableSectionsTitles = [[self.tableSectionsContents allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        self.tableContentsImages = [self findContentsIcons:self.tableContents];
        
        /*
        for (NSString *item in self.tableContents)
        {
            for (int i = 0; i<item.length; i++)
            {
                unichar ch = [item characterAtIndex:i];
                NSLog(@"%C", ch);
                NSLog(@"%d %d", isChineseWord(ch), isEnglishLetter(ch));
                if (isChineseWord(ch))
                {
                    NSLog(@"%c", pinyinFirstLetter(ch));
                }
            }
        }
        */
        
        [self.tableViewTitle setTitle:self.fieldGuideName forState:UIControlStateNormal];
    }
    //NSLog(@"%lu", [self.tableContents count]);
    //NSLog(@"%@", self.tableContents);
    
    // No search results controller to display the search results in the current view
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    // Configure the search bar with scope buttons and add it to the table view header
    self.searchController.searchBar.scopeButtonTitles = @[];//@[NSLocalizedString(@"ScopeButtonCountry",@"Country"),NSLocalizedString(@"ScopeButtonCapital",@"Capital")];
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    // The search bar does not seem to set its size automatically
    // which causes it to have zero height when there is no scope
    // bar. If you remove the scopeButtonTitles above and the
    // search bar is no longer visible make sure you force the
    // search bar to size itself (make sure you do this after
    // you add it to the view hierarchy).
    [self.searchController.searchBar sizeToFit];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if (self.searchController.isActive)
    {
        return 1;
    }
    else
    {
        return [self.tableSectionsTitles count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (!self.searchController.isActive)
    {
        return [self.tableSectionsTitles objectAtIndex:section];
    }
    else
    {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.searchController.isActive)
    {
        return [self.filteredList count];
    }
    else
    {
        return [[self.tableSectionsContents objectForKey:[self.tableSectionsTitles objectAtIndex:section]] count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FGNodeCell" forIndexPath:indexPath];
    
    if (self.searchController.isActive)
    {
        cell.textLabel.text = [self.filteredList objectAtIndex:indexPath.row];
    }
    else
    {
        NSString *sectionTitle = [self.tableSectionsTitles objectAtIndex:indexPath.section];
        NSArray *sectionContent = [self.tableSectionsContents objectForKey:sectionTitle];
        cell.textLabel.text = [sectionContent objectAtIndex:indexPath.row];
    }
    
    NSString *picPath;
    if ((picPath = [self.tableContentsImages objectForKey:cell.textLabel.text]) == nil)
    {
        picPath = @"pacman";
    }
    //NSLog(@"%@",picPath);
    cell.imageView.image = [UIImage imageNamed:picPath];
    
    // Configure the cell...
    
    return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.tableSectionsTitles;
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
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *destination = [segue destinationViewController];
    //NSLog(@"%@", segue.identifier);
    
    if ([segue.identifier isEqualToString: @"TableSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSString *object;
        if (self.searchController.active)
        {
            object = [[self.filteredList objectAtIndex:indexPath.row] copy];
        }
        else
        {
            NSString *sectionTitle = [self.tableSectionsTitles objectAtIndex:indexPath.section];
            NSArray *sectionContents = [self.tableSectionsContents objectForKey:sectionTitle];
            object = [[sectionContents objectAtIndex:indexPath.row] copy];
        }
        //NSLog(@"Before wind segue: %@", object);
        if ([destination respondsToSelector:@selector(setNodePath:)])
        {
            [destination setValue:[[NSString alloc] initWithString:object] forKey:@"nodePath"];
        }
        if ([destination respondsToSelector:@selector(setDataBasePath:)])
        {
            [destination setValue:[[NSString alloc] initWithString:self.dataBasePath] forKey:@"dataBasePath"];
        }
    }
    else if ([segue.identifier isEqualToString: @"ButtonSegue"])
    {
        if ([destination respondsToSelector:@selector(setMainNode:)])
        {
            [destination setValue:self.mainNode forKey:@"mainNode"];
        }
        if ([destination respondsToSelector: @selector(setDataBasePath:)])
        {
            [destination setValue:self.dataBasePath forKey:@"dataBasePath"];
        }
        if ([destination respondsToSelector:@selector(setMainNodeDirPath:)])
        {
            [destination setValue:[self.dataBasePath stringByAppendingPathComponent:self.fieldGuideName] forKey:@"mainNodeDirPath"];
        }
    }
    //    NSLog(@"%d", [object isKindOfClass:[NSURL class]]);
    //    NSLog(@"%@", [object class]);
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


#pragma mark -
#pragma mark === UISearchBarDelegate ===
#pragma mark -

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

#pragma mark -
#pragma mark === UISearchResultsUpdating ===
#pragma mark -

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    NSLog(@"%@\n", searchString);
    [self searchForText:searchString];
    [self.tableView reloadData];
}

- (void)searchForText:(NSString *)searchText{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if (searchText == nil || [searchText isEqualToString:@""])
    {
        self.filteredList = self.tableContents;
        return;
    }
    
    for (NSString *item in self.mainNode.owns)
    {
        if ([item rangeOfString:searchText].location != NSNotFound)
        {
            [result addObject:[[NSString alloc] initWithString:item]];
        }
    }
    self.filteredList = [result sortedArrayUsingSelector:@selector(compare:)];
}

#pragma organize contents

-(NSMutableDictionary *)organizeContents:(NSArray *) contents
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (NSString *item in contents)
    {
        if (item.length < 1)
            continue;
        unichar firstLetter = [item characterAtIndex:0];
        NSString *orgKey;
        if (isEnglishLetter(firstLetter))
        {
            orgKey = [[[NSString alloc] initWithFormat:@"%C", firstLetter] capitalizedString];
        }
        else if (isChineseWord(firstLetter))
        {
            char ch = pinyinFirstLetter(firstLetter);
            orgKey = [[[NSString alloc] initWithFormat:@"%c", ch] capitalizedString];
        }
        else{
            orgKey = @"#";
        }
        if ([result objectForKey:orgKey] == nil)
        {
            [result setObject:[[NSMutableArray alloc] init] forKey:orgKey];
        }
        [[result objectForKey:orgKey] addObject:item];
    }
    //NSLog(@"%@", result);
    return result;
}

-(NSDictionary *)findContentsIcons:(NSArray *)contents
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *item in contents)
    {
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

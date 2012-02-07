//
//  PageController.m
//  RHITInfo
//
//  Created by Eric Henderson on 2/3/12.
//

#import "PageController.h"
#import "Page.h"
#import "SubpageController.h"

@implementation PageController

- (void)pagesLoaded
{
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [Pages sharedInstance].loadListener = self;
    [[Pages sharedInstance] loadData];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Pages sharedInstance].pages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Page *tmp = [[Pages sharedInstance].pages objectAtIndex:indexPath.row];
    cell.textLabel.text = tmp.title;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"PageToSubpage"])
    {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        SubpageController *c = [segue destinationViewController];
        Page *tmp = [[Pages sharedInstance].pages objectAtIndex:selectedRowIndex.row];
        c.myPage = tmp;
    }
}

#pragma mark - Refresh Button Event

- (IBAction)refreshClicked:(id)sender
{
    [Pages sharedInstance].loadListener = self;
    [[Pages sharedInstance] loadData];
}

@end

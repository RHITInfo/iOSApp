//
//  SubpageController.m
//  RHITInfo
//
//  Created by Eric Henderson on 2/6/12.
//

#import "SubpageController.h"
#import "Subpage.h"
#import "ViewerController.h"

@implementation SubpageController

@synthesize myPage = _myPage;

- (void)viewWillAppear:(BOOL)animated
{
    [self.myPage loadData];
    self.title = self.myPage.title;
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
    return self.myPage.subpages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SubpageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Subpage *tmp = [self.myPage.subpages objectAtIndex:indexPath.row];
    cell.textLabel.text = tmp.title;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SubpageToView"])
    {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        ViewerController *c = [segue destinationViewController];
        Subpage *tmp = [self.myPage.subpages objectAtIndex:selectedRowIndex.row];
        c.mySubpage = tmp;
    }
}

@end

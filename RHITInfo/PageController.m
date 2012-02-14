//
//  PageController.m
//  RHITInfo
//
//  Created by Eric Henderson on 2/3/12.
//

#import <QuartzCore/QuartzCore.h>
#import "PageController.h"
#import "Page.h"
#import "SubpageController.h"

//for Pull to Refresh (see comment later in the file)
#define REFRESH_HEADER_HEIGHT 52.0f

@implementation PageController
@synthesize tableView = _tableView;

- (void)pagesLoaded
{
    [self.tableView reloadData];
    [self stopLoading];
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

- (void)refresh
{
    [Pages sharedInstance].loadListener = self;
    [[Pages sharedInstance] loadData];
}

- (IBAction)refreshClicked:(id)sender
{
    [self refresh];
}

#pragma mark - Image Link Event

- (IBAction)imageClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.rose-hulman.edu/"]];
}

#pragma mark - Pull to Refresh Code

//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize refreshLabel = _refreshLabel;
@synthesize refreshArrow = _refreshArrow;
@synthesize refreshSpinner = _refreshSpinner;
@synthesize isDragging = _isDragging;
@synthesize isLoading = _isLoading;
@synthesize textPull = _textPull;
@synthesize textRelease = _textRelease;
@synthesize textLoading = _textLoading;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupStrings];
    [self addPullToRefreshHeader];
}

- (void)setupStrings
{
    self.textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    self.textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
    self.textLoading = [[NSString alloc] initWithString:@"Loading..."];
}

- (void)addPullToRefreshHeader
{
    self.refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake((self.tableView.frame.size.width - 320) / 2, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    self.refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    self.refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    self.refreshLabel.backgroundColor = [UIColor clearColor];
    self.refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    self.refreshLabel.textAlignment = UITextAlignmentCenter;
    
    self.refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    self.refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),                                  (floorf(REFRESH_HEADER_HEIGHT - 44) / 2), 27, 44);
    
    self.refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    self.refreshSpinner.hidesWhenStopped = YES;
    
    [self.refreshHeaderView addSubview:self.refreshLabel];
    [self.refreshHeaderView addSubview:self.refreshArrow];
    [self.refreshHeaderView addSubview:self.refreshSpinner];
    [self.tableView addSubview:self.refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(self.isLoading)
        return;
    self.isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.isLoading)
    {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if(self.isDragging && scrollView.contentOffset.y < 0)
    {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if(scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT)
        {
            // User is scrolling above the header
            self.refreshLabel.text = self.textRelease;
            [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        }
        else
        { // User is scrolling somewhere within the header
            self.refreshLabel.text = self.textPull;
            [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if(self.isLoading)
        return;
    self.isDragging = NO;
    if(scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT)
    {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading
{
    self.isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    self.refreshLabel.text = self.textLoading;
    self.refreshArrow.hidden = YES;
    [self.refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading
{
    self.isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets tableContentInset = self.tableView.contentInset;
    tableContentInset.top = 0.0;
    self.tableView.contentInset = tableContentInset;
    [self.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID
                   finished:(NSNumber *)finished
                    context:(void *)context
{
    // Reset the header
    self.refreshLabel.text = self.textPull;
    self.refreshArrow.hidden = NO;
    [self.refreshSpinner stopAnimating];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                         duration:(NSTimeInterval)duration
{
    self.refreshHeaderView.frame = CGRectMake((self.tableView.frame.size.width - 320) / 2, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT);
}

@end

//
//  ViewerController.m
//  RHITInfo
//
//  Created by Eric Henderson on 2/6/12.
//

#import "ViewerController.h"

@implementation ViewerController

@synthesize mySubpage = _mySubpage;
@synthesize webView = _webView;

- (void)viewWillAppear:(BOOL)animated
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.mySubpage.url]]];
    self.title = self.mySubpage.title;
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - Refresh Button Event

- (IBAction)refreshClicked:(id)sender
{
    [self.webView reload];
}

@end

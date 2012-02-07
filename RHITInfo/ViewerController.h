//
//  ViewerController.h
//  RHITInfo
//
//  Created by Eric Henderson on 2/6/12.
//

#import <UIKit/UIKit.h>
#import "Subpage.h"

@interface ViewerController : UIViewController
@property (nonatomic, strong) Subpage *mySubpage;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

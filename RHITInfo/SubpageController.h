//
//  SubpageController.h
//  RHITInfo
//
//  Created by Eric Henderson on 2/6/12.
//

#import <UIKit/UIKit.h>
#import "Page.h"

@interface SubpageController : UITableViewController <PageLoadListener>
@property (nonatomic, strong) Page *myPage;
@end

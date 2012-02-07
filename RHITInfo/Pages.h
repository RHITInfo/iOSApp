//
//  Pages.h
//  RHITInfo
//
//  Created by Eric Henderson on 2/6/12.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSXMLParser.h>

@interface Pages : NSObject <NSXMLParserDelegate>
@property (readonly) NSArray *pages;
- (void)loadData;
+ (Pages *)sharedInstance;
@end

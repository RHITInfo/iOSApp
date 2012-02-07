//
//  Page.h
//  RHITInfo
//
//  Created by Eric Henderson on 2/6/12.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSXMLParser.h>

@interface Page : NSObject <NSXMLParserDelegate>
@property (readonly) NSArray *subpages;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
- (void)loadData;
@end

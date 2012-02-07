//
//  Page.h
//  RHITInfo
//
//  Created by Eric Henderson on 2/6/12.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSXMLParser.h>

@class Page;

@protocol PageLoadListener <NSObject>
- (void)pageLoaded:(Page *)p;
@end

@interface Page : NSObject <NSXMLParserDelegate>
@property (readonly) NSArray *subpages;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, weak) id <PageLoadListener> loadListener;
- (void)loadData;
@end

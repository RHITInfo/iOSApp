//
//  Pages.h
//  RHITInfo
//
//  Created by Eric Henderson on 2/6/12.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSXMLParser.h>

@class Pages;

@protocol PagesLoadedListener <NSObject>
- (void)pagesLoaded;
@end

@interface Pages : NSObject <NSXMLParserDelegate>
@property (readonly) NSArray *pages;
@property (nonatomic, weak) id <PagesLoadedListener> loadListener;
- (void)loadData;
+ (Pages *)sharedInstance;
@end

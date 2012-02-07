//
//  Pages.m
//  RHITInfo
//
//  Created by Eric Henderson on 2/6/12.
//

#import "Pages.h"
#import "Page.h"

@interface Pages()
@property (nonatomic, strong) NSMutableArray *myPages;
@property (nonatomic, strong) NSMutableString *currentStringValue;
@property (nonatomic, strong) Page *currentPage;
@end

@implementation Pages

@synthesize myPages = _myPages;
@synthesize currentStringValue = _currentStringValue;
@synthesize currentPage = _currentPage;

- (NSArray *)pages
{
    if(!self.myPages)
    {
        [self loadData];
        return nil;
    }
    return [self.myPages copy];
}

+ (Pages *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static Pages *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        [_sharedObject loadData];
    });
    return _sharedObject;
}

- (void)loadData
{
    NSXMLParser *p = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://dev.rose-hulman.edu/RHITInfoTest/pages.php"]];
    p.delegate = self;
    [p parse];
}

-   (void)parser:(NSXMLParser *)parser
 didStartElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI
   qualifiedName:(NSString *)qName
      attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"pages"])
    {
        if(!self.myPages)
            self.myPages = [[NSMutableArray alloc] init];
        else
            [self.myPages removeAllObjects];
    }
    else if([elementName isEqualToString:@"page"])
        self.currentPage = [[Page alloc] init];
    else
        self.currentStringValue = [[NSMutableString alloc] init];
}

-   (void)parser:(NSXMLParser *)parser
 foundCharacters:(NSString *)string
{
    if(!self.currentStringValue)
        self.currentStringValue = [[NSMutableString alloc] init];
    [self.currentStringValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"page"])
        [self.myPages addObject:self.currentPage];
    else if([elementName isEqualToString:@"title"])
        self.currentPage.title = [self.currentStringValue copy];
    else if([elementName isEqualToString:@"url"])
        self.currentPage.url = [self.currentStringValue copy];
}

@end

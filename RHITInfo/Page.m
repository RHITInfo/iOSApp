//
//  Page.m
//  RHITInfo
//
//  Created by Eric Henderson on 2/6/12.
//

#import "Page.h"
#import "Subpage.h"

@interface Page()
@property (nonatomic, strong) NSMutableArray *mySubpages;
@property (nonatomic, strong) NSMutableString *currentStringValue;
@property (nonatomic, strong) Subpage *currentSubpage;
@end

@implementation Page

@synthesize url = _url;
@synthesize title = _title;
@synthesize mySubpages = _mySubpages;
@synthesize currentStringValue = _currentStringValue;
@synthesize currentSubpage = _currentSubpage;
@synthesize loadListener = _loadListener;

- (NSArray *)subpages
{
    if(!self.mySubpages)
    {
        [self loadData];
        return nil;
    }
    return [self.mySubpages copy];
}

- (void)loadData
{
    NSXMLParser *p = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:self.url]];
    p.delegate = self;
    [p parse];
}

-   (void)parser:(NSXMLParser *)parser
 didStartElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI
   qualifiedName:(NSString *)qName
      attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"subpages"])
    {
        if(!self.mySubpages)
            self.mySubpages = [[NSMutableArray alloc] init];
        else
            [self.mySubpages removeAllObjects];
    }
    else if([elementName isEqualToString:@"subpage"])
        self.currentSubpage = [[Subpage alloc] init];
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
    if([elementName isEqualToString:@"subpage"])
        [self.mySubpages addObject:self.currentSubpage];
    else if([elementName isEqualToString:@"title"])
        self.currentSubpage.title = [self.currentStringValue copy];
    else if([elementName isEqualToString:@"url"])
        self.currentSubpage.url = [self.currentStringValue copy];
    else if([elementName isEqualToString:@"subpages"])
        [self.loadListener pageLoaded:self];
}

@end

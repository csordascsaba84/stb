//
//  MasterViewController.m
//  stb
//
//  Created by CSABA CSORDAS on 27/02/2013.
//  Copyright (c) 2013 Reply. All rights reserved.
//

#import "MasterViewController.h"
#import <AFNetworking/AFXMLRequestOperation.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "ChannelsCell.h"
#import "UIImageView+AFNetworking.h"
#import "Channel.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
    _objects = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self stubNetworkRequest];
    [self getChannelList];
    
}

-(void) stubNetworkRequest
{
    
    [OHHTTPStubs shouldStubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        if ([request.URL.absoluteString.lastPathComponent.pathExtension isEqualToString:@"xml"]){
            return YES;
        }else{
            return NO;
        }

    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFile:@"full_querry_response.xml" contentType:@"application/xml" responseTime:1.0f];
    }];
}

-(void)getChannelList
{
    NSURL *url = [NSURL URLWithString:@"http://httpbin.org/ip.xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request
                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
                                NSLog(@"response: %@", response);
                                XMLParser.delegate = self;
                                [XMLParser parse];
                            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
                                NSLog(@"Error: %@", error);
                            }];
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{

    if([elementName isEqualToString:@"channel"]){
        Channel *channel = [[Channel alloc] initWithAttributes:attributeDict];
        [_objects addObject:channel];
    }
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSLog(@"%@", [[_objects objectAtIndex:indexPath.row] valueForKey:@"name"]);
    
    Channel *channel = [_objects objectAtIndex:indexPath.row];
    
    cell.channelName.text = channel.name;
    [cell.channelLogo setImageWithURL:channel.logo placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    
    return cell;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *object = _objects[indexPath.row];
    self.detailViewController.detailItem = object;
}

@end

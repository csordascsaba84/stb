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
#import <MBProgressHUD/MBProgressHUD.h>
#import "STBClient.h"
#import "DetailViewController.h"
#import "STBClient.h"

@interface MasterViewController () {
    NSMutableArray *_objects;

}

@property (nonatomic, strong) NSString  *currentChannel;
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[self stubNetworkRequest];
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
    NSDictionary *parameters = @{@"source":@"channels"};
    AFHTTPRequestOperation *operation = [[STBClient sharedClient] HTTPRequestOperationWithRequest:[[STBClient sharedClient]getChannel:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"response: %@", [responseObject class]);
        NSXMLParser *XMLParser = responseObject;
        XMLParser.delegate = self;
        [XMLParser parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
        if ([[attributeDict valueForKey:@"online_epg"] isEqualToString:@"true"]) {
            Channel *channel = [[Channel alloc] initWithAttributes:attributeDict];
            [_objects addObject:channel];
            self.currentChannel = [attributeDict valueForKey:@"id"];
            NSLog(@"Channel ID: %@", [attributeDict valueForKey:@"id"]);
        }
        self.currentChannel = [attributeDict valueForKey:@"id"];
    }
    if ([elementName isEqualToString:@"status"]) {
        NSLog(@"Status code: %@", [attributeDict valueForKey:@"code"]);
    }
    
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"query_result"])
    {
        [self getCurrentChannel];
        Channel *replyChannel  = [[Channel alloc] init];
        replyChannel.channelID = @"reply";
        replyChannel.name = @"ViewTV Demo";
        replyChannel.logical_channel_number = 999;
        replyChannel.logo = [[NSBundle mainBundle] URLForResource:@"replyLogo2" withExtension:@"png"];
        
        [_objects addObject:replyChannel];
    }
    if ([elementName isEqualToString:@"current_channel_result"]) {
        [self.tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSUInteger barIndex = [_objects indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([[(Channel *)obj channelID] isEqualToString:self.currentChannel]) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:barIndex inSection:0]
                               animated:NO
                         scrollPosition:UITableViewScrollPositionMiddle];
        self.detailViewController.detailItem = [_objects objectAtIndex:barIndex];
        
    }
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{

}

-(void) getCurrentChannel
{
    NSLog(@"Current channel called");
    AFHTTPRequestOperation *operation = [[STBClient sharedClient] HTTPRequestOperationWithRequest: [[STBClient sharedClient] getCurrentChannel:nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSXMLParser *XMLParser = responseObject;
        XMLParser.delegate = self;
        [XMLParser parse];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];

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
    __block ChannelsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //NSLog(@"%@", [[_objects objectAtIndex:indexPath.row] valueForKey:@"name"]);
    
    Channel *channel = [_objects objectAtIndex:indexPath.row];
    
    cell.channelName.text = channel.name;
    NSLog(@"%@ Is hidden: %@", channel.name, channel.hidden? @"true":@"false");
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
    Channel *object = _objects[indexPath.row];
    NSLog(@"%@", object.channelID);
    
    if ([object.channelID isEqualToString:@"reply"]) {
        self.detailViewController.detailItem = object;
    }
    else{
        NSDictionary *parameters = @{@"channel_id":[NSString stringWithFormat:@"%@", object.channelID]};
        AFHTTPRequestOperation *operation = [[STBClient sharedClient] HTTPRequestOperationWithRequest:[[STBClient sharedClient]tuneToChannel:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"request: %@", [[operation.request URL] absoluteString]);
            NSXMLParser *XMLParser = responseObject;
            XMLParser.delegate = self;
            [XMLParser parse];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        }];
        [operation start];
    
        self.detailViewController.detailItem = object;
    }
}


@end

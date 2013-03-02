//
//  DetailViewController.m
//  stb
//
//  Created by CSABA CSORDAS on 27/02/2013.
//  Copyright (c) 2013 Reply. All rights reserved.
//

#import "DetailViewController.h"
#import "PostTableViewCell.h"
#import "Post.h"
#import "Channel.h"
#import "STBClient.h"
#import "AFHTTPRequestOperation.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SpotifyWebViewController.h"


@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) Channel *channelData;
@property (strong, nonatomic) NSString *twitterQueryString;
@property (strong, nonatomic) NSMutableArray *events;
- (void)configureView;
@end

@implementation DetailViewController{
@private
NSArray *_posts;

__strong UIActivityIndicatorView *_activityIndicatorView;
}

-(NSMutableArray *)events
{
    if(!_events)
    {
        _events = [NSMutableArray array];
    }
    return _events;
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.twitterQueryString = self.detailItem.name;
        //NSLog(@"QueryString: %@", self.twitterQueryString);
        [self reload:self];
    }
    //NSString *channel_id = self.detailItem.channelID;
    NSTimeInterval MY_EXTRA_TIME = 3600; // 10 Seconds
    NSDate *futureDate = [[NSDate date] dateByAddingTimeInterval:MY_EXTRA_TIME];
    
    NSDictionary *parameters = @{@"source": @"epg", @"filter":[NSString stringWithFormat:@"channel_id-%@~start_time-%%3E%%3D%.0f~stop_time-%%3C%%3D%.0f",self.detailItem.channelID,[[NSDate date] timeIntervalSince1970], [futureDate timeIntervalSince1970]],@"metadata":@"id~name~thumbnail~summary~director~country_of_production~year_of_production~episode_title~episode_number~season_number~part_number"};
    
    NSLog(@"parameters: %@", parameters);
    
    if (self.detailItem){
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperation *operation = [[STBClient sharedClient] HTTPRequestOperationWithRequest:[[STBClient sharedClient] getEPG:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"request: %@", [[operation.request URL] absoluteString]);
        NSXMLParser *XMLParser = responseObject;
        XMLParser.delegate = self;
        [XMLParser parse];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
    }
}

- (void)reload:(id)sender {
    [_activityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSString *query = [self.twitterQueryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if(query){
    [Post globalTimelinePostsWithBlock:query forQuery:^(NSArray *posts, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            _posts = posts;
            [self.tableView reloadData];
        }
        
        [_activityIndicatorView stopAnimating];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];}
}

- (void)loadView {
    [super loadView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.hidesWhenStopped = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicatorView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];

    self.tableView.rowHeight = 70.0f;
    
    [self addMenu];
    
    [self reload:nil];
}

-(void)addMenu
{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:[UIImage imageNamed:@"spotifyLogo.png"]
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:[UIImage imageNamed:@"game2.png"]
                                                    highlightedContentImage:nil];
    
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, nil];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.menu.bounds menus:menus];
    menu.startPoint = CGPointMake(380, 650);
	// customize menu
	
    // menu.rotateAngle = M_PI/3;
     menu.menuWholeAngle = M_PI;
    // menu.timeOffset = 0.2f;
     menu.farRadius = 180.0f;
     menu.endRadius = 100.0f;
//    menu.nearRadius = 50.0f;
	
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Channels", @"Channels");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.post = [_posts objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PostTableViewCell heightForCellWithPost:[_posts objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Awsomemenu Delegate

-(void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    if (idx == 0) {
        [self performSegueWithIdentifier:@"showSpotify" sender:self];
    } else if (idx == 1){
        [self performSegueWithIdentifier:@"showQuiz" sender:self];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSpotify"]) {
        SpotifyWebViewController *viewController =  segue.destinationViewController;
        viewController.query = [NSString stringWithFormat:@"%@+soundtrack",self.currentEvent.name];
    }
}



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:@"query_result"]) {
        [self.events removeAllObjects];
    }
    if([elementName isEqualToString:@"event"]){
            NSLog(@"Event ID: %@", [attributeDict valueForKey:@"id"]);
            [self.events addObject:[[Event alloc] initEventWithResponse:attributeDict]];
        }
    if ([elementName isEqualToString:@"status"]) {
        NSLog(@"Status code: %@", [attributeDict valueForKey:@"code"]);
    }
    
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"query_result"])
    {
        
    }
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    self.currentEvent = [self.events objectAtIndex:0];
    self.eventTitle.text = self.currentEvent.name;
    self.eventSummary.text = self.currentEvent.summary;
    [self.eventImage setImageWithURL:self.currentEvent.thumbnail];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.view setNeedsLayout];
}

@end

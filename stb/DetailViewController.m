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

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController{
@private
NSArray *_posts;

__strong UIActivityIndicatorView *_activityIndicatorView;
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
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)reload:(id)sender {
    [_activityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [Post globalTimelinePostsWithBlock:^(NSArray *posts, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            _posts = posts;
            [self.tableView reloadData];
        }
        
        [_activityIndicatorView stopAnimating];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
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
    
    UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem6 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem7 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem8 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem9 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, starMenuItem6, starMenuItem7,starMenuItem8,starMenuItem9, nil];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.menu.bounds menus:menus];
    menu.startPoint = CGPointMake(515, 331);
	// customize menu
	/*
     menu.rotateAngle = M_PI/3;
     menu.menuWholeAngle = M_PI;
     menu.timeOffset = 0.2f;
     menu.farRadius = 180.0f;
     menu.endRadius = 100.0f;
     menu.nearRadius = 50.0f;
     */
	
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

@end

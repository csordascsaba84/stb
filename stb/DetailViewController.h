//
//  DetailViewController.h
//  stb
//
//  Created by CSABA CSORDAS on 27/02/2013.
//  Copyright (c) 2013 Reply. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwesomeMenuItem.h"
#import "AwesomeMenu.h"
#import "Channel.h"
#import "Event.h"
#import "UIImageView+AFNetworking.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, AwesomeMenuDelegate, NSXMLParserDelegate>

- (IBAction)tweet:(UIBarButtonItem *)sender;
@property (strong, nonatomic) Channel *detailItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendTweet;

@property (weak, nonatomic) IBOutlet UIView *menu;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Event *currentEvent;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventSummary;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;

@end

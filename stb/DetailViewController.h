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

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, AwesomeMenuDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIView *menu;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

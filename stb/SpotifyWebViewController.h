//
//  SpotifyWebViewController.h
//  stb
//
//  Created by CSABA CSORDAS on 02/03/2013.
//  Copyright (c) 2013 Reply. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpotifyWebViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *query;

@end

//
//  SpotifyWebViewController.m
//  stb
//
//  Created by CSABA CSORDAS on 02/03/2013.
//  Copyright (c) 2013 Reply. All rights reserved.
//

#import "SpotifyWebViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface SpotifyWebViewController ()

@end

@implementation SpotifyWebViewController

- (void)viewDidLoad
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat: @"http://192.168.43.218:8080/ViewTV/album.jsp?q=%@",[self.query stringByReplacingOccurrencesOfString:@" " withString:@"+"] ]]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat: @"http://172.20.10.4:8080/ViewTV/album.jsp?q=%@",[self.query stringByReplacingOccurrencesOfString:@" " withString:@"+"] ]]];
  
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat: @"http://172.20.10.4:8080/ViewTV/album.jsp?q=avatar"]]];
    
    
    NSLog(@"%@",[request.URL absoluteString]);
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.webView loadRequest:request];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}


@end

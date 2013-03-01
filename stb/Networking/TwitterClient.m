//
//  TwitterClient.m
//  stb
//
//  Created by CSABA CSORDAS on 28/02/2013.
//  Copyright (c) 2013 Reply. All rights reserved.
//

#import "TwitterClient.h"
#import <AFNetworking/AFJSONRequestOperation.h>

@implementation TwitterClient

static NSString * const kTwitterAPIBaseURLString = @"http://search.twitter.com/";

+ (TwitterClient *)sharedClient
{
    static TwitterClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}


@end

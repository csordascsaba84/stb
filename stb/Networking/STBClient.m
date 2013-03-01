//
//  STBClient.m
//  stb
//
//  Created by CSABA CSORDAS on 01/03/2013.
//  Copyright (c) 2013 Reply. All rights reserved.
//

#import "STBClient.h"
#import <AFNetworking/AFXMLRequestOperation.h>

@implementation STBClient

static NSString * const kSTBAPIBaseURLString = @"http://search.twitter.com/";

+(STBClient *)sharedClient
{
    static STBClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[STBClient alloc] initWithBaseURL:[NSURL URLWithString:kSTBAPIBaseURLString]];
    });
    
    return _sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFXMLRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}



@end

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

//static NSString * const kSTBAPIBaseURLString = @"http://192.168.0.100";
static NSString * const kSTBAPIBaseURLString = @"http://192.168.43.75";

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
    [self setDefaultHeader:@"Accept" value:@"application/xml"];
    
    return self;
}

-(NSMutableURLRequest *) getChannel:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = nil;
    
    request = [self requestWithMethod:@"POST" path:@"query" parameters:parameters];
    
    NSLog(@"Request URL: %@", request.URL);
    
    return request;
}

-(NSMutableURLRequest *) tuneToChannel:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"GET" path:@"tune" parameters:parameters];
    
    return request;
}

-(NSMutableURLRequest *) getCurrentChannel:(NSDictionary *)pararmeters
{
    NSMutableURLRequest *request = nil;
    NSDictionary *dict;
    request = [self requestWithMethod:@"GET" path:@"current_channel" parameters:dict];
    
    return request;
}

-(NSMutableURLRequest *) getEPG:(NSDictionary *)pararmeters
{
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"POST" path:@"query" parameters:pararmeters];
    return request;
}

@end

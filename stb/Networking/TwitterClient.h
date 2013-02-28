//
//  TwitterClient.h
//  stb
//
//  Created by CSABA CSORDAS on 28/02/2013.
//  Copyright (c) 2013 Reply. All rights reserved.
//

#import <AFNetworking/AFHTTPClient.h>

@interface TwitterClient : AFHTTPClient

+ (TwitterClient *)sharedClient;

@end

//
//  STBClient.h
//  stb
//
//  Created by CSABA CSORDAS on 01/03/2013.
//  Copyright (c) 2013 Reply. All rights reserved.
//

#import <AFNetworking/AFHTTPClient.h>

@interface STBClient : AFHTTPClient

+ (STBClient *)sharedClient;

@end

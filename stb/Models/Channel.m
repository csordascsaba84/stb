//
//  Channel.m
//  stb
//
//  Created by CSABA CSORDAS on 01/03/2013.
//  Copyright (c) 2013 Reply. All rights reserved.
//

#import "Channel.h"
#import <AFNetworking/AFImageRequestOperation.h>

NSString * const kChannelImageDidLoadNotification = @"eu.reply.channel.image.loaded";

@interface Channel ()

@property (readwrite) NSString *channelID;
@property (readwrite) NSString *name;
@property (readwrite) NSUInteger logical_channel_number;
@property (readwrite) BOOL online_epg;
@property (readwrite) BOOL hidden;
@property (readwrite) BOOL locked;
@property (readwrite) NSUInteger schedule_id;
@property (readwrite) NSURL *logo;

@end

@implementation Channel {
    @private
    AFImageRequestOperation *_channelImageRequestOperation;
}

-(id) initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        self.channelID = [attributes valueForKey:@"id"];
        self.name = [attributes valueForKey:@"name"];
        self.logical_channel_number = [[attributes valueForKey:@"logical_channel_number"] integerValue];
        self.online_epg = [[attributes valueForKey:@"online_epg"] isEqualToString:@"false"]?NO:YES;
        self.hidden = [[attributes valueForKey:@"hidden"] isEqualToString:@"false"]?NO:YES;
        self.locked = [[attributes valueForKey:@"locked"] isEqualToString:@"false"]?NO:YES;
        self.schedule_id = [[attributes valueForKey:@"schedule_id"] integerValue];
        NSLog(@"Logo url: %@", [attributes valueForKey:@"logo"]);
        self.logo = [NSURL URLWithString:[attributes valueForKey:@"logo"]];
    }
    return self;
}

@end

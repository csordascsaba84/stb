//
//  Channel.h
//  stb
//
//  Created by CSABA CSORDAS on 01/03/2013.
//  Copyright (c) 2013 Reply. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject

@property (readonly) NSUInteger channelID;
@property (readonly) NSString *name;
@property (readonly) NSUInteger logical_channel_number;
@property (readonly) BOOL online_epg;
@property (readonly) BOOL hidden;
@property (readonly) BOOL locked;
@property (nonatomic) BOOL record_status;
@property (readonly) NSUInteger schedule_id;
@property (readonly) NSURL *logo;

-(id) initWithAttributes:(NSDictionary *)attributes;

@end

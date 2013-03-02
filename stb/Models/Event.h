//
//  Event.h
//  stb
//
//  Created by CSABA CSORDAS on 01/03/2013.
//  Copyright (c) 2013 Reply. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSUInteger channelID;
@property (nonatomic) NSUInteger scheduled_start_time;
@property (nonatomic) NSUInteger scheduled_end_time;
@property (nonatomic) NSUInteger maturity_rating;
@property (nonatomic) NSUInteger channel_maturity_rating;
@property (nonatomic) NSUInteger scheduleID;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *director;
@property (nonatomic, strong) NSString *country_of_production;
@property (nonatomic, strong) NSString *episode_title;
@property (nonatomic, strong) NSURL *thumbnail;
@property (nonatomic, strong) NSString *presenter;
@property (nonatomic, strong) NSString *actor;
@property (nonatomic, strong) NSString *guest;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *detailed_description;
@property (nonatomic, strong) NSString  *year_of_production;
@property (nonatomic) NSUInteger episode_number;
@property (nonatomic) NSUInteger season_number;
@property (nonatomic) NSUInteger part_number;
@property (nonatomic) NSUInteger total_parts;
@property (nonatomic) NSUInteger subtitle_tracks;

-(id)initEventWithResponse:(NSDictionary *)response;

@end

//
//  Event.m
//  stb
//
//  Created by CSABA CSORDAS on 01/03/2013.
//  Copyright (c) 2013 Reply. All rights reserved.
//

#import "Event.h"

@implementation Event

-(id)initEventWithResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        self.eventID = [response valueForKey:@"id"];
        self.name = [response valueForKey:@"name"];
        self.summary = [response valueForKey:@"summary"];
        self.thumbnail = [NSURL URLWithString: [[response valueForKey:@"thumbnail"] stringByReplacingOccurrencesOfString:@"https" withString:@"http"]];
        
        self.director = [response valueForKey:@"director"];
        self.country_of_production = [response valueForKey:@"country_of_production"];
        self.year_of_production = [response valueForKey:@"year_of_production"];
        self.episode_title = [response valueForKey:@"episode_title"];
        self.episode_number = [[response valueForKey:@"episode_number"] integerValue];
        self.season_number = [[response valueForKey:@"season_number"] integerValue];
        self.part_number = [[response valueForKey:@"part_number"] integerValue];
    }
    return self;
}

@end

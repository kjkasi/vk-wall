//
//  Wall+Extended.m
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "Wall+Extended.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Profile+Extended.h"

@implementation Wall (Extended)

- (NSString *)dateString {
    
    NSDate *date = self.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *stingDate = [dateFormatter stringFromDate:date];
    
    return stingDate;
}

- (instancetype)initWithResponse:(id)response inContext:(NSManagedObjectContext *)context {
    
    NSNumber *uid = response[@"id"];
    
    Wall *wall = [Wall MR_findFirstByAttribute:@"uid" withValue:uid.stringValue inContext:context];
    
    if (wall == nil) {
        wall = [Wall MR_createEntityInContext:context];
    }
    
    wall.uid = uid.stringValue;
    
    NSNumber *fromId = response[@"from_id"];
    
    wall.owner = [Profile MR_findFirstByAttribute:@"uid" withValue:fromId.stringValue inContext:context];
    
    NSNumber *date = response[@"date"];
    wall.date = [NSDate dateWithTimeIntervalSince1970:date.doubleValue];
    
    NSString *text = response[@"text"];
    wall.text = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    
    return wall;
}

+ (instancetype)initWithResponse:(id)response inContext:(NSManagedObjectContext *)context {
    
    Wall *wall = [[Wall alloc] initWithResponse:response inContext:context];
    
    return wall;
}

- (void)addPhotosObject:(Photo *)value {
    NSMutableOrderedSet *photos = [[NSMutableOrderedSet alloc] initWithOrderedSet:self.photos];
    [photos addObject:value];
    self.photos = photos;
}

@end

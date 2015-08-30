//
//  Profile+Extended.m
//  vk-wall
//
//  Created by Anton Minin on 30/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "Profile+Extended.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation Profile (Extended)

- (instancetype)initWithResponse:(id)response inContext:(NSManagedObjectContext *)context {
    
    NSNumber *uid = response[@"id"];
    
    Profile *profile = [Profile MR_findFirstByAttribute:@"uid" withValue:uid.stringValue inContext:context];
    
    if (profile == nil) {
        profile = [Profile MR_createEntityInContext:context];
    }
    
    profile.uid = uid.stringValue;
    profile.firstName = response[@"first_name"];
    profile.lastName = response[@"last_name"];
    profile.photo50 = response[@"photo_50"];
    
    return profile;
}

+ (instancetype)initWithResponse:(id)response inContext:(NSManagedObjectContext *)context {
    
    Profile *profile = [[Profile alloc] initWithResponse:response inContext:context];
    
    return profile;
}

@end

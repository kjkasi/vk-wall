//
//  Profile+Extended.h
//  vk-wall
//
//  Created by Anton Minin on 30/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "Profile.h"

@interface Profile (Extended)

- (instancetype)initWithResponse:(id)response inContext:(NSManagedObjectContext *)context;

+ (instancetype)initWithResponse:(id)response inContext:(NSManagedObjectContext *)context;

@end

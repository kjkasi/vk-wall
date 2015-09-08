//
//  Photo+Extended.h
//  vk-wall
//
//  Created by Anton Minin on 30/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "Photo.h"

@interface Photo (Extended)

+ (instancetype)photoWithData:(id)data inContext:(NSManagedObjectContext *)context;

- (instancetype)initWithResponse:(id)response inContext:(NSManagedObjectContext *)context;

+ (instancetype)initWithResponse:(id)response inContext:(NSManagedObjectContext *)context;

- (NSURL *)url;

@end

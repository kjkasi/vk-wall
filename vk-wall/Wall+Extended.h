//
//  Wall+Extended.h
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "Wall.h"

typedef NS_ENUM(NSUInteger, ImageType) {
    ImageTypeNone,
    ImageTypeOne,
    ImageTypeTwo,
};

@interface Wall (Extended)

- (NSString *)dateString;

- (instancetype)initWithResponse:(id)response inContext:(NSManagedObjectContext *)context;

+ (instancetype)initWithResponse:(id)response inContext:(NSManagedObjectContext *)context;

- (ImageType)type;

//переделать
- (NSString *)cellIdetifier;

- (NSArray *)photosUrl;

@end

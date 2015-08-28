//
//  Profile.h
//  vk-wall
//
//  Created by Anton Minin on 29/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Wall;

@interface Profile : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * photo50;
@property (nonatomic, retain) NSSet *wall;
@end

@interface Profile (CoreDataGeneratedAccessors)

- (void)addWallObject:(Wall *)value;
- (void)removeWallObject:(Wall *)value;
- (void)addWall:(NSSet *)values;
- (void)removeWall:(NSSet *)values;

@end

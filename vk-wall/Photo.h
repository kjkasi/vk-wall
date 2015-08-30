//
//  Photo.h
//  vk-wall
//
//  Created by Anton Minin on 30/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Wall;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSSet *walls;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addWallsObject:(Wall *)value;
- (void)removeWallsObject:(Wall *)value;
- (void)addWalls:(NSSet *)values;
- (void)removeWalls:(NSSet *)values;

@end

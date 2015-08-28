//
//  Wall.h
//  vk-wall
//
//  Created by Anton Minin on 29/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Profile;

@interface Wall : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * fromId;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) Profile *owner;

@end

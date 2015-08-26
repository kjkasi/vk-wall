//
//  Profile.h
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Profile : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * uid;

@end

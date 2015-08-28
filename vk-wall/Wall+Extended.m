//
//  Wall+Extended.m
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "Wall+Extended.h"

@implementation Wall (Extended)

- (NSString *)dateString {
    
    NSDate *date = self.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *stingDate = [dateFormatter stringFromDate:date];
    
    return stingDate;
}

@end

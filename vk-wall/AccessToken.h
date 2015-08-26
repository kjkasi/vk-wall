//
//  AccessToken.h
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessToken : NSObject

+ (NSString *)token;

+ (void)setToken:(NSString *)token;

+ (NSTimeInterval)expirationInterval;

+ (void)setExpirationInterval:(NSTimeInterval)Interval;

+ (NSString *)userId;

+ (void)setUserId:(NSString *)userId;

+ (void)initWithURL:(NSURL *)url;

@end

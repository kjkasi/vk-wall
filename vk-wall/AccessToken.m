//
//  AccessToken.m
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "AccessToken.h"

NSString *const kTokenKey = @"access_token";
NSString *const kExpirationDateKey = @"expires_in";
NSString *const kUserIdKey = @"user_id";

@implementation AccessToken

+ (NSString *)token; {
    
    NSString *tokenString = [[NSUserDefaults standardUserDefaults] stringForKey:kTokenKey];
    return tokenString;
}

+ (void)setToken:(NSString *)token {
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kTokenKey];
}

+ (NSTimeInterval)expirationInterval {
    
    NSTimeInterval interval = [[NSUserDefaults standardUserDefaults] doubleForKey:kExpirationDateKey];
    return interval;
}

+ (void)setExpirationInterval:(NSTimeInterval)interval {
    [[NSUserDefaults standardUserDefaults] setDouble:interval forKey:kExpirationDateKey];
}

+ (NSString *)userId {
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserIdKey];
    return userId;
}

+ (void)setUserId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kUserIdKey];
}

+ (void)initWithURL:(NSURL *)url {
    
    NSString *fragment = url.fragment;
    NSArray *pairs = [fragment componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *values = [pair componentsSeparatedByString:@"="];
        if (values.count == 2) {
            NSString *key = values.firstObject;
            NSString *value = values.lastObject;
            if ([key isEqualToString:kTokenKey]) {
                [AccessToken setToken:value];
            } else if ([key isEqualToString:kExpirationDateKey]) {
                [AccessToken setExpirationInterval:value.doubleValue];
            } else if ([key isEqualToString:kUserIdKey]) {
                [AccessToken setUserId:value];
            }
        }
    }
    
}

@end

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

@synthesize token = _token;
@synthesize expirationDate = _expirationDate;
@synthesize userId = _userId;

- (NSString *)token {
    
    if (_token == nil) {
        NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:kTokenKey];
        _token = token;
    }
    return _token;
}

- (void)setToken:(NSString *)token {
    
    _token = token;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)expirationDate {
    
    if (_expirationDate == nil) {
        NSDate *expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:kExpirationDateKey];
        _expirationDate = expirationDate;
    }
    return _expirationDate;
}

- (void)setExpirationDate:(NSDate *)expirationDate {
    
    _expirationDate = expirationDate;
    [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:kExpirationDateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userId {
    
    if (_userId == nil) {
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserIdKey];
        _userId = userId;
    }
    return _userId;
}

- (void)setUserId:(NSString *)userId {
    
    _userId = userId;
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kUserIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLoggedIn {
    
    if (self.token && [self.expirationDate compare:[NSDate date]] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

/*+ (NSString *)token; {
    
    NSString *tokenString = [[NSUserDefaults standardUserDefaults] stringForKey:kTokenKey];
    
    if (tokenString == nil) {
        //tokenString = @"";
    }
    
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
    
    if (userId == nil) {
        //userId = @"";
    }
    
    return userId;
}

+ (void)setUserId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kUserIdKey];
}
*/

- (instancetype)initWithURL:(NSURL *)url {
    
    self = [super init];
    if (self) {
        NSString *fragment = url.fragment;
        NSArray *pairs = [fragment componentsSeparatedByString:@"&"];
        
        for (NSString *pair in pairs) {
            NSArray *values = [pair componentsSeparatedByString:@"="];
            if (values.count == 2) {
                NSString *key = values.firstObject;
                NSString *value = values.lastObject;
                if ([key isEqualToString:kTokenKey]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kTokenKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                } else if ([key isEqualToString:kExpirationDateKey]) {
                    
                    NSTimeInterval timeInterval = value.doubleValue;
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate dateWithTimeIntervalSinceNow:timeInterval] forKey:kExpirationDateKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                } else if ([key isEqualToString:kUserIdKey]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:value forKey:kUserIdKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
            }
        }
    }
    return self;
    
    
    
}

@end

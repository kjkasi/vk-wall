//
//  AccessToken.h
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessToken : NSObject

@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSDate *expirationDate;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, assign, getter=isLoggedIn) BOOL loggedIn;

/*+ (NSString *)token;

+ (void)setToken:(NSString *)token;

+ (NSTimeInterval)expirationInterval;

+ (void)setExpirationInterval:(NSTimeInterval)Interval;

+ (NSString *)userId;

+ (void)setUserId:(NSString *)userId;*/

- (instancetype)initWithURL:(NSURL *)url;

@end

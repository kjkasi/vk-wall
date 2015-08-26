//
//  ApiManager.h
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>

static const NSInteger kItemCount = 10;

@interface ApiManager : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

+ (instancetype)sharedManager;

@end

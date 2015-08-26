//
//  ApiManager.m
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "ApiManager.h"

#import <AFNetworking/AFNetworking.h>
#import "AFNetworkActivityIndicatorManager.h"

NSString *const kBaseUrl = @"https://api.vk.com/";

@interface ApiManager()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation ApiManager

+ (instancetype)sharedManager {
    
    static ApiManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ApiManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        __weak typeof(self) weakSelf = self;
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                case AFNetworkReachabilityStatusReachableViaWWAN: {
                    [weakSelf.manager.operationQueue setSuspended:NO];
                    break;
                }
                    
                case AFNetworkReachabilityStatusUnknown:
                case AFNetworkReachabilityStatusNotReachable: {
                    [weakSelf.manager.operationQueue setSuspended:YES];
                    break;
                }
            }
            
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
            
        }];
    }
    return self;
}

@end

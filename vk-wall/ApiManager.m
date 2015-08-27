//
//  ApiManager.m
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "ApiManager.h"

#import "AFNetworkActivityIndicatorManager.h"

NSString *const kBaseUrl = @"https://api.vk.com/method/";

@interface ApiManager()

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
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        NSOperationQueue *operationQueue = manager.operationQueue;
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [operationQueue setSuspended:NO];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                default:
                    [operationQueue setSuspended:YES];
                    break;
            }
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        }];
        
        [manager.reachabilityManager startMonitoring];
        
        self.manager = manager;
        
    }
    return self;
}

#pragma mark - topViewController

- (void)authorize {
    
    UIStoryboard *newStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [newStoryboard instantiateViewControllerWithIdentifier:@"AuchViewController"];
    
    [[self topViewController] presentViewController:vc animated:YES completion:nil];
}

- (UIViewController *)topViewController
{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

- (AccessToken *)token {
    if (_token == nil) {
        AccessToken *token = [[AccessToken alloc] init];
        _token = token;
    }
    return _token;
}

@end

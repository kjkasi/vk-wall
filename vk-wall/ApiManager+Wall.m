//
//  ApiManager+Wall.m
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "ApiManager+Wall.h"

#import "AccessToken.h"
#import "Wall+Extended.h"
#import "Profile.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation ApiManager (Wall)

- (void)getWallWithOffset:(NSInteger)offset response:(ApiGetWallResponse)response {
    
    if (![self.token isLoggedIn]) {
        response(nil);
        [self authorize];
        return;
    }
    
    NSDictionary *param = @{@"count": @(kItemCount), @"access_token": self.token.token, @"extended": @1};
    
    [self.manager GET:@"wall.get" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *res = responseObject[@"response"];
        
        NSArray *groups = res[@"groups"];
        NSArray *wall = res[@"wall"];
        NSArray *profiles = res[@"profiles"];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            //Parse wall
            for (id object in wall) {
                if ([object isKindOfClass:[NSDictionary class]]) {
                    //
                    NSNumber *uid = object[@"id"];
                    
                    Wall *wall = [Wall MR_findFirstByAttribute:@"uid" withValue:uid.stringValue inContext:localContext];
                    
                    if (wall == nil) {
                        wall = [Wall MR_createEntityInContext:localContext];
                    }
                    
                    wall.uid = uid.stringValue;
                    
                    NSNumber *fromId = object[@"from_id"];
                    wall.fromId = fromId.stringValue;
                    
                    NSNumber *date = object[@"date"];
                    wall.date = [NSDate dateWithTimeIntervalSince1970:date.doubleValue];
                    
                    wall.text = object[@"text"];
                    NSLog(@"text: %@", wall.text);
                }
            }
            
            //Parse profiles
            for (id object in profiles) {
                //
                Profile *profile = [Profile MR_findFirstInContext:localContext];
                
                if (profile == nil) {
                    profile = [Profile MR_createEntityInContext:localContext];
                }
                
                NSNumber *uid = object[@"uid"];
                profile.uid = uid.stringValue;
                
                profile.firstName = object[@"first_name"];
                profile.lastName = object[@"last_name"];
                
            }
            
        } completion:^(BOOL contextDidSave, NSError *error) {
            response(error);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        response(error);
    }];
}

#pragma mark -

@end

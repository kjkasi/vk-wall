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
#import "Profile+Extended.h"
#import "Photo+Extended.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation ApiManager (Wall)

- (void)getWallWithOffset:(NSInteger)offset response:(ApiGetWallResponse)response {
    
    if (![self.token isLoggedIn]) {
        response(nil);
        [self authorize];
        return;
    }
    
    NSDictionary *param = @{@"count": @(kItemCount), @"access_token": self.token.token, @"extended": @1, @"offset": @(offset), @"v": @5.37};
    
    [self.manager GET:@"wall.get" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *res = responseObject[@"response"];
        NSDictionary *error = responseObject[@"error"];
        
        if (error) {
            NSNumber *errorCode = error[@"error_code"];
            
            if ([errorCode isEqualToNumber:@5]) {
                response(nil);
                [self.token clean];
                [self authorize];
            }
        }
        
        //NSArray *groups = res[@"groups"];
        NSArray *wall = res[@"items"];
        NSArray *profiles = res[@"profiles"];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            if (offset == 0) {
                [Wall MR_truncateAllInContext:localContext];
            }
            
            //MARK:Parse profiles
            for (id object in profiles) {
                
                [Profile initWithResponse:object inContext:localContext];
                
            }
            
            //MARK:Parse wall
            for (id object in wall) {
                if ([object isKindOfClass:[NSDictionary class]]) {
                    
                    Wall *wall = [Wall initWithResponse:object inContext:localContext];
                    
                    //MARK: Parse Photo
                    NSArray *attachments = object[@"attachments"];
                    
                    for (id attachment in attachments) {
                        
                        NSDictionary *dictPhoto = attachment[@"photo"];
                        
                        if (dictPhoto) {
                            Photo *photo = [Photo initWithResponse:dictPhoto inContext:localContext];
                            [wall addPhotosObject:photo];
                        }
                        
                    }
                    
                }
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

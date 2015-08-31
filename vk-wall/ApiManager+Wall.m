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

static NSString *kAccessToken = @"access_token";

static NSString *kCount = @"count";

static NSString *kExtended = @"extended";

static NSString *kOffset = @"offset";

static NSString *kVersion = @"v";

static NSString *kWallGet = @"wall.get";

static NSString *kResponse = @"response";

static NSString *kError = @"response";

static NSString *kErrorCode = @"error_code";

static NSString *kItems = @"items";

static NSString *kProfiles = @"profiles";

static NSString *kAttachments = @"attachments";

static NSString *kPhoto = @"photo";

@implementation ApiManager (Wall)

- (void)getWallWithOffset:(NSInteger)offset response:(ApiGetWallResponse)response {
    
    if (![self.token isLoggedIn]) {
        response(nil);
        if (self.handleLogin) {
            self.handleLogin();
        }
        
        return;
    }
    
    NSDictionary *param = @{kCount: @(kItemCount), kAccessToken: self.token.token, kExtended: @1, kOffset: @(offset), kVersion: @5.37};
    
    [self.manager GET:kWallGet parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *res = responseObject[kResponse];
        NSDictionary *error = responseObject[kError];
        
        if (error) {
            NSNumber *errorCode = error[kErrorCode];
            
            if ([errorCode isEqualToNumber:@5]) {
                response(nil);
                [self.token clean];
                if (self.handleLogin) {
                    self.handleLogin();
                }
            }
        }
        
        //NSArray *groups = res[@"groups"];
        NSArray *wall = res[kItems];
        NSArray *profiles = res[kProfiles];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            if (offset == 0) {
                [Wall MR_truncateAllInContext:localContext];
            }
            
            // MARK:Parse profiles
            for (id object in profiles) {
                
                [Profile initWithResponse:object inContext:localContext];
                
            }
            
            // MARK:Parse wall
            for (id object in wall) {
                if ([object isKindOfClass:[NSDictionary class]]) {
                    
                    Wall *wall = [Wall initWithResponse:object inContext:localContext];
                    
                    //MARK: Parse Photo
                    NSArray *attachments = object[kAttachments];
                    
                    for (id attachment in attachments) {
                        
                        NSDictionary *dictPhoto = attachment[kPhoto];
                        
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

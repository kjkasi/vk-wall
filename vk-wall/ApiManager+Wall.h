//
//  ApiManager+Wall.h
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "ApiManager.h"

typedef void (^ApiGetWallResponse)(NSError *error);

@interface ApiManager (Wall)

- (void)getWallWithOffset:(NSInteger)offset response:(ApiGetWallResponse)response;

@end

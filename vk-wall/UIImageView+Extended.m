//
//  UIImageView+Extended.m
//  vk-wall
//
//  Created by Anton Minin on 31/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "UIImageView+Extended.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@implementation UIImageView (Extended)

- (void)setCacheImageWithURL:(NSURL *)url {
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    [self setImageWithURLRequest:imageRequest
                             placeholderImage:nil
                                      success:nil
                                      failure:nil];
}

@end

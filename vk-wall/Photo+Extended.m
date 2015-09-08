//
//  Photo+Extended.m
//  vk-wall
//
//  Created by Anton Minin on 30/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "Photo+Extended.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation Photo (Extended)

+ (instancetype)photoWithData:(id)data inContext:(NSManagedObjectContext *)context {
    
    NSNumber *photoId = data[@"id"];
    
    Photo *photo = [Photo MR_findFirstByAttribute:@"uid" withValue:photoId.stringValue inContext:context];
    
    if (photo == nil) {
        photo = [Photo MR_createEntityInContext:context];
    }
    
    return photo;
}

- (instancetype)initWithResponse:(id)response inContext:(NSManagedObjectContext *)context {
    
    NSNumber *photoId = response[@"id"];
    
    Photo *photo = [Photo MR_findFirstByAttribute:@"uid" withValue:photoId.stringValue inContext:context];
    
    if (photo == nil) {
        photo = [Photo MR_createEntityInContext:context];
    }
    
    NSNumber *uid = response[@"id"];
    photo.uid = uid.stringValue;
    
    NSNumber *width = response[@"width"];
    photo.width = width;
    
    NSNumber *height = response[@"height"];
    photo.height = height;
    
    NSString *photoURL = nil;
    
    NSInteger maxSide  = MAX(width.integerValue, height.integerValue);
        
    if (maxSide <= 75) {
        
        photoURL = response[@"photo_75"];
        
    } else if (maxSide <= 130) {
        
        photoURL = response[@"photo_130"];
        
    } else if (maxSide <= 604) {
        
        photoURL = response[@"photo_604"];
        
    } else if (maxSide <= 807) {
        
        photoURL = response[@"photo_807"];
        
    } else if (maxSide <= 1280) {
        
        photoURL = response[@"photo_1280"];
        
    } else if (maxSide <= 2560) {
        
        photoURL = response[@"photo_2560"];
    }
    
    photo.photoURL = photoURL;
    
    return photo;
}

+ (instancetype)initWithResponse:(id)response inContext:(NSManagedObjectContext *)context {
    
    Photo *photo = [[Photo alloc] initWithResponse:response inContext:context];
    
    return photo;
    
}

- (NSURL *)url {
    
    NSString *stringURL = self.photoURL;
    NSURL *photoURL = [NSURL URLWithString:stringURL];

    return photoURL;
}


@end

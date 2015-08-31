//
//  ActivityView.m
//  vk-wall
//
//  Created by Anton Minin on 31/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "ActivityView.h"

@implementation ActivityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activity startAnimating];
        
        [self addSubview:activity];
        activity.center = self.center;
        
    }
    return self;
}

@end

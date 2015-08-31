//
//  WallOneCell.m
//  vk-wall
//
//  Created by Anton Minin on 31/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "WallOneCell.h"

@implementation WallOneCell

- (void)configureWith:(Wall *)wall {
    [super configureWith:wall];
    
    Photo *photo = wall.photos[0];
    [self.imageOne setCacheImageWithURL:photo.url];
}

- (CGFloat)calculateHeight {
    
    CGFloat height = CGRectGetMaxY(self.imageOne.frame);
    
    return height + kPadding;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

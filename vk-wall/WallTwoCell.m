//
//  WallTwoCell.m
//  vk-wall
//
//  Created by Anton Minin on 31/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "WallTwoCell.h"

@implementation WallTwoCell

- (void)configureWith:(Wall *)wall {
    [super configureWith:wall];
    
    Photo *photoOne = wall.photos[0];
    [self.imageOne setImageWithURL:photoOne.url];
    Photo *photoTwo = wall.photos[1];
    [self.imageTwo  setImageWithURL:photoTwo.url];
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

//
//  WallCell.m
//  vk-wall
//
//  Created by Anton Minin on 27/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "WallCell.h"

@implementation WallCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWith:(Wall *)wall {
    
    Profile *profile = wall.owner;
    
    self.labelName.text = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
    self.labelDate.text = wall.date.description;
    self.labelText.text = wall.text;
    
    [UIView transitionWithView:self.imageProfile duration:0.1f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.imageProfile setImageWithURL:[NSURL URLWithString:profile.photo50]];
    } completion:nil];
    
}

- (CGFloat)calculateHeight {
    return 44.f;
}

@end

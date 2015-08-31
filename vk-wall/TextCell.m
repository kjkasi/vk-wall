//
//  TextCell.m
//  vk-wall
//
//  Created by Anton Minin on 31/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "TextCell.h"

static const CGFloat kPadding = 8.f;

@implementation TextCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)calculateHeight {
    
    UIFont* font = [UIFont systemFontOfSize:17.f];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,
     shadow, NSShadowAttributeName, nil];
    
    CGSize size = CGSizeMake(CGRectGetWidth(self.labelText.bounds), CGFLOAT_MAX);
    
    CGRect rect = [self.labelText.text boundingRectWithSize:size
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:attributes
                                          context:nil];
    
    return rect.size.height + kPadding + kPadding;
}

@end

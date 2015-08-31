//
//  WallCell.h
//  vk-wall
//
//  Created by Anton Minin on 27/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Wall+Extended.h"
#import "Profile+Extended.h"
#import "Photo+Extended.h"
#import <AFNetworking/UIKit+AFNetworking.h>

static const CGFloat kPadding = 8.f;

@interface WallCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageProfile;

@property (nonatomic, weak) IBOutlet UILabel *labelName;

@property (nonatomic, weak) IBOutlet UILabel *labelDate;

@property (nonatomic, weak) IBOutlet UILabel *labelText;

@property (nonatomic, weak) IBOutlet UIImageView *imageOne;

@property (nonatomic, weak) IBOutlet UIImageView *imageTwo;

- (void)configureWith:(Wall *)wall;

- (CGFloat)calculateHeight;

@end

//
//  WallCell.h
//  vk-wall
//
//  Created by Anton Minin on 27/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Wall;

@interface WallCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageProfile;

@property (nonatomic, weak) IBOutlet UILabel *labelName;

@property (nonatomic, weak) IBOutlet UILabel *labelDate;

@property (nonatomic, weak) IBOutlet UILabel *labelText;

@property (nonatomic, weak) IBOutlet UIImageView *imageOne;

@property (nonatomic, weak) IBOutlet UIImageView *imageTwo;

@end

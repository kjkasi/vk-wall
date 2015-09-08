//
//  DetailViewController.h
//  vk-wall
//
//  Created by Anton Minin on 31/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Wall;

@interface DetailViewController : UITableViewController

@property (nonatomic, strong) Wall *wall;

@end

//
//  DetailViewController.m
//  vk-wall
//
//  Created by Anton Minin on 31/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "DetailViewController.h"

#import "Wall+Extended.h"
#import "Photo+Extended.h"
#import "TextCell.h"
#import "ImageCell.h"
#import <AFNetworking/UIKit+AFNetworking.h>

static NSString *kTextCellIdentifier = @"TextCellIdentifier";
static NSString *kImageCellIdentifier = @"ImageCellIdentifier";
static CGFloat kPadding = 8.f;

@interface DetailViewController ()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    
    self.items = [@[] mutableCopy];
    
    Wall *wall = self.wall;
    
    [self.items addObject:wall];
    [self.items addObjectsFromArray:wall.photos.array];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = self.items[indexPath.row];
    
    if ([object isKindOfClass:[Wall class]]) {
        
        Wall *wall = object;
        
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextCellIdentifier];
        cell.labelText.text = wall.text;
        
        return cell;
        
    } else {
        
        Photo *photo = object;
        
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kImageCellIdentifier];
        [cell.imagePhoto setImageWithURL:photo.url];
        
        return cell;
        
    }
    
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = self.items[indexPath.row];
    
    if ([object isKindOfClass:[Wall class]]) {
        
        Wall *wall = object;
        
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextCellIdentifier];
        cell.labelText.text = wall.text;
        
        return cell.calculateHeight;
        
    } else {
        
        Photo *photo = object;
        
        CGFloat frameWidth = CGRectGetWidth(self.view.frame);
        
        if (photo.height.floatValue > frameWidth) {
            return frameWidth;
        }
        
        return photo.height.floatValue + kPadding + kPadding;
        
    }

    
    return 44.f;
}


@end

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
        
        static NSString *cellIdentifier = @"TextCellIdentifier";
        
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.labelText.text = wall.text;
        
        return cell;
        
    } else {
        
        Photo *photo = object;
        
        static NSString *cellIdentifier = @"ImageCellIdentifier";
        
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
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
        
        CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame) - 8.f - 8.f, CGFLOAT_MAX);
        
        CGRect rect = [wall.text boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attributes
                                         context:nil];
        return rect.size.height + 8.f + 8.f;
        
        
    } else {
        
        Photo *photo = object;
        
        CGFloat frameWidth = CGRectGetWidth(self.view.frame);
        
        if (photo.height.floatValue > frameWidth) {
            return frameWidth;
        }
        
        return photo.height.floatValue + 8.f + 8.f;
        
    }

    
    return 44.f;
}


@end

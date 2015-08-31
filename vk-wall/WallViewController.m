//
//  WallViewController.m
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "WallViewController.h"

#import "ApiManager+Wall.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Wall+Extended.h"
#import "Profile.h"
#import "AccessToken.h"
#import "WallCell.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import "Photo+Extended.h"
#import "DetailViewController.h"

@interface WallViewController() <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSMutableArray *posts;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *buttonLogout;

@end

@implementation WallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.posts = [@[] mutableCopy];
    
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshWall) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self loadDataWithOffset:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)loadDataWithOffset:(NSInteger)offset {
    
    self.tableView.tableFooterView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [[ApiManager sharedManager] getWallWithOffset:offset response:^(NSError *error) {
        
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        
        self.tableView.tableFooterView = nil;
        
        if (error) {
            [[[UIAlertView alloc] initWithTitle:error.domain message:error.description delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }
    }];
}

- (void)refreshWall {
    //[Wall MR_truncateAll];
    //[Profile MR_truncateAll];
    [self loadDataWithOffset:0];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    //NSLog(@"row count%@", @([sectionInfo numberOfObjects]));
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self configureCellAtIndexPath:indexPath];
    
    return cell;
}

- (WallCell *)configureCellAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableView *tableView = self.tableView;
    
    Wall *wall = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    WallCell *cell = [tableView dequeueReusableCellWithIdentifier:wall.cellIdetifier];
    
    Profile *profile = wall.owner;
    
    cell.labelName.text = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
    cell.labelDate.text = wall.date.description;
    cell.labelText.text = wall.text;
    
    [UIView transitionWithView:cell.imageProfile duration:0.1f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.imageProfile setImageWithURL:[NSURL URLWithString:profile.photo50]];
    } completion:nil];
    
    if (wall.type == ImageTypeOne) {
        Photo *photo = wall.photos[0];
        [cell.imageOne setImageWithURL:photo.url];
    } else if (wall.type == ImageTypeTwo) {
        Photo *photoOne = wall.photos[0];
        [cell.imageOne setImageWithURL:photoOne.url];
        Photo *photoTwo = wall.photos[1];
        [cell.imageTwo  setImageWithURL:photoTwo.url];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Wall *wall = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    WallCell *cell = [self configureCellAtIndexPath:indexPath];
    
    CGFloat height = CGRectGetMaxY(cell.labelText.frame);
    
    if (wall.type == ImageTypeOne) {
        height += 78.f;
    } else if (wall.type == ImageTypeTwo) {
        height += 78.f + 8.f;
    }
    
    return height + 8.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Wall *wall = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"DetailSegueIdentifier" sender:wall];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Wall *wall = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([wall isEqual:[self.fetchedResultsController.fetchedObjects lastObject]]) {
        [self loadDataWithOffset:self.fetchedResultsController.fetchedObjects.count];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController == nil) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Wall" inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        //[fetchRequest setFetchBatchSize:20];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        _fetchedResultsController = aFetchedResultsController;
        
    }
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView.delegate tableView:tableView willDisplayCell:[tableView cellForRowAtIndexPath:indexPath] forRowAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Action

- (IBAction)actionLogout:(UIBarButtonItem *)sender {

    AccessToken *token = [[AccessToken alloc] init];
    [token clean];
    
    [self performSegueWithIdentifier:@"AuchSigueIdentifier" sender:nil];
}

#pragma mark - 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"DetailSegueIdentifier"]) {
        DetailViewController *vc = segue.destinationViewController;
        vc.wall = sender;
    }
    
}

@end

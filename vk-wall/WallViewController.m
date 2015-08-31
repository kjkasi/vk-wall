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
#import "ActivityView.h"

static NSString *kAuchSigueIdentifier = @"AuchSigueIdentifier";

static NSString *kDetailSegueIdentifier = @"DetailSegueIdentifier";

static NSString *kWallNoneCellIdentifier = @"WallNoneCellIdentifier";

static NSString *kWallOneCellIdentifier = @"WallOneCellIdentifier";

static NSString *kWallTwoCellIdentifier = @"WallTwoCellIdentifier";

@interface WallViewController() <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSMutableArray *posts;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *buttonLogout;

@property (nonatomic, assign, getter=isFirstAppear) BOOL firstAppear;

@end

@implementation WallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.posts = [@[] mutableCopy];
    
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshWall) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    self.firstAppear = YES;
    
    __weak typeof(self) weakSekf = self;
    
    [[ApiManager sharedManager] handleLogin:^{
        [weakSekf performSegueWithIdentifier:kAuchSigueIdentifier sender:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self isFirstAppear]) {
        self.firstAppear = NO;
        [self loadDataWithOffset:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)loadDataWithOffset:(NSInteger)offset {
    
    self.tableView.tableFooterView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.bounds), 44.f)];
    
    __weak typeof(self) weakSelf = self;
    
    [[ApiManager sharedManager] getWallWithOffset:offset response:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakSelf.refreshControl isRefreshing]) {
                [weakSelf.refreshControl endRefreshing];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.tableView.tableFooterView = nil;
            });
            
            if (error) {
                [[[UIAlertView alloc] initWithTitle:error.domain message:error.description delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
            }
        });
    }];
}

- (void)refreshWall {
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
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Wall *wall = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    WallCell *cell = nil;
    
    if (wall.type == ImageTypeNone) {
        cell = [tableView dequeueReusableCellWithIdentifier:kWallNoneCellIdentifier];
    } else if (wall.type == ImageTypeOne) {
        cell = [tableView dequeueReusableCellWithIdentifier:kWallOneCellIdentifier];
    } else if (wall.type == ImageTypeTwo) {
        cell = [tableView dequeueReusableCellWithIdentifier:kWallTwoCellIdentifier];
    }
    
    [cell configureWith:wall];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Wall *wall = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    WallCell *cell = nil;
    
    if (wall.type == ImageTypeNone) {
        cell = [tableView dequeueReusableCellWithIdentifier:kWallNoneCellIdentifier];
    } else if (wall.type == ImageTypeOne) {
        cell = [tableView dequeueReusableCellWithIdentifier:kWallOneCellIdentifier];
    } else if (wall.type == ImageTypeTwo) {
        cell = [tableView dequeueReusableCellWithIdentifier:kWallTwoCellIdentifier];
    }
    
    [cell configureWith:wall];
    
    return cell.calculateHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Wall *wall = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:kDetailSegueIdentifier sender:wall];
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
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
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
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    [self performSegueWithIdentifier:kAuchSigueIdentifier sender:nil];
}

#pragma mark - 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kDetailSegueIdentifier]) {
        DetailViewController *vc = segue.destinationViewController;
        vc.wall = sender;
    } else if ([segue.identifier isEqualToString:kAuchSigueIdentifier]) {
        self.firstAppear = YES;
    }
    
}

@end

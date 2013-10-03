//
//  MyPlayersViewController.m
//  MUT25 Database
//
//  Created by Trent Callan on 9/13/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import "MyPlayersViewController.h"

@interface MyPlayersViewController ()

@end

@implementation MyPlayersViewController
@synthesize myPlayersArray;
@synthesize myPlayersTableView;
@synthesize filteredMyPlayersArray;
@synthesize myPlayersSearchBar;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchDisplayController.searchBar.scopeButtonTitles = [[NSArray alloc] initWithObjects:@"Name",@"Position",@"Team",@"Overall",@"Speed",nil];
    [myPlayersSearchBar setShowsScopeBar:NO];
    [myPlayersSearchBar sizeToFit];
    filteredMyPlayersArray = [[NSMutableArray alloc] initWithCapacity:[myPlayersArray count]];
}

-(void) viewWillAppear:(BOOL)animated{
    NSData* decodedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"myPlayersEncodedData"];
    myPlayersArray = [[NSKeyedUnarchiver unarchiveObjectWithData:decodedData] mutableCopy];
    
    if ((!myPlayersArray) || ([myPlayersArray count] == 0)) {
        myPlayersArray = [[NSMutableArray alloc] initWithObjects:[[Player alloc] initWithName:@"Add Players from All Players Screen"], nil];
        
        NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:myPlayersArray];
        [[NSUserDefaults standardUserDefaults] setObject:encodedData forKey:@"myPlayersEncodedData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [myPlayersTableView reloadData];
}


#pragma mark UITableView DataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Player* tmpPlayer;
    static NSString *CellIdentifier = @"Cell";
    //////////////////////////////////////////////////// Search Related
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
    ////////////////////////////////////////////////////////////////////////////////////////////////
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tmpPlayer = [filteredMyPlayersArray objectAtIndex:indexPath.row];
    } else {
        tmpPlayer = [myPlayersArray objectAtIndex:indexPath.row];
    }

    
    PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if(cell == nil){
        cell = [[PlayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setPropertiesForPlayer:tmpPlayer];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredMyPlayersArray count];
    } else {
        return [myPlayersArray count];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PlayerCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set Background Color for Card Tier
    Player* selectedPlayer;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        selectedPlayer = [filteredMyPlayersArray objectAtIndex:indexPath.row];
    } else {
        selectedPlayer = [myPlayersArray objectAtIndex:indexPath.row];
    }
    
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"] || [[[UIDevice currentDevice] model] isEqualToString:@"iPad Simulator"]) {
        NSLog(@"will display ipad cell");
        NSLog(@"bounds width = %f", self.view.bounds.size.width);
        
        cell.teamImageView.frame = CGRectMake(0,0, 55, 43);
        cell.playerImageView.frame = CGRectMake(56,0, 55, 43);
        cell.chemistry2ImageView.frame = CGRectMake((self.view.bounds.size.width - 110),0, 55, 43);
        cell.chemistry1ImageView.frame = CGRectMake((self.view.bounds.size.width -56),0, 55, 43);
        cell.chemType1Label.frame = CGRectMake((self.view.bounds.size.width -56),6, 55, 43);;
        cell.chemType2Label.frame = CGRectMake((self.view.bounds.size.width - 109),6, 55, 43);
        cell.chemValue1Label.frame = CGRectMake((self.view.bounds.size.width -56),-7, 55, 43);;
        cell.chemValue2Label.frame = CGRectMake((self.view.bounds.size.width - 109),-7, 55, 43);
        
        cell.nameLabel.frame = CGRectMake(120, 2, (self.view.bounds.size.width - 230), 15);
        cell.detailLabel.font = [UIFont systemFontOfSize:15];
        cell.detailLabel.frame = CGRectMake(120, 25, (self.view.bounds.size.width - 230),15);
    }
    

    NSLog(@"card tier = %@",selectedPlayer.cardTier);
    
    if ([selectedPlayer.cardTier isEqualToString:@"Bronze"]) {
        NSLog(@"Bronze color set for Player: %@",[selectedPlayer name]);
        cell.backgroundColor = [UIColor brownColor];
        cell.detailLabel.textColor = [UIColor blackColor];
    }
    else if ([selectedPlayer.cardTier isEqualToString:@"Silver"]) {
        cell.backgroundColor = [UIColor grayColor];
        cell.detailLabel.textColor = [UIColor blackColor];
    }
    else if ([selectedPlayer.cardTier isEqualToString:@"Gold"]) {
        cell.backgroundColor = [UIColor yellowColor];
        cell.detailLabel.textColor = [UIColor blackColor];
    }
    else if ([selectedPlayer.cardTier isEqualToString:@"Elite"]) {
        cell.backgroundColor = [UIColor colorWithRed:256 green:0 blue:0 alpha:.75];
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.detailLabel.textColor = [UIColor whiteColor];
    }
    else if ([selectedPlayer.cardTier isEqualToString:@"Legendary"]) {
        cell.backgroundColor = [UIColor blueColor];
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.detailLabel.textColor = [UIColor whiteColor];
    }
    else if ([selectedPlayer.cardTier isEqualToString:@"Fantasy"]) {
        cell.backgroundColor = [UIColor greenColor];
        cell.detailLabel.textColor = [UIColor blackColor];
    }
    else{
        NSLog(@"white color set for Player: %@",[selectedPlayer name]);
        cell.backgroundColor = [UIColor whiteColor];
    }
    
}




#pragma mark UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //////////////////////////////////////////////////// Search Related ///////////////////////////////////
    int sentFromSearchTableView = 0;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        sentFromSearchTableView = 1;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:sentFromSearchTableView  forKey:@"sentFromSearchTableView"];
    NSData* encodedFilteredArray = [NSKeyedArchiver archivedDataWithRootObject:filteredMyPlayersArray];
    [[NSUserDefaults standardUserDefaults] setObject:encodedFilteredArray forKey:@"filteredMyPlayersArray"];
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"rowSelected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"row selected on table = %d", indexPath.row);
    [tableView deselectRowAtIndexPath: indexPath animated:YES];
    [self performSegueWithIdentifier:@"NAVmyPlayersToDetailSegue" sender:self];
    

    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            Player* currentlySelectedPlayer = [filteredMyPlayersArray objectAtIndex:indexPath.row];
            for (int i = 0; i < [myPlayersArray count]; i++) {
                if (([currentlySelectedPlayer.chemistryValueArray isEqualToArray: [[myPlayersArray objectAtIndex:i] chemistryValueArray]]) && ([currentlySelectedPlayer.chemistryTypeArray isEqualToArray:[[myPlayersArray objectAtIndex:i] chemistryTypeArray]]) && ([currentlySelectedPlayer.name isEqualToString:[[myPlayersArray objectAtIndex:i] name]])) {
                    NSLog(@"deleted %@",currentlySelectedPlayer.name);
                    [myPlayersArray removeObjectAtIndex:i];
                    [filteredMyPlayersArray removeObjectAtIndex:indexPath.row];
                }
            }
        } else {
            [myPlayersArray removeObjectAtIndex:indexPath.row];
        }
        
        
        NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:myPlayersArray];
        [[NSUserDefaults standardUserDefaults] setObject:encodedData forKey:@"myPlayersEncodedData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.searchDisplayController.searchResultsTableView reloadData];
        [myPlayersTableView reloadData];
        
        
    }
}

#pragma mark UISearchBarDelegate Methods

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    myPlayersSearchBar.showsScopeBar = YES;
    [filteredMyPlayersArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.name beginswith[c] %@) OR (SELF.position beginswith[c] %@) OR (SELF.team beginswith[c] %@) OR (ANY SELF.chemistryTypeArray beginswith[c] %@)",searchText,searchText,searchText, searchText];
    filteredMyPlayersArray = [NSMutableArray arrayWithArray:[myPlayersArray filteredArrayUsingPredicate:predicate]];
    
    //if ([searchText isEqualToString:@"all"] || [searchText isEqualToString:@"ALL"]) {
    //    filteredMyPlayersArray = myPlayersArray;
    //}
    
    
    if ([scope isEqualToString:@"Name"]) {
    }
    else if ([scope isEqualToString:@"Overall"]) {
        
        
        NSSortDescriptor* overallSort = [NSSortDescriptor sortDescriptorWithKey:@"overall" ascending:YES];
        [filteredMyPlayersArray sortUsingDescriptors:[NSArray arrayWithObject:overallSort]];
        [self.searchDisplayController.searchResultsTableView reloadData];
        
    }
    else if ([scope isEqualToString:@"Speed"]) {
        
        
        NSSortDescriptor* speedSort = [NSSortDescriptor sortDescriptorWithKey:@"speed" ascending:NO];
        [filteredMyPlayersArray sortUsingDescriptors:[NSArray arrayWithObject:speedSort]];
        [self.searchDisplayController.searchResultsTableView reloadData];
        
    }
    else if ([scope isEqualToString:@"Position"]) {
        NSSortDescriptor* posSort = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
        [filteredMyPlayersArray sortUsingDescriptors:[NSArray arrayWithObject:posSort]];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
    else if ([scope isEqualToString:@"Team"]) {
        NSSortDescriptor* teamSort = [NSSortDescriptor sortDescriptorWithKey:@"team" ascending:YES];
        [filteredMyPlayersArray sortUsingDescriptors:[NSArray arrayWithObject:teamSort]];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }

}


#pragma mark UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}




#pragma mark Unload Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyPlayersTableView:nil];
    [super viewDidUnload];
}
@end

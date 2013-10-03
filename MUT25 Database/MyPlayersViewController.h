//
//  MyPlayersViewController.h
//  MUT25 Database
//
//  Created by Trent Callan on 9/13/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "PlayerCell.h"

@interface MyPlayersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,UITextFieldDelegate>

@property NSMutableArray* myPlayersArray;
@property NSMutableArray* filteredMyPlayersArray;
@property (strong, nonatomic) IBOutlet UISearchBar *myPlayersSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *myPlayersTableView;

@end

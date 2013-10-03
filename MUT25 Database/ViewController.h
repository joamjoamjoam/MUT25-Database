//
//  ViewController.h
//  MUT25 Database
//
//  Created by Trent Callan on 9/7/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "player.h"
#import "PlayerCell.h"


@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
@property NSMutableArray* playerArray;
@property (strong, nonatomic) IBOutlet UITableView *playerTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *allPlayersSearchBar;
@property (strong, nonatomic) NSMutableArray* filteredAllPlayersArray;

@end

//
//  AllPlayerDetailViewController.h
//  MUT25 Database
//
//  Created by Trent Callan on 9/11/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "TFHpple.h"

@interface AllPlayerDetailViewController : UIViewController 
@property (strong, nonatomic) IBOutlet UIWebView *cardWebView;
@property (strong, nonatomic) IBOutlet UIWebView *statsWebView;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *coinsLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong,nonatomic) NSMutableArray* playerArray;
@property (strong, nonatomic) NSMutableArray* filteredAllPlayersArray;
@property (strong, nonatomic) NSMutableArray* filteredMyPlayersArray;
@property (strong, nonatomic) NSMutableArray* myPlayersArray;
@property (strong, nonatomic) Player* currentlySelectedPlayer;

- (IBAction)addButtonPressed:(id)sender;
- (void) parseSuggestedPrice;
@end

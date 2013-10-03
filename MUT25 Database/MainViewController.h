//
//  MainViewController.h
//  MUT25 Database
//
//  Created by Trent Callan on 9/11/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "TFHpple.h"
#import "player.h"
#import "PlayerCell.h"

@interface MainViewController : UIViewController
@property int currentLastPage;
@property NSMutableArray* playerArray;
@property (strong, nonatomic) IBOutlet UILabel *firstRunLabel2;
@property (strong, nonatomic) IBOutlet UILabel *firstRunLabel1;
@property (strong, nonatomic) IBOutlet UIProgressView *updateProgressView;
@property (strong, nonatomic) IBOutlet UIButton *myPlayersButton;
@property (strong, nonatomic) IBOutlet UIButton *allPlayersButton;
@property (strong, nonatomic) IBOutlet UIButton *updateDatabaseButton;
@property (strong, nonatomic) UIAlertView* alert;

- (IBAction)updateButtonPressed:(id)sender;
-(BOOL)testForInternetConnection;
-(void)prepareViewforUpdateDatabase;
-(void)resetView;
-(int) parsePageNumber;
-(NSMutableArray*) parsePlayersThroughPage: (int)page;
@end

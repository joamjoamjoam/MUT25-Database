//
//  PlayerCell.h
//  MUT25 Database
//
//  Created by Trent Callan on 9/9/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface PlayerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *teamImageView;
@property (strong, nonatomic) IBOutlet UIImageView *playerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *chemistry2ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *chemistry1ImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *chemValue2Label;
@property (strong, nonatomic) IBOutlet UILabel *chemType2Label;
@property (strong, nonatomic) IBOutlet UILabel *chemValue1Label;
@property (strong, nonatomic) IBOutlet UILabel *chemType1Label;


-(void)setPropertiesForPlayer: (Player*)playerForCell;
@end

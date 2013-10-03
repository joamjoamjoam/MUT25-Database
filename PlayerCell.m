//
//  PlayerCell.m
//  MUT25 Database
//
//  Created by Trent Callan on 9/9/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import "PlayerCell.h"

@implementation PlayerCell
@synthesize teamImageView;
@synthesize playerImageView;
@synthesize chemistry2ImageView;
@synthesize chemistry1ImageView;
@synthesize nameLabel;
@synthesize detailLabel;
@synthesize chemType1Label;
@synthesize chemType2Label;
@synthesize chemValue1Label;
@synthesize chemValue2Label;


-(void)setPropertiesForPlayer: (Player*)playerForCell{
    
    NSString* deviceString = [[UIDevice currentDevice] model];
    
    //Blank out Reusable Cells
    chemistry1ImageView.image = [UIImage imageNamed:@"blankImage.png"];
    chemistry2ImageView.image = [UIImage imageNamed:@"blankImage.png"];
    chemistry2ImageView.hidden = NO;
    chemistry1ImageView.hidden = NO;
    self.nameLabel.textColor = [UIColor blackColor];
    self.detailLabel.textColor = [UIColor lightGrayColor];
    self.chemType1Label.text = @"";
    self.chemType2Label.text = @"";
    self.chemValue1Label.text = @"";
    self.chemValue2Label.text = @"";
    self.userInteractionEnabled = YES;

    // Handle User Input on Add Players Cell
    if ([playerForCell.name isEqualToString: @"Add Players from All Players Screen"]) {
        nameLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:9];
        self.userInteractionEnabled = NO;
    }
    
    
    teamImageView.image = playerForCell.teamImage;
    playerImageView.image = playerForCell.playerImage;
    // set Chemistry Image
    for (int i = 0; i < [playerForCell.chemistryTypeArray count]; i++) {
        
        
        
        
        if([[[playerForCell chemistryTypeArray] objectAtIndex:i] isEqualToString:@"RS"]  || [[[playerForCell chemistryTypeArray] objectAtIndex:i] isEqualToString:@"MD"] || [[[playerForCell chemistryTypeArray] objectAtIndex:i] isEqualToString:@"ZD"] || [[[playerForCell chemistryTypeArray] objectAtIndex:i] isEqualToString:@"PR"])
        {
            if (i == 0) {
                
                if (![[[playerForCell chemistryValueArray] objectAtIndex:i] isEqualToString:@""]) {
                    chemistry1ImageView.image = [UIImage imageNamed:@"chemGold.png"];
                    chemValue1Label.text = [[playerForCell chemistryValueArray] objectAtIndex:i];
                    chemType1Label.text = [[playerForCell chemistryTypeArray] objectAtIndex:i];
                    chemValue2Label.hidden = YES;
                    chemType2Label.hidden = YES;
                    chemistry2ImageView.hidden = YES;
                }
                
                
            }
            else if (i == 1){
                chemistry2ImageView.hidden = NO;
                chemistry2ImageView.image = [UIImage imageNamed:@"chemGold.png"];
                
                chemValue2Label.hidden = NO;
                chemType2Label.hidden = NO;
                
                chemValue2Label.text = [[playerForCell chemistryValueArray] objectAtIndex:i];
                chemType2Label.text = [[playerForCell chemistryTypeArray] objectAtIndex:i];
                
            }
            else{
            }
        }
        else{
            if (i == 0) {
                
                if (![[[playerForCell chemistryValueArray] objectAtIndex:i] isEqualToString:@""]){
                    chemistry1ImageView.image = [UIImage imageNamed:@"chemBlue.png"];
                    chemValue1Label.text = [[playerForCell chemistryValueArray] objectAtIndex:i];
                    chemType1Label.text = [[playerForCell chemistryTypeArray] objectAtIndex:i];
                    chemValue2Label.hidden = YES;
                    chemType2Label.hidden = YES;
                    chemistry2ImageView.hidden = YES;
                }
            }
            else if (i == 1){
                chemistry2ImageView.hidden = NO;
                chemistry2ImageView.image = [UIImage imageNamed:@"chemGold.png"];
                
                chemValue2Label.hidden = NO;
                chemType2Label.hidden = NO;
                
                chemValue2Label.text = [[playerForCell chemistryValueArray] objectAtIndex:i];
                chemType2Label.text = [[playerForCell chemistryTypeArray] objectAtIndex:i];
            }
            else{
            }
        }
    }
    
    
    nameLabel.text = playerForCell.name;
    if ([deviceString isEqualToString:@"iPad Simulator"] || [deviceString isEqualToString:@"iPad"]){
        if (playerForCell.price == 0) {
            
            detailLabel.text = [[NSString alloc] initWithFormat:@"Pos: %@, OVR: %d, AWR: %d, SPD: %d, ACC: %d, AGI: %d, STR: %d",playerForCell.position,playerForCell.overall,playerForCell.awareness,playerForCell.speed,playerForCell.acceleration,playerForCell.agility,playerForCell.strength];
        }
        else{
            detailLabel.text = [[NSString alloc] initWithFormat:@"Pos: %@, OVR: %d, AWR: %d, SPD: %d, ACC: %d, AGI: %d, STR: %d Price: %d",playerForCell.position,playerForCell.overall,playerForCell.awareness,playerForCell.speed,playerForCell.acceleration,playerForCell.agility,playerForCell.strength,playerForCell.price];
        }
    }
    else{
        if (playerForCell.price == 0) {
            detailLabel.text = [[NSString alloc] initWithFormat:@"Pos:%@, OVR:%d",playerForCell.position,playerForCell.overall];
        }
        else{
            detailLabel.text = [[NSString alloc] initWithFormat:@"Pos:%@, Price:%d",playerForCell.position,playerForCell.price];
        }
    }
    if ([playerForCell.name isEqualToString:@"Add Players from All Players Screen"]) {
        detailLabel.text = @"Add Players For Stats";
    }
    
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end

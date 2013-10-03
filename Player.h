//
//  player.h
//  MUT25 Database
//
//  Created by Trent Callan on 9/8/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject <NSCoding>
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* position;
@property (strong, nonatomic) NSString* number;
@property (strong, nonatomic) NSString* team;
@property (strong, nonatomic) UIImage* teamImage;
@property (strong, nonatomic) UIImage* playerImage;
@property (strong, nonatomic) NSString* cardTier;
@property (strong, nonatomic) NSMutableArray* chemistryValueArray;
@property (strong, nonatomic) NSMutableArray* chemistryTypeArray;
@property (strong, nonatomic) NSURL* descURL;
@property (nonatomic) int price;
@property int overall;
@property int awareness;
@property int speed;
@property int acceleration;
@property int agility;
@property int strength;


-(void)encodeWithCoder: (NSCoder*)encoder;
-(id)initWithCoder: (NSCoder*)decoder;
-(id)initWithName: (NSString*)playerName;


@end

//
//  player.m
//  MUT25 Database
//
//  Created by Trent Callan on 9/8/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import "Player.h"

@implementation Player
@synthesize name;
@synthesize position;
@synthesize number;
@synthesize team;
@synthesize teamImage;
@synthesize playerImage;
@synthesize cardTier;
@synthesize chemistryValueArray;
@synthesize chemistryTypeArray;
@synthesize overall;
@synthesize awareness;
@synthesize speed;
@synthesize acceleration;
@synthesize agility;
@synthesize strength;
@synthesize descURL;
@synthesize price;

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeObject:position forKey:@"position"];
    [encoder encodeObject:number forKey:@"number"];
    [encoder encodeObject:team forKey:@"team"];
    [encoder encodeObject:teamImage forKey:@"teamImage"];
    [encoder encodeObject:playerImage forKey:@"playerImage"];
    [encoder encodeObject:cardTier forKey:@"cardTier"];
    [encoder encodeObject:chemistryValueArray forKey:@"chemistryValueArray"];
    [encoder encodeObject:chemistryTypeArray forKey:@"chemistryTypeArray"];
    [encoder encodeInt:overall forKey:@"overall"];
    [encoder encodeInt:awareness forKey:@"awareness"];
    [encoder encodeInt:speed forKey:@"speed"];
    [encoder encodeInt:acceleration forKey:@"acceleration"];
    [encoder encodeInt:agility forKey:@"agility"];
    [encoder encodeInt:strength forKey:@"strength"];
    [encoder encodeObject:descURL forKey:@"descURL"];
    [encoder encodeInt:price forKey:@"price"];

    
}

-(id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    
    if(self){
        name =  [decoder decodeObjectForKey:@"name"];
        position =  [decoder decodeObjectForKey:@"position"];
        number =  [decoder decodeObjectForKey:@"number"];
        team =  [decoder decodeObjectForKey:@"team"];
        teamImage =  [decoder decodeObjectForKey:@"teamImage"];
        playerImage =  [decoder decodeObjectForKey:@"playerImage"];
        cardTier =  [decoder decodeObjectForKey:@"cardTier"];
        chemistryValueArray =  [decoder decodeObjectForKey:@"chemistryValueArray"];
        chemistryTypeArray =  [decoder decodeObjectForKey:@"chemistryTypeArray"];
        overall =  [decoder decodeIntForKey:@"overall"];
        awareness =  [decoder decodeIntForKey:@"awareness"];
        speed =  [decoder decodeIntForKey:@"speed"];
        acceleration = [decoder decodeIntForKey:@"acceleration"];
        agility =  [decoder decodeIntForKey:@"agility"];
        strength =  [decoder decodeIntForKey:@"strength"];
        descURL = [decoder decodeObjectForKey:@"descURL"];
        price = [decoder decodeIntForKey:@"price"];
    }
    return self;
}

-(id)initWithName: (NSString*)playerName{
    self = [super init];
    
    if(self){
        name = playerName;
    }
    
    return self;
}

-(NSString*) description{
    
    return name;
}

@end

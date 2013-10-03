//
//  MainViewController.m
//  MUT25 Database
//
//  Created by Trent Callan on 9/11/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import "MainViewController.h"





@interface MainViewController ()

@end

@implementation MainViewController
@synthesize currentLastPage;
@synthesize playerArray;
@synthesize firstRunLabel1;
@synthesize firstRunLabel2;
@synthesize updateProgressView;
@synthesize updateDatabaseButton;
@synthesize myPlayersButton;
@synthesize allPlayersButton;
@synthesize alert;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbarHidden = YES;
        
    
}
-(void) viewDidAppear:(BOOL)animated{
    
    //NSLog(@"internet status = %d", [self testForInternetConnection]);
    
    //if (![self testForInternetConnection]) {
        
        //alert = [[UIAlertView alloc] initWithTitle:@"No Connection" message:@"You need to be Connected to the Internet to use this Application. Please Close the Application." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      //  [alert show];
        
    //}
   // else{
    //}
    
    
    NSData* decodedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"encodedData"];
    playerArray = [[NSKeyedUnarchiver unarchiveObjectWithData:decodedData] mutableCopy];
    
    if (playerArray) {
        NSLog(@"button = %@", myPlayersButton);
        NSLog(@"Not First Run");
        NSData* decodedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"encodedData"];
        playerArray = [[NSKeyedUnarchiver unarchiveObjectWithData:decodedData] mutableCopy];
        //NSLog(@"Player Array = %@", playerArray);
    }
    else{
        NSLog(@"First Run");
        //NSLog(@"%@", updateProgressView);
        //[self prepareViewforUpdateDatabase];
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //    NSMutableArray* tmpArray = [self parsePlayersThroughPage:currentLastPage];
        //
        //    dispatch_async(dispatch_get_main_queue(), ^{
        //        playerArray = tmpArray;
        //    });
            
        //});
        
    }
}



#pragma mark User Methods
-(void)resetView{
    NSLog(@"View Reset");
    NSLog(@"button = %@", myPlayersButton);
    myPlayersButton.hidden = NO;
    allPlayersButton.hidden = NO;
    updateDatabaseButton.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    firstRunLabel1.hidden = YES;
    firstRunLabel2.hidden = YES;
    updateProgressView.hidden = YES;
    
}

-(void)prepareViewforUpdateDatabase{
    NSLog(@"View Prepared");
    NSLog(@"button = %@", updateProgressView);
    myPlayersButton.hidden = YES;
    allPlayersButton.hidden = YES;
    updateDatabaseButton.hidden = YES;
    self.view.backgroundColor = [UIColor blueColor];
    firstRunLabel1.hidden = NO;
    firstRunLabel2.hidden = NO;
    updateProgressView.hidden = NO;
    [[self view] setNeedsDisplay];
}

-(int) parsePageNumber{
    int lastPage=0;
    int tmp=0;
    
    
    NSURL* pageEnd = [NSURL URLWithString:@"http://www.muthead.com/25/players"];
    NSData* htmlData = [NSData dataWithContentsOfURL:pageEnd];
    TFHpple* pageParser = [TFHpple hppleWithHTMLData:htmlData];
    NSString* pageQueryString = @"//li[@class='b-pagination-item']/a";
    NSArray* nodesArray = [pageParser searchWithXPathQuery:pageQueryString];
    for (TFHppleElement* element in nodesArray) {
        NSLog(@"%@",[[element firstChild] content]);
        
        if([[[element firstChild] content] isEqualToString:@"Next"]){
            lastPage = tmp;
            break;
        }
        else{
            tmp = [[[element firstChild] content] intValue];
        }
    }
    //lastPage = 2;
    return lastPage;
}

-(NSMutableArray*) parsePlayersThroughPage: (int)page{
    NSMutableArray* tmpArray = [[NSMutableArray alloc] initWithCapacity:0];
    CFTimeInterval startTime = CFAbsoluteTimeGetCurrent();
    currentLastPage = [self parsePageNumber];
    int progressIncrements = 100/currentLastPage;
    
    for (int i = 1; i <= page; i++) {
        
        NSLog(@"current page is: %d",i);
        
        NSURL* currentPage = [NSURL URLWithString:[[NSString alloc] initWithFormat: @"http://www.muthead.com/25/players?page=%d", i]];
        NSData* htmlData = [NSData dataWithContentsOfURL:currentPage];
        TFHpple* pageParser = [TFHpple hppleWithHTMLData:htmlData];
        
        NSString* nodeQueryString = @"//tbody/tr";
        NSArray* nodesArray = [pageParser searchWithXPathQuery:nodeQueryString];
        for (TFHppleElement* element in nodesArray) {
            
            
            Player* tmpPlayer = [[Player alloc] init];
            
            // Parse Player Image
            NSString* tmpPlayerImage = @"http://www.muthead.com";
            tmpPlayerImage = [[[[element firstChildWithClassName:@"col-name"] firstChildWithTagName:@"a"] firstChildWithTagName:@"img"] objectForKey:@"src"];
            NSURL *imageURL = [NSURL URLWithString:tmpPlayerImage];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *tmpImage= [UIImage imageWithData:imageData];
            
            tmpPlayer.playerImage = tmpImage;
            
            //Parse Player Name
            NSString* tmpName = [[[[[element firstChildWithClassName:@"col-name"] firstChildWithTagName:@"a"] childrenWithTagName:@"text"] objectAtIndex:([[[[element firstChildWithClassName:@"col-name"] firstChildWithTagName:@"a"] childrenWithTagName:@"text"] count]-1)] content];
            tmpName = [tmpName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSLog(@"Name = %@", tmpName);
            tmpPlayer.name = tmpName;
            
            //Parse Card Tier
            NSString* tmpCardTier = [[[element firstChildWithClassName:@"col-name"] firstChildWithTagName:@"span"] objectForKey:@"class"];
            if ([tmpCardTier isEqualToString:@"t1"]) {
                tmpCardTier = @"Bronze";
            }
            else if ([tmpCardTier isEqualToString:@"t2"]) {
                tmpCardTier = @"Silver";
            }
            else if ([tmpCardTier isEqualToString:@"t3"]) {
                tmpCardTier = @"Gold";
            }
            else if ([tmpCardTier isEqualToString:@"t4"]) {
                tmpCardTier = @"Elite";
            }
            else if ([tmpCardTier isEqualToString:@"t5"]) {
                tmpCardTier = @"Legendary";
            }
            else if ([tmpCardTier isEqualToString:@"t9"]){
                tmpCardTier = @"Fantasy";
            }
            else{
                tmpCardTier = @"";
            }
            NSLog(@"Card Tier = %@", tmpCardTier);
            tmpPlayer.cardTier = tmpCardTier;
            
            
            //Parse Position
            NSString* tmpPosition = [[element firstChildWithClassName:@"col-position"] text];
            NSLog(@"position = %@", tmpPosition);
            tmpPlayer.position = tmpPosition;
            
            // Parse Player Number
            NSString* tmpPlayerNumber = [[element firstChildWithClassName:@"col-number"] text];
            NSLog(@"Number = %@",tmpPlayerNumber);
            tmpPlayer.number = tmpPlayerNumber;
            
            //Parse Team Name
            NSString* tmpTeamName = [[[[[element firstChildWithClassName:@"col-team"] firstChildWithTagName:@"a"] childrenWithTagName:@"text"] objectAtIndex:([[[[element firstChildWithClassName:@"col-team"] firstChildWithTagName:@"a"] childrenWithTagName:@"text"] count]-1)] content];
            NSLog(@"Team Name = %@",tmpTeamName);
            
            tmpPlayer.team = tmpTeamName;
            
            //Parse Team Image
            NSString* tmpTeamImage = [[[[element firstChildWithClassName:@"col-team"] firstChildWithTagName:@"a"] firstChildWithTagName:@"img"] objectForKey:@"src"];
            imageURL = [NSURL URLWithString:tmpTeamImage];
            imageData = [NSData dataWithContentsOfURL:imageURL];
            tmpImage = [UIImage imageWithData:imageData];
            if (!tmpImage) {
                if ([[tmpPlayer team] isEqualToString:@"Free Agents"]) {
                    tmpImage = [UIImage imageNamed:@"free-agent.png"];
                }
                else{
                    tmpImage = [UIImage imageNamed:@"legendsTeamImage.png"];
                }
            }
            
            tmpPlayer.teamImage = tmpImage;
            
            //Parse Overall Rating
            int tmpOverall = [[[element firstChildWithClassName:@"col-overall"] text] intValue];
            NSLog(@"Overall = %d",tmpOverall);
            
            tmpPlayer.overall = tmpOverall;
            
            //Parse Awareness Rating
            int tmpAwareness = [[[element firstChildWithClassName:@"col-awareness"] text] intValue];
            NSLog(@"Awareness = %d",tmpAwareness);
            
            tmpPlayer.awareness = tmpAwareness;
            
            //Parse Speed Rating
            int tmpSpeed = [[[element firstChildWithClassName:@"col-speed"] text] intValue];
            NSLog(@"Speed = %d",tmpSpeed);
            
            tmpPlayer.speed = tmpSpeed;
            
            //Parse Acceleration Rating
            int tmpAcceleration = [[[element firstChildWithClassName:@"col-acceleration"] text] intValue];
            NSLog(@"Acceleration = %d",tmpAcceleration);
            
            tmpPlayer.acceleration = tmpAcceleration;
            
            //Parse Agility Rating
            int tmpAgility = [[[element firstChildWithClassName:@"col-agility"] text] intValue];
            NSLog(@"Agility = %d",tmpAgility);
            
            tmpPlayer.agility = tmpAgility;
            
            //Parse Strength Rating
            int tmpStrength = [[[element firstChildWithClassName:@"col-strength"] text] intValue];
            NSLog(@"Strength = %d",tmpStrength);
            
            tmpPlayer.strength = tmpStrength;
            
            //Parse Chemistry Value
            NSMutableArray* tmpSecondLevelDivArray = [[NSMutableArray alloc] init];
            NSMutableArray* tmpSpanArray = [[NSMutableArray alloc] init];
            NSMutableArray* tmpFirstChildArray = [[NSMutableArray alloc]init];
            NSMutableArray* tmpChemValueArray = [[NSMutableArray alloc] init];
            NSArray* tmpFirstLevelDivArray = [[[element firstChildWithClassName:@"col-chem"] firstChildWithTagName:@"div"] childrenWithTagName:@"div"];
            
            for (int j =0; j<[tmpFirstLevelDivArray count]; j++) {
                [tmpSecondLevelDivArray addObject:[[tmpFirstLevelDivArray objectAtIndex:j] firstChildWithTagName:@"div"]];
                [tmpSpanArray addObject:[[tmpSecondLevelDivArray objectAtIndex:j] firstChildWithClassName:@"chem-amount"]];
                [tmpFirstChildArray addObject:[[tmpSpanArray objectAtIndex:j] firstChild]];
                [tmpChemValueArray addObject:[[tmpFirstChildArray objectAtIndex:j]content]];
            }
            if (![tmpChemValueArray count]) {
                NSLog(@"Empty Chem Value %d", [tmpChemValueArray count]);
                // [tmpChemValueArray addObject:@"hi"];
            }
            NSLog(@"Chem Value = %@",tmpChemValueArray);
            
            tmpPlayer.chemistryValueArray = tmpChemValueArray;
            
            //Parse Chemestry Type
            tmpSecondLevelDivArray = [[NSMutableArray alloc] init];
            tmpSpanArray = [[NSMutableArray alloc] init];
            tmpFirstChildArray = [[NSMutableArray alloc]init];
            NSMutableArray* tmpChemTypeArray = [[NSMutableArray alloc] init];
            tmpFirstLevelDivArray = [[[element firstChildWithClassName:@"col-chem"] firstChildWithTagName:@"div"] childrenWithTagName:@"div"];
            
            for (int j =0; j<[tmpFirstLevelDivArray count]; j++) {
                [tmpSecondLevelDivArray addObject:[[tmpFirstLevelDivArray objectAtIndex:j] firstChildWithTagName:@"div"]];
                [tmpSpanArray addObject:[[tmpSecondLevelDivArray objectAtIndex:j] firstChildWithClassName:@"chem-type"]];
                [tmpFirstChildArray addObject:[[tmpSpanArray objectAtIndex:j] firstChild]];
                [tmpChemTypeArray addObject:[[tmpFirstChildArray objectAtIndex:j]content]];
            }
            if (![tmpChemTypeArray count]) {
                NSLog(@"Empty Chem Type");
            }
            NSLog(@"Chem Type = %@",tmpChemTypeArray);
            
            tmpPlayer.chemistryTypeArray = tmpChemTypeArray;
            
            
            // Scrape Individual Player URLs
            NSString* tmpURL = [[NSString alloc] initWithFormat:@"http://www.muthead.com%@",[[[[element firstChildWithClassName:@"col-name"] firstChildWithTagName:@"a"] attributes] objectForKey:@"href"]];
            tmpPlayer.descURL = [NSURL URLWithString:tmpURL];
            
            NSLog(@"tmpURL = %@", tmpURL);
            
            // add player to array
            [tmpArray addObject:tmpPlayer];
        }
        
        updateProgressView.progress+= progressIncrements;
        
        
        
    }
    NSSortDescriptor* AtoZ = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [tmpArray sortUsingDescriptors:[NSArray arrayWithObject:AtoZ]];
    //persist tmpArray to plist
    
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:tmpArray];
    [[NSUserDefaults standardUserDefaults] setObject:encodedData forKey:@"encodedData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    NSLog(@"Scrape Time in Seconds = %f", (CFAbsoluteTimeGetCurrent() - startTime));
    [self resetView];
    return tmpArray;
}

-(BOOL)testForInternetConnection{
   // Reachability* reachability = [Reachability reachabilityWithHostname:@"http://www.muthead.com"];
   // NetworkStatus networkStatus = [reachability currentReachabilityStatus];
   // return !(networkStatus == NotReachable);
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.muthead.com/"]
                              
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                              
                                          timeoutInterval:2.0];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        return YES;
        
    } else {
        
        return NO;
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (![self testForInternetConnection]) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"No Connection" message:@"You need to be Connected to the Internet to use this Application. Please Close the Application." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
#pragma mark IBAction Methods

- (IBAction)updateButtonPressed:(id)sender {
    [self prepareViewforUpdateDatabase];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray* tmpArray = [self parsePlayersThroughPage:currentLastPage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            playerArray = tmpArray;
        });
        
    });
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFirstRunLabel2:nil];
    [self setFirstRunLabel1:nil];
    [self setUpdateProgressView:nil];
    [self setMyPlayersButton:nil];
    [self setAllPlayersButton:nil];
    [self setUpdateDatabaseButton:nil];
    [super viewDidUnload];
}
@end

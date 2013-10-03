//
//  AllPlayerDetailViewController.m
//  MUT25 Database
//
//  Created by Trent Callan on 9/11/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import "AllPlayerDetailViewController.h"

@interface AllPlayerDetailViewController ()

@end

@implementation AllPlayerDetailViewController
@synthesize playerArray;
@synthesize cardWebView;
@synthesize statsWebView;
@synthesize currentlySelectedPlayer;
@synthesize myPlayersArray;
@synthesize priceTextField;
@synthesize addButton;
@synthesize priceLabel;
@synthesize coinsLabel;
@synthesize filteredAllPlayersArray;
@synthesize filteredMyPlayersArray;



- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    cardWebView.userInteractionEnabled = NO;
    cardWebView.scalesPageToFit = YES;
    statsWebView.scalesPageToFit = YES;
    statsWebView.userInteractionEnabled = NO;
    self.navigationController.toolbarHidden = YES;
    priceTextField.placeholder = @"";
    
    NSData* decodedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"encodedData"];
    playerArray = [[NSKeyedUnarchiver unarchiveObjectWithData:decodedData] mutableCopy];
    NSInteger rowSelected = [[NSUserDefaults standardUserDefaults] integerForKey:@"rowSelected"];
    
    ////////////////////////     Search Related      ////////////////////////////////////////////////////
    NSInteger sentFromSearchTableView = [[NSUserDefaults standardUserDefaults] integerForKey:@"sentFromSearchTableView"];
    
    
    NSData* filteredAllPlayersData = [[NSUserDefaults standardUserDefaults] objectForKey:@"filteredAllPlayersArray"];
    filteredAllPlayersArray = [[NSKeyedUnarchiver unarchiveObjectWithData:filteredAllPlayersData] mutableCopy];
    
    NSData* filteredMyPlayersData = [[NSUserDefaults standardUserDefaults] objectForKey:@"filteredMyPlayersArray"];
    filteredMyPlayersArray = [[NSKeyedUnarchiver unarchiveObjectWithData:filteredMyPlayersData] mutableCopy];
    
    
    NSLog(@"search int = %d and filtered array = %@",sentFromSearchTableView,filteredAllPlayersArray);
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    NSData* myPlayersDecodedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"myPlayersEncodedData"];
    myPlayersArray = [[NSKeyedUnarchiver unarchiveObjectWithData:myPlayersDecodedData] mutableCopy];
    
    
    if ([NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 2)] class]) isEqualToString:@"ViewController"]) {
        ////////////////////////     Search Related      ////////////////////////////////////////////////////
        if(sentFromSearchTableView){
            NSLog(@"sent from search view = YES");
            currentlySelectedPlayer = [filteredAllPlayersArray objectAtIndex:rowSelected];
            ///////////////////////////////////////////////////////////////////////////////
        }
        else{
            currentlySelectedPlayer = [playerArray objectAtIndex:rowSelected];
        }
    }
    else{
        ////////////////////////     Search Related      ////////////////////////////////////////////////////
        if(sentFromSearchTableView){
            NSLog(@"sent from search view = YES");
            NSLog(@"filtered array = %@",filteredMyPlayersArray);
            currentlySelectedPlayer = [filteredMyPlayersArray objectAtIndex:rowSelected];
            ///////////////////////////////////////////////////////////////////////////////
        }
        else{
            currentlySelectedPlayer = [myPlayersArray objectAtIndex:rowSelected];
        }
    }
    
    
    //NSLog(@"rowSelected Loaded = %d", rowSelected);
    //NSLog(@"URL Loaded = %@",[[playerArray objectAtIndex:rowSelected] descURL]);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[currentlySelectedPlayer descURL]];
    [self parseSuggestedPrice];
    [cardWebView loadRequest:request];
    [statsWebView loadRequest:request];
    
}

- (void)webViewDidFinishLoad: (UIWebView *)webView {
    
    NSString* deviceString = [[UIDevice currentDevice] model];
    if ([deviceString isEqualToString:@"iPad"] || [deviceString isEqualToString:@"iPad Simulator"]) {
        NSLog(@"fsdfsd");
        [[cardWebView scrollView] setContentOffset:CGPointMake(10, 190) animated:NO];
    }
    else{
        priceTextField.hidden = NO;
        priceLabel.hidden = NO;
        coinsLabel.hidden = NO;
        
        [[cardWebView scrollView] zoomToRect:CGRectMake(5, 103, 0, 85) animated:NO];
        [[statsWebView scrollView] setContentOffset:CGPointMake(0, 195) animated:NO];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCardWebView:nil];
    [self setStatsWebView:nil];
    [self setPriceTextField:nil];
    [self setAddButton:nil];
    [self setPriceLabel:nil];
    [self setCoinsLabel:nil];
    [super viewDidUnload];
}

- (void) parseSuggestedPrice{
    NSData* htmlData = [NSData dataWithContentsOfURL:[currentlySelectedPlayer descURL]];
    TFHpple* pageParser = [TFHpple hppleWithHTMLData:htmlData];
    NSString* pageQueryString = @"//ul[@class='platforms']";
    NSArray* nodesArray = [pageParser searchWithXPathQuery:pageQueryString];
    
    for (TFHppleElement* element in nodesArray) {
        NSString* tmpPricePS3 = [[element firstChildWithClassName:@"ps3"] text];
        NSString* tmpPrice360 =[[element firstChildWithClassName:@"xbox"] text];
        
        NSLog(@"price ps3 = %@", tmpPricePS3);
        
        if(currentlySelectedPlayer.price == 0){
            priceTextField.placeholder = [NSString stringWithFormat:@"ps3: %@ Xbox: %@", tmpPricePS3,tmpPrice360];
        }
        else{
            priceTextField.text = [[NSString alloc] initWithFormat:@"%d", currentlySelectedPlayer.price ];
        }
        
    }
}

- (IBAction)addButtonPressed:(id)sender {
    BOOL shouldAddObject = YES;
    UIAlertView* alert;
    if ((!myPlayersArray) || ([myPlayersArray count] == 0)) {
        NSLog(@"if1 ran");
        myPlayersArray = [[NSMutableArray alloc] initWithObjects:[[Player alloc] initWithName:@"Add Players from All Players Screen"], nil];
    }
    if ([[[myPlayersArray objectAtIndex:0] name] isEqualToString:@"Add Players from All Players Screen"]) {
        [myPlayersArray removeAllObjects];
    }
    for (int i = 0; i < [myPlayersArray count]; i++) {
        if ((([currentlySelectedPlayer.chemistryValueArray isEqualToArray: [[myPlayersArray objectAtIndex:i] chemistryValueArray]]) && ([currentlySelectedPlayer.chemistryTypeArray isEqualToArray:[[myPlayersArray objectAtIndex:i] chemistryTypeArray]])) && ([currentlySelectedPlayer.name isEqualToString:[[myPlayersArray objectAtIndex:i] name]])){
            // if playerCard is added already just change price
            NSLog(@"ran 2");
            if ([addButton.title isEqualToString: @"Add to My Players"] || [addButton.title isEqualToString:@"Add Player With Price"]) {
                
                alert = [[UIAlertView alloc] initWithTitle:@"Player Duplicate" message:@"This Player Aready Exists in Your Player List." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            }
            else if([addButton.title isEqualToString:@"Update Price"]){
                
                alert = [[UIAlertView alloc] initWithTitle:@"Price Update" message:@"The Price has Been Updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            }
            shouldAddObject = NO;
            
            
            [[myPlayersArray objectAtIndex:i] setPrice: priceTextField.text.intValue];
        }
    }
    
    // if playerCard is not already added in myPlayersArray
    if(shouldAddObject){
        if(![priceTextField.text isEqualToString:@""]) {
            currentlySelectedPlayer.price = priceTextField.text.intValue;
        }
        alert = [[UIAlertView alloc] initWithTitle:@"Player Added" message:@"Player was added to your player database viewable from the main screen when you press the my players button." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [myPlayersArray addObject:currentlySelectedPlayer];
    }
    addButton.title = @"Add to My Players";
    [priceTextField resignFirstResponder];
    
    NSSortDescriptor* AtoZ = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [myPlayersArray sortUsingDescriptors:[NSArray arrayWithObject:AtoZ]];
    
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:myPlayersArray];
    [[NSUserDefaults standardUserDefaults] setObject:encodedData forKey:@"myPlayersEncodedData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [alert show];
    
}

#pragma mark UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    for (int i = 0; i < [myPlayersArray count]; i++) {
        if (([currentlySelectedPlayer.chemistryValueArray isEqualToArray: [[myPlayersArray objectAtIndex:i] chemistryValueArray]]) && ([currentlySelectedPlayer.chemistryTypeArray isEqualToArray:[[myPlayersArray objectAtIndex:i] chemistryTypeArray]]) && ([currentlySelectedPlayer.name isEqualToString:[[myPlayersArray objectAtIndex:i] name]])) {
            addButton.title = @"Update Price";
        }
        else{
            addButton.title = @"Add Player With Price";
        }
    }
}


@end

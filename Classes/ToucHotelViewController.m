//
//  ToucHotelViewController.m
//  PerDueCItyCard
//
//  Created by mario greco on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToucHotelViewController.h"


@implementation ToucHotelViewController
@synthesize descriptionWebView, openTHbtn, openStoreBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - bottoni view

-(IBAction)downloadFromAppStore:(id)sender{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/it/app/touchotel/id358599349?mt=8"]];
}

-(IBAction)launchThApp:(id)sender{
 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"touchotel://"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"ToucHotel";

    NSURL *infos = [NSURL URLWithString:@"http://www.cartaperdue.it/partner/toucHotelInfo.html"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:infos];
	[self.descriptionWebView loadRequest:requestObj];		
    
    [self.openTHbtn setHidden:YES];
    [self.openStoreBtn setHidden:YES];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: @"touchotel://"]]) 
    {
        //app th installata, creo pulsante per lanciare app
        
        [self.openTHbtn setHidden:NO];
        
    }
    else {        
        
        //creo pulsante per lancio app store
        [self.openStoreBtn setHidden:NO];
    }
    //@"http://itunes.apple.com/it/app/touchotel/id358599349?mt=8"
    

    
}

- (void)viewDidUnload
{
    self.openStoreBtn = nil;
    self.openTHbtn = nil;
    self.descriptionWebView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    self.openStoreBtn = nil;
    self.openTHbtn = nil;
    self.descriptionWebView = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

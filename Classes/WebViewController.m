//
//  WebViewController.m
//  PerDueCItyCard
//
//  Created by mario greco on 15/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController
@synthesize webView, urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithUrlString:(NSString *)urlStr{
    
    self = [super initWithNibName:@"WebViewController" bundle:nil];
    if(self){
        self.urlString = urlStr;
    }
    
    return self;
}

-(void)closeButtonClicked:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:139.0/255 green:29.0/255 blue:0.0 alpha:1]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Chiudi" style:UIBarButtonItemStyleBordered target:self action:@selector(closeButtonClicked:)];
    self.navigationItem.leftBarButtonItem = button;
    [button release];
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.urlString = nil;
    self.webView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    self.urlString = nil;
    self.webView = nil;
    [super dealloc];
}

@end

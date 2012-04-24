//
//  FotoIngranditaController.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FotoIngranditaController.h"
#import "Utilita.h"

@interface FotoIngranditaController () {}
@property (nonatomic, retain) NSString *imageUrl;
@end



@implementation FotoIngranditaController

@synthesize imageView=_imageView;

@synthesize imageUrl=_imageUrl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil imageUrlString:(NSString *)aUrl {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imageUrl = aUrl;
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView loadImageFromURLString:self.imageUrl];
    [self.imageView setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![Utilita networkReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
		[alert show];
        [alert release];
        return;
    }
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.imageView = nil;
}


- (void)dealloc {
    self.imageUrl = nil;
    self.imageView = nil;
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationPortrait       ||
        interfaceOrientation == UIInterfaceOrientationLandscapeRight ||
        interfaceOrientation == UIInterfaceOrientationLandscapeLeft    ) {
        return YES;
    }
    else {
        return NO;
    }
}


#pragma  mark - FotoIngranditaController (IBActions)

- (IBAction)chiudi:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end

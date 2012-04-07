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
@property (nonatomic, retain) DatabaseAccess *dbAccess;
@end



@implementation FotoIngranditaController

@synthesize imageView=_imageView, activityIndicator=_activityIndicator, couponViewController=_couponViewController;

@synthesize imageUrl=_imageUrl, dbAccess=_dbAccess;

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


+ (FotoIngranditaController *) fotoIngranditaControllerWithImageUrlString:(NSString *)aUrl delegate:(Coupon *)couponViewController {
    FotoIngranditaController *controller = [[FotoIngranditaController alloc] init];
    controller.imageUrl = aUrl;
    
    NSDictionary *proxies = [NSDictionary dictionaryWithObject:couponViewController forKey:@"delegate"];
    NSDictionary *options = [NSDictionary dictionaryWithObject:proxies forKey:UINibExternalObjects];

    [[NSBundle mainBundle] loadNibNamed:@"FotoIngranditaController" 
                                  owner:controller
                                options:options];
    return [controller autorelease];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbAccess = [[[DatabaseAccess alloc] init] autorelease];
    self.dbAccess.delegate = self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![Utilita networkReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];
        return;
    }
    if (!self.dbAccess) {
        // Se istanziamo il view controller dal metodo statico (che chiama loadNibNamed) 
        // viewDidLoad non viene chiamato, e il dbAccess non è stato istanziato.
        self.dbAccess = [[[DatabaseAccess alloc] init] autorelease];
        self.dbAccess.delegate = self;
    }
    self.imageView.alpha = 0;
    [self.activityIndicator startAnimating];
    [self.dbAccess getConnectionToURL:self.imageUrl];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    self.dbAccess.delegate = nil;
    self.dbAccess = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.imageView = nil;
    self.activityIndicator = nil;
    self.couponViewController = nil;
}


- (void)dealloc {
    self.imageUrl = nil;
    self.dbAccess.delegate = nil;
    self.dbAccess = nil;
    self.imageView = nil;
    self.activityIndicator = nil;
    self.couponViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - DatabaseAccessDelegate


- (void)didReceiveData:(NSMutableData *)data {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    UIImage *image = [[UIImage alloc] initWithData:data];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    self.imageView.image = image;
    self.imageView.alpha = 1;
    [UIView commitAnimations];
    [image release];
}


- (void)didReceiveError:(NSError *)error {
#warning implementare
}

@end

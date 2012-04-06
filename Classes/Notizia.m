//
//  Notizia.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Notizia.h"
#import "Utilita.h"

@interface Notizia () {}
@property (nonatomic, retain) NSMutableDictionary *dataModel;
@property (nonatomic, retain) DatabaseAccess *dbAccess;
@end


@implementation Notizia


@synthesize idNotizia=_idNotizia;

@synthesize dataModel=_dataModel, dbAccess=_dbAccess;


/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbAccess = [[[DatabaseAccess alloc] init] autorelease];
    self.dbAccess.delegate = self;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if (![Utilita networkReachable]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];
        return;
	}
    
    if (self.dataModel) {
        // Già ho scaricato i dati, evito di riscaricarli.
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.cartaperdue.it/partner/Notizia.php?id=%d", self.idNotizia];
	[self.dbAccess getConnectionToURL:urlString];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark - DatabaseAccessDelegate


- (void)didReceiveCoupon:(NSDictionary *)data {
    NSObject *temp = [data objectForKey:@"Esercente"];
    if (![temp isKindOfClass:[NSArray class]]) {
        return;
    }
    
    temp = [((NSArray *)temp) objectAtIndex:0];
    if (![temp isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.dataModel = (NSMutableDictionary *)temp;
    
    //titolo
    UILabel *titoloLbl = (UILabel *)[self.view viewWithTag:1];
	titoloLbl.text = [self.dataModel objectForKey:@"post_title"];
	titoloLbl.text = [titoloLbl.text stringByReplacingOccurrencesOfString:@"&#39;"  
                                                               withString:@"'"];
	titoloLbl.text = [titoloLbl.text stringByReplacingOccurrencesOfString:@"&#39"   
                                                               withString:@"'"];
	titoloLbl.text = [titoloLbl.text stringByReplacingOccurrencesOfString:@"&#146;"
                                                               withString:@"'"];
    
	//data news in navigation bar
    NSString *dataApp = [Utilita dateStringFromMySQLDate:[self.dataModel objectForKey:@"post_date"]];
	NSLog(@"%@", dataApp);
	self.title = dataApp;
    
    NSString *testoHTML = [self.dataModel objectForKey:@"post_content"];
	UIWebView *webView = (UIWebView *)[self.view viewWithTag:2];
    webView.opaque = NO;
	webView.backgroundColor = [UIColor whiteColor];
	[webView loadHTMLString:testoHTML baseURL:nil];
}


- (void)didReceiveError:(NSError *)error {
#warning implementare!
}

@end

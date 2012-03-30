//
//  Notizia.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Notizia.h"


@implementation Notizia
@synthesize rows, identificativo,webView, url;

-(int)check:(Reachability*) curReach{
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
	
	switch (netStatus){
		case NotReachable:{
			return -1;
			break;
		}
		default:
			return 0;
	}
}
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];

	url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/Notizia.php?id=%d",identificativo]];
	//NSLog(@"Url: %@", url);
	
	NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url];
	//NSLog(@"%@",jsonreturn); // Look at the console and you can see what the restults are
	
	NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;	
	dict = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error] retain];	
	//rows=[[NSMutableArray alloc] initWithObjects:[dict allObjects],nil];
	NSMutableArray *r=[[NSMutableArray alloc] init];
	if (dict)
	{
		r = [[dict objectForKey:@"Esercente"] retain];
		
	}
	
	//NSLog(@"Array: %@",r);
	
	rows=[[NSMutableArray alloc] init];
	
	[rows addObjectsFromArray: r];
	

	
	NSLog(@"Ho aggiunto %d righe",[r count]);
	NSLog(@"Rows ha %d righe",[rows count]);
	dict = [rows objectAtIndex: 0];
	
	//titolo
	titolo.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"post_title"]];
	titolo.text = [titolo.text stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
	titolo.text = [titolo.text stringByReplacingOccurrencesOfString:@"&#39" withString:@"'"];
	titolo.text = [titolo.text stringByReplacingOccurrencesOfString:@"&#146;" withString:@"'"];

	//data news in navigation bar
	NSDateFormatter *formatoapp = [[NSDateFormatter alloc] init];
	[formatoapp setDateFormat:@"dd-MM-YYYY"];
	NSString *datadb = [NSString stringWithFormat:@"%@",[dict objectForKey:@"post_date"]];
	NSDateFormatter *formatodb=[[NSDateFormatter alloc] init];
	[formatodb setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *d1=[formatodb dateFromString:datadb];
	NSString *dataapp = [formatoapp stringFromDate:d1];
	//NSLog(@"%@",dataapp);
	self.title=[NSString stringWithFormat:@"%@",dataapp];


	//contenuto html
	//NSString *impostazioniHTML =[[NSString alloc] initWithString:@"<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'><html xmlns='http://www.w3.org/1999/xhtml' dir='ltr' lang='it-IT'><head profile='http://gmpg.org/xfn/11'><meta http-equiv='Content-Type' content='text/html; charset=UTF-8' /><meta name='generator' content='Bluefish 2.0.0' /> <!-- leave this for stats --><link rel='stylesheet' href='http://cartaperdue.it/blog/wp-content/themes/naruto-strikes-back/style.css' type='text/css' media='screen' /><link rel='alternate' type='application/rss+xml' title='CartaPerDue RSS Feed' href='http://cartaperdue.it/blog/feed/' /><link rel='pingback' href='http://cartaperdue.it/blog/xmlrpc.php' /><link rel='stylesheet' id='wp-postratings-css'  href='http://cartaperdue.it/blog/wp-content/plugins/wp-postratings/postratings-css.css?ver=1.50' type='text/css' media='all' /><script type='text/javascript' src='http://cartaperdue.it/blog/wp-includes/js/jquery/jquery.js?ver=1.4.2'></script><link rel='EditURI' type='application/rsd+xml' title='RSD' href='http://cartaperdue.it/blog/xmlrpc.php?rsd' /><link rel='wlwmanifest' type='application/wlwmanifest+xml' href='http://cartaperdue.it/blog/wp-includes/wlwmanifest.xml' /><link rel='index' title='CartaPerDue' href='http://cartaperdue.it/blog/' />  <meta name='generator' content='WordPress 3.0.4' /></head>"];
	//NSString * testoHTML =[NSString stringWithFormat:@"%@<body>%@</body></html>",impostazioniHTML, [dict objectForKey:@"post_content"]];
	
	NSString * testoHTML =[NSString stringWithFormat:@"%@",[dict objectForKey:@"post_content"]];
	webView.opaque = NO;
	webView.backgroundColor = [UIColor whiteColor];
	[webView loadHTMLString:testoHTML baseURL:nil];

	
}

-(void)spinTheSpinner {
    NSLog(@"Spin The Spinner");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self performSelectorOnMainThread:@selector(doneSpinning) withObject:nil waitUntilDone:YES];
	
    [pool release]; 
}

-(void)doneSpinning {
    NSLog(@"done spinning");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(void)viewWillAppear:(BOOL)animated {
	int wifi=0;
	int internet=0;
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	internet= [self check:internetReach];
	
	wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	wifi=[self check:wifiReach];	
	if( (internet==-1) &&( wifi==-1) ){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];

	}
	
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[wifiReach release];
	[internetReach release];
    [super viewWillDisappear:animated];
	
	
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[url release];
	[webView release];
}


- (void)dealloc {
    [super dealloc];
}


@end

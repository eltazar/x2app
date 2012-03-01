//
//  Contatti.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 26/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Contatti.h"


@implementation Contatti

@synthesize close,tableview,sito,webView;

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




- (IBAction)chiudi:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)chiudisito:(id)sender{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown						   
						   forView:[self view]
							 cache:YES];
	
	[UIView commitAnimations];	
	[sito removeFromSuperview];
	
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
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"cellacontatti" owner:self options:NULL];
		cell= cellacontatti ;
	}
	
	if(indexPath.row==0) {	
		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
		lbl.text = @"800737383"; 
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}
	if (indexPath.row==1) {	
		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
		lbl.text = @"redazione@cartaperdue.it"; 
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}
	if (indexPath.row==2) {	
		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
		lbl.text = @"www.cartaperdue.it"; 
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if  (indexPath.row == 0){ //telefona
		UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Vuoi chiamare\nCarta PerDue?"] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Chiama", nil];
		[aSheet showInView:self.view];
			//[aSheet setBackgroundColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
		
		[aSheet release];			
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];		
	}
	if (indexPath.row == 1){ //mail
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		[[controller navigationBar] setTintColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
		NSArray *to = [NSArray arrayWithObject:[NSString stringWithFormat:@"redazione@cartaperdue.it"]];
		[controller setToRecipients:to];
		controller.mailComposeDelegate = self;
		[controller setMessageBody:@"" isHTML:NO];
		[self presentModalViewController:controller animated:YES];
		[controller release];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	if  (indexPath.row == 2) { //sito
		NSURL *url = [NSURL URLWithString:@"http://www.cartaperdue.it"];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[webView loadRequest:requestObj];		
			//[self.navigationController pushViewController:sito animated:YES];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
							   forView:[self view]
								 cache:YES];
		
		[UIView commitAnimations];
		
		[[self view] addSubview:sito];
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[webView release];
		webView=nil;
		
	}
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:800737383"]];
		[[UIApplication sharedApplication] openURL:url];
	} 
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
		// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
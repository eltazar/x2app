//
//  Info.m
//  Per Due
//
//  Created by Giuseppe Lisanti on 02/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Info.h"


@implementation Info
@synthesize close, credits,tableview,sito,webView,cred;

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

- (IBAction)opencredits:(id)sender {


	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:[self view]
							 cache:YES];
	
	[UIView commitAnimations];
	[[self view] addSubview:cred];
	

}

- (IBAction)switchinfo:(id)sender{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:[self view]
							 cache:YES];
	[self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow] animated:YES];
	[UIView commitAnimations];	
	[cred removeFromSuperview];
	self.title = @"Info";


	
	
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
    [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow] animated:YES];
    [sito removeFromSuperview];
	[UIView commitAnimations];	
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
	NSURL *infos = [NSURL URLWithString:@"http://www.cartaperdue.it/partner/PD.html"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:infos];
	[infocarta loadRequest:requestObj];		
	[infocarta release];
	infocarta=nil;
	
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
	return 4;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)] autorelease];
    [customView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.lineBreakMode = UILineBreakModeWordWrap;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont boldSystemFontOfSize:20];
    
//	
//	if (section == 0)
//	{
//		lbl.text =@"Supervision";
//	}
//	if (section == 1){
//		lbl.text = @"Developer";
//		
//	}
//	
	if (section == 0){
		lbl.text = @"Contatti";	

		}

    
    UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    lbl.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, labelSize.height+6);
    
    [customView addSubview:lbl];
    
    return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	NSString *lblText;

	if (section == 0){
			lblText = @"Contatti";	
		}


    UIFont *txtFont = [UIFont boldSystemFontOfSize:20];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lblText sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height+6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"CellaCredits" owner:self options:NULL];
		cell= cellacredits ;
	}
		
//	if ((indexPath.row==0) && (indexPath.section==0) ){	
//		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
//		lbl.text = @"Prof. Emanuele Panizzi"; 
//		UILabel *etc = (UILabel *)[cell viewWithTag:2];
//		etc.text = @"Dipartimento di Informatica \"La Sapienza\" di Roma";
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//	}
//	if ((indexPath.row==0) && (indexPath.section==1)) {	
//		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
//		lbl.text = @"Giuseppe Lisanti"; 
//		UILabel *etc = (UILabel *)[cell viewWithTag:2];
//		etc.text = @"";
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//	}
	if ((indexPath.row==0) && (indexPath.section==0)) {	
		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
		lbl.text = @"800737383"; 
		UILabel *etc = (UILabel *)[cell viewWithTag:2];
		etc.text = @"";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	}
	if ((indexPath.row==1) && (indexPath.section==0)) {	
		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
		lbl.text = @"redazione@cartaperdue.it"; 
		UILabel *etc = (UILabel *)[cell viewWithTag:2];
		etc.text = @"";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}
	if ((indexPath.row==2) && (indexPath.section==0)) {	
		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
		lbl.text = @"www.cartaperdue.it"; 
		UILabel *etc = (UILabel *)[cell viewWithTag:2];
		etc.text = @"";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}
    if ((indexPath.row==3) && (indexPath.section==0)) {	
		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
		lbl.text = @"Seguici su Facebook"; 
		UILabel *etc = (UILabel *)[cell viewWithTag:2];
		etc.text = @"";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( (indexPath.row == 0)&&(indexPath.section==0) ){ //telefona
		UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Vuoi chiamare\nCarta PerDue?"] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Chiama", nil];
		[aSheet showInView:self.view];
		//[aSheet setBackgroundColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
		
		[aSheet release];	
    }
	if ( (indexPath.row == 1)&&(indexPath.section==0) ){ //mail
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		[[controller navigationBar] setTintColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
		NSArray *to = [NSArray arrayWithObject:[NSString stringWithFormat:@"info@cartaperdue.it"]];
		[controller setToRecipients:to];
		controller.mailComposeDelegate = self;
		[controller setMessageBody:@"" isHTML:NO];
		[self presentModalViewController:controller animated:YES];
		[controller release];
	}
	if ( (indexPath.row == 2)&&(indexPath.section==0) ){ //sito
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
		[[self view] addSubview:cred];
		
		[[self view] addSubview:sito];

		[webView release];
		webView=nil;
        [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
	}
    if ( (indexPath.row == 3)&&(indexPath.section==0) ){ //facebook
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.facebook.com/perdue.roma"]];
	}
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:800737383"]];
		[[UIApplication sharedApplication] openURL:url];
	} else {
        [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow] animated:YES];
    }
}
					  
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
		[self becomeFirstResponder];
		[self dismissModalViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"Info::viewWillAppear");
    [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow]  animated:YES];
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

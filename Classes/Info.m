//
//  Info.m
//  Per Due
//
//  Created by Giuseppe Lisanti on 02/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Info.h"
#import "Utilita.h"


@implementation Info

@synthesize closeBtn=_closeBtn, creditsBtn=_creditsBtn, tableview=_tableview, infoWebView=_infoWebView, sitoPerDueView=_sitoPerDueView, sitoPerDueWebView=_sitoPerDueWebView, contattiView=_contattiView;



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


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"[%@ wiewDidLoad", [self class]);
	NSURL *infos = [NSURL URLWithString:@"http://www.cartaperdue.it/partner/PD.html"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:infos];
	[self.infoWebView loadRequest:requestObj];		
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Info::viewWillAppear");
    [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow]  animated:YES];
	if (![Utilita networkReachable]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
		[alert show];
        [alert release];

	}
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.closeBtn           = nil;
    self.creditsBtn         = nil;
    self.tableview          = nil;
    self.infoWebView        = nil;
    self.sitoPerDueView     = nil;
    self.sitoPerDueWebView  = nil;
    self.contattiView       = nil;
}


- (void)dealloc {
    self.closeBtn           = nil;
    self.creditsBtn         = nil;
    self.tableview          = nil;
    self.infoWebView        = nil;
    self.sitoPerDueView     = nil;
    self.sitoPerDueWebView  = nil;
    self.contattiView       = nil;
    [super dealloc];
}


/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
	
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"InfoCell" owner:self options:NULL] objectAtIndex:0];
	}
    
    if ((indexPath.row==0) && (indexPath.section==0)) {	
		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
		lbl.text = @"800737383"; 
		UILabel *etc = (UILabel *)[cell viewWithTag:2];
		etc.text = @"";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
	}
	else if ((indexPath.row==1) && (indexPath.section==0)) {	
		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
		lbl.text = @"redazione@cartaperdue.it"; 
		UILabel *etc = (UILabel *)[cell viewWithTag:2];
		etc.text = @"";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}
	else if ((indexPath.row==2) && (indexPath.section==0)) {	
		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
		lbl.text = @"www.cartaperdue.it"; 
		UILabel *etc = (UILabel *)[cell viewWithTag:2];
		etc.text = @"";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}
    else if ((indexPath.row==3) && (indexPath.section==0)) {	
		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
		lbl.text = @"Seguici su Facebook"; 
		UILabel *etc = (UILabel *)[cell viewWithTag:2];
		etc.text = @"";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}
	
	return cell;
	
}


#pragma mark - UITableViewDelegate


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)];
    [customView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.shadowColor = [UIColor blackColor];
    lbl.shadowOffset = CGSizeMake(0, 1);
    lbl.lineBreakMode = UILineBreakModeWordWrap;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont boldSystemFontOfSize:17];
    
	if (section == 0) {
        lbl.text = @"Contatti";	
    }
    
    UIFont *txtFont = [UIFont boldSystemFontOfSize:17];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    lbl.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, labelSize.height+6);
    NSInteger lblPadding = 20;
    lbl.frame = CGRectMake(lblPadding, lblPadding-10, tableView.bounds.size.width-2*lblPadding, labelSize.height);
    
    [customView addSubview:lbl];
    
    [lbl release];
    return [customView autorelease];
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	NSString *lblText;
    
	if (section == 0) {
        lblText = @"Contatti";	
        UIFont *txtFont = [UIFont boldSystemFontOfSize:17];
        CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
        CGSize labelSize = [lblText sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        return labelSize.height+10+5;
    }
    else {
        return 0;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( (indexPath.row == 0)&&(indexPath.section==0) ){ //telefona
		UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Vuoi chiamare\nCarta PerDue?"] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Chiama", nil];
		[aSheet showInView:self.view];
		//[aSheet setBackgroundColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
		
		[aSheet release];	
    }
	if ((indexPath.row == 1) && (indexPath.section == 0)) { 
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		[[controller navigationBar] setTintColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
		NSArray *to = [NSArray arrayWithObject:[NSString stringWithFormat:@"info@cartaperdue.it"]];
		[controller setToRecipients:to];
		controller.mailComposeDelegate = self;
		[controller setMessageBody:@"" isHTML:NO];
		[self presentModalViewController:controller animated:YES];
		[controller release];
	}
	if ((indexPath.row == 2) && (indexPath.section == 0)) { 
		NSURL *url = [NSURL URLWithString:@"http://www.cartaperdue.it"];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[self.sitoPerDueWebView loadRequest:requestObj];		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
							   forView:[self view]
								 cache:YES];
		
		[UIView commitAnimations];		
		[[self view] addSubview:self.sitoPerDueView];
        
        [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
	}
    if ((indexPath.row == 3) && (indexPath.section == 0)){ 
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.facebook.com/perdue.roma"]];
	}
}


#pragma  mark - UIActionSheedDelegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:800737383"]];
		[[UIApplication sharedApplication] openURL:url];
	} else {
        [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow] animated:YES];
    }
}
					 

#pragma mark - MFMailComposeViewControllerDelegate


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
		[self becomeFirstResponder];
		[self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Info (IBActions)


- (IBAction)apriContattiView:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:[self view]
							 cache:YES];
	
	[UIView commitAnimations];
	[[self view] addSubview:self.contattiView];
}


- (IBAction)chiudiContattiView:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:[self view]
							 cache:YES];
	[self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow] animated:YES];
	[UIView commitAnimations];	
	[self.contattiView removeFromSuperview];
	self.title = @"Info";
}


- (IBAction)chiudiSitoPerDueView:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown						   
						   forView:[self view]
							 cache:YES];
    [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow] animated:YES];
    [self.sitoPerDueView removeFromSuperview];
	[UIView commitAnimations];	
}


- (IBAction)chiudi:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}



@end

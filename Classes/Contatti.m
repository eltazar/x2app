//
//  Contatti.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 26/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Contatti.h"
#import <QuartzCore/QuartzCore.h>
#import "Utilita.h"

@implementation Contatti

@synthesize close,tableview,sito,webView;

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

	UITextView *infoTextView = [[UITextView alloc] init];
    infoTextView.frame = CGRectMake(10, 10, 300,130);
    infoTextView.text = @"I tuoi dati e quelli della tua carta di credito sono archiviati esclusivamente sul tuo smartphone per facilitarti i prossimi acquisti. I dati della carta di credito non vengono conservati sul server. La trasmissione delle informazioni  per ogni signolo acquisto avviene utilizzando le più recenti e sicure tecnologie disponibili per assicurare la massima sicurezza, su una connessione cifrata SSL (Secure Socket Layer), e i dati non vengono conservati sul server." ;
    infoTextView.editable = NO;
    infoTextView.font = [UIFont fontWithName:@"Helvetica" size:15];
    infoTextView.layer.cornerRadius = 6;
    [self.tableview addSubview:infoTextView];
    [infoTextView release];
    [super viewDidLoad];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 150;
    else return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 4;
        default:
            return 0;
            break;
    }
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContattiCell"];
	
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"ContattiCell" owner:self options:NULL] objectAtIndex:0];
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
    
    if (indexPath.row==3) {	
		UILabel *lbl = (UILabel *)[cell viewWithTag:1];
		lbl.text = @"Seguici su Facebook"; 
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if  (indexPath.row == 0){ //telefona
		UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Vuoi chiamare\nCarta PerDue?"] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Chiama", nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
		[aSheet showInView:self.view];
			//[aSheet setBackgroundColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
		
		[aSheet release];			
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
	}
	if  (indexPath.row == 2) { //sito
		NSURL *url = [NSURL URLWithString:@"http://www.cartaperdue.it"];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[webView loadRequest:requestObj];		
			//[self.navigationController pushViewController:sito animated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
        [UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
							   forView:[self view]
								 cache:YES];
		[UIView commitAnimations];
		
		[[self view] addSubview:sito];
		
		[webView release];
		webView=nil;
		
	}
    if(indexPath.row == 3){
        //facebook
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.facebook.com/perdue.roma"]];
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
    NSLog(@"Contatti::viewWillAppear");
    [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow]  animated:YES];
    if( ![Utilita networkReachable]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
        [alert show];
        [alert release];
	}
	
	
}

- (void)viewWillDisappear:(BOOL)animated {
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
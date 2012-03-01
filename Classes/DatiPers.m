//
//  DatiPers.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 30/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatiPers.h"


@implementation DatiPers
@synthesize tableinfopersonali,campo;

-(void)save:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	[self.navigationController popViewControllerAnimated:YES];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
		return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellID = @"celladatipersonali";
	
	Celladati *cell = (Celladati *)[tableinfopersonali dequeueReusableCellWithIdentifier:cellID];
	
	if (cell == nil)
	{
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"celladatipersonali" owner:nil options:nil];
		
		for (id currentObject in nibObjects)
		{
			if ([currentObject isKindOfClass:[Celladati class]])
			{
				cell = (Celladati *)currentObject;
				break;
			}
			
		}	
    }
    
    cell.detail.delegate = self;
    
    cell.mytext.text = @"";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.detail.tag=indexPath.row;

    
	if (indexPath.row == 0) {
		nomeSalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"Nome"];	
		cell.mytext.text =@"Nome:";
		cell.detail.placeholder =@"Inserisci nome";
		cell.detail.text = nomeSalvato;
		[cell.detail setReturnKeyType:UIReturnKeyNext];
		cell.detail.keyboardType = UIKeyboardTypeASCIICapable;
		cell.key = @"Nome";
		[cell.labelRight removeFromSuperview];
	}
		
	if (indexPath.row == 1) {
		cognomeSalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"Cognome"];

		cell.mytext.text =@"Cognome:";

		cell.detail.placeholder =@"Inserisci cognome";
		cell.detail.text = cognomeSalvato;
		[cell.detail setReturnKeyType:UIReturnKeyNext];
		cell.detail.keyboardType = UIKeyboardTypeASCIICapable;
		cell.key = @"Cognome";
		[cell.labelRight removeFromSuperview];
	}
	if (indexPath.row == 2) {
		telefonoSalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"Telefono"];
		
		cell.mytext.text =@"Telefono:";
		
		cell.detail.placeholder =@"Inserisci numero di telefono";
		cell.detail.text = telefonoSalvato;
		cell.detail.keyboardType = UIKeyboardTypeNumberPad;
		cell.key = @"Telefono";
		[cell.labelRight removeFromSuperview];
	}
	if (indexPath.row == 3) {
		emailSalvata = [[NSUserDefaults standardUserDefaults] objectForKey:@"Email"];
		
		cell.mytext.text =@"Email:";
		
		cell.detail.placeholder =@"Inserisci indirizzo mail";
		cell.detail.text = emailSalvata;
		[cell.detail setReturnKeyType:UIReturnKeyNext];
		cell.detail.keyboardType = UIKeyboardTypeEmailAddress;
		cell.detail.autocapitalizationType = UITextAutocapitalizationTypeNone;
		
		cell.key = @"Email";
		[cell.labelRight removeFromSuperview];
	}
	return cell;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
	self.navigationItem.rightBarButtonItem.enabled = FALSE;

	int z = textField.tag;                                              
	
    if (z > 2) { //le prime tre celle sono completamente visibili
		
		// ridimensiono la tableview per poter visualizzare correttamente l'ultima riga che viene nascosta dalla tabella

			self.tableinfopersonali.frame = CGRectMake(0.0,0,320.0,200.0);       
		// adjust the contentInset
		
        tableinfopersonali.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);        
		
		// Scroll to the current text field
		
        [tableinfopersonali scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:z inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
		
    }
    	
	Celladati * currentCell = (Celladati *)[[textField superview] superview];
	NSIndexPath * selectedPath = [tableinfopersonali indexPathForCell:currentCell];
    currentField = textField;
    
		//	nextPath = selectedPath;
	[tableinfopersonali selectRowAtIndexPath:selectedPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
	
	currentKey = currentCell.key;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{	
	NSIndexPath * currentPath = [tableinfopersonali indexPathForSelectedRow];
    NSIndexPath * nextPath = [NSIndexPath indexPathForRow:currentPath.row + 1 inSection:currentPath.section];
    
	if ( (currentPath.section == 0) && (currentPath.row >= 3) ) {  
		nextPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[theTextField resignFirstResponder];
		return YES;
	}
	
    
    Celladati * nextCell = (Celladati *)[tableinfopersonali cellForRowAtIndexPath:nextPath];
    [tableinfopersonali selectRowAtIndexPath:nextPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [nextCell.detail becomeFirstResponder];
    
	return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
	int z = textField.tag;  
	
    if (z > 2) {
		
			// resize the UITableView to the original size
		
        self.tableinfopersonali.frame = CGRectMake(0.0,0,320.0,416.0);       
		
			// Undo the contentInset
        tableinfopersonali.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	}
	
	if (textField.text)  {
		NSString *stringaTesto = textField.text;
		textField.text = [[NSString alloc] initWithFormat:@"%@", stringaTesto];
		
		NSString *testoInserito = textField.text;
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:testoInserito forKey:currentKey];
		[defaults synchronize];
		self.navigationItem.rightBarButtonItem.enabled = TRUE;

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
	UIBarButtonItem *salva = [[UIBarButtonItem alloc]
								  initWithTitle:@"Salva"
								  style:UIBarButtonItemStyleBordered
								  target:self
								  action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = salva;

}
/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}*/

/*
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if (textField.text) 
	{
		[campo setText:[NSString stringWithFormat:@"%@",textField.text]];	
		
							
		NSString *stringaTesto = textField.text;
		
		textField.text = [[NSString alloc] initWithFormat:@"%@", stringaTesto];
		
		NSString *testoInserito =textField.text;
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:testoInserito forKey:@"Nome"];
		[defaults synchronize];
		
	}
	NSLog(@"%@",campo.text);
	
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
	
}/*
-(IBAction)editingEnded:(id)sender{
    [sender resignFirstResponder]; 
}
*/

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

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[tableinfopersonali release];
	
	[myAccount release];
    [currentKey release];

}


@end

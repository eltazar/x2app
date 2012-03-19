//
//  LoginController.m
//  PerDueCItyCard
//
//  Created by mario greco on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"

@implementation LoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - TextField and TextView Delegate

- (void)textFieldDidEndEditing:(UITextField *)txtField
{   
    if([txtField.text isEqualToString:@"prova"]){
        [messaggioEmailTrue setHidden:NO];
        [pswLabel setHidden:NO];
        [pswTextField setHidden:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
    if(textField.tag ==10){
        NSLog(@"lancia query email");
        
    }
    else if(textField.tag == 11){
        NSLog(@"lancia query email+psw");
    }
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dbAccess = [[DatabaseAccess alloc] init];
    dbAccess.delegate = self;
    
    [pswLabel setHidden:YES];
    [pswTextField setHidden:YES];
    [messaggioEmailTrue setHidden:YES];
    [nonRegistratoLabel setHidden:YES];
    [nonRicordoPswLabel setHidden:YES];
    [registratiBtn setHidden:YES];
    [ricordaBtn setHidden:YES];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Memory Management

- (void)dealloc {
    [dbAccess release];
    [super dealloc];
}

@end
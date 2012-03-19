//
//  RegistrazioneController.m
//  PerDueCItyCard
//
//  Created by mario greco on 19/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegistrazioneController.h"

@implementation RegistrazioneController

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

-(BOOL)validateFields{
    
    
    //controlla che le stringhe non siano ne vuote ne formate da soli spazi bianchi
    if(! [Utilita isStringEmptyOrWhite:nome] || ! [Utilita isStringEmptyOrWhite:cognome] ||
       ![Utilita isStringEmptyOrWhite:telefono] || ! [Utilita isStringEmptyOrWhite:email]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dati mancanti" message:@"Per favore inserisci tutti i dati richiesti" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return FALSE ;
    }
    
    //controlla che i dati inseriti siano solo numerici per il numero di telefono
    if(![Utilita isNumeric:telefono]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Numero di telefono formalmente non valido" message:@"Il numero deve esser composto da soli numeri" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return FALSE;
    }
    
    //controlla che i dati inseriti nel titolare siano solo caratteri
    
    //controllare formato email
    if( ! [Utilita isEmailValid:email]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail formalmente non valida" message:@"Controlla l'indirizzo inserito" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return FALSE;
    }
    
    
    return TRUE;
}
-(IBAction)registraBtnClicked:(id)sender{
 
    //fa si che il testo inserito nei texfield sia preso anche se non è stata dismessa la keyboard
    [self.view endEditing:TRUE];
    
    if([self validateFields]){
        NSLog(@"tutti campi sono validi!");
    
        
    
    }
    
}
#pragma mark - TextField and TextView Delegate

- (void)textFieldDidEndEditing:(UITextField *)txtField
{   
    if(txtField.tag == 80){
        self.nome = txtField.text;
    }
    else if(txtField.tag == 81){
        self.cognome = txtField.text;
    }
    else if(txtField.tag == 82){
        self.email = txtField.text;
    }
    else if(txtField.tag == 83){
        self.telefono = txtField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    self.nome = @"";
    self.cognome = @"";
    self.email = @"";
    self.telefono = @"";
    
    [super viewDidLoad];
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

@end

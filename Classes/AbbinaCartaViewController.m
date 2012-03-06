//
//  AbbinaCartaViewController.m
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbbinaCartaViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PerDueCItyCardAppDelegate.h"

@implementation AbbinaCartaViewController
@synthesize viewPulsante, abbinaButton, titolare, numeroCarta, scadenza;

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

#pragma mark - UITextField delegate
- (void)textFieldDidEndEditing:(UITextField *)txtField
{   
    
    if(txtField.tag == 5){
        self.titolare = txtField.text;
    }
    else if(txtField.tag == 4){
        self.numeroCarta = txtField.text;
    }
    else if(txtField.tag == 3){
        self.scadenza = txtField.text;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
    
    // riabbasso la view se si tratta dei texfield relativi a numeroCarta e scadenz
    if(isViewUp){
        [UIView animateWithDuration:0.15 animations:^void{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+25, self.view.frame.size.width, self.view.frame.size.height)];
        }
                         completion:^(BOOL finished){
                             isViewUp = FALSE;
                         }
         ];    
    }
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"iniziato editing");
    
    //alzo la view se si tratta dei texfield relativi a numeroCarta e scadenza
    
    if(!isViewUp){
        [UIView animateWithDuration:0.25 animations:^void{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-25, self.view.frame.size.width, self.view.frame.size.height)];
        }
                         completion:^(BOOL finished){
                             isViewUp = TRUE;
                         }
        ];    
    }
    
}

#pragma mark - Bottoni view

-(IBAction)abbinaButtonClicked:(id)sender{
        
    //validare i campi inseriti
    
    //query sul db per vedere se esiste carta fisica
    
    //se esiste salvo dati
    
   // NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"abbina premuto = %@, %@, %@", titolare,numeroCarta,scadenza);
    
//    [prefs setObject:titolare forKey:@"_titolare_AB"];
//    [prefs setObject:numeroCarta forKey:@"_carta_AB"];
//    [prefs setObject:scadenza forKey:@"_scadenza_AB"];
//    [prefs synchronize];

    //Otteniamo il puntatore al NSManagedContext
    PerDueCItyCardAppDelegate *appDelegate = (PerDueCItyCardAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
	//Creiamo un'istanza di NSManagedObject per l'Entità che ci interessa
	NSManagedObject *cartaPD = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"CartaPerDue" 
                                 inManagedObjectContext:context];
    
	//Usando il Key-Value Coding inseriamo i dati presi dall'interfaccia nell'istanza dell'Entità appena creata
	[cartaPD setValue:titolare forKey:@"titolare"];
	[cartaPD setValue:numeroCarta forKey:@"numero"];
	[cartaPD setValue:scadenza forKey:@"scadenza"];
    
	//Effettuiamo il salvataggio gestendo eventuali errori
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
	}
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"bla";
        
    isViewUp = FALSE;
    
    self.viewPulsante.layer.cornerRadius = 6;
    
    UIImageView *cartaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cartaGrande.png"]];
    [cartaView setFrame:CGRectMake(11, 20, 300, 180)];
    cartaView.userInteractionEnabled = YES;
    
    
    //    
//    UITextField *titolareTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 191, 31)];
//    titolareTextField.tag = 5;
//    
//    [self.view addSubview:titolareTextField];
//    [self.view addSubview:cartaView];
    
    
    UITextField *titolareField = [[UITextField alloc] initWithFrame:CGRectMake(10, cartaView.frame.size.height/2 + 10, 191, 28)];
    titolareField.borderStyle = UITextBorderStyleRoundedRect;
    titolareField.font = [UIFont systemFontOfSize:15];
    titolareField.placeholder = @"Titolare";
    titolareField.autocorrectionType = UITextAutocorrectionTypeNo;
    titolareField.keyboardType = UIKeyboardTypeDefault;
    titolareField.returnKeyType = UIReturnKeyDone;
    titolareField.clearButtonMode = UITextFieldViewModeWhileEditing;
    titolareField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;   
    titolareField.tag = 5;
    titolareField.delegate = self;
    
    UITextField *numeroCartaField = [[UITextField alloc] initWithFrame:CGRectMake(10, cartaView.frame.size.height/2 + titolareField.frame.size.height+20, 160, 28)];
    numeroCartaField.borderStyle = UITextBorderStyleRoundedRect;
    numeroCartaField.font = [UIFont systemFontOfSize:15];
    numeroCartaField.placeholder = @"Numero carta";
    numeroCartaField.autocorrectionType = UITextAutocorrectionTypeNo;
    numeroCartaField.keyboardType = UIKeyboardTypeDefault;
    numeroCartaField.returnKeyType = UIReturnKeyDone;
    numeroCartaField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numeroCartaField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; 
    numeroCartaField.tag = 4;
    numeroCartaField.delegate = self;
    
    UITextField *scadenzaField = [[UITextField alloc] initWithFrame:CGRectMake(numeroCartaField.frame.origin.x+numeroCartaField.frame.size.width+20, cartaView.frame.size.height/2 + titolareField.frame.size.height+20, 100, 28)];
    scadenzaField.borderStyle = UITextBorderStyleRoundedRect;
    scadenzaField.font = [UIFont systemFontOfSize:15];
    scadenzaField.placeholder = @"Scadenza";
    scadenzaField.autocorrectionType = UITextAutocorrectionTypeNo;
    scadenzaField.keyboardType = UIKeyboardTypeDefault;
    scadenzaField.returnKeyType = UIReturnKeyDone;
    scadenzaField.clearButtonMode = UITextFieldViewModeWhileEditing;
    scadenzaField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; 
    scadenzaField.tag = 3;
    scadenzaField.delegate = self;
    
    [cartaView addSubview:scadenzaField];
    [cartaView addSubview:numeroCartaField];
    [cartaView addSubview:titolareField];
   
    [self.view addSubview:cartaView];
    
    [cartaView release];
    [numeroCartaField release];
    [titolareField release];
    [scadenzaField release];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.viewPulsante = nil;
    self.abbinaButton = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    
    [titolare release];
    [numeroCarta release];
    [scadenza release];
    [super dealloc];
}
@end

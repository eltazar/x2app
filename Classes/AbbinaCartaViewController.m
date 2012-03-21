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
#import "PickerViewController.h"
#import "LocalDatabaseAccess.h"
#import "Utilita.h"

//metodi e ivar private
@interface AbbinaCartaViewController()
@property(nonatomic, retain)NSString *nome;
@property(nonatomic, retain)NSString *cognome;
@property(nonatomic, retain)NSString *numeroCarta;
@property(nonatomic, retain)NSString *scadenza;

-(BOOL)isValidFields;
@end

@implementation AbbinaCartaViewController
@synthesize abbinaButton, nome, cognome, numeroCarta, scadenza,delegate;

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
    NSLog(@"editing finito");
    if(txtField.tag == 6){
        self.nome = txtField.text;
    }
    else if(txtField.tag == 5){
        self.cognome = txtField.text;
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{    
    
    if(textField.tag == 3){
        UIActionSheet *myActionSheet = [[UIActionSheet alloc] initWithTitle:@"Data scadenza" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Seleziona", nil];
        
        myActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        //imposto questo controller come delegato dell'actionSheet
        [myActionSheet setDelegate:self];
        //[actionSheet showInView:self.view];
        [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
        //setto i bounds dell'action sheet in modo tale da contenere il picker
        [myActionSheet setBounds:CGRectMake(0,0,320, 500)]; 
        
        //array contenente le subviews dello sheet (sono 2, il titolo e il bottone custom
        NSArray *subviews = [myActionSheet subviews];
        //setto il frame del tasto così da mostrarlo sotto al picker
        //1 lo passo a mano, MODIFICARE
        [[subviews objectAtIndex:1] setFrame:CGRectMake(20, 255, 280, 46)]; 
        //        pickerView = [[PickerViewController alloc] initw];
        [myActionSheet addSubview: pickerDate.view];
        
        [textField setInputView:myActionSheet];
        
        [myActionSheet release];
        return NO;

    }
    return YES;
}


#pragma mark - ActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{         
    NSString *date = [NSString stringWithFormat:@"%@/%@",[pickerDate.objectsInRow objectAtIndex:0],[pickerDate.objectsInRow objectAtIndex:1]];
    
    //NSLog(@"date = %@", date);
                    
    for(UIView *tempView in [self.view subviews]){
        
       // NSLog(@"temp view tag = %d",tempView.tag);
        if (tempView.tag == 2) {
            for(UIView *textField in [tempView subviews]){
                if(textField.tag == 3)
                    ((UITextField*)textField).text = date;
            }
            
        }
    }
        
    self.scadenza = date;
    
}


#pragma mark - Bottoni view

-(BOOL)isValidFields{
    
    
    if(! [Utilita isDateFormatValid:self.scadenza]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data errata" message:@"Inserisci una data di scadenza valida" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return FALSE;
    }
    if(! [Utilita isStringEmptyOrWhite:self.nome] || ! [Utilita isStringEmptyOrWhite:self.cognome] || ! [Utilita isStringEmptyOrWhite:self.numeroCarta]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dati incompleti" message:@"Inserisci tutti i dati richiesti" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return FALSE;
    
    }
    
    return TRUE;
}

-(IBAction)abbinaButtonClicked:(id)sender{
    // TODO: creare oggetto cartaPerDue e darlo in pasto a LocalDatabaseAccess
        
    //validare i campi inseriti
    if([self isValidFields]){
        
        NSLog(@"CHIAMATA AL DB PER INTERROGARLO SU ESISTENZA CARTA");
        
        //poi se esiste salvo i dati in core data
        NSLog(@"abbina premuto = %@, %@, %@, %@", nome,cognome,numeroCarta,scadenza);
        CartaPerDue *card = [[CartaPerDue alloc] init];
        card.name = nome;
        card.surname = cognome;
        card.number = numeroCarta;
        card.expiryString = scadenza;
        
        //Effettuiamo il salvataggio gestendo eventuali errori
        NSError *error;
        if (![LocalDatabaseAccess storeCard:card AndWriteErrorIn:&error]) {
            NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
        }
        else{
            if(delegate && [delegate respondsToSelector:@selector(didMatchNewCard)])
                [delegate didMatchNewCard];
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Abbina carta";
        
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroundPattern.png"]]];
    
    isViewUp = FALSE;
    
    self.abbinaButton.layer.cornerRadius = 6;    
        
    UIImageView *cartaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cartaGrande.png"]];
    [cartaView setFrame:CGRectMake(11, 20, 300, 180)];
    cartaView.userInteractionEnabled = YES;
    cartaView.tag = 2;
    
    
    UITextField *nomeField = [[UITextField alloc] initWithFrame:CGRectMake(10, cartaView.frame.size.height/2 + 10, 110, 28)];
    nomeField.borderStyle = UITextBorderStyleRoundedRect;
    nomeField.font = [UIFont systemFontOfSize:15];
    nomeField.placeholder = @"Nome";
    nomeField.autocorrectionType = UITextAutocorrectionTypeNo;
    nomeField.keyboardType = UIKeyboardTypeDefault;
    nomeField.returnKeyType = UIReturnKeyDone;
    nomeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nomeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;   
    nomeField.tag = 6;
    nomeField.delegate = self;
    
    UITextField *cognomeField = [[UITextField alloc] initWithFrame:CGRectMake(nomeField.frame.origin.x+nomeField.frame.size.width+10, cartaView.frame.size.height/2 + 10, 110, 28)];
    cognomeField.borderStyle = UITextBorderStyleRoundedRect;
    cognomeField.font = [UIFont systemFontOfSize:15];
    cognomeField.placeholder = @"Cognome";
    cognomeField.autocorrectionType = UITextAutocorrectionTypeNo;
    cognomeField.keyboardType = UIKeyboardTypeDefault;
    cognomeField.returnKeyType = UIReturnKeyDone;
    cognomeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cognomeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;   
    cognomeField.tag = 5;
    cognomeField.delegate = self;
    
    UITextField *numeroCartaField = [[UITextField alloc] initWithFrame:CGRectMake(10, cartaView.frame.size.height/2 + nomeField.frame.size.height+20, 160, 28)];
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
    
    UITextField *scadenzaField = [[UITextField alloc] initWithFrame:CGRectMake(numeroCartaField.frame.origin.x+numeroCartaField.frame.size.width+15, cartaView.frame.size.height/2 + nomeField.frame.size.height+20, 100, 28)];
    scadenzaField.borderStyle = UITextBorderStyleRoundedRect;
    scadenzaField.font = [UIFont systemFontOfSize:15];
    scadenzaField.placeholder = @"Scadenza";
//    scadenzaField.autocorrectionType = UITextAutocorrectionTypeNo;
//    scadenzaField.keyboardType = UIKeyboardTypeDefault;
//    scadenzaField.returnKeyType = UIReturnKeyDone;
//    scadenzaField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    scadenzaField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; 
    scadenzaField.tag = 3;
    scadenzaField.delegate = self;
    
    [cartaView addSubview:scadenzaField];
    [cartaView addSubview:numeroCartaField];
    [cartaView addSubview:nomeField];
    [cartaView addSubview:cognomeField];
    
    [self.view addSubview:cartaView];
        
    [cartaView release];
    [numeroCartaField release];
    [nomeField release];
    [scadenzaField release];
    [cognomeField release];
    
    NSArray *calendar = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"--",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil],[NSArray arrayWithObjects:@"--",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2020",@"2021",@"2022",@"2023",@"2024", nil] , nil];
    
    pickerDate = [[PickerViewController alloc] initWithArray: calendar andNumber:2];
    
    [calendar release];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
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
    
    [nome release];
    [cognome release];
    [numeroCarta release];
    [scadenza release];

    [abbinaButton release];
    
    [super dealloc];
}
@end

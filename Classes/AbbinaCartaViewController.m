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

@interface AbbinaCartaViewController() {
    BOOL isViewUp;
    DatabaseAccess *_dbAccess; 
    NSString *_nome;
    NSString *_cognome;
    NSString *_numeroCarta;
    NSString *_scadenza;
}
@property (nonatomic, retain) DatabaseAccess *dbAccess;
@property (nonatomic, retain) NSString *nome;
@property (nonatomic, retain) NSString *cognome;
@property (nonatomic, retain) NSString *numeroCarta;
@property (nonatomic, retain) NSString *scadenza;
-(BOOL)isValidFields;
@end


@implementation AbbinaCartaViewController

// Properties
@synthesize delegate = _delegate, pickerDate = _pickerDate;
// IBOutlets
@synthesize abbinaButton = _abbinaButton;
// Properties private:
@synthesize dbAccess = _dbAccess, nome = _nome, cognome = _cognome, numeroCarta = _numeroCarta, scadenza = _scadenza;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


- (void)viewDidLoad {
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
    
    self.pickerDate = [[[PickerViewController alloc] initWithArray: calendar andNumber:2] autorelease];
    
    self.dbAccess = [[[DatabaseAccess alloc] init] autorelease];
    [self.dbAccess setDelegate:self];
    
    [calendar release];
}


- (void)viewDidUnload {
    // Roba ricreata in viewDidLoad:
    self.pickerDate = nil;
    self.dbAccess.delegate = nil;
    self.dbAccess = nil;
    // IBOutlets:    
    self.abbinaButton = nil;
    
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    [_delegate release];
    [_pickerDate release];
    [_abbinaButton release];
    
    [_nome release];
    [_cognome release];
    [_numeroCarta release];
    [_scadenza release];
    self.dbAccess.delegate = nil;
    [_dbAccess release];
    
    [super dealloc];
}


#pragma mark - UITextFieldDelegate


- (void)textFieldDidEndEditing:(UITextField *)txtField {   
    NSLog(@"editing finito");
    if (txtField.tag == 6) {
        self.nome = txtField.text;
    }
    else if (txtField.tag == 5) {
        self.cognome = txtField.text;
    }
    else if (txtField.tag == 4) {
        self.numeroCarta = txtField.text;
    }
    else if (txtField.tag == 3) {
        self.scadenza = txtField.text;
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField { 
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


- (void)textFieldDidBeginEditing:(UITextField *)textField {
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


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {    
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
        [myActionSheet addSubview: self.pickerDate.view];
        
        [textField setInputView:myActionSheet];
        
        [myActionSheet release];
        return NO;
    }
    return YES;
}


#pragma mark - ActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {         
    NSString *date = [NSString stringWithFormat:@"%@/%@",[self.pickerDate.objectsInRow objectAtIndex:0],[self.pickerDate.objectsInRow objectAtIndex:1]];
    
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


#pragma mark - DatabaseAccessDelegate

- (void)didReceiveCoupon:(NSDictionary *)receivedData {
    NSLog(@"AbbinaCartaViewController received from server: %@", [receivedData objectForKey:@"response"]);
}

- (void)didReceiveError:(NSError *)error {
    NSLog(@"AbbinaCartaViewController received connection error: \n\t%@\n\t%@\n\t%@", 
          [error localizedDescription], [error localizedFailureReason],
          [error localizedRecoveryOptions]);
}


# pragma mark - AbbinaCartaViewController (IBActions)


- (IBAction)abbinaButtonClicked:(id)sender {
    // TODO: creare oggetto cartaPerDue e darlo in pasto a LocalDatabaseAccess
    
    //validare i campi inseriti
    if([self isValidFields]){
        
        CartaPerDue *card = [[[CartaPerDue alloc] init] autorelease];
        card.name = self.nome;
        card.surname = self.cognome;
        card.number = self.numeroCarta;
        card.expiryString = self.scadenza;
        
        NSLog(@"CHIAMATA AL DB PER INTERROGARLO SU ESISTENZA CARTA");
        [self.dbAccess checkCardExistence:card];
        
        //TODO: mostrare ProgressHUD
        
        //poi se esiste salvo i dati in core data
        NSLog(@"abbina premuto = %@, %@, %@, %@", self.nome, self.cognome, self.numeroCarta,self.scadenza);
        
        //Effettuiamo il salvataggio gestendo eventuali errori
        NSError *error;
        if (![[LocalDatabaseAccess getInstance]storeCard:card AndWriteErrorIn:&error]) {
            NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
        }
        else{
            if(self.delegate && [self.delegate respondsToSelector:@selector(didMatchNewCard)])
                [self.delegate didMatchNewCard];
        }
    }
}



#pragma mark - AbbinaCartaViewController (metodi privati)

- (BOOL)isValidFields{
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


@end

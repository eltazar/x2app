//
//  RichiediCardViewController.m
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegistrazioneController.h"
#import "BaseCell.h"
#import "TextFieldCell.h"
#import "Utilita.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

//metodi e variabili private
@interface RegistrazioneController ()

@property(nonatomic,retain) NSString *nome;
@property(nonatomic,retain) NSString *cognome;
@property(nonatomic,retain) NSString *telefono;
@property(nonatomic,retain) NSString *email;

-(void)fillCell: (UITableViewCell *)cell rowDesc:(NSDictionary *)rowDesc;
@end

@implementation RegistrazioneController
@synthesize nome,cognome,telefono,email;
@synthesize hud = _hud;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return sectionDescription.count;
}

//setta gli header delle sezioni
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{  
    return [sectionDescription objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{   
    if(sectionData){
        return [[sectionData objectAtIndex: section] count];
    } 
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *sec = [sectionData objectAtIndex:indexPath.section];
    NSDictionary *rowDesc = [sec objectAtIndex:indexPath.row]; 
    NSString *dataKey = [rowDesc objectForKey:@"DataKey"];
    NSString *kind = [rowDesc objectForKey:@"kind"];
    int cellStyle = UITableViewCellStyleDefault;
    
    NSLog(@"dataKey = %@, kind = %@",dataKey,kind);
    
    BaseCell *cell = (BaseCell *)[tableView dequeueReusableCellWithIdentifier: dataKey];
    
    //se non è recuperata creo una nuova cella
	if (cell == nil) {        
        cell = [[[NSClassFromString(kind) alloc] initWithStyle: cellStyle reuseIdentifier:kind withDictionary:rowDesc] autorelease];
        
        //NSLog(@"CELL = %@",cell);
    }    
    
    [self fillCell:cell rowDesc:rowDesc];
    
    [cell setDelegate:self];
    
    return cell;
}

//riempe le celle in base ai dati del job creato
-(void)fillCell: (UITableViewCell *)cell rowDesc:(NSDictionary *)rowDesc
{
    NSString *datakey= [rowDesc objectForKey:@"DataKey"];
    
    if([datakey isEqualToString:@"name"]){
        ((TextFieldCell *)cell).textField.text = self.nome;
        //((TextFieldCell *)cell).textField.text = [prefs objectForKey:@"_numero"];
    }
    else if([datakey isEqualToString:@"surname"]){
        ((TextFieldCell *)cell).textField.text = self.cognome;
        //((TextFieldCell *)cell).textField.text = [prefs objectForKey:@"cvv"];
    }
    else if([datakey isEqualToString:@"email"]){
        ((TextFieldCell *)cell).textField.text = self.email;
    }
    else if([datakey isEqualToString:@"phone"]){
        ((TextFieldCell *)cell).textField.text = self.telefono;
    }
    
}

#pragma mark - Table view delegate
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 2) {
        
        UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)] autorelease];
        [customView setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.lineBreakMode = UILineBreakModeWordWrap;
        lbl.numberOfLines = 0;
        lbl.textAlignment =  UITextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:14];       
        
        
        lbl.text = @"Sarai ricontattato entro un giorno lavorativo ";
        
        UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
        CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
        CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        lbl.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, labelSize.height);
        
        [customView addSubview:lbl];
        
        return customView;
    }
    
    return nil;
}
 */

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0;
}

//setta il colore delle label dell'header BIANCHE
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    if(section == 1){
        // create the parent view that will hold 1 or more buttons
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(21.0, 10.0, 280.0, 37)];
        
        // create the button object
        UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [b setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
        
        //[b setBackgroundColor:[UIColor grayColor]];
        
        b.frame = CGRectMake(21.0, 0, 280.0, 37);
        b.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [b setTitle:@"Registrati" forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        b.layer.cornerRadius = 8.0f;
        b.layer.masksToBounds = YES;
        
        // give it a tag in case you need it later
        //b.tag = 1;
        
        // this sets up the callback for when the user hits the button
        
        [b addTarget:self action:@selector(sendRequestClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        // add the button to the parent view
        [v addSubview:b];
        
        return [v autorelease];
        
    }
    else{
        
        
        UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)] autorelease];
        [customView setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.lineBreakMode = UILineBreakModeWordWrap;
        lbl.numberOfLines = 0;
        lbl.font = [UIFont boldSystemFontOfSize:20];
        
        
        
        lbl.text = [sectionDescription objectAtIndex:section];   
        
        UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
        CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
        CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        lbl.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, labelSize.height+6);
        
        [customView addSubview:lbl];
        
        return customView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
        TextFieldCell *cell = (TextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
}

#pragma mark - Bottoni view

-(void)cancel{
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)isNumeric:(NSString*)inputString{
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Numero di telefono non valido" message:@"Il numero deve esser composto da soli numeri" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return FALSE;
    }
    
    //controlla che i dati inseriti nel titolare siano solo caratteri
    
    //controllare formato email
    if( ! [Utilita isEmailValid:email]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail non valida" message:@"Controlla l'indirizzo inserito" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return FALSE;
    }
    
    
    return TRUE;
}



-(void)sendRequestClicked:(id)sender{
    
    //fa si che il testo inserito nei texfield sia preso anche se non è stata dismessa la keyboard
    [self.view endEditing:TRUE];
    
  
    //controllo i vari campi
    if ( ! [Utilita isStringEmptyOrWhite:self.nome] || ![Utilita isStringEmptyOrWhite:self.email] || ! [Utilita isStringEmptyOrWhite:self.telefono] || ! [Utilita isStringEmptyOrWhite:self.cognome]){
        NSLog(@"ERRORE ->qualche campo è vuoto");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"Inserire tutti i dati richiesti" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if( [Utilita isNumeric:self.nome] || [Utilita isNumeric:self.cognome]){
        NSLog(@" ERRORE -> nome o cognome  sono numeri");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"I campi Nome e Cognome non possono contenere  numeri" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
//    else if(! [Utilita isNumeric:self.telefono]){
//        NSLog(@"ERRORE ->telefo nn è un numero");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Numero di telefono formalmente non valido" message:@"Il numero di telefono deve contenere solo numeri" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
    else if( ! [ Utilita isEmailValid:self.email]){
        NSLog(@"ERRORE ->email nn valida");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail non valida" message:@"Controlla l'indirizzo inserito" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else{
        //controllo presenza rete
        if([Utilita networkReachable]){
            //lancio chiamata a server
            [dbAccess registerUserOnServer:[NSArray arrayWithObjects:self.email,[NSString stringWithFormat:@"%@",[Utilita checkPhoneNumber:self.telefono]],self.nome,self.cognome, nil]];
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Registrazione...";  
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
            [alert show];
            [alert release];
        }
    }
    
    //inviare email alla PerDue o salvare richiesta sul DB
    
}

#pragma mark - DatabaseDelegate

-(void)didReceiveResponsFromServer:(NSString *)receivedData{
    NSLog(@"RISPOSTA SERVER DOP REGISTRAZIONE: %@",receivedData);
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.hud = nil;
    
    NSString *trimmedString = [receivedData stringByTrimmingCharactersInSet:
                                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([trimmedString isEqualToString:@"utente registrato in precendenza"]){
        NSLog(@"UTENTE GIà REGISTRATO");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Utente già registrato" message:@"Risutli già registrato a perdue.it" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([trimmedString isEqualToString:@"registrazione ok"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Complimenti" message:@"Registrazione avvenuta con successo, riceverai a breve un'e-mail con i dettagli di registrazione e la password" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([trimmedString isEqualToString:@"errore parametri in ingresso non corretti"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"I parametri in ingresso non sono corretti, riprova" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"errore nel processo  di registrazione, riprova" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}

-(void)didReceiveError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.hud = nil;
    NSLog(@"ERRORE SERVER = %@", [error description]);
}

#pragma mark - TextField and TextView Delegate

- (void)textFieldDidEndEditing:(UITextField *)txtField
{   
    //recupera la cella relativa al texfield
    TextFieldCell *cell = (TextFieldCell *) [[txtField superview] superview];
    
    if([cell.dataKey isEqualToString:@"name"]){
        //[prefs setObject: txtField.text forKey:@"_numero"];
        self.nome = txtField.text;
    }
    else if([cell.dataKey isEqualToString:@"surname"]){
        self.cognome = txtField.text;
        //[prefs setObject: txtField.text forKey:@"_cvv"];
    }
    else if([cell.dataKey isEqualToString:@"email"]){
        //[prefs setObject: txtField.text forKey:@"_nome"];
        self.email = txtField.text;
    }
    else if([cell.dataKey isEqualToString:@"phone"]){
        //[prefs setObject: txtField.text forKey:@"_nome"];
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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [super viewDidLoad];
    
    [self setTitle:@"Registrazione"];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Annulla" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = cancelBtn;
    //self.navigationItem.rightBarButtonItem = saveBtn;
    
    //[saveBtn release];
    [cancelBtn release];

    
    sectionDescription = [[NSMutableArray alloc] initWithObjects:@"Inserisci i dati",@"", nil];  
    sectionData = [[NSMutableArray alloc] init];
    
    NSArray *secBtn = [[NSArray alloc] init];
    NSMutableArray *secB = [[NSMutableArray alloc] initWithCapacity:4];
    
    [secB insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                         @"name",              @"DataKey",
                         @"TextFieldCell",               @"kind",
                         @"Nome"      , @"label",
                         @"",                   @"detailLabel",
                         @"",               @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardTypeDefault], @"keyboardType",
                         nil] autorelease] atIndex: 0];
    
    [secB insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"surname",           @"DataKey",
                         @"TextFieldCell",       @"kind",
                         @"Cognome",   @"label",
                         @"",       @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardTypeDefault], @"keyboardType",
                         nil] autorelease] atIndex: 1];
    [secB insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"email",           @"DataKey",
                         @"TextFieldCell",       @"kind",
                         @"E-mail",   @"label",
                         @"",       @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardTypeEmailAddress], @"keyboardType",
                         nil] autorelease] atIndex: 2];
    
    [secB insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"phone",           @"DataKey",
                         @"TextFieldCell",       @"kind",
                         @"Telefono",   @"label",
                         @"",       @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardTypeNumbersAndPunctuation], @"keyboardType",
                         nil] autorelease] atIndex: 2];
    
    [sectionData insertObject:secB atIndex:0];
    [sectionData insertObject:secBtn atIndex:1];
    
    [secBtn release];
    [secB release];
    
    self.nome = @"";
    self.cognome = @"";
    self.telefono = @"";
    self.email = @"";
    
    dbAccess = [[DatabaseAccess alloc] init];
    dbAccess.delegate = self;
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
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [_hud release];
    _hud = nil;
    
    dbAccess.delegate = nil;
    [dbAccess release];
    self.nome = nil;
    self.cognome = nil;
    self.telefono = nil;
    self.email = nil;
    
    [sectionData release];
    [sectionDescription release];
    
    [super dealloc];
}

@end

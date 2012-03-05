//
//  DatiUtenteController.m
//  PerDueCItyCard
//
//  Created by mario greco on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatiUtenteController.h"
#import "BaseCell.h"
#import "TextFieldCell.h"
#import "ActionCell.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@implementation DatiUtenteController
@synthesize delegate, nome, cognome, telefono, email;

#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.job = nil; //commentato 19 novembre
    }
    return self;
}

#pragma mark - DataSourceDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 1){
        // create the parent view that will hold 1 or more buttons
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(21.0, 10.0, 280.0, 35)];
        
        // create the button object
        UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [b setBackgroundImage:[UIImage imageNamed:@"buttonGrayPattern.png"] forState:UIControlStateNormal];
        
        //[b setBackgroundColor:[UIColor grayColor]];
        
        b.frame = CGRectMake(21.0, 0.0, 280.0, 35);
        b.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [b setTitle:@"Cancella dati" forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        // give it a tag in case you need it later
        //b.tag = 1;
        
        // this sets up the callback for when the user hits the button
        [b addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // add the button to the parent view
        [v addSubview:b];
        
        return [v autorelease];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView   heightForHeaderInSection:(NSInteger)section {
    
    if(section == 3)
        return 46;
    else return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if(section == 1){
        return @"Premendo \"Cancella dati\" verranno cancellati i dati da te inseriti";
    }
    return nil;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return sectionDescripition.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{   
    if(sectionData){
        //         NSLog(@"[AbstractJobViewController numOfRows]: %d", cellDescription.count);
        return [[sectionData objectAtIndex: section] count];
    } 
    //    NSLog(@"[AbstractJobViewController numOfRows]: %d", 0);
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sec = [sectionData objectAtIndex:indexPath.section];
    NSDictionary *rowDesc = [sec objectAtIndex:indexPath.row]; 
    NSString *kind = [rowDesc objectForKey:@"kind"];
    NSString *dataKey = [rowDesc objectForKey:@"DataKey"];
    
    int cellStyle = UITableViewCellStyleDefault;
    
    BaseCell *cell = (BaseCell *)[tableView dequeueReusableCellWithIdentifier:dataKey];
    
    if (cell == nil) {       
        cell = [[[NSClassFromString(kind) alloc] initWithStyle: cellStyle reuseIdentifier:kind withDictionary:rowDesc] autorelease];
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
    else if([datakey isEqualToString:@"phone"]){
        ((TextFieldCell *)cell).textField.text = self.telefono;
        
        //((TextFieldCell *)cell).textField.text = [prefs objectForKey:@"_nome"];
    }
    else if([datakey isEqualToString:@"email"]){
        ((TextFieldCell *)cell).textField.text = self.email;
        
        //((TextFieldCell *)cell).textField.text = [prefs objectForKey:@"_nome"];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return [sectionDescripition objectAtIndex:section];
}

//azioni per le celle selezionate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    TextFieldCell *cell = (TextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
    
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
    else if([cell.dataKey isEqualToString:@"phone"]){
        //[prefs setObject: txtField.text forKey:@"_nome"];
        self.telefono = txtField.text;
    }
    else if([cell.dataKey isEqualToString:@"email"]){
        //[prefs setObject: txtField.text forKey:@"_nome"];
        self.email = txtField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
	[textField resignFirstResponder];
	return YES;
}



#pragma mark - TableViewDelegate


//setto altezza celle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - Gestione Bottoni view

-(void)cancelBtnClicked:(id)sender{
    
    [prefs removeObjectForKey:@"_nomeUtente"];
    [prefs removeObjectForKey:@"_cognome"];
    [prefs removeObjectForKey:@"_telefono"];
    [prefs removeObjectForKey:@"_email"];
    [prefs synchronize];
    
    self.nome = @"";
    self.cognome = @"";
    self.telefono = @"";
    self.email = @"";
    
    [self.tableView reloadData];

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
    if([allTrim(nome) length] == 0 || [allTrim(cognome) length] == 0 || 
       [allTrim(telefono) length] == 0 || [allTrim(email) length] == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dati mancanti" message:@"Per favore inserisci tutti i dati richiesti" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return FALSE ;
    }
    
    //controlla che i dati inseriti siano solo numerici per il numero carta e cvv
    if(![self isNumeric:telefono]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Numero di telefono formalmente non valido" message:@"Controlla il numero inserito" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return FALSE;
    }
    
    //controlla che i dati inseriti nel titolare siano solo caratteri
    
    return TRUE;
    
    
}

-(void)save{
    
    //dismette la tastiera e prende i salva i dati nelle variabili quando si preme il button
    [self.view endEditing:TRUE];
    
    NSLog(@"Save button pressed: \n nome = %@, cognome = %@, telefono = %@, email = %@",nome, cognome, telefono, email);
    
    if(! [self validateFields]){
        //qualcosa
    }
    else{
        
        [prefs removeObjectForKey:@"_nomeUtente"];
        [prefs setObject:nome forKey:@"_nomeUtente"];
        [prefs removeObjectForKey:@"_cognome"];
        [prefs setObject:cognome forKey:@"_cognome"];
        [prefs removeObjectForKey:@"_telefono"];
        [prefs setObject:telefono forKey:@"_telefono"];
        [prefs removeObjectForKey:@"_email"];
        [prefs setObject:email forKey:@"_email"];
        
        [prefs synchronize];
        
        if(delegate && [delegate respondsToSelector:@selector(didSaveUserDetail)])
            [self.delegate didSaveUserDetail];
    }
}

-(void)cancel{
    
    if(delegate && [delegate respondsToSelector:@selector(didAbortUserDetail)])
        [self.delegate didAbortUserDetail];
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{   
    [super viewDidLoad];
    [self.tableView setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease] ];
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    self.title = @"Dati utente";
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:139.0/255 green:29.0/255 blue:0.0 alpha:1]];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Conferma" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Annulla" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = cancelBtn;
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    [saveBtn release];
    [cancelBtn release];
    
    if([prefs objectForKey:@"_nomeUtente"])
        self.nome =  [prefs objectForKey:@"_nomeUtente"];
    else self.nome = @"";
    
    if([prefs objectForKey:@"_cognome"])
        self.cognome = [prefs objectForKey:@"_cognome"];
    else self.cognome = @"";
    
    if([prefs objectForKey:@"_telefono"])
        self.telefono = [prefs objectForKey:@"_telefono"];
    else self.telefono = @"";
        
    if([prefs objectForKey:@"_email"])
        self.email = [prefs objectForKey:@"_email"];
    else self.email = @"";
    
    sectionDescripition = [[NSArray alloc] initWithObjects:@"",@"", nil];
    
    NSMutableArray *secC = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *secD = [[NSMutableArray alloc] init];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"name",            @"DataKey",
                         @"TextFieldCell",    @"kind",
                         @"Nome",         @"label",
                         //@"Scegli...",             @"detailLabel",
                         @"Mario",         @"placeholder",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         nil] autorelease ]  atIndex: 0];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"surname",            @"DataKey",
                         @"TextFieldCell",    @"kind",
                         @"Cognome",         @"label",
                         //numeroCarta,                 @"detailLabel",
                         @"Rossi",         @"placeholder",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardTypeNumbersAndPunctuation], @"keyboardType",
                         nil] autorelease ]  atIndex: 1];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"phone",            @"DataKey",
                         @"TextFieldCell",    @"kind",
                         @"Telefono",           @"label",
                         @"061234567", @"placeholder",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardTypeNumbersAndPunctuation], @"keyboardType",
                         nil] autorelease] atIndex: 2];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"email",              @"DataKey",
                         @"TextFieldCell",    @"kind", 
                         @"E-mail",              @"label", 
                         // @"Seleziona data...",             @"detailLabel",
                         @"mario@prova.it",  @"placeholder",
                         @"",                 @"img", 
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         nil] autorelease] atIndex: 3];
    
    
    sectionData = [[NSArray alloc] initWithObjects: secC, secD, nil];
    
    [secC release];
    [secD release];
}



- (void)viewDidUnload
{   
    [sectionDescripition release];
    sectionDescripition = nil;
    [sectionData release];
    sectionData = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)dealloc
{
    [sectionDescripition release];
    [sectionData release];
    
    self.nome = nil;
    self.cognome = nil;
    self.telefono = nil;
    self.email = nil;
    
    [super dealloc];
}

@end

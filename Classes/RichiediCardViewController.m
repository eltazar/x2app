//
//  RichiediCardViewController.m
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RichiediCardViewController.h"
#import "BaseCell.h"
#import "TextFieldCell.h"
#import "Utilita.h"

//metodi e variabili private
@interface RichiediCardViewController ()

@property(nonatomic,retain) NSString *nome;
@property(nonatomic,retain) NSString *cognome;
@property(nonatomic,retain) NSString *telefono;
@property(nonatomic,retain) NSString *email;

-(BOOL)isValidFields;
@end

@implementation RichiediCardViewController
@synthesize nome,cognome,telefono,email;
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
        
        NSLog(@"CELL = %@",cell);
    }    
    
    [cell setDelegate:self];
    
    return cell;
}


#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)] autorelease];
        [customView setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.lineBreakMode = UILineBreakModeWordWrap;
        lbl.numberOfLines = 0;
        lbl.textAlignment =  UITextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:14];       
        
        
        lbl.text = @"Inviando la richiesta sarai ricontattato entro un giorno lavorativo ";
        
        UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
        CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
        CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        lbl.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, labelSize.height+6);
        
        [customView addSubview:lbl];
        
        return customView;
    }
    
    return nil;
}

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
        [b setBackgroundImage:[UIImage imageNamed:@"yellowButton.png"] forState:UIControlStateNormal];
        
        //[b setBackgroundColor:[UIColor grayColor]];
        
        b.frame = CGRectMake(21.0, 0, 280.0, 37);
        b.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [b setTitle:@"Invia richiesta" forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        
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



-(void)sendRequestClicked:(id)sender{
    
    //fa si che il testo inserito nei texfield sia preso anche se non è stata dismessa la keyboard
    [self.view endEditing:TRUE];
    
    if([self validateFields])
        NSLog(@"tutti campi sono validi!");
    
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
    
    [self setTitle:@"Gestione carte"];
    
    
    sectionDescription = [[NSMutableArray alloc] initWithObjects:@"I tuoi dati",@"", nil];  
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
                         nil] autorelease] atIndex: 0];
    
    [secB insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"surname",           @"DataKey",
                         @"TextFieldCell",       @"kind",
                         @"Cognome",   @"label",
                         @"",       @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         nil] autorelease] atIndex: 1];
    [secB insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"email",           @"DataKey",
                         @"TextFieldCell",       @"kind",
                         @"E-mail",   @"label",
                         @"",       @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         nil] autorelease] atIndex: 2];
    
    [secB insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"phone",           @"DataKey",
                         @"TextFieldCell",       @"kind",
                         @"Telefono",   @"label",
                         @"",       @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         nil] autorelease] atIndex: 2];
    
    [sectionData insertObject:secB atIndex:0];
    [sectionData insertObject:secBtn atIndex:1];
    
    [secBtn release];
    [secB release];
    
    self.nome = @"";
    self.cognome = @"";
    self.telefono = @"";
    self.email = @"";
    
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
    
    self.nome = nil;
    self.cognome = nil;
    self.telefono = nil;
    self.email = nil;
    
    [sectionData release];
    [sectionDescription release];
    
    [super dealloc];
}

@end
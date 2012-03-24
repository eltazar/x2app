//
//  LoginControllerBis.m
//  PerDueCItyCard
//
//  Created by mario greco on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginControllerBis.h"
#import "BaseCell.h"
#import "TextFieldCell.h"
#import "ActionCell.h"
#import "RegistrazioneController.h"
#import "Utilita.h"

@interface LoginControllerBis() {
}
@property(nonatomic,retain)NSString *user;
@property(nonatomic, retain)NSString *psw;
-(void)fillCell: (UITableViewCell *)cell rowDesc:(NSDictionary *)rowDesc;
@end

@implementation LoginControllerBis
@synthesize user,psw,delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:139.0/255 green:29.0/255 blue:0.0 alpha:1]];
    
    self.title = @"Benvenuto";
    
    dbAccess = [[DatabaseAccess alloc] init];
    dbAccess.delegate = self;
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Annulla" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    sectionDescription = [[NSArray alloc] initWithObjects:@"Login",@"",@"Non ricordi la password?",@"Non sei registrato?", nil];
    
    NSMutableArray *secC = [[NSMutableArray alloc] initWithCapacity:2];
    NSMutableArray *secD = [[NSMutableArray alloc] init];
    NSMutableArray *secE = [[NSMutableArray alloc] initWithCapacity:1];
     NSMutableArray *secG = [[NSMutableArray alloc] initWithCapacity:1];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"user",            @"DataKey",
                         @"TextFieldCell",    @"kind",
                         @"E-mail",         @"label",
                         //@"Scegli...",             @"detailLabel",
                         @"E-email di registrazione",  @"placeholder",
                         [NSString stringWithFormat:@"%d", NO], @"isSecret",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardTypeDefault], @"keyboardType",
                         nil] autorelease ]  atIndex: 0];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"psw",            @"DataKey",
                         @"TextFieldCell",    @"kind",
                         @"Password",         @"label",
                         @"La tua password",  @"placeholder",
                         [NSString stringWithFormat:@"%d", YES], @"isSecret",
                         //numeroCarta,                 @"detailLabel",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardTypeDefault], @"keyboardType",
                         nil] autorelease ]  atIndex: 1];
    
    [secE insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"remeber",            @"DataKey",
                         @"ActionCell",    @"kind",
                         @"Ricorda password",         @"label",
                         //numeroCarta,                 @"detailLabel",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",                         nil] autorelease ]  atIndex: 0];
    
    [secG insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"register",            @"DataKey",
                         @"ActionCell",    @"kind",
                         @"Registrati",         @"label",
                         //numeroCarta,                 @"detailLabel",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",                         nil] autorelease ]  atIndex: 0];
    
    sectionData = [[NSArray alloc] initWithObjects:secC,secD,secE,secG,nil];
    
    [secC release];
    [secD release];
    [secE release];
    [secG release];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - bottoni view
-(void)cancel{
    
    if(delegate && [delegate respondsToSelector:@selector(didAbortLogin)])
        [self.delegate didAbortLogin];
    
}


#pragma mark - DBAccessDelegate

-(void)didReceiveCoupon:(NSDictionary *)coupon{
    
    NSLog(@"VALORE RITORNATO DA SERVER CHECK EMAIL = %@",coupon);
    
    NSArray *array;//= [[coupon objectForKey:@"checkEmail"] retain];
    
    // NSLog(@"DIMENSIONE ARRAY = %d",[array count]);
    
    if([coupon objectForKey:@"login"]){
        array = [[coupon objectForKey:@"login"] retain];
        if(array.count == 2){
            NSLog(@"UTENTE ESISTE");
            idUtente = [[[array objectAtIndex:0] objectForKey:@"idcustomer"] intValue];
            NSLog(@" ID CUSTOMER LOGIN = %d",idUtente);
            
            //salvo i dati per il login
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs removeObjectForKey:@"_idUtente"];
            [prefs setObject:[NSNumber numberWithInt:idUtente] forKey:@"_idUtente"];
            [prefs removeObjectForKey:@"_nomeUtente"];
            [prefs setObject:[[array objectAtIndex:0] objectForKey:@"nome_contatto"] forKey:@"_nomeUtente"];
            [prefs removeObjectForKey:@"_cognome"];
            [prefs setObject:[[array objectAtIndex:0] objectForKey:@"cognome_contatto"] forKey:@"_cognome"];
            [prefs removeObjectForKey:@"_email"];
            [prefs setObject:self.user forKey:@"_email"];
            [prefs synchronize];
            
            if(delegate && [delegate respondsToSelector:@selector(didLogin:)])
                [delegate didLogin:idUtente];
            
        }
        else{
            NSLog(@"PSW SBAGLIATA ");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Spiacenti" message:@"L'utente o la password non esistono. Inserisci i dati login corretti e riprova" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
        
    [array release];
    
}

-(void)didReceiveError:(NSError *)error{
    
    NSLog(@"ERRORE CHECK EMAIL SU SERVER = %@",[error description]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore rete" message:@"Non è stato possibile effettuare la richiesta, riprovare" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


#pragma mark - TextField and TextView Delegate

- (void)textFieldDidEndEditing:(UITextField *)txtField
{   
    //recupera la cella relativa al texfield
    TextFieldCell *cell = (TextFieldCell *) [[txtField superview] superview];
    
    if([cell.dataKey isEqualToString:@"user"]){
        //[prefs setObject: txtField.text forKey:@"_numero"];
        self.user = txtField.text;
    }
    else if([cell.dataKey isEqualToString:@"psw"]){
        self.psw= txtField.text;
        //[prefs setObject: txtField.text forKey:@"_cvv"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - Gestione bottoni view



#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return [sectionDescription objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return sectionDescription.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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

-(void)fillCell: (UITableViewCell *)cell rowDesc:(NSDictionary *)rowDesc
{
    NSString *datakey= [rowDesc objectForKey:@"DataKey"];
    
    if([datakey isEqualToString:@"user"]){
        ((TextFieldCell *)cell).textField.text = self.user;
        //((TextFieldCell *)cell).textField.text = [prefs objectForKey:@"_numero"];
    }
    else if([datakey isEqualToString:@"psw"]){
        ((TextFieldCell *)cell).textField.text = self.psw;
        //((TextFieldCell *)cell).textField.text = [prefs objectForKey:@"cvv"];
    }
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView   heightForHeaderInSection:(NSInteger)section {
    
    if(section == 1)
        return 60;
    else return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 1){
        // create the parent view that will hold 1 or more buttons
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(21.0, 10.0, 280.0, 37)];
        
        // create the button object
        UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [b setBackgroundImage:[UIImage imageNamed:@"buttonGrayPattern.png"] forState:UIControlStateNormal];
        
        //[b setBackgroundColor:[UIColor grayColor]];
        
        b.frame = CGRectMake(21.0, 0.0, 280.0, 37);
        b.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [b setTitle:@"Login" forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        // give it a tag in case you need it later
        //b.tag = 1;
        
        // this sets up the callback for when the user hits the button
        [b addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
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
        lbl.font = [UIFont boldSystemFontOfSize:18];
        
        lbl.text = [sectionDescription objectAtIndex:section];

        UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
        CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
        CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        lbl.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, labelSize.height+6);
        
        [customView addSubview:lbl];
        
        return customView;
    }
    
    return nil;
}

-(void)loginBtnClicked:(id)sender{
    //dismette la tastiera e salva i dati nelle variabili quando si preme il button
    [self.view endEditing:TRUE];
    
    if(! [Utilita isStringEmptyOrWhite:self.user] || ![Utilita isStringEmptyOrWhite:self.psw]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dati mancanti" message:@"Devono esser inseriti entrambi i dati richiesti, riprova" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if(![Utilita isEmailValid:self.user]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Formato email errato" message:@"Inserisci un indirizzo e-mail valido e riprova" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else{
        NSArray *data = [NSArray arrayWithObjects:self.user, self.psw,nil];
        [dbAccess checkUserFields:data];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        TextFieldCell *cell = (TextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }
    else if(indexPath.section == 3 && indexPath.row == 0){
        RegistrazioneController *regController = [[RegistrazioneController alloc] initWithNibName:@"RegistrazioneController" bundle:nil];
        [self.navigationController pushViewController:regController animated:YES];
        [regController release];
    }
}

#pragma mark - MemoryManagement

- (void)dealloc {
    
    dbAccess.delegate = nil;
    [dbAccess release];
    [sectionData release];
    [sectionDescription release];
    self.user = nil;
    self.psw = nil;
    [super dealloc];
}

@end
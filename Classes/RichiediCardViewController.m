//
//  RichiediCardViewController.m
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RichiediCardViewController.h"
#import "BaseCell.h"
#import "TextFieldCell.h"
#import "Utilita.h"
#import "PickerViewController.h"
#import "ActionCell.h"
#import "PDHTTPAccess.h"
#import "MBProgressHUD.h"

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//metodi e variabili private
@interface RichiediCardViewController ()

@property(nonatomic, retain) UIActionSheet *confirmActionSheet;
@property(nonatomic,retain) NSString *nome;
@property(nonatomic,retain) NSString *cognome;
@property(nonatomic,retain) NSString *telefono;
@property(nonatomic,retain) NSString *email;
@property(nonatomic,retain) NSString *tipoCarta;

-(void)fillCell: (UITableViewCell *)cell rowDesc:(NSDictionary *)rowDesc;
@end

@implementation RichiediCardViewController
@synthesize nome,cognome,telefono,email,tipoCarta, confirmActionSheet;
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
    NSString *kind = [rowDesc objectForKey:@"kind"];
    int cellStyle = UITableViewCellStyleDefault;
    
   // NSLog(@"dataKey = %@, kind = %@",dataKey,kind);
    
    BaseCell *cell = (BaseCell *)[tableView dequeueReusableCellWithIdentifier: kind];
    
    //se non è recuperata creo una nuova cella
	if (cell == nil) {        
        cell = [[[NSClassFromString(kind) alloc] initWithStyle: cellStyle reuseIdentifier:kind withDictionary:rowDesc] autorelease];
        
        //NSLog(@"CELL = %@",cell);
    }    
    
    if(indexPath.section == 0 && isNew){
        cell.detailTextLabel.text = @"Scegli...";
    }
    
    [self fillCell:cell rowDesc:rowDesc];
    
    [cell setDelegate:self];
    
    return cell;
}


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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if(section == 1){
        return nil;
    }
    
    UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)] autorelease];
    [customView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.lineBreakMode = UILineBreakModeWordWrap;
    lbl.numberOfLines = 0;
    lbl.textAlignment =  UITextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:14];       
    
    if(section == 0){
        lbl.text = @"Per richiedere la Guida ai Vantaggi + Carta PerDue";
    }
    else if(section == 2){
        lbl.text = @"Sarai ricontattato entro un giorno lavorativo ";
    }
    
    UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    lbl.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, labelSize.height);
    
    [customView addSubview:lbl];
    [lbl release];
    return customView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 30;
    }
    else if(section == 2){
        return 2;
    }
    else if(IOS_VERSION < 5.0)
        return 0;
    else return [super tableView:tableView heightForFooterInSection:section];
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
//    if(section != 0)
//        return 35.0;
//    else
    if(section == 1){
        return 35.0;
    }
    else if(section == 2){
        return 25;
    }
    else if(IOS_VERSION < 5.0)
        return 0;
    else return [super tableView:tableView heightForHeaderInSection:section];
}

//setta il colore delle label dell'header BIANCHE
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 2){
        // create the parent view that will hold 1 or more buttons
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(21.0, 10.0, 280.0, 40)];
        
        // create the button object
        UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [b setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
        
        //[b setBackgroundColor:[UIColor grayColor]];
        
        b.frame = CGRectMake(21.0, 0, 280.0, 40);
        b.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [b setTitle:@"Invia richiesta via email allo staff di Carta PerDue" forState:UIControlStateNormal];
        b.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        b.titleLabel.numberOfLines = 0;
        [b.titleLabel sizeToFit];
        b.titleLabel.textAlignment = UITextAlignmentCenter;
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
        [lbl release];
        
        return customView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if(indexPath.section != 0){
        TextFieldCell *cell = (TextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }
    else{
        //creo actionSheet con un solo tasto custom
        UIActionSheet *myActionSheet = [[UIActionSheet alloc] initWithTitle:@"Tipo di carta" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Seleziona", nil];
        //setto il frame NN CE NE è BISOGNO; PERCHé???
        //        [actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
        
        myActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        //imposto questo controller come delegato dell'actionSheet
        [myActionSheet setDelegate:self];
        //[actionSheet showInView:self.view];
        [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
        //setto i bounds dell'action sheet in modo tale da contenere il picker
        [myActionSheet setBounds:CGRectMake(0,0,320, 565)]; 
        
        //array contenente le subviews dello sheet (sono 2, il titolo e il bottone custom
        NSArray *subviews = [myActionSheet subviews];
        //setto il frame del tasto così da mostrarlo sotto al picker
        //1 lo passo a mano, MODIFICARE
        [[subviews objectAtIndex:1] setFrame:CGRectMake(20, 255, 280, 46)]; 
        [myActionSheet addSubview: pickerCards.view];   
        NSLog(@"ACTION SHEET SUBVIEWS: %@, num = %d", myActionSheet.subviews,myActionSheet.subviews.count);
        [myActionSheet release];

    }
}

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{   
    int actionSheetSubviewNumber = 2;
    
    if(IOS_VERSION >= 6.0)
        actionSheetSubviewNumber = 3;
    
        
    if([actionSheet.title isEqualToString:@"Conferma richiesta"]){
     
        if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Invia"]){
            
            if([Utilita networkReachable]){
                
                //NSLog(@"tutti campi sono validi!");
                
                //prendo solo il nome del tipo carta, senza prezzo
                NSString *token = [[self.tipoCarta componentsSeparatedByString:@" "] objectAtIndex:0];
                
                NSLog(@"token = %@",token);
                
                NSArray *data = [NSArray arrayWithObjects:token,self.nome,self.cognome,[Utilita checkPhoneNumber:self.telefono],self.email, nil];
                //NSLog(@"%@",data);
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = @"Invio...";
                
                [PDHTTPAccess requestACard:data delegate:self];
                
             
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
                [alert show];
                [alert release];
            }

        }
        
    }
    else if([[actionSheet.subviews objectAtIndex:actionSheetSubviewNumber] tag] == 777){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        BaseCell *cell = (ActionCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.detailTextLabel.text = [pickerCards.objectsInRow objectAtIndex:0];
        
        self.tipoCarta = [pickerCards.objectsInRow objectAtIndex:0];
        
        NSLog(@" carta  = %@, cell = %@",self.tipoCarta,cell.detailTextLabel.text);
        
        isNew = NO;
        
    }
    
    [self.tableView reloadData];
    
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
    if(! [Utilita isStringEmptyOrWhite:nome] || ! [Utilita isStringEmptyOrWhite:cognome]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dati mancanti" message:@"Per favore inserisci il tuo nome e cognome" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return FALSE ;
    }
    
    if([self.tipoCarta isEqualToString:@"Scegli..."]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Scegli il tipo di carta" message:@"Per favore scegli quale carta PerDue richiedere" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return FALSE ;
    }
    
    //controlla che i dati inseriti nel titolare siano solo caratteri
    
    NSString *telefonoTemp = [Utilita checkPhoneNumber:self.telefono];
    
    if(![Utilita isStringEmptyOrWhite:telefonoTemp] && ! [Utilita isStringEmptyOrWhite:email]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contatti mancanti" message:@"Per favore inserisci almeno un tuo recapito" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return FALSE ;
    }
    
    //controllare formato email
    if( ![email isEqualToString:@""] && ! [Utilita isEmailValid:email]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail non valida" message:@"Controlla l'indirizzo inserito" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return FALSE;
    }
    
//    //controlla che i dati inseriti siano solo numerici per il numero di telefono
//    if(![Utilita isNumeric:telefono]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Numero di telefono formalmente non valido" message:@"Il numero deve esser composto da soli numeri" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        return FALSE;
//    }
    
    return TRUE;
}



-(void)sendRequestClicked:(id)sender{
    
    //fa si che il testo inserito nei texfield sia preso anche se non è stata dismessa la keyboard
    [self.view endEditing:TRUE];
    
    if([self validateFields]){
        [self.confirmActionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    /*
    if([Utilita networkReachable]){
    
        if([self validateFields]){
            NSLog(@"tutti campi sono validi!");
            
            //prendo solo il nome del tipo carta, senza prezzo
            NSString *token = [[self.tipoCarta componentsSeparatedByString:@" "] objectAtIndex:0];
            
            NSLog(@"token = %@",token);
            
            NSArray *data = [NSArray arrayWithObjects:token,self.nome,self.cognome,self.telefono,self.email, nil];
            NSLog(@"%@",data);
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Invio...";
            
            [PDHTTPAccess requestACard:data delegate:self];
            
        }    
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
		[alert show];
        [alert release];
    }*/
}


#pragma mark PDHTTPAccessDelegate

-(void)didReceiveString:(NSString *)receivedString{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"Richiesta inviata";
    
   [hud hide:YES afterDelay:3];
    
    //NSLog(@"%@",receivedString);
}

-(void)didReceiveError:(NSError *)error{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     hud.customView = nil;
    hud.labelText = @"Errore, riprova";
    hud.mode = MBProgressHUDModeCustomView;
    
    [hud hide:YES afterDelay:3];
    //NSLog(@"errore server =%@",error.description);
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
        
    [self setTitle:@"Richiedi"];
    
    isNew = YES;
    self.tipoCarta = @"Scegli...";
    
    self.confirmActionSheet = [[UIActionSheet alloc] init];
    self.confirmActionSheet.delegate = self;
    self.confirmActionSheet.title = @"Conferma richiesta";
    [self.confirmActionSheet addButtonWithTitle:@"Invia"];
    [self.confirmActionSheet addButtonWithTitle:@"Annulla"];
    self.confirmActionSheet.destructiveButtonIndex = 1;
    
    sectionDescription = [[NSMutableArray alloc] initWithObjects:@"",@"I tuoi dati",@"", nil];  
    sectionData = [[NSMutableArray alloc] init];
    
    NSArray *secBtn = [[NSArray alloc] init];
    NSMutableArray *secB = [[NSMutableArray alloc] initWithCapacity:4];
    NSMutableArray *secA = [[NSMutableArray alloc] initWithCapacity:1];
    
    [secA insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"type",            @"DataKey",
                         @"ActionCell",    @"kind",
                         @"Tipo Carta",         @"label",
                         //@"Scegli...",             @"detailLabel",
                         @"Scegli la tua carta",         @"placeholder",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         nil] autorelease ]  atIndex: 0];
    
    [secB insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                         @"name",              @"DataKey",
                         @"TextFieldCell",               @"kind",
                         @"Nome"      , @"label",
                         @"",                   @"detailLabel",
                         @"",               @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardAppearanceDefault], @"keyboardType",
                         nil] autorelease] atIndex: 0];
    
    [secB insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"surname",           @"DataKey",
                         @"TextFieldCell",       @"kind",
                         @"Cognome",   @"label",
                         @"",       @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardAppearanceDefault], @"keyboardType",
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
    
    [sectionData insertObject:secA atIndex:0];
    [sectionData insertObject:secB atIndex:1];
    [sectionData insertObject:secBtn atIndex:2];
    
    NSArray *payCards = [[NSArray alloc] initWithObjects:@"Semestrale 20€",@"Annuale 36€",@"Biennale  55€", nil];
    pickerCards = [[PickerViewController alloc] initWithArray:[NSArray arrayWithObjects:payCards,nil] andNumber:1];
    [payCards release];
    
    [secA release];
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
    self.confirmActionSheet = nil;
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

    [pickerCards release];
    self.confirmActionSheet = nil;
    self.nome = nil;
    self.cognome = nil;
    self.telefono = nil;
    self.email = nil;
    
    [sectionData release];
    [sectionDescription release];
    
    [super dealloc];
}

@end

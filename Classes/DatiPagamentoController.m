//
//  DatiPagamentoController.m
//  PerDueCItyCard
//
//  Created by mario greco on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatiPagamentoController.h"
#import "BaseCell.h"
#import "PickerViewController.h"
#import "TextFieldCell.h"
#import "ActionCell.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@implementation DatiPagamentoController
@synthesize delegate, titolare, numeroCarta, tipoCarta, cvv, scadenza;

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
        return @"Premendo \"Cancella dati\" i dati relativi alla tua carta di credito saranno rimossi";
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
    
    if(indexPath.row == 0){
        cell.detailTextLabel.text = self.tipoCarta;
    }
    else if(indexPath.row == 3){
        cell.detailTextLabel.text = self.scadenza;
    }
    
    [self fillCell:cell rowDesc:rowDesc];
    
    [cell setDelegate:self];
    
    return cell;    
}

//riempe le celle in base ai dati del job creato
-(void)fillCell: (UITableViewCell *)cell rowDesc:(NSDictionary *)rowDesc
{
   NSString *datakey= [rowDesc objectForKey:@"DataKey"];
    
    if([datakey isEqualToString:@"number"]){
        ((TextFieldCell *)cell).textField.text = self.numeroCarta;
        //((TextFieldCell *)cell).textField.text = [prefs objectForKey:@"_numero"];
    }
    else if([datakey isEqualToString:@"cvv"]){
        ((TextFieldCell *)cell).textField.text = self.cvv;
        //((TextFieldCell *)cell).textField.text = [prefs objectForKey:@"cvv"];
    }
    else if([datakey isEqualToString:@"owner"]){
        ((TextFieldCell *)cell).textField.text = self.titolare;
        
        //((TextFieldCell *)cell).textField.text = [prefs objectForKey:@"_nome"];
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return [sectionDescripition objectAtIndex:section];
}

//azioni per le celle selezionate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int section = indexPath.section;
    int row = indexPath.row;
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(section == 0 && row == 0){
        
        //creo actionSheet con un solo tasto custom
        myActionSheet = [[UIActionSheet alloc] initWithTitle:@"Tipo di carta" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Seleziona", nil];
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
        
        [myActionSheet addSubview: pickerCards.view];

    }
    else if(section == 0 && row == 3){
        
        //creo actionSheet con un solo tasto custom
        myActionSheet = [[UIActionSheet alloc] initWithTitle:@"Data scadenza" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Seleziona", nil];
        //setto il frame NN CE NE è BISOGNO; PERCHé???
        //        [actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
        
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
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)selectedFromActionSheet{

    NSLog(@"dismiss");
}



#pragma mark - TextField and TextView Delegate

- (void)textFieldDidEndEditing:(UITextField *)txtField
{   
    //recupera la cella relativa al texfield
    TextFieldCell *cell = (TextFieldCell *) [[txtField superview] superview];
    
    if([cell.dataKey isEqualToString:@"number"]){
        //[prefs setObject: txtField.text forKey:@"_numero"];
        self.numeroCarta = txtField.text;
    }
    else if([cell.dataKey isEqualToString:@"cvv"]){
        self.cvv = txtField.text;
        //[prefs setObject: txtField.text forKey:@"_cvv"];
    }
    else if([cell.dataKey isEqualToString:@"owner"]){
        //[prefs setObject: txtField.text forKey:@"_nome"];
        self.titolare = txtField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
	[textField resignFirstResponder];
	return YES;
}


#pragma mark - ActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{   

    if([[actionSheet.subviews objectAtIndex:2] tag] == 777){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        BaseCell *cell = (ActionCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.detailTextLabel.text = [pickerCards.objectsInRow objectAtIndex:0];
        
        NSLog(@" carta di credito = %@, cell = %@",[pickerCards.objectsInRow objectAtIndex:0],cell.detailTextLabel.text);
        
       
        self.tipoCarta = [pickerCards.objectsInRow objectAtIndex:0];
        
        //[prefs setObject: [pickerCards.objectsInRow objectAtIndex:0] forKey:@"_tipoCarta"];
        
    }
    else if([[actionSheet.subviews objectAtIndex:2] tag] == 778){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        BaseCell *cell = (ActionCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"cell = %@, %p",cell,cell);
        NSString *date = [NSString stringWithFormat:@"%@/%@",[pickerDate.objectsInRow objectAtIndex:0],[pickerDate.objectsInRow objectAtIndex:1]];
        
        NSLog(@"date = %@", date);
        
        cell.detailTextLabel.text = date;
        
        
        NSLog(@" data  cell = %@",cell.detailTextLabel.text);
    
        //[prefs setObject: date forKey:@"_scadenza"];
        
        self.scadenza = date;
        
    }

    [self.tableView reloadData];
    
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
    
    [prefs removeObjectForKey:@"_nome"];
    [prefs removeObjectForKey:@"_tipoCarta"];
    [prefs removeObjectForKey:@"_numero"];
    [prefs removeObjectForKey:@"_cvv"];
    [prefs removeObjectForKey:@"_scadenza"];
    [prefs synchronize];
    
    self.titolare = @"";
    self.tipoCarta = @"";
    self.numeroCarta = @"";
    self.scadenza = @"";
    self.cvv = @"";
    
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
    if([allTrim(titolare) length] == 0 || [allTrim(tipoCarta) length] == 0 || 
       [allTrim(numeroCarta) length] == 0 || [allTrim(cvv) length] == 0 ||
       [allTrim(scadenza) length] == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dati mancanti" message:@"Per favore inserisci tutti i dati richiesti" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return FALSE ;
    }
    
    //controlla formato della stringa scadenza
    if([scadenza isEqualToString:@"--/--"] || [[scadenza substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"--"] || [[scadenza substringWithRange:NSMakeRange(3, 2)] isEqualToString:@"--"]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Formato data errato" message:@"Seleziona una data di scadenza valida" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return FALSE;
    }
    
    //controlla che i dati inseriti siano solo numerici per il numero carta e cvv
    if(![self isNumeric:numeroCarta]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Numero carta di credito formalmente non valido" message:@"Controlla il numero inserito" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return FALSE;
    }
    
    if(![self isNumeric:cvv]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Codice CVV formalmente non valido" message:@"Controlla il numero inserito" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
    
    NSLog(@"Save button pressed: \n titolare = %@, numero = %@, cvv = %@, tipo = %@, scadenza = %@", titolare, numeroCarta, cvv, tipoCarta, scadenza);
    
    if(! [self validateFields]){
        //qualcosa
    }
    else{
    
        [prefs removeObjectForKey:@"_nome"];
        [prefs setObject:titolare forKey:@"_nome"];
        [prefs removeObjectForKey:@"_tipoCarta"];
        [prefs setObject:tipoCarta forKey:@"_tipoCarta"];
        [prefs removeObjectForKey:@"_numero"];
        [prefs setObject:numeroCarta forKey:@"_numero"];
        [prefs removeObjectForKey:@"_cvv"];
        [prefs setObject:cvv forKey:@"_cvv"];
        [prefs removeObjectForKey:@"_scadenza"];
        [prefs setObject:scadenza forKey:@"_scadenza"];
        
        [prefs synchronize];
        
        if(delegate && [delegate respondsToSelector:@selector(didSavePaymentDetail)])
            [self.delegate didSavePaymentDetail];
    }
}

-(void)cancel{

    if(delegate && [delegate respondsToSelector:@selector(didAbortPaymentDetail)])
        [self.delegate didAbortPaymentDetail];
       
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{   
    [super viewDidLoad];
    [self.tableView setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease] ];
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    self.title = @"Dati pagamento";
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:139.0/255 green:29.0/255 blue:0.0 alpha:1]];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Conferma" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Annulla" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = cancelBtn;
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    [saveBtn release];
    [cancelBtn release];
    
    if([prefs objectForKey:@"_nome"])
        self.titolare =  [prefs objectForKey:@"_nome"];
    else self.titolare = @"";
    
    if([prefs objectForKey:@"_tipoCarta"])
         self.tipoCarta = [prefs objectForKey:@"_tipoCarta"];
    else self.tipoCarta = @"";
    
    if([prefs objectForKey:@"_numero"])
        self.numeroCarta = [prefs objectForKey:@"_numero"];
    else self.numeroCarta = [prefs objectForKey:@"_numero"];
    
    self.cvv = @"";
    
    if([prefs objectForKey:@"_scadenza"])
        self.scadenza = [prefs objectForKey:@"_scadenza"];
    else self.scadenza = @"";
    
    sectionDescripition = [[NSArray alloc] initWithObjects:@"",@"", nil];
    
    NSMutableArray *secC = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *secD = [[NSMutableArray alloc] init];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"type",            @"DataKey",
                         @"ActionCell",    @"kind",
                         @"Tipo Carta",         @"label",
                         //@"Scegli...",             @"detailLabel",
                         @"Visa, Mastercard, ...",         @"placeholder",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         nil] autorelease ]  atIndex: 0];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"number",            @"DataKey",
                         @"TextFieldCell",    @"kind",
                         @"Numero",         @"label",
                         //numeroCarta,                 @"detailLabel",
                         @"1234123412341234",         @"placeholder",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardTypeNumbersAndPunctuation], @"keyboardType",
                         nil] autorelease ]  atIndex: 1];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"cvv",            @"DataKey",
                         @"TextFieldCell",    @"kind",
                         @"CVV",           @"label",
                         @"123", @"placeholder",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardTypeNumbersAndPunctuation], @"keyboardType",
                         nil] autorelease] atIndex: 2];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"expire",              @"DataKey",
                         @"ActionCell",    @"kind", 
                         @"Scadenza",              @"label", 
                        // @"Seleziona data...",             @"detailLabel",
                         @"01/2013",  @"placeholder",
                         @"",                 @"img", 
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         nil] autorelease] atIndex: 3];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"owner",            @"DataKey",
                         @"TextFieldCell",    @"kind",
                         @"Titolare",           @"label",
                         //titolare,             @"detailLabel",
                         @"Mario Rossi", @"placeholder",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardTypeDefault], @"keyboardType",
                         nil] autorelease] atIndex: 4];
    
    
    sectionData = [[NSArray alloc] initWithObjects: secC, secD, nil];
    
    NSArray *payCards = [[NSArray alloc] initWithObjects:@"--",@"Visa",@"Mastercard",@"Maestro", nil];
    pickerCards = [[PickerViewController alloc] initWithArray:[NSArray arrayWithObjects:payCards,nil] andNumber:1];
    [payCards release];
    

    NSArray *calendar = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"--",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil],[NSArray arrayWithObjects:@"--",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2020",@"2021",@"2022",@"2023",@"2024", nil] , nil];
    
    pickerDate = [[PickerViewController alloc] initWithArray: calendar andNumber:2];

    [calendar release];
    
    [secC release];
    [secD release];
}



- (void)viewDidUnload
{   
    [sectionDescripition release];
    sectionDescripition = nil;
    [sectionData release];
    sectionData = nil;
    
    [pickerCards release];
    pickerCards = nil;
    
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
    [pickerCards release];
    [pickerDate release];
    [myActionSheet release];
    
    [sectionDescripition release];
    [sectionData release];
    
    self.titolare = nil;
    self.numeroCarta = nil;
    self.cvv = nil;
    self.scadenza = nil;
    self.tipoCarta = nil;
    
    [super dealloc];
}

@end
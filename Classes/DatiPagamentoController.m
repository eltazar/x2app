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

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 \
green:((c>>16)&0xFF)/255.0 \
blue:((c>>8)&0xFF)/255.0 \
alpha:((c)&0xFF)/255.0]

@implementation DatiPagamentoController
@synthesize delegate;

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
    
    
    //[self fillCell:cell rowDesc:rowDesc];
    
    [cell setDelegate:self];
    
    return cell;    
}

//riempe le celle in base ai dati del job creato
-(void)fillCell: (UITableViewCell *)cell rowDesc:(NSDictionary *)rowDesc
{
   /* NSString *datakey= [rowDesc objectForKey:@"DataKey"];
    
    if([datakey isEqualToString:@"employee"]){
        cell.detailTextLabel.text = job.field;
        if(job.field == nil || [job.field isEqualToString:@""])
            ((ActionCell *)cell).detailTextLabel.text = [rowDesc objectForKey:@"placeholder"];
        else ((ActionCell *)cell).detailTextLabel.text = job.field;
    }
    else if([datakey isEqualToString:@"description"])
        ((TextAreaCell*)cell).textView.text = job.description;
    else if([datakey isEqualToString:@"phone"])
        ((TextFieldCell *)cell).textField.text = job.phone;
    else if([datakey isEqualToString:@"phone2"])
        ((TextFieldCell *)cell).textField.text = job.phone2;
    else if([datakey isEqualToString:@"email"])
        ((TextFieldCell *)cell).textField.text = job.email;
    else if([datakey isEqualToString:@"url"])
        ((TextFieldCell *)cell).textField.text = [job.url absoluteString]; 

    */
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return [sectionDescripition objectAtIndex:section];
}

//azioni per le celle selezionate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int section = indexPath.section;
    int row = indexPath.row;
    //    NSURL *url; 
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(section == 0 && row == 0){
        
        //creo actionSheet con un solo tasto custom
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Tipo di carta" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Seleziona", nil];
        //setto il frame NN CE NE è BISOGNO; PERCHé???
        //        [actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        //imposto questo controller come delegato dell'actionSheet
        [actionSheet setDelegate:self];
        //[actionSheet showInView:self.view];
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        //setto i bounds dell'action sheet in modo tale da contenere il picker
        [actionSheet setBounds:CGRectMake(0,0,320, 500)]; 
        
        //array contenente le subviews dello sheet (sono 2, il titolo e il bottone custom
        NSArray *subviews = [actionSheet subviews];
        //setto il frame del tasto così da mostrarlo sotto al picker
        //1 lo passo a mano, MODIFICARE
        [[subviews objectAtIndex:1] setFrame:CGRectMake(20, 255, 280, 46)]; 
//        pickerView = [[PickerViewController alloc] initw];
        [actionSheet addSubview: pickerCards.view];
        
        //inizializzo la cella al primo elemento del picker
        //cell.detailTextLabel.text = pickerView.jobCategory;
        
        //inizializzo la cella al primo elemento del picker
        //cell.detailTextLabel.text = pickerView.jobCategory;
    }
    else if(section == 0 && row == 3){
        
        //creo actionSheet con un solo tasto custom
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Data scadenza" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Seleziona", nil];
        //setto il frame NN CE NE è BISOGNO; PERCHé???
        //        [actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        //imposto questo controller come delegato dell'actionSheet
        [actionSheet setDelegate:self];
        //[actionSheet showInView:self.view];
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        //setto i bounds dell'action sheet in modo tale da contenere il picker
        [actionSheet setBounds:CGRectMake(0,0,320, 500)]; 
        
        //array contenente le subviews dello sheet (sono 2, il titolo e il bottone custom
        NSArray *subviews = [actionSheet subviews];
        //setto il frame del tasto così da mostrarlo sotto al picker
        //1 lo passo a mano, MODIFICARE
        [[subviews objectAtIndex:1] setFrame:CGRectMake(20, 255, 280, 46)]; 
        //        pickerView = [[PickerViewController alloc] initw];
        [actionSheet addSubview: pickerDate.view];
        
        //inizializzo la cella al primo elemento del picker
        //cell.detailTextLabel.text = pickerView.jobCategory;
        
        //inizializzo la cella al primo elemento del picker
        //cell.detailTextLabel.text = pickerView.jobCategory;
        
    }
}


#pragma mark - TextField and TextView Delegate

- (void)textFieldDidEndEditing:(UITextField *)txtField
{   
    //recupera la cella relativa al texfield
    TextFieldCell *cell = (TextFieldCell *) [[txtField superview] superview];
    
    if([cell.dataKey isEqualToString:@"type"])
        tipoCarta = txtField.text;
    else if([cell.dataKey isEqualToString:@"number"])
        numeroCarta = txtField.text;
    else if([cell.dataKey isEqualToString:@"cvv"])
        cvv = txtField.text;
    else if([cell.dataKey isEqualToString:@"expire"])
        scadenza = txtField.text;
    else if([cell.dataKey isEqualToString:@"owner"])
        titolare = txtField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - ActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{   
    NSLog(@"EDITA_TABLE: job.employee = ");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
//    if(pickerView.jobCategory != nil)
//        cell.detailTextLabel.text = pickerView.jobCategory;
//    else cell.detailTextLabel.text = @"Scegli...";
    
    //salvo dato preso dal picker dentro job
    //job.employee = pickerView.jobCategory;
    //   NSLog(@"EDITA_TABLE: job.employee = %@",job.employee);
    //    NSLog(@"job puntatore: %p",job);
}

#pragma mark - TableViewDelegate


//setto altezza celle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - Gestione Bottoni view

-(void)save{
    NSLog(@"Save button pressed");
}

-(void)cancel{

    if(delegate && [delegate respondsToSelector:@selector(didAbortPaymentDetail)])
        [self.delegate didAbortPaymentDetail];
       
}

-(void)getCardInfo{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"USER DEFAULTS = %@",[prefs objectForKey:@"xxxxxxxx"]);
    
    if([prefs objectForKey:@"_nome"])
        titolare = [prefs objectForKey:@"_nome"];
    
    if([prefs objectForKey:@"_tipoCarta"])
        tipoCarta = [prefs objectForKey:@"_tipoCarta"];
    
    if([prefs objectForKey:@"_numero"])
        numeroCarta = [prefs objectForKey:@"_numero"];
    
    if([prefs objectForKey:@"_scadenza"])
        scadenza = [prefs objectForKey:@"_scadenza"];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{   
    [super viewDidLoad];
    [self.tableView setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease] ];
    
    self.title = @"Dati pagamento";
    
    UIColor *color = HEXCOLOR(0x8B1800);
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:139.0/255 green:29.0/255 blue:0.0 alpha:1]];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Salva" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Annulla" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = cancelBtn;
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    [saveBtn release];
    [cancelBtn release];
    
    [self getCardInfo];
    
    sectionDescripition = [[NSArray alloc] initWithObjects:@"", nil];
    
    NSMutableArray *secC = [[NSMutableArray alloc] initWithCapacity:5];
    
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"type",            @"DataKey",
                         @"InfoCell",    @"kind",
                         @"Tipo Carta",         @"label",
                         tipoCarta,             @"detailLabel",
                         @"Visa, Mastercard, ...",         @"placeholder",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         nil] autorelease ]  atIndex: 0];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"number",            @"DataKey",
                         @"TextFieldCell",    @"kind",
                         @"Numero",         @"label",
                         numeroCarta,                 @"detailLabel",
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
                         @"InfoCell",    @"kind", 
                         @"Scadenza",              @"label", 
                         scadenza,             @"detailLabel",
                         @"01/2013",  @"placeholder",
                         @"",                 @"img", 
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         nil] autorelease] atIndex: 3];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"owner",            @"DataKey",
                         @"TextFieldCell",    @"kind",
                         @"Titolare",           @"label",
                         titolare,             @"detailLabel",
                         @"Mario Rossi", @"placeholder",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         [NSString stringWithFormat:@"%d", UIKeyboardTypeDefault], @"keyboardType",
                         nil] autorelease] atIndex: 4];
    
    
    sectionData = [[NSArray alloc] initWithObjects: secC,nil];
    
    NSArray *payCards = [[NSArray alloc] initWithObjects:@"", @"Visa",@"Mastercard",@"Maestro", nil];
    pickerCards = [[PickerViewController alloc] initWithArray:[NSArray arrayWithObjects:payCards,nil] andNumber:1];
    [payCards release];
    

    NSArray *calendar = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil],[NSArray arrayWithObjects:@"Gennaio",@"Febbraio",@"Marzo",@"Aprile",@"Maggio",@"Giugno",@"Luglio",@"Agosto",@"Settembre",@"Ottobre",@"Novembre",@"Dicembre", nil] , nil];
    
    pickerDate = [[PickerViewController alloc] initWithArray: calendar andNumber:2];

    [calendar release];
    
    [secC release];
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
    
    [sectionDescripition release];
    [sectionData release];
    
    [titolare release];
    [tipoCarta release];
    [numeroCarta release];
    [scadenza release];
    [cvv release];
    
    [super dealloc];
}

@end
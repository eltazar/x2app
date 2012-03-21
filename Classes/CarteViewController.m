//
//  CarteViewController.m
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CarteViewController.h"
#import "BaseCell.h"
#import "CartaTableViewCell.h"
#import "PerDueCItyCardAppDelegate.h"
#import "AbbinaCartaViewController.h"
#import "PerDueCItyCardAppDelegate.h"
#import "RichiediCardViewController.h"
#import "ControlloCartaController.h"
#import "AcquistoOnlineController.h"
#import "Utilita.h"
#import "LocalDatabaseAccess.h"

#define MAX_CARD 6

@implementation CarteViewController

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
//        if([kind isEqualToString:@"CartaTableViewCell"]){
//            
//            cell = (CartaTableViewCell *)[CartaTableViewCell cellFromNibNamed:@"CartaTableViewCell" andDictionary:rowDesc];            
//        }
//        else {
//            cell = [[[NSClassFromString(kind) alloc] initWithStyle: cellStyle reuseIdentifier:kind withDictionary:rowDesc] autorelease];
//        }
        
        cell = [[[NSClassFromString(kind) alloc] initWithStyle: cellStyle reuseIdentifier:kind withDictionary:rowDesc] autorelease];
        
        //NSLog(@"CELL = %@",cell);
    }
    
    if([kind isEqualToString:@"CartaTableViewCell"]){
        NSLog(@"carta per due");
        ((CartaTableViewCell*)cell).nome.text =  [NSString stringWithFormat:@"%@ %@",[rowDesc objectForKey:@"nome"], [rowDesc objectForKey:@"cognome"]];
        ((CartaTableViewCell*)cell).tessera.text =  [rowDesc objectForKey:@"tessera"];
        if([Utilita isDateExpired:[rowDesc objectForKey:@"data"]])
            ((CartaTableViewCell*)cell).data.text = @"Scaduta";
        else ((CartaTableViewCell*)cell).data.text =  [rowDesc objectForKey:@"data"];
    }
    else if([kind isEqualToString:@"ActionCell"]){
        cell.textLabel.text = [rowDesc objectForKey:@"label"];
        cell.detailTextLabel.text = [rowDesc objectForKey:@"subtitle"];
    }
    
    if(indexPath.section == 1 && numCarteAbbinate >= MAX_CARD){
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0;
}

//setta il colore delle label dell'header BIANCHE
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)] autorelease];
    [customView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.lineBreakMode = UILineBreakModeWordWrap;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont boldSystemFontOfSize:20];
    
	
    
    lbl.text = [sectionDescription objectAtIndex:section];
    
    //	if (section == 0)
    //	{
    //		lbl.text = [sectionDescripition objectAtIndex:section];
    //	}
    //	if (section == 1){
    //        
    //        //queste due qui sotto settarle dopo...
    //		lbl.text = @"Operazioni";
    //		
    //	}
    //	
    //	if (section == 2){
    //		lbl.text = @"Contatti";	
    //        
    //    }
    
    
    UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    lbl.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, labelSize.height+6);
    
    [customView addSubview:lbl];
    
    return customView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    BaseCell *cell = (BaseCell*) [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"CELL DATAKEY = %@",cell.dataKey);
    
    if (numCarteAbbinate < MAX_CARD && [cell.dataKey isEqualToString:@"abbina"]) {
        
        AbbinaCartaViewController *abbinaCartaViewController = [[AbbinaCartaViewController alloc] init];
        abbinaCartaViewController.delegate = self;
        [self.navigationController pushViewController:abbinaCartaViewController animated:YES];
        [abbinaCartaViewController release];
    }
    else if(numCarteAbbinate < MAX_CARD && [cell.dataKey isEqualToString:@"richiedi"])
    {
        RichiediCardViewController *richiediViewController = [[RichiediCardViewController alloc] initWithNibName:@"RichiediCardViewController" bundle:nil];
        [self.navigationController pushViewController:richiediViewController animated:YES];
        [richiediViewController release];
    }
    else if(numCarteAbbinate < MAX_CARD && [cell.dataKey isEqualToString:@"acquista"]){
        
        AcquistoOnlineController *acquistaController = [[AcquistoOnlineController alloc] initWithNibName:@"AcquistoOnlineController" bundle:nil];
        [self.navigationController pushViewController:acquistaController animated:YES];
        [acquistaController release];
    }
    else if([cell.dataKey isEqualToString:@"card"]){
        
        ControlloCartaController *controllaCartaCtrl = [[ControlloCartaController alloc] initWithCardDetail:[NSDictionary dictionaryWithObjectsAndKeys:((CartaTableViewCell*)cell).nome.text,@"titolare",((CartaTableViewCell*)cell).tessera.text, @"tessera",((CartaTableViewCell*)cell).data.text,@"scadenza",nil]];
        [self.navigationController pushViewController:controllaCartaCtrl animated:YES];
        [controllaCartaCtrl release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Azione non permesssa" message:@"Hai raggiunto il numero massimo di carte associabili al dispositivo" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
     
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



-(NSMutableArray*)creaDataContent{
    NSError *error;
    NSArray *cardsArray = [LocalDatabaseAccess fetchStoredCardsAndWriteErrorIn:&error];
    NSMutableArray *dataContent = [[NSMutableArray alloc] init];
    
    // TODO: controllare errori
    for(int i = 0; i < cardsArray.count ; i++){
        //creo l'array di dizionari per le righe della sezione "carte"            
        CartaPerDue *carta = [cardsArray objectAtIndex:i];
        
        [dataContent insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                             @"card",               @"DataKey",
                             @"CartaTableViewCell", @"kind",
                             carta.name,            @"nome",
                             carta.surname,         @"cognome",
                             carta.number,          @"tessera",
                             carta.expiryString,    @"data",
                             [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",nil] autorelease] atIndex: i];
    }
    return [dataContent autorelease];
}

-(void)didMatchNewCard{
    
    NSLog(@" quiiiiiiiiiii");
    
    if(sectionData.count == 1){
        [sectionDescription replaceObjectAtIndex:0 withObject:@"Carte"];
        [sectionDescription insertObject:@"Gestione" atIndex:1];
        
        NSArray *tempA = [[sectionData objectAtIndex:0]retain];
        
        [sectionData removeObjectAtIndex:0];
        [sectionData insertObject:[self creaDataContent] atIndex:0];
        [sectionData insertObject:tempA atIndex:1];
        
        [tempA release];
    }
    else if(sectionData.count > 1){
        
        [sectionData replaceObjectAtIndex:0 withObject:[self creaDataContent]];
    }
    
    numCarteAbbinate = [[sectionData objectAtIndex:0] count];

 }

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Gestione carte"];
    
    sectionDescription = [[NSMutableArray alloc] init];
 
    
    NSMutableArray *secA = [[self creaDataContent] retain];
    
    if(secA && secA.count > 0){
        [sectionDescription insertObject:@"Carte" atIndex:0];
        [sectionDescription insertObject:@"Gestione" atIndex:1];
    }
    else{
        [sectionDescription insertObject:@"Gestione" atIndex:0];
    }
    
    NSMutableArray *secB = [[NSMutableArray alloc] init];
    
    [secB insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                         @"abbina",              @"DataKey",
                         @"ActionCell",               @"kind",
                         @"Abbina la tua carta"      , @"label",
                         @"",                   @"detailLabel",
                         @"Per abbinare la tua carta reale all'iPhone", @"subtitle",
                         @"",               @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleSubtitle], @"style",
                         nil] autorelease] atIndex: 0];
    
    [secB insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"acquista",           @"DataKey",
                         @"ActionCell",       @"kind",
                         @"Acquista carta",   @"label",
                         @"Per acquistare la carta PerDue online", @"subtitle",
                         @"",       @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleSubtitle], @"style",
                         nil] autorelease] atIndex: 1];
    [secB insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"richiedi",           @"DataKey",
                         @"ActionCell",       @"kind",
                         @"Richiedi carta",   @"label",
                         @"Sarai ricontattato da PerDue", @"subtitle",
                         @"",       @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleSubtitle], @"style",
                         nil] autorelease] atIndex: 2];
    
    
    if(secA && secA.count > 0){
        sectionData = [[NSMutableArray alloc] init];
        [sectionData insertObject:secA atIndex:0];
        [sectionData insertObject:secB atIndex:1];
        numCarteAbbinate = secA.count;
    
    }
    else{
        sectionData = [[NSMutableArray alloc] initWithObjects:secB, nil];
    }
    
    [secA release];
    [secB release];

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
    [self.tableView reloadData];
    NSLog(@"********UDID: %@",[[UIDevice currentDevice] uniqueIdentifier]);

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

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc{
    
    [sectionData release];
    [sectionDescription release];
    
    
    [super dealloc];
}


@end

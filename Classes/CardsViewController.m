//
//  CarteViewController.m
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define MAX_CARD 6

#import "CardsViewController.h"
#import "BaseCell.h"
#import "CartaTableViewCell.h"
#import "PerDueCItyCardAppDelegate.h"
#import "AbbinaCartaViewController.h"
#import "PerDueCItyCardAppDelegate.h"
#import "RichiediCardViewController.h"
#import "DettaglioCartaViewController.h"
#import "AcquistoOnlineController.h"
#import "Utilita.h"
#import "LocalDatabaseAccess.h"
#import "DatabaseAccess.h"
#import "LoginControllerBis.h"
#import "LocalDatabaseAccess.h"


@interface CardsViewController() {
    NSInteger nAssociatedCards;

    NSMutableArray *sectionDescription;
    NSMutableArray *sectionData;
    DatabaseAccess *_dbAccess;
    NSIndexPath *_selectedRow;
}
@property (nonatomic, retain) NSIndexPath *selectedRow;
@property (nonatomic, retain) NSMutableArray *sectionDescription;
@property (nonatomic, retain) NSMutableArray *sectionData;
@property (nonatomic, retain) DatabaseAccess *dbAccess;
- (NSMutableArray*)creaDataContent;
@end


@implementation CardsViewController


@synthesize sectionData, sectionDescription, dbAccess=_dbAccess,selectedRow;


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
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
    [self setTitle:@"Gestione carte"];
    
    // Allocazione strutture dati del Data Model
    self.sectionDescription = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *cardsSection  = [[self creaDataContent] retain];
    NSMutableArray *manageSection = [[NSMutableArray alloc] init];
    NSMutableArray *retrieveSection = [[NSMutableArray alloc]init];
    
    // Inizializzazione struttura dati della sezione di gestione
    [manageSection insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  @"abbina",                @"DataKey",
                                  @"ActionCell",            @"kind",
                                  @"Abbina la tua carta",   @"label",
                                  @"",                      @"detailLabel",
                                  @"Per abbinare la tua carta reale all'iPhone", @"subtitle",
                                  @"",                      @"img",
                                  [NSString stringWithFormat:@"%d", UITableViewCellStyleSubtitle], @"style",
                                  nil] autorelease] atIndex: 0];
    
    [manageSection insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"acquista",              @"DataKey",
                                  @"ActionCell",            @"kind",
                                  @"Acquista carta",        @"label",
                                  @"Per acquistare la carta PerDue online", @"subtitle",
                                  @"",                      @"img",
                                  [NSString stringWithFormat:@"%d", UITableViewCellStyleSubtitle], @"style",
                                  nil] autorelease] atIndex: 1];
    [manageSection insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"richiedi",              @"DataKey",
                                  @"ActionCell",            @"kind",
                                  @"Richiedi carta",        @"label",
                                  @"Sarai ricontattato da PerDue", @"subtitle",
                                  @"",                      @"img",
                                  [NSString stringWithFormat:@"%d", UITableViewCellStyleSubtitle], @"style",
                                  nil] autorelease] atIndex: 2];
    
    [retrieveSection insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"recupera",              @"DataKey",
                                  @"ActionCell",            @"kind",
                                  @"Recupera carta PerDue",        @"label",
                                  @"Se hai effettuato l'acquisto online", @"subtitle",
                                  @"",                      @"img",
                                  [NSString stringWithFormat:@"%d", UITableViewCellStyleSubtitle], @"style",
                                  nil] autorelease] atIndex: 0];
    
    
    // se la sezione "Carte" è vuota, non la aggiungo al model, così da nasconderla
    if (cardsSection && cardsSection.count > 0) {
        [self.sectionDescription insertObject:@"Carte" atIndex:0];
        [self.sectionDescription insertObject:@"Gestione" atIndex:1];
        [self.sectionDescription insertObject:@"Recupera acquisti" atIndex:2];
        
        self.sectionData = [[[NSMutableArray alloc] initWithObjects:cardsSection, manageSection, retrieveSection, nil] autorelease];
        nAssociatedCards = cardsSection.count;
    } else {
        [self.sectionDescription insertObject:@"Gestione" atIndex:0];
        [self.sectionDescription insertObject:@"Recupera acquisti" atIndex:1];
        self.sectionData = [[[NSMutableArray alloc] initWithObjects:manageSection, retrieveSection, nil] autorelease];
    }
    
    self.dbAccess = [[[DatabaseAccess alloc] init] autorelease];
    self.dbAccess.delegate = self;
    
// TODO: trovare un modo per far sparire le carte associate con altri devices    
    [cardsSection release];
    [manageSection release];
    [retrieveSection release];
}


- (void)viewWillAppear:(BOOL)animated {
    // FIXME: Il reloadData rompe l'animazione. bisogna usare come cristo comanda i metodi per l'inserimento delle righe nelle tabelle.
    [super viewWillAppear:animated];    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]  animated:YES];
    [self.tableView reloadData];
    NSLog(@"********UDID: %@",[[UIDevice currentDevice] uniqueDeviceIdentifier]);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    self.selectedRow = nil;
    self.sectionData = nil;
    self.sectionDescription = nil;
    self.dbAccess.delegate = nil;
    self.dbAccess = nil;
}


- (void)dealloc {
    self.selectedRow = nil;
    self.sectionData = nil;
    self.sectionDescription = nil;
    self.dbAccess.delegate = nil;
    [_dbAccess release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - LoginControllerDelegate

- (void)didLogin:(int)idUtente {
    NSLog(@"IN CARDS CONTROLLER DOPO LOGIN id = %d", idUtente);
    [self dismissModalViewControllerAnimated:YES];
    

    [self tableView:self.tableView didSelectRowAtIndexPath:self.selectedRow];
    
}


-(void)didAbortLogin{
    NSLog(@"Abortito login da parte dell'utente");
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionDescription.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {  
    return [self.sectionDescription objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section{   
    if(self.sectionData){
        return [[self.sectionData objectAtIndex: section] count];
    } 
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sec = [self.sectionData objectAtIndex:indexPath.section];
    NSDictionary *rowDesc = [sec objectAtIndex:indexPath.row]; 
    NSString *kind = [rowDesc objectForKey:@"kind"];
    int cellStyle = UITableViewCellStyleDefault;
    
    //NSLog(@"dataKey = %@, kind = %@",dataKey,kind);
    
    BaseCell *cell = (BaseCell *)[tableView dequeueReusableCellWithIdentifier: kind];
    
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
        CartaTableViewCell *cardCell = (CartaTableViewCell *) cell;
        CartaPerDue *card = [rowDesc objectForKey:@"card"];
        cardCell.nome.text    =  [NSString stringWithFormat:@"%@ %@",card.name, card.surname];
        cardCell.tessera.text =  card.number;
        if (card.isExpired)
            cardCell.data.text = [NSString stringWithFormat:@"Scaduta il %@", card.expiryString];
        else cardCell.data.text =  card.expiryString;
    }
    else if([kind isEqualToString:@"ActionCell"]){
        cell.textLabel.text = [rowDesc objectForKey:@"label"];
        cell.detailTextLabel.text = [rowDesc objectForKey:@"subtitle"];
    }
    
    if(indexPath.section == 1 && nAssociatedCards >= MAX_CARD){
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
}


#pragma mark - UITableViewDelegate


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30.0;
}

//setta il colore delle label dell'header BIANCHE
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)] autorelease];
    [customView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.lineBreakMode = UILineBreakModeWordWrap;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont boldSystemFontOfSize:20];
    lbl.text = [self.sectionDescription objectAtIndex:section];
    
    //	if (section == 0)
    //	{
    //		lbl.text = [self.sectionDescripition objectAtIndex:section];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    // "Navigo" il model fino alla cella selezionata
    NSArray *sec = [self.sectionData objectAtIndex:indexPath.section];
    NSDictionary *row = [sec objectAtIndex:indexPath.row];
    NSString *dataKey = [row objectForKey:@"DataKey"];
    
    self.selectedRow = indexPath;
    
    // Click su una carta
    if ([dataKey isEqualToString:@"card"]){
        CartaPerDue *card = [row objectForKey:@"card"];
        DettaglioCartaViewController *controllaCartaCtrl = [[DettaglioCartaViewController alloc] initWithCard:card];
        [self.navigationController pushViewController:controllaCartaCtrl animated:YES];
        [controllaCartaCtrl release];
    }
    
    // Click su un tasto relativo all'aggiunta / acquisto IAP / richiesta d'acquisto di una tessera
    // nel caso in cui abbiamo già abbinato il numero massimo di tessere consentito
    else if (nAssociatedCards >= MAX_CARD) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Azione non permesssa" message:@"Hai raggiunto il numero massimo di carte associabili al dispositivo" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
            
    // Click sul tasto "abbina"
    else if ([dataKey isEqualToString:@"abbina"]) {
        
        AbbinaCartaViewController *abbinaCartaViewController = [[AbbinaCartaViewController alloc] init];
        abbinaCartaViewController.delegate = self;
        [self.navigationController pushViewController:abbinaCartaViewController animated:YES];
        [abbinaCartaViewController release];
    }
    
    // Click sul tasto "richiedi"
    else if ([dataKey isEqualToString:@"richiedi"]){
        RichiediCardViewController *richiediViewController = [[RichiediCardViewController alloc] initWithNibName:@"RichiediCardViewController" bundle:nil];
        [self.navigationController pushViewController:richiediViewController animated:YES];
        [richiediViewController release];
    }
    
    // Click sul tasto "acquista"
    else if ([dataKey isEqualToString:@"acquista"]){
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSNumber *idUtente = [prefs objectForKey:@"_idUtente"];
        
        if (!idUtente) {
            //lancio view modale per il login
            LoginControllerBis *loginController = [[LoginControllerBis alloc] initWithNibName:@"LoginControllerBis" bundle:nil];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
            loginController.delegate = self;
            [loginController release];
            
            
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentModalViewController:navController animated:YES];
            [navController release];
            
        } 
        else{            
            AcquistoOnlineController *acquistaController = [[AcquistoOnlineController alloc] initWithNibName:@"AcquistoOnlineController" bundle:nil];
            [self.navigationController pushViewController:acquistaController animated:YES];
            [acquistaController release];
        }
    }
    
    else if ([dataKey isEqualToString:@"recupera"]){
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSNumber *idUtente = [prefs objectForKey:@"_idUtente"];
        
        if (!idUtente) {
            //lancio view modale per il login
            LoginControllerBis *loginController = [[LoginControllerBis alloc] initWithNibName:@"LoginControllerBis" bundle:nil];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
            loginController.delegate = self;
            [loginController release];
            
            
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentModalViewController:navController animated:YES];
            [navController release];
            
        } 
        else{            
            //lancio query per recupero della carta acquistato dall'utente idutente
            NSLog(@"ID UTENTE = %d",[idUtente intValue]);
            [_dbAccess retrieveCardFromServer:[idUtente intValue]];
        }
        
    }
}

#pragma mark - DBAccessDelegate

-(void)didReceiveCoupon:(NSDictionary *)coupon{
    
    if([coupon objectForKey:@"CartaRecuperata"] &&
       [[coupon objectForKey:@"CartaRecuperata"] count] > 1){
        NSLog(@"CARTA RICEVUTA = %@",coupon);
        
        CartaPerDue *card = [[CartaPerDue alloc] init];
        card.name = @"prova";
        card.surname = @"ciao";
        NSLog(@"numero carta = %@",[[[coupon objectForKey:@"CartaRecuperata"] objectAtIndex:0] objectForKey:@"codice_carta"]);

        card.number = [[[coupon objectForKey:@"CartaRecuperata"] objectAtIndex:0] objectForKey:@"codice_carta"];
        
        NSLog(@"DATA SCADENZA = %@",[[[coupon objectForKey:@"CartaRecuperata"] objectAtIndex:0] objectForKey:@"data_scadenza"]);
        
        card.expiryString = [[[coupon objectForKey:@"CartaRecuperata"] objectAtIndex:0] objectForKey:@"data_scadenza"];
        
        NSError *error;
        if (![[LocalDatabaseAccess getInstance]storeCard:card AndWriteErrorIn:&error]) {
            NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
        } else if (self && [self respondsToSelector:@selector(didAssociateNewCard)]) {
            [self didAssociateNewCard];
            [self.tableView reloadData];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }       
    }
    else{
#warning mostrare alert ad utente
        NSLog(@"NO CARTA RECUPERATA");
    }
}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"ERRORE = %@", error.description);
}


# pragma mark - AbbinaCartaDelegate


- (void)didAssociateNewCard {
    
    NSLog(@" quiiiiiiiiiii");
    
    if (self.sectionData.count == 2) {
        [self.sectionDescription replaceObjectAtIndex:0 withObject:@"Carte"];
        [self.sectionDescription insertObject:@"Gestione" atIndex:1];
        
        NSArray *tempA = [[self.sectionData objectAtIndex:0]retain];
        
        [self.sectionData removeObjectAtIndex:0];
        [self.sectionData insertObject:[self creaDataContent] atIndex:0];
        [self.sectionData insertObject:tempA atIndex:1];
        
        [tempA release];
    } else if(self.sectionData.count > 2){
        
        [self.sectionData replaceObjectAtIndex:0 withObject:[self creaDataContent]];
    }
    
    nAssociatedCards = [[self.sectionData objectAtIndex:0] count];
    [self.navigationController popViewControllerAnimated:YES];
}


# pragma mark - CardsViewController (private methods)


- (NSMutableArray*)creaDataContent {
    NSError *error;
    NSArray *cardsArray = [[LocalDatabaseAccess getInstance]fetchStoredCardsAndWriteErrorIn:&error];
    NSMutableArray *dataContent = [[NSMutableArray alloc] init];
    
    // TODO: controllare errori
    for(int i = 0; i < cardsArray.count ; i++){
        //creo l'array di dizionari per le righe della sezione "carte"            
        CartaPerDue *card = [cardsArray objectAtIndex:i];
        
        NSMutableDictionary *tempDict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          @"card",               @"DataKey",
                                          @"CartaTableViewCell", @"kind",
                                          card,                  @"card",
                                          [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                                          nil] autorelease];
        
        [dataContent insertObject: tempDict atIndex: i];
    }
    return [dataContent autorelease];
}


@end

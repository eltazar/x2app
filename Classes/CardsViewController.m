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
#import "LoginControllerBis.h"
#import "UIDevice+IdentifierAddition.h"
#import "PDHTTPAccess.h"


@interface CardsViewController() {
    NSInteger nAssociatedCards;

    NSMutableArray *sectionDescription;
    NSMutableArray *sectionData;
    NSIndexPath *_selectedRow;
}
@property (nonatomic, retain) NSIndexPath *selectedRow;
@property (nonatomic, retain) NSMutableArray *sectionDescription;
@property (nonatomic, retain) NSMutableArray *sectionData;
- (NSMutableArray*)creaDataContent;
@end


@implementation CardsViewController



@synthesize sectionData, sectionDescription, selectedRow;



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
    
    NSLog(@"cards did load");
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[IAPHelper sharedHelper]];
    
    [self setTitle:@"Gestione carte"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:kDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAbortLogout) name:kDidAbortLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAssociateNewCard) name:kPurchasedCard object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteCard) name:kDeletedCard object:nil];
    
    //inapp purchase
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(cardDownloadError:) name:kCardServerError object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(cardDownloaded:) name:kCardDownloaded object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(cardDownloading:) name:kCardDownloading object: nil];
    
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
    
    
// TODO: trovare un modo per far sparire le carte associate con altri devices    
    [cardsSection release];
    [manageSection release];
    [retrieveSection release];
}


- (void)viewWillAppear:(BOOL)animated {
    // FIXME: Il reloadData rompe l'animazione. bisogna usare come cristo comanda i metodi per l'inserimento delle righe nelle tabelle.
    [super viewWillAppear:animated];   
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]  animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSNumber *idUtente = [prefs objectForKey:@"_idUtente"];
    
    //se utente è loggato aggiorno model con nuova riga
    if (idUtente && [[self.sectionData objectAtIndex:self.sectionData.count - 1]count] == 1 ){
//        [self.sectionDescription insertObject:@"" atIndex:self.sectionDescription.count];
        
        NSMutableArray *logoutSection = [self.sectionData objectAtIndex:self.sectionData.count-1];
        NSLog(@"section = %@",logoutSection);
        [logoutSection insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"logout",              @"DataKey",
                                      @"ActionCell",            @"kind",
                                      @"Logout",        @"label",
                                      @"Per effettuare il logout da perdue.it", @"subtitle",
                                      @"",                      @"img",
                                      [NSString stringWithFormat:@"%d", UITableViewCellStyleSubtitle], @"style",
                                      nil] autorelease] atIndex: 1];
        
//        [self.sectionData replaceObjectAtIndex:self.sectionData.count-1 withObject:logoutSection];
//        [logoutSection release];
    }
    
    
    [self.tableView reloadData];
    NSLog(@"********UDID: %@",[[UIDevice currentDevice] identificativoUnivocoDispositivo]);
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
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidAbortLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPurchasedCard object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kDeletedCard object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCardServerError object:nil];    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCardDownloaded object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCardDownloading object:nil];
    
    self.selectedRow = nil;
    self.sectionData = nil;
    self.sectionDescription = nil;
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
        NSLog(@"section n = %d",section);
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

- (void)tableView:tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *sec = [self.sectionData objectAtIndex:indexPath.section];
    NSDictionary *rowDesc = [sec objectAtIndex:indexPath.row]; 
    NSString *dataKey = [rowDesc objectForKey:@"DataKey"];
    
    if([dataKey isEqualToString:@"abbina"] || [dataKey isEqualToString:@"acquista"]){
        if([[LocalDatabaseAccess getInstance] isThereAvalidCard]){
            cell.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.userInteractionEnabled = NO;
        }
    }
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
            if([Utilita networkReachable]){
                //lancio query per recupero della carta acquistato dall'utente idutente
                NSLog(@"ID UTENTE = %d",[idUtente intValue]);
                [PDHTTPAccess retrieveCardFromServer:[idUtente intValue] delegate:self]; 
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
                [alert show];
                [alert release];
            }
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    else if([dataKey isEqualToString:@"logout"]){
        
        DataLoginController *dataLogin = [[DataLoginController alloc] initWithNibName:@"DataLoginController" bundle:nil];
        //dataLogin.delegate = self;        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:dataLogin];
        [dataLogin release];
        
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentModalViewController:navController animated:YES];
        
        [navController release];        
    }
}

#pragma mark - InAppPurchase metodi per gestire acquisti recuperati o non terminati



-(void) cardDownloadError:(NSNotification*) notification{
 
    NSLog(@"CARDS CONTROLLER : errore lato server nel recupero carta");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void) cardDownloaded:(NSNotification*) notification{
        
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"CARDS CONTROLLER : carta scaricata = %@",notification.object);
    //mostrare alert
    
    //TODO: creare la carta con i dati ricevuti e nome e cognome presi da userdefault, quindi salvare sul db locale
    
    NSDictionary *cardReceived = (NSDictionary*)notification.object;
    
    CartaPerDue *card = [[CartaPerDue alloc] init];
    card.name = [[NSUserDefaults standardUserDefaults] objectForKey:@"originalName"];
    card.surname = [[NSUserDefaults standardUserDefaults] objectForKey:@"originalSurname"];     
    card.number = [cardReceived objectForKey:@"number"];
    
    card.expiryString = [cardReceived objectForKey:@"expiryDate"];
    
    NSError *error;
    if (![[LocalDatabaseAccess getInstance]storeCard:card error:&error]) {
        NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
    } else{
        //[self didAssociateNewCard];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPurchasedCard object:nil];
    }
    
    [card release];
    
    //crash se le sezioni sono 2, ovvero senza carte aggiunte
    
    [self didAssociateNewCard];
    
    [self.tableView reloadData];
}

-(void) cardDownloading:(NSNotification*) notification{
    
    NSLog(@"CARDS CONTROLLER : downloading carta acquistata");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Recupero acquisto";
    hud.detailsLabelText = @"Download carta...";
}

#pragma mark - DataLoginDelegate

-(void)didLogout{
    
    NSLog(@"did logout in cards view controller");
    
    //se effettuo il logout cancello i dati della carta di credito, perchè non è detto che al prossimo login sia  lo stesso utente
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_nome"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_tipoCarta"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_numero"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_cvv"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_scadenza"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //NSLog(@"sec data = %@, count = %d",[self.sectionData objectAtIndex:self.sectionData.count - 1],[[self.sectionData objectAtIndex:self.sectionData.count - 1] count]);
    
    //se nella sezione c'è la riga "logout" la rimuovo
    if([[self.sectionData objectAtIndex:self.sectionData.count - 1] count] > 1){
        NSLog(@"entrato in remove logout row");
        [[self.sectionData objectAtIndex:self.sectionData.count - 1] removeObjectAtIndex:1];
    }
    [self.tableView reloadData];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)didAbortLogout{    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - WMHTTPAccessDelegate

-(void)didReceiveJSON:(NSDictionary *)jsonDict {
    
    NSLog(@"procedura recupero carta count = %d, tipo = %@",[[jsonDict objectForKey:@"CartaRecuperata"] count],[[jsonDict objectForKey:@"CartaRecuperata"] class]);
    
    if([jsonDict objectForKey:@"CartaRecuperata"] &&
       [[jsonDict objectForKey:@"CartaRecuperata"] count] > 0){
      
        //dal server arriva arrai senza valore sentinella alla fine dell'array
        
        NSLog(@"CARTA RICEVUTA = %@", jsonDict);
        
//        if(! [[NSUserDefaults standardUserDefaults] objectForKey:@"_nomeUtente"] || ! [[NSUserDefaults standardUserDefaults] objectForKey:@"_cognome"]){
//            
//            NSLog(@"annullo perchè  è stato fatto logout da qualche  altra parte");
//            return;
//        }
        
//        NSLog(@"tipo = %@, obj: %@", [[jsonDict objectForKey:@"CartaRecuperata"] class], [[[jsonDict objectForKey:@"CartaRecuperata"] objectAtIndex:0] class] );
        
        for(int i = 0; i < [[jsonDict objectForKey:@"CartaRecuperata"] count]; i++){
          
            NSDictionary *c = [[jsonDict objectForKey:@"CartaRecuperata"] objectAtIndex:i];
          
            NSLog(@"DIZIONARIO MINI = %@",[c objectForKey:@"expiryDate"]);
            
            CartaPerDue *card = [[CartaPerDue alloc] init];
            card.name = [[NSUserDefaults standardUserDefaults] objectForKey:@"_nomeUtente"];
            card.surname = [[NSUserDefaults standardUserDefaults] objectForKey:@"_cognome"];     
            card.number = [c objectForKey:@"number"];
            card.expiryString = [c objectForKey:@"expiryDate"];
            
            NSError *error;
            if (![[LocalDatabaseAccess getInstance]storeCard:card error:&error]) {
                NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
            } else if (self && [self respondsToSelector:@selector(didAssociateNewCard)]) {
                [self didAssociateNewCard];
                [self.tableView reloadData];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
            
            [card release];
    
        }
    }
    else{
#warning mostrare alert ad utente
        NSLog(@"NO CARTA RECUPERATA");
    }
}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"ERRORE = %@", error.description);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore connessione" message:@"Si è verificato un errore di connessione, riprovare" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
    [alert show];
    [alert release];
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

-(void)didDeleteCard{
    [self didAssociateNewCard];
}

# pragma mark - CardsViewController (private methods)


- (NSMutableArray*)creaDataContent {
    NSError *error;
    NSArray *cardsArray = [[LocalDatabaseAccess getInstance]fetchStoredCards:&error];
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

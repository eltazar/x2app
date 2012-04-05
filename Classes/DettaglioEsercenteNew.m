//
//  DettaglioEsercente.m
//  Per Due
//
//  Created by Gabriele "Whisky" Visconti on 04/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DettaglioEsercenteNew.h"
#import "PerDueCItyCardAppDelegate.h"
#import "CJSONDeserializer.h"
#import "GoogleHQAnnotation.h"
#import "Utilita.h"


@interface DettaglioEsercenteNew () {
    IndexPathMapper *_idxMap;
    NSDictionary *_dataModel;
    DatabaseAccess *_dbAccess;
    BOOL isGenerico;
    BOOL isCoupon;
    BOOL isDataModelReady;
}
@property (nonatomic, retain) IndexPathMapper *idxMap;
@property (nonatomic, retain) NSDictionary *dataModel;
@property (nonatomic, retain) DatabaseAccess *dbAccess;
- (void)removeNullItemsFromModel;
@end


@implementation DettaglioEsercenteNew


// Properties:
@synthesize identificativo=_identificativo, webView=_webView;

// IBOutlets:
@synthesize tableview=_tableview, activityIndicator=_activityIndicator, mappa=_mappa, condizioni=_condizioni, cond=_cond, tipoMappa=_tipoMappa, map=_map, cellavalidita=_cellavalidita, sito=_sito;

//Properties private:
@synthesize idxMap=_idxMap, dataModel=_dataModel, dbAccess=_dbAccess;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}


#pragma  mark - View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.idxMap = [[[IndexPathMapper alloc] init] autorelease];
    
    [self.idxMap setKey:@"Indirizzo"        forSection:0 row:0];
    [self.idxMap setKey:@"GiornoChiusura"   forSection:0 row:1];
    [self.idxMap setKey:@"GiornoValidita"   forSection:0 row:2];
    [self.idxMap setKey:@"Telefono"         forSection:1 row:0];
    [self.idxMap setKey:@"Email"            forSection:2 row:0];
    [self.idxMap setKey:@"URL"              forSection:3 row:0];
    
    if (isCoupon || isGenerico) {
        [self.idxMap removeKey:@"GiornoValidita"]; 
    }
    
    self.dbAccess = [[[DatabaseAccess alloc] init] autorelease];
    self.dbAccess.delegate = self;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(void)viewWillAppear:(BOOL)animated {
    [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow] animated:YES];
    
    if(! [Utilita networkReachable]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];
	}
    else if (!isDataModelReady) {
        // Quando sto per visualizzare la view eseguo il fetch dei dettagli,
        // ma solo se non è stato già fatto. Es: apro la view -> torno alla
        // springboard -> torno all'app PerDue senza riscaricare i dati.
        [self.activityIndicator startAnimating];
        NSString *urlString;
        if (isGenerico) {
            urlString = [NSString stringWithFormat: @"http://www.cartaperdue.it/partner/DettaglioEsercenteGenerico.php?id=%d", self.identificativo];
        }
        else {
            urlString = [NSString stringWithFormat: @"http://www.cartaperdue.it/partner/DettaglioEsercente.php?id=%d", self.identificativo];
        }
        [self.dbAccess getConnectionToURL:urlString];
    }
}


- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.activityIndicator = nil;
    self.mappa = nil;
    self.condizioni = nil;
    self.cond = nil;
    self.tipoMappa = nil;
    self.map.delegate = nil;
    self.map = nil;
    self.cellavalidita = nil;
    self.sito = nil;
    
    self.idxMap = nil;
    self.dbAccess.delegate = nil;
    self.dbAccess = nil;
    [super viewDidUnload];
}


- (void)dealloc {
#warning inserire il release degli iboutlet ecc?
    self.map.delegate = nil;
    self.map = nil;
    
    self.dbAccess.delegate = nil;
    self.dbAccess = nil;
    self.idxMap = nil;
    
    [super dealloc];
}


#pragma mark - DatabaseAccessDelegate


- (void) didReceiveCoupon:(NSDictionary *)data {
    if (![data isKindOfClass:[NSDictionary class]])
        return;
    // Il pacchetto json relativo all'esercente ha formato:
    // {Esercente=({....});}
    NSObject *temp = [data objectForKey:@"Esercente"];
    if (temp && [temp isKindOfClass:[NSArray class]]) {
        self.dataModel = [((NSArray *)temp) objectAtIndex:0];
        isDataModelReady = YES;
        // lancio query per la validità:
        NSString *urlString = [NSString stringWithFormat: @"http://www.cartaperdue.it/partner/Validita.php?idcontratto=%d", [[self.dataModel objectForKey:@"IDcontratto_Contresercente"]intValue]];
        if (!isCoupon && !isGenerico) {
            [self.dbAccess getConnectionToURL:urlString];
        }
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        [self removeNullItemsFromModel];
        [self.tableview reloadData];
    }
    
    temp = [data objectForKey:@"Giorni"];
    if (temp) {
        self.dataModel = [[NSMutableDictionary alloc] initWithDictionary:self.dataModel];
        [self.tableview beginUpdates];
        [((NSMutableDictionary *)self.dataModel) setObject:temp forKey:@"GiorniValidita"];
        NSArray *idxPaths = [NSArray arrayWithObject:[self.idxMap indexPathForKey:@"GiornoValidita"]];
        [self.tableview reloadRowsAtIndexPaths:idxPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableview endUpdates];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


# pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!isDataModelReady) {
        return 0;
    }
    return [self.idxMap sections];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!isDataModelReady) {
        return 0;
    }
    return [self.idxMap rowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    NSString *key = [self.idxMap keyForIndexPath:indexPath];
    
    
#warning mettere il riuso al posto giusto
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	
    if ([key isEqualToString:@"Indirizzo"]) {
        [[NSBundle mainBundle] loadNibNamed:@"cellaindirizzo" owner:self options:NULL];
        cell = cellaindirizzo;
        UILabel *indirizzo = (UILabel *)[cell viewWithTag:1];
		UILabel *zona = (UILabel *)[cell viewWithTag:2];
		indirizzo.text = [NSString stringWithFormat:@"%@, %@",
                          [self.dataModel objectForKey:@"Indirizzo_Esercente"],
                          [self.dataModel objectForKey:@"Citta_Esercente"]];	
        indirizzo.text = [indirizzo.text capitalizedString];
        if ([[self.dataModel objectForKey:@"Zona_Esercente"] isKindOfClass:[NSNull class]]) {
            zona.text = @"";
		}
        else {
            zona.text = [NSString stringWithFormat:@"Zona: %@",
                         [self.dataModel objectForKey:@"Zona_Esercente"]];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    else if ([key isEqualToString:@"GiornoChiusura"]) {
        [[NSBundle mainBundle] loadNibNamed:@"CellaDettaglio1" owner:self options:NULL] ;
        cell = CellaDettaglio1;
        UILabel *giorno = (UILabel *)[cell viewWithTag:1];
        UILabel *etich = (UILabel *)[cell viewWithTag:2];
        etich.text = @"Chiusura settimanale";
        giorno.text = [self.dataModel objectForKey:@"Giorno_chiusura_Esercente"];
        giorno.text = [giorno.text capitalizedString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    else if ([key isEqualToString:@"GiornoValidita"]) {
        [[NSBundle mainBundle] loadNibNamed:@"CellaValidita2" owner:self options:NULL];
        cell = self.cellavalidita;
        UILabel *etich = (UILabel *)[cell viewWithTag:1];
        UILabel *validita = (UILabel *)[cell viewWithTag:2];
        etich.text = @"Giorni di validita della Carta PerDue";
        
        NSArray *righe = [self.dataModel objectForKey:@"GiorniValidita"];
        
        if (!righe) {
            validita.text = @"Caricamento in corso...";
        }
        else if ([righe count] == 0){ 
            //condizioni assenti
            validita.text=@"Non disponibile";
        }
        else { 
            //costruisco la strinaga condizioni
            //NSLog(@"La tessera vale per %d giorni settimanali", [righe count]);
            NSMutableString *giorni = [[NSMutableString alloc] init];
            for (int i=0; i<[righe count]; i++) {
                [giorni appendString: [[righe objectAtIndex:i] objectForKey:@"giorno_della_settimana"]];
                [giorni appendString:@" "];
            }
            validita.text = [giorni capitalizedString];
            [giorni release];
            
            if ( [[self.dataModel objectForKey:@"Note_Varie_CE"] isKindOfClass:[NSNull class]] ){ //non ci sono condizioni
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }

    }
    
    else if ([key isEqualToString:@"Telefono"]) {
        [[NSBundle mainBundle] loadNibNamed:@"provacella" owner:self options:NULL] ;
        cell = provacella;
        UILabel *telefono = (UILabel *)[cell viewWithTag:1];
        UILabel *etic = (UILabel *)[cell viewWithTag:2];
        etic.text = @"";
        telefono.text = [self.dataModel objectForKey:@"Telefono_Esercente"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    else if ([key isEqualToString:@"Email"]) {
        [[NSBundle mainBundle] loadNibNamed:@"provacella" owner:self options:NULL] ;
        cell = provacella;
        UILabel *email = (UILabel *)[cell viewWithTag:1];
        UILabel *etic = (UILabel *)[cell viewWithTag:2];
        etic.text = @"";
        email.text = [self.dataModel objectForKey:@"Email_Esercente"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    else if ([key isEqualToString:@"URL"]) {
        [[NSBundle mainBundle] loadNibNamed:@"provacella" owner:self options:NULL] ;
        cell = provacella;
        UILabel *sitoweb = (UILabel *)[cell viewWithTag:1];
        UILabel *etic = (UILabel *)[cell viewWithTag:2];
        etic.text=@"";
        sitoweb.text = [self.dataModel objectForKey:@"Url_Esercente"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)] autorelease];
    [customView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.lineBreakMode = UILineBreakModeWordWrap;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont boldSystemFontOfSize:18];
    
	
	if (section == 0) {
		lbl.text = [self.dataModel objectForKey:@"Insegna_Esercente"];
	}
	else if (section == 1) {
        lbl.text = @"Contatti";	
    }
	else {	
        lbl.text = @"";
    }
    
    UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    lbl.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, labelSize.height+6);
    
    [customView addSubview:lbl];
    
    return customView;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	NSString *lblText;
	
	if (section == 0) {
		lblText = [self.dataModel objectForKey:@"Insegna_Esercente"];
	} 
    else if (section == 1) {
			lblText = @"Contatti";	
    }
	else {
        lblText = @"";
    }
    UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lblText sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height+6;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *key = [self.idxMap keyForIndexPath:indexPath];
    
    if ([key isEqualToString:@"Indirizzo"]) { 
		self.mappa.navigationItem.titleView = self.tipoMappa;
        //TODO: capire se ste righe relative a map.delegate e map.showUserLocation devono
        //andare qui...
        self.map.delegate = self;
		self.map.showsUserLocation = YES;
		[self.navigationController pushViewController:self.mappa animated:YES];
		
		double latitude = [[self.dataModel objectForKey:@"Latitudine"] doubleValue];
		double longitude =[[self.dataModel objectForKey:@"Longitudine"] doubleValue];
		NSInteger idEsercente = [[self.dataModel objectForKey:@"IDesercente"] intValue];
		NSString *nome = [self.dataModel objectForKey:@"Insegna_Esercente"];
		NSString *address = [NSString stringWithFormat:@"%@, %@",
                    [[self.dataModel objectForKey:@"Indirizzo_Esercente"]capitalizedString],
                    [[self.dataModel objectForKey:@"Citta_Esercente"]capitalizedString]];
        GoogleHQAnnotation *ann = [[[GoogleHQAnnotation alloc] init:latitude :longitude :nome :address :idEsercente] autorelease];
		[self.map addAnnotation:ann];
	}	
	
	if ([key isEqualToString:@"GiornoValidita"] ) {
		self.condizioni.title = [self.dataModel objectForKey:@"Insegna_Esercente"];
		self.cond.text = [self.dataModel objectForKey:@"Note_Varie_CE"];
        [self.navigationController pushViewController:self.condizioni animated:YES];
	}
	
	if ([key isEqualToString:@"Telefono"]) { //telefona o mail o sito
        PerDueCItyCardAppDelegate *appDelegate = (PerDueCItyCardAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *actionSheetTxt = [NSString stringWithFormat:@"Vuoi chiamare\n%@?",
                                    [self.dataModel objectForKey:@"Insegna_Esercente"]];
        UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTxt
                                                            delegate:self 
                                                   cancelButtonTitle:@"Annulla"
                                              destructiveButtonTitle:nil 
                                                   otherButtonTitles:@"Chiama", nil];
        [aSheet showInView:appDelegate.window];
        [aSheet release];				
    }
		
    
    if ([key isEqualToString:@"Email"]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [[controller navigationBar] setTintColor:[UIColor colorWithRed:142/255.0 
                                                                 green:21/255.0 
                                                                  blue:7/255.0
                                                                  alpha:1.0]];
        NSArray *to = [NSArray arrayWithObject:[self.dataModel objectForKey:@"Email_Esercente"]];
        [controller setToRecipients:to];
        controller.mailComposeDelegate = self;
        [controller setMessageBody:@"" isHTML:NO];
        [self presentModalViewController:controller animated:YES];
        [controller release];
    }
    
    if ([key isEqualToString:@"URL"]) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@",
                              [self.dataModel objectForKey:@"Url_Esercente"]];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:requestObj];		
        self.sito.title = [self.dataModel objectForKey:@"Insegna_Esercente"];
        [self.navigationController pushViewController:self.sito animated:YES];
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[self.dataModel objectForKey:@"Telefono_Esercente"]]];
		[[UIApplication sharedApplication] openURL:url];
	} 
}


#pragma mark - MFMailComposeViewControllerDelegate


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark - MKMapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id )annotation {
    if (annotation == mapView.userLocation) {
        return nil;
    }
    MKPinAnnotationView *pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"] autorelease];
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    return pinView;
}


- (void)mapView:(MKMapView *)m didAddAnnotationViews:(NSArray *)views {
    for (MKAnnotationView *annotationView in views) {
		if (annotationView.annotation != m.userLocation) {
			MKCoordinateSpan span = MKCoordinateSpanMake(0.01,0.01);
			MKCoordinateRegion region = MKCoordinateRegionMake(annotationView.annotation.coordinate, span);
			[m setRegion:region animated:YES];
		}
	}
}


#pragma mark - DettaglioEsercente (IBActions)


- (IBAction)mostraTipoMappa:(id)sender{
	if ([self.tipoMappa selectedSegmentIndex]==0) {
		self.map.mapType=MKMapTypeStandard;
	} else if ([self.tipoMappa selectedSegmentIndex]==1) {
		self.map.mapType=MKMapTypeSatellite;
	} else if ([self.tipoMappa selectedSegmentIndex]==2) {
		self.map.mapType=MKMapTypeHybrid;
	}
}


#pragma mark - DettaglioEsercente (metodi privati)

- (void)removeNullItemsFromModel {
    Class null = [NSNull class];
    if ([[self.dataModel objectForKey:@"Giorno_chiusura_Esercente"] isKindOfClass:null]){
        [self.idxMap removeKey:@"GiornoChiusura"];
    }
    if ([[self.dataModel objectForKey:@"Telefono_Esercente"] isKindOfClass:null]) {
        [self.idxMap removeKey:@"Telefono"];
    }
    if ([[self.dataModel objectForKey:@"Email_Esercente"] isKindOfClass:null]) {
        [self.idxMap removeKey:@"Email"];
    }
    if ([[self.dataModel objectForKey:@"Url_Esercente"] isKindOfClass:null]) {
        [self.idxMap removeKey:@"URL"];
    }
    
}

@end


#pragma mark -
/*********************************************************************/
#pragma mark -

@interface IndexPathMapper () {
    NSMutableArray *map;
}
@end



@implementation IndexPathMapper


- (id)init {
    self = [super init];
    if (self) {
        map = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)setKey:(NSString *)key forSection:(NSInteger)section row:(NSInteger)row {    
    NSMutableArray *sectionArray;
    if (section >= map.count) {
        sectionArray = [[[NSMutableArray alloc] init] autorelease];
        [map addObject:sectionArray];
    }
    else {
        sectionArray = [map objectAtIndex:section];
    }
    
    if (row >= sectionArray.count) {
        [sectionArray addObject:key];
    }
    else {
        [sectionArray insertObject:key atIndex:row];
    }
}


- (NSString *)keyForSection:(NSInteger)section row:(NSInteger)row {
    if (section >= map.count) {
        return nil;
    }
    else {
        NSArray *sectionArray = [map objectAtIndex:section];
        if (row >= sectionArray.count) {
            return nil;
        }
        else {
            return [sectionArray objectAtIndex:row];
        }
    }
}


- (void)removeKeyAtSection:(NSInteger)section row:(NSInteger)row {
    NSMutableArray *sectionArray;
    if (section >= map.count) {
        sectionArray = [[[NSMutableArray alloc] init] autorelease];
        [map addObject:sectionArray];
    }
    else {
        return;
    }
    
    if (row >= sectionArray.count) {
        return;
    }
    else {
        [sectionArray removeObjectAtIndex:row];
    }

}


- (void)removeKey:(NSString *)key {
    for (NSMutableArray *sectionArray in map) {
        [sectionArray removeObject:key];
    }
}


- (NSInteger)sections {
    return [map count];
}


- (NSInteger)rowsInSection:(NSInteger)section {
    if (section >= map.count) {
        return 0;
    }
    return [[map objectAtIndex:section] count];
    
}

- (void)setKey:(NSString *)key forIndexPath:(NSIndexPath *)indexPath {
    [self setKey:key forSection:indexPath.section row:indexPath.row];
}


- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath {
    return [self keyForSection:indexPath.section row:indexPath.row];
}


- (void)removeKeyAtIndexPath:(NSIndexPath *)indexPath {
    [self removeKeyAtSection:indexPath.section row:indexPath.row];
}

- (NSIndexPath *)indexPathForKey:(NSString *) key {
    NSInteger i = 0;
    NSInteger j = 0;
    for (i=0; i<map.count; i++) {
        NSArray *sectionArray = [map objectAtIndex:i]; 
        j = [sectionArray indexOfObject:key];
        if (j != NSNotFound) {
            return [NSIndexPath indexPathForRow:j inSection:i]; 
        }
    }
    return nil;
}

- (void)dealloc {
    [map release];
}
@end


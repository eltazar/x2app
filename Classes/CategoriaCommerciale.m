//
//  CategoriaCommerciale.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "CategoriaCommerciale.h"
#import "UserDefaults.h"
#import "EsercenteMapAnnotation.h"
#import "CJSONDeserializer.h"
#import "Utilita.h"
#import "DatabaseAccess.h"
#import "DettaglioEsercente.h"


//Metodi privati
@interface CategoriaCommerciale () {
    BOOL lastFetchWasASearch;
    BOOL inSearchUI;
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
    NSString *_phpFile;
    NSString *_phpSearchFile;
    GeoDecoder *_geoDec;
    DatabaseAccess *_dbAccess;
    NSArray* _tempBuff;
}
- (NSString *)searchMethod;
- (NSArray *)fetchRowsFromUrlString:(NSString*) urlString;
- (void)fetchRows;
- (NSInteger)fetchMoreRows;
- (void)fetchRowsBySearchKey:(NSString *)searchkey;
- (void)showMap:(id)sender;
- (void)hideMap:(id)sender;
@property (nonatomic, retain) NSString *phpFile;
@property (nonatomic, retain) NSString *phpSearchFile;
@property (nonatomic, retain) GeoDecoder *geoDec;
@property (nonatomic, retain) DatabaseAccess *dbAccess;
@property (nonatomic, retain) NSArray *tempBuff;
@end


@implementation CategoriaCommerciale


// Properties
@synthesize urlString = _urlString, rows = _rows;

// IBOutlets
@synthesize searchBar = _searchBar, tableView = _tableView, mapView = _mapView, footerView = _footerView, /*searchSegCtrlView,*/ searchSegCtrl = _searchSegCtrl, mapTypeSegCtrl = _mapTypeSegCtrl;

// Properties private
@synthesize phpFile = _phpFile, phpSearchFile = _phpSearchFile,  geoDec = _geoDec, dbAccess = _dbAccess, tempBuff = _tempBuff;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithTitle:(NSString *)title phpFile:(NSString *)pf phpSearchFile:(NSString *)psf latitude:(CLLocationDegrees)la longitude:(CLLocationDegrees)lo {
    self = [self initWithNibName:nil bundle:nil];
    self.title = title;
    self.phpFile = pf;
    self.phpSearchFile = psf;
    latitude = la;
    longitude = lo;
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    self.urlString = @"http://www.cartaperdue.it/partner/v2.0/Esercenti.php";
    self.rows = [[[NSMutableArray alloc] init] autorelease];
    lastFetchWasASearch = NO;
    inSearchUI = NO;
	UIBarButtonItem *mapButton = [[[UIBarButtonItem alloc]
                                   initWithTitle:@"Mappa"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(showMap:)] autorelease];
    self.navigationItem.rightBarButtonItem = mapButton;
    self.geoDec = [[[GeoDecoder alloc] init] autorelease];
    self.geoDec.delegate = self;
    self.dbAccess = [[[DatabaseAccess alloc] init] autorelease];
    self.dbAccess.delegate = self;
}



- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]  animated:YES];
    if( ![Utilita networkReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
        [alert show];
        [alert release];
	} else {
        // Quando sto per visualizzare la view eseguo il fetch delle righe,
        // ma solo se non è stato già fatto. Es: apro la view -> torno alla
        // springboard -> torno all'app PerDue senza riscaricare i dati.
        if (!self.rows.count) [self fetchRows];
        // TODO: se già li ho scaricati non dovrei riscaricarli.
        if(! [[UserDefaults city] isEqualToString:@"Qui"]) {
            [self.geoDec searchCoordinatesForAddress:[UserDefaults city]];
        }
    }
    if (inSearchUI)
        [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    // Roba ri-creata in viewDidLoad:
    self.urlString = nil;
    self.rows = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.geoDec.delegate = nil;
    self.geoDec = nil;
    self.dbAccess.delegate = nil;
    self.dbAccess = nil;
    
    // IBOutlets:
    self.mapView.delegate = nil;
	self.mapView = nil;
    self.tableView.delegate = nil; //perché non erditiamo UITableViewController, quindi super non lo fa.
    self.tableView = nil;
    self.searchBar.delegate = nil;
	self.searchBar = nil;
	self.mapTypeSegCtrl = nil;
    self.searchSegCtrl = nil;
	self.footerView = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    self.urlString = nil;
    self.rows = nil;
    
    self.mapView.delegate = nil;
    self.mapView = nil;
    self.tableView.delegate = nil;
    self.tableView = nil;
    self.searchBar.delegate = nil;
	self.searchBar = nil;
	self.mapTypeSegCtrl = nil;
    self.searchSegCtrl = nil;
	self.footerView = nil;
    
    self.phpFile = nil; 
    self.phpSearchFile = nil;
    self.geoDec.delegate = nil;
    self.geoDec = nil;
    self.dbAccess.delegate = nil;
    self.dbAccess = nil;
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tView {
	if ([self.rows count] < 6) {
		return 1;
	} else {
		return 2;
	}
}


- (NSInteger)tableView:(UITableView *)tView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return [self.rows count];
		case 1:
			return 1;
		default:
			return 0;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
        // Stiamo mostrando la cella che suggerisce la visualizzazione di ulteriori esercenti
		UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"LastCell"];
		
		if (cell == nil){
			cell = [[[NSBundle mainBundle] loadNibNamed:@"LastCell" owner:self options:NULL] objectAtIndex:0];
		}
		UILabel *altri = (UILabel *)[cell viewWithTag:1];
		altri.text = @"Mostra altri...";
		UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
		altri2.text = @"";
		return cell;		
	} else {
        // Stiamo mostrando la cella relativa ad un esercente
		UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"CategoriaCommercialeCell"];
		
		if (cell == nil){
			cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoriaCommercialeCell" owner:self options:NULL] objectAtIndex:0];
		}
		
		NSDictionary *r  = [self.rows objectAtIndex:indexPath.row];
		
		UILabel *esercente = (UILabel *)[cell viewWithTag:1];
		esercente.text = [r objectForKey:@"Insegna_Esercente"];
		
		UILabel *indirizzo = (UILabel *)[cell viewWithTag:2];
		indirizzo.text = [NSString stringWithFormat:@"%@, %@",[r objectForKey:@"Indirizzo_Esercente"],[r objectForKey:@"Citta_Esercente"]];	
		indirizzo.text= [indirizzo.text capitalizedString];
        
		UILabel *distanza = (UILabel *)[cell viewWithTag:3];
		distanza.text = [NSString stringWithFormat:@"a %.1f Km",[[r objectForKey:@"Distanza"] doubleValue]];	
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	}
}


#pragma mark - UITableViewDelegate


- (UIView *)tableView:(UITableView *)tView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}


- (CGFloat)tableView:(UITableView *)tView heightForFooterInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 0;	
		case 1:
			return 65;
		default:
			return 0;
	}
}


- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		NSDictionary* r = [self.rows objectAtIndex: indexPath.row];
		NSInteger i = [[r objectForKey:@"IDesercente"] integerValue];
		NSLog(@"L'id dell'esercente da visualizzare è %d",i );
		DettaglioEsercente *detail = [[DettaglioEsercente alloc] initWithNibName:nil bundle:nil couponMode:NO genericoMode:NO];
		detail.idEsercente = i;
		detail.title = @"Esercente";
        //Facciamo visualizzare la vista con i dettagli
//        if (inSearchUI)
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
		[self.navigationController pushViewController:detail animated:YES];
        [detail release];
	}
	else { 
        //riga mostra altri
		int i = [self fetchMoreRows];
		if (i < 20) { // non ci sono alri esercenti
			UITableViewCell *cell = [tView cellForRowAtIndexPath:indexPath];
			UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
			altri2.text = @"Non ci sono altri esercenti da mostrare";
		}
	}
}


#pragma mark - MKMapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mView viewForAnnotation:(id )annotation {
    if (annotation == mView.userLocation) {
        return nil;
    }
    MKPinAnnotationView *pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"] autorelease];
    pinView.pinColor = MKPinAnnotationColorPurple;
    pinView.canShowCallout = YES;
    pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinView.animatesDrop = YES;
    return pinView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	EsercenteMapAnnotation *ann = (EsercenteMapAnnotation *)view.annotation;	
	DettaglioEsercente *detail = [[DettaglioEsercente alloc] initWithNibName:nil bundle:nil couponMode:NO genericoMode:NO];
	detail.idEsercente = ann.idEsercente;
	detail.title = @"Esercente";
	[self.navigationController pushViewController:detail animated:YES];
    //rilascio controller
    [detail release];
}

//zoom su posizione utente
- (void)mapView:(MKMapView *)m didAddAnnotationViews:(NSArray *)views {
    if([[UserDefaults city] isEqualToString:@"Qui"]){
        for (MKAnnotationView *annotationView in views) {
            if (annotationView.annotation == m.userLocation) {
                MKCoordinateSpan span = MKCoordinateSpanMake(0.15,0.15);
                MKCoordinateRegion region = MKCoordinateRegionMake(m.userLocation.coordinate, span);
                [m setRegion:region animated:YES];
            }
        }
    }
}


#pragma mark - UISearchBarDelegate


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidBeginEditing");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    /*CGFloat DeltaTableHeight = self.navigationController.navigationBar.bounds.size.height + self.searchSegCtrlView.bounds.size.height;*/
    if (!inSearchUI)
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.searchSegCtrl.enabled = NO;
    self.searchSegCtrl.alpha = 0.5;
    //NSLog(@"tableView.frame.origin.y = %f -> %f", self.tableView.frame.origin.y, self.searchBar.frame.size.height);
    //self.searchSegCtrlView.frame = CGRectMake(
                                        //0, 
                                        //self.searchSegCtrlView.frame.origin.y,
                                        //self.searchSegCtrlView.bounds.size.width,
                                        //0);
    //self.tableView.frame = CGRectMake(0, self.tableView.frame.origin.y - 36, self.tableView.bounds.size.width, self.tableView.bounds.size.height + DeltaTableHeight);
    //self.view.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
	[self.searchBar setShowsCancelButton:YES animated:YES];//showsCancelButton = YES;
    // disattiviamo la possibilità di modificare le celle della tabella
	self.navigationItem.rightBarButtonItem.enabled = FALSE;
    [UIView commitAnimations];
    inSearchUI = YES;
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidEndEditing");
    [self.searchBar resignFirstResponder];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchBarCancelButtonClicked");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //se l'utente esegue una ricerca valida, ma poi la annulla
    // dobbiamo inserire i valori originali nella tabella*/
    [self.searchBar resignFirstResponder];
	[self.navigationController setNavigationBarHidden:NO animated:YES]; 
    self.searchSegCtrl.enabled = YES;
    self.searchSegCtrl.alpha = 1;
    //self.searchSegCtrlView.frame = CGRectMake(0, self.searchSegCtrlView.frame.origin.y, self.searchSegCtrlView.bounds.size.width, 36);
    self.searchBar.text = @"";
    [self.searchBar setShowsCancelButton:NO animated:YES];
	self.navigationItem.rightBarButtonItem.enabled = TRUE;
    [UIView commitAnimations];
    inSearchUI = NO;
    [self fetchRows];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	NSLog(@"searchBar:textDidChange");
    [self fetchRowsBySearchKey:searchText];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{ 
	NSLog(@"searchBarSearchButtonClicked");
    [self.searchBar resignFirstResponder];
	//self.searchBar.text = @"";
	self.navigationItem.rightBarButtonItem.enabled = TRUE;
}


# pragma mark - GeoDecoderDelegate


- (void)didReceivedGeoDecoderData:(NSDictionary *) geoData {
    NSLog(@"DICTIONARY IS: %@", geoData);
    NSArray *resultsArray = [geoData objectForKey:@"results"];
    NSDictionary *result = [resultsArray objectAtIndex:0];
    //NSString *addressString = [ result objectForKey:@"formatted_address"];
    latitude = [[[[result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
    longitude = [[[[result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
    NSLog(@"LAT = %f LONG = %f",latitude,longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.15,0.15);
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitude, longitude), span);
    [self.mapView setRegion:region animated:YES];
}


- (void)didReceiveErrorGeoDecoder:(NSError *)error{
    NSLog(@"errore geodecoder = %@",[error description]);
}


#pragma mark - DatabaseAccessDelegate


- (void)didReceiveCoupon:(NSDictionary *)dataDict {
    NSString *type = [[dataDict allKeys] objectAtIndex:0];
    NSArray *rows = [dataDict objectForKey:type];
    
    // Ci aspettiamo che rows sia effettivamente un array, se non lo è
    // si ignora.
    if (![rows isKindOfClass:[NSArray class]]) return;
    
    if ([type isEqualToString:@"Esercenti:FirstRows"]) {
        //
    } else if ([type isEqualToString:@"Esercenti:MoreRows"]) {
        //
    } else if ([type isEqualToString:@"Esercenti:Search"]) {
        //
    } 
    
    [self compare:rows];
}


#pragma mark - CategoriaCommerciale (IBActions)


- (IBAction)didChangeSearchSegCtrlState:(id)sender {
    [self fetchRows];
}


- (IBAction)didChangeMapTypeSegCtrlState:(id)sender {
    NSInteger selection = [self.mapTypeSegCtrl selectedSegmentIndex];
	if (selection == 2) {
		self.mapView.mapType = MKMapTypeHybrid;
	} else if (selection == 1) {
		self.mapView.mapType = MKMapTypeSatellite;
	} else  {
		self.mapView.mapType = MKMapTypeStandard;
	}
}


#pragma mark - CategoriaCommerciale (metodi privati)


- (NSArray *)fetchRowsFromUrlString:(NSString*) urlString {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"DoveUsarla: Fetching from url:\n\t%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString *jsonResponse = [[[NSString alloc] initWithContentsOfURL:url encoding:NSStringEncodingConversionAllowLossy error:&error] autorelease];
    // TODO: gestire errori
	NSData *jsonData = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
	error = nil;
	NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];	
    // TODO: gestire errori
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (dict) {
        self.tempBuff = [dict objectForKey:@"Esercente"];
        return [dict objectForKey:@"Esercente"];
    } else {
        return [[[NSArray alloc] init] autorelease];
    }
}


- (void) fetchRows{
    lastFetchWasASearch = NO;
	NSString *urlStringV1 = [NSString stringWithFormat: 
                           @"http://www.cartaperdue.it/partner/%@.php?prov=%@&lat=%f&long=%f&giorno=%@&ordina=%@&from=%d&to=20", 
                            self.phpFile, [UserDefaults city],
                            latitude, longitude,
                            [UserDefaults weekDay], [self searchMethod], 0];

    NSString *postString = [NSString stringWithFormat:
                            @"request=fetch&categ=%@&prov=%@&lat=%f&long=%f&giorno=%@&ordina=%@&from=%d",
                            self.phpFile, [UserDefaults city],
                            latitude, longitude, [UserDefaults weekDay],
                            [self searchMethod], 0];
    NSLog(@"urlString is: [%@]", self.urlString);
    NSLog(@"postString is: [%@]", postString);
    [self.dbAccess postConnectionToURL:self.urlString withData:postString];
    
    NSArray *newRows = [self fetchRowsFromUrlString: urlStringV1];
    [self.rows removeAllObjects];
    [self.rows addObjectsFromArray:newRows];
    [self.tableView reloadData];
}


- (NSInteger)fetchMoreRows {
    if (lastFetchWasASearch) return 0;
    NSString *urlString = [NSString stringWithFormat: 
                           @"http://www.cartaperdue.it/partner/%@.php?prov=%@&lat=%f&long=%f&giorno=%@&ordina=%@&from=%d&to=20", 
                           self.phpFile, [UserDefaults city],
                           latitude, longitude,
                           [UserDefaults weekDay], [self searchMethod], self.rows.count];
    
    NSString *postString = [NSString stringWithFormat:
                            @"request=fetch&categ=%@&prov=%@&lat=%f&long=%f&giorno=%@&ordina=%@&from=%d",
                            self.phpFile, [UserDefaults city],
                            latitude, longitude, [UserDefaults weekDay],
                            [self searchMethod], self.rows.count];
    [self.dbAccess postConnectionToURL:self.urlString withData:postString];
    
    NSArray *newRows = [self fetchRowsFromUrlString: urlString];
    NSMutableArray *indexPaths = [[NSMutableArray alloc]initWithCapacity:newRows.count]; 
    for (int i = self.rows.count; i < self.rows.count + newRows.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.tableView beginUpdates];
    [self.rows addObjectsFromArray:newRows];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [indexPaths release];
    return newRows.count;
}


- (void) fetchRowsBySearchKey:(NSString *)searchKey {
    lastFetchWasASearch = YES;
    // inserisco un carattere speciale per gli spazi, nel file php verrà risostituito dallo spazio
    searchKey = [searchKey stringByReplacingOccurrencesOfString:@" " withString:@"-"]; 
	NSString *urlString = [NSString stringWithFormat: 
                 @"http://www.cartaperdue.it/partner/%@.php?chiave=%@&&lat=%f&long=%f",
                 self.phpSearchFile, searchKey, 
                 latitude, longitude];
    
    NSString *postString = [NSString stringWithFormat:
                            @"request=search&categ=%@&chiave=%@&lat=%f&long=%f&ordina=distanza&from=0",
                            self.phpFile, searchKey,
                            latitude, longitude, [UserDefaults weekDay],
                            [self searchMethod], 0];
    [self.dbAccess postConnectionToURL:self.urlString withData:postString];
    
    NSArray *newRows = [self fetchRowsFromUrlString: urlString];
    [self.rows removeAllObjects];
    [self.rows addObjectsFromArray:newRows];
    [self.tableView reloadData];
}


-(void)showMap:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:[self view]
							 cache:YES];
	[UIView commitAnimations];
	
	[[self view] addSubview:self.mapView];
	self.navigationItem.titleView = self.mapTypeSegCtrl;
	self.mapView.showsUserLocation = YES;
	
	NSLog(@"Ci sono  %d esercenti da inserire in mappa", [self.rows count]);
	for (NSDictionary *r in self.rows) {
		NSLog(@"%@",[r objectForKey:@"Insegna_Esercente"]);
        
		double lati    = [[r objectForKey:@"Latitudine"]  doubleValue];
		double longi   = [[r objectForKey:@"Longitudine"] doubleValue];
		NSInteger Id   = [[r objectForKey:@"IDesercente"] intValue];
		NSString *name = [r objectForKey:@"Insegna_Esercente"];
		NSString *address = [[[NSString alloc] initWithFormat:@"%@, %@",
                             [[r objectForKey:@"Indirizzo_Esercente"] capitalizedString],
                             [[r objectForKey:@"Citta_Esercente"] capitalizedString]] autorelease];
		
		EsercenteMapAnnotation *newAnnotation = [[[EsercenteMapAnnotation alloc] initWithLatitudine:lati longitudine:longi insegna:name indirizzo:address idEsercente:Id] autorelease];
        [self.mapView addAnnotation:newAnnotation];
		NSLog(@"Latitudine:  %f\n", lati);
		NSLog(@"Longitudine: %f\n", longi);
		NSLog(@"ID: %d\n", Id);
		
		
	} 	
	UIBarButtonItem *listBtn = [[[UIBarButtonItem alloc]
							  initWithTitle:@"Lista"
							  style:UIBarButtonItemStyleBordered
							  target:self
							  action:@selector(hideMap:)] autorelease];
	self.navigationItem.rightBarButtonItem = listBtn;
}


- (void)hideMap:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
						   forView:[self view]
							 cache:YES];
	[self.mapView removeFromSuperview];
	self.navigationItem.titleView = NULL;
	
	[UIView commitAnimations];	
	UIBarButtonItem *mapBtn = [[[UIBarButtonItem alloc]
								  initWithTitle:@"Mappa"
								  style:UIBarButtonItemStyleBordered
								  target:self
								  action:@selector(showMap:)] autorelease];
	self.navigationItem.rightBarButtonItem = mapBtn;
	
}


- (NSString *)searchMethod {
    NSInteger selection = [self.searchSegCtrl selectedSegmentIndex];
    if (selection == 0) {
        return @"distanza";
    } else if (selection == 1) {
        return @"nome";
    } else {
        return @"";
    }
}


- (void) compare:(NSArray *)rows {
    // N.B. è opportuno ricordare che rows contiene un FALSE finale, 
    // come tutti gli array ritornati dalle nostre query php.
    BOOL success = TRUE;
    
    if (self.tempBuff.count != (rows.count - 1)) {
        success = FALSE;
    } else {
        printf("\n");
        for (int i = 0; i < rows.count-1; i++) {
            NSInteger r1id = [[[self.tempBuff objectAtIndex:i] objectForKey:@"IDesercente"] intValue];
            NSInteger r2id = [[[rows objectAtIndex:i] objectForKey:@"IDesercente"] intValue];
            if ( r1id != r2id ) {
                success = FALSE;
                printf("X[%d/%d]", r1id, r2id);
            } else {
                printf("O");
            }
        }
        printf("\n");
    }
    
    if (success) 
        NSLog(@"CategoriaCommerciale compare: ** SUCCESS");
    else
        NSLog(@"CategoriaCommerciale compare: ** FAIL");
}


@end

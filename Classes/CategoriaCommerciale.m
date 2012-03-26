//
//  CategoriaCommerciale.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "CategoriaCommerciale.h"
#import "DettaglioEsercenti.h"
#import "UserDefaults.h"
#import "GoogleHQAnnotation.h"
#import "CJSONDeserializer.h"

//Metodi privati
@interface CategoriaCommerciale () {
    BOOL lastFetchWasASearch;
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
    GeoDecoder *geoDec;
}
- (NSString *)searchMethod;
- (NSArray *)fetchRowsFromUrlString:(NSString*) urlString;
- (int)checkNetReachability:(Reachability*) curReach;
@property (nonatomic, retain) NSString *phpFile;
@property (nonatomic, retain) NSString *phpSearchFile;
@end


@implementation CategoriaCommerciale


// Properties
@synthesize rows;

// IBOutlets
@synthesize searchBar, tableview, mapView, footerView, searchSegCtrl, mapTypeSegCtrl;

// Properties private
@synthesize phpFile, phpSearchFile;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithTitle:(NSString *)title phpFile:(NSString *)pf phpSearchFile:(NSString *)psf latitude:(CLLocationDegrees)la longitude:(CLLocationDegrees)lo {
    self = [super init];
    self.title = title;
    self.phpFile = pf;
    self.phpSearchFile = psf;
    latitude = la;
    longitude = lo;
    return self;
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([rows count] < 6){
		return 1;
	} else {
		return 2;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return [self.rows count];
		case 1:
			return 1;
		default:
			return 0;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
        // Stiamo mostrando la cella che suggerisce la visualizzazione di ulteriori esercenti
		static NSString *CellIdentifier = @"Cell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
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
		static NSString *CellIdentifier = @"Cell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil){
			cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoriaCommercialeCell" owner:self options:NULL] objectAtIndex:0];
		}
		
		NSDictionary *r  = [rows objectAtIndex:indexPath.row];
		
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


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 0;	
		case 1:
			return 65;
		default:
			return 0;
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		//[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
		NSDictionary* r = [rows objectAtIndex: indexPath.row];
		NSInteger i = [[r objectForKey:@"IDesercente"] integerValue];
		NSLog(@"L'id dell'esercente da visualizzare è %d",i );
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		DettaglioEsercenti *detail = [[[DettaglioEsercenti alloc] initWithNibName:@"DettaglioEsercenti" bundle:[NSBundle mainBundle]] autorelease];
		[(DettaglioEsercenti*)detail setIdentificativo:i];
		[detail setTitle:@"Esercente"];
        //Facciamo visualizzare la vista con i dettagli
		[self.navigationController pushViewController:detail animated:YES];
	}
	else { 
        //riga mostra altri
		int i = [self fetchMoreRows];
		if (i < 20) { // non ci sono alri esercenti
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
	GoogleHQAnnotation * v =(GoogleHQAnnotation*)view.annotation;	
	DettaglioEsercenti *detail = [[[DettaglioEsercenti alloc] initWithNibName:@"DettaglioEsercenti" bundle:[NSBundle mainBundle]] autorelease];
	[(DettaglioEsercenti*)detail setIdentificativo:[v ide]];
	[detail setTitle:@"Esercente"];
    //Facciamo visualizzare la vista con i dettagli
	[self.navigationController pushViewController:detail animated:YES];
    //rilascio controller
    //[detail release];
    //detail = nil;
	
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


#pragma mark - UISearBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	self.searchBar.showsCancelButton = YES;
    // disattiviamo la possibilità di modificare le celle della tabella
	self.navigationItem.rightBarButtonItem.enabled = FALSE;
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
	self.searchBar.showsCancelButton = NO;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //se l'utente esegue una ricerca valida, ma poi la annulla
    // dobbiamo inserire i valori originali nella tabella*/
	[self.searchBar resignFirstResponder];
	self.searchBar.text = @"";
	self.navigationItem.rightBarButtonItem.enabled = TRUE;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	[self fetchRowsBySearchKey:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{ 
	[self.searchBar resignFirstResponder];
	self.searchBar.text = @"";
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




# pragma mark - Memory Management


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    self.rows = [[[NSMutableArray alloc] init] autorelease];
    lastFetchWasASearch = NO;
	//[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
	UIBarButtonItem *mapButton = [[[UIBarButtonItem alloc]
								  initWithTitle:@"Mappa"
								  style:UIBarButtonItemStyleBordered
								  target:self
								  action:@selector(showMap:)] autorelease];
    self.navigationItem.rightBarButtonItem = mapButton;
    geoDec = [[GeoDecoder alloc] init];
    geoDec.delegate = self;
	[self fetchRows];
}



- (void)viewWillAppear:(BOOL)animated {
	int wifi =0;
	int internet = 0;
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
    internet = [self checkNetReachability:internetReach];
	wifi = [self checkNetReachability:wifiReach];	
    
	if( (internet == -1) &&( wifi == -1) ){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];
	} else {
        if(! [[UserDefaults city] isEqualToString:@"Qui"]) {
            [geoDec searchCoordinatesForAddress:[UserDefaults city]];
        }
    }
}


- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.mapView = nil;
    self.tableview = nil;
	self.searchBar = nil;
	self.mapTypeSegCtrl = nil;
    self.searchSegCtrl = nil;
	self.footerView = nil;
}


- (void)dealloc {
    self.mapView.delegate = nil;
    self.rows = nil;
    self.phpFile = nil, 
    self.phpSearchFile = nil;
    geoDec.delegate = nil;
    [geoDec release];
    geoDec = nil;
    [super dealloc];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - CategoriaCommerciale

- (void) fetchRows{
    lastFetchWasASearch = NO;
	NSString *urlString = [NSString stringWithFormat: 
                           @"http://www.cartaperdue.it/partner/%@.php?prov=%@&lat=%f&long=%f&giorno=%@&ordina=%@&from=%d&to=20", 
                            self.phpFile, [UserDefaults city],
                            latitude, longitude,
                            [UserDefaults weekDay], [self searchMethod], 0];
    NSArray *newRows = [self fetchRowsFromUrlString: urlString];
    [self.rows removeAllObjects];
    [self.rows addObjectsFromArray:newRows];
    [self.tableview reloadData];
}


- (NSInteger)fetchMoreRows {
    if (lastFetchWasASearch) return 0;
    NSString *urlString = [NSString stringWithFormat: 
                           @"http://www.cartaperdue.it/partner/%@.php?prov=%@&lat=%f&long=%f&giorno=%@&ordina=%@&from=%d&to=20", 
                           self.phpFile, [UserDefaults city],
                           latitude, longitude,
                           [UserDefaults weekDay], [self searchMethod], self.rows.count];
    NSArray *newRows = [self fetchRowsFromUrlString: urlString];
    [self.rows addObjectsFromArray:newRows];
    [self.tableview reloadData];
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
    NSArray *newRows = [self fetchRowsFromUrlString: urlString];
    [self.rows removeAllObjects];
    [self.rows addObjectsFromArray:newRows];
    [self.tableview reloadData];
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
	
	NSLog(@"Ci sono  %d esercenti da inserire in mappa", [rows count]);
	for (NSDictionary *r in rows) {
		NSLog(@"%@",[r objectForKey:@"Insegna_Esercente"]);
        
		double lati    = [[r objectForKey:@"Latitudine"]  doubleValue];
		double longi   = [[r objectForKey:@"Longitudine"] doubleValue];
		NSInteger Id   = [[r objectForKey:@"IDesercente"] intValue];
		NSString *name = [r objectForKey:@"Insegna_Esercente"];
		NSString *address = [[[NSString alloc] initWithFormat:@"%@, %@",
                             [[r objectForKey:@"Indirizzo_Esercente"] capitalizedString],
                             [[r objectForKey:@"Citta_Esercente"] capitalizedString]] autorelease];
		
		[self.mapView addAnnotation:[[[GoogleHQAnnotation alloc] init:lati:longi:name:address:Id] autorelease]];
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


-(void)hideMap:(id)sender {
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


#pragma mark - CategoriaCommerciale (private methods)


- (NSArray *)fetchRowsFromUrlString:(NSString*) urlString {
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error = nil;
    NSString *jsonResponse = [[[NSString alloc] initWithContentsOfURL:url encoding:NSStringEncodingConversionAllowLossy error:&error] autorelease];
    // TODO: gestire errori
	NSData *jsonData = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
	error = nil;
	NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];	
    // TODO: gestire errori
    
    if (dict) {
        return [dict objectForKey:@"Esercente"];
    } else {
        return [[[NSArray alloc] init] autorelease];
    }
    
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


# pragma mark - Net Reachability


// TODO: Mi lascia perplesso
- (int)checkNetReachability:(Reachability*) curReach {
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
	
	switch (netStatus){
		case NotReachable:
			return -1;
			break;
		default:
			return 0;
	}
}


@end

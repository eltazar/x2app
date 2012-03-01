//
//  Parchi.m
//  Per Due
//
//  Created by Giuseppe Lisanti on 26/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Parchi.h"


@implementation Parchi
@synthesize tableview,map,mappa;
@synthesize rows,dict;
@synthesize barraRicerca;
@synthesize risultatoRicerca;
@synthesize mylatitudine;
@synthesize mylongitudine;
@synthesize provincia,giorno,footerView,url;

-(int)check:(Reachability*) curReach{
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
	
	switch (netStatus){
		case NotReachable:{
			return -1;
			break;
		}
		default:
			return 0;
	}
}

- (IBAction)mostratiporicerca:(id)sender{
	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];

	if ([tiporicerca selectedSegmentIndex]==0) {
		[self ricerca:@"distanza"];
		tiporic=[[NSString alloc]initWithString:@"distanza"];
		[tableview reloadData];
	} 
	if ([tiporicerca selectedSegmentIndex]==1) {
		[self ricerca:@"nome"];
		tiporic=[[NSString alloc]initWithString:@"nome"];
		[tableview reloadData];
		
	}
}


-(void)removeMap:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:[self view]
							 cache:YES];
	[map removeFromSuperview];
	self.navigationItem.titleView = NULL;
	
	[UIView commitAnimations];	
	UIBarButtonItem *mapButton = [[UIBarButtonItem alloc]
								  initWithTitle:@"Mappa"
								  style:UIBarButtonItemStyleBordered
								  target:self
								  action:@selector(showMap:)];
	
	self.navigationItem.rightBarButtonItem = mapButton;
	
}

-(void)showMap:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:[self view]
							 cache:YES];
	
	[UIView commitAnimations];
	
	[[self view] addSubview:map];
	self.navigationItem.titleView = tipoMappa;
		//map=[[[MKMapView alloc] init] autorelease];
	map.delegate = self;
	map.showsUserLocation = YES;
	
	int i=0;
	float lati, longi;
	int d;
	NSLog(@"Ci sono  %d esercenti da inserire in mappa", [rows count]);
	for (i=0; i<[rows count]; i++) {
		dict = [rows objectAtIndex: i];	
		NSLog(@"%@",[dict objectForKey:@"Insegna_Esercente"]);
		lati=[[dict objectForKey:@"Latitudine"] doubleValue];
		longi=[[dict objectForKey:@"Longitudine"] floatValue];
		d=[[dict objectForKey:@"IDesercente"]intValue];
		NSString *nome=[NSString alloc];
		nome=[dict objectForKey:@"Insegna_Esercente"];
		NSString *indirizzo=[[NSString alloc ]initWithFormat:@"%@, %@",[[dict objectForKey:@"Indirizzo_Esercente"]capitalizedString],[[dict objectForKey:@"Citta_Esercente"]capitalizedString] ];
		int identificativo=d;
		
		[map addAnnotation:[[[GoogleHQAnnotation alloc] init:lati:longi:nome:indirizzo:identificativo] autorelease]];
		NSLog(@"Latitudine:%f\n", lati);
		NSLog(@"Latitudine:%f\n", longi);
		NSLog(@"ID:%d\n", identificativo);
		
		
	} 
		//self.view = map;
	
	UIBarButtonItem *lista = [[UIBarButtonItem alloc]
							  initWithTitle:@"Lista"
							  style:UIBarButtonItemStyleBordered
							  target:self
							  action:@selector(removeMap:)];
	
	self.navigationItem.rightBarButtonItem = lista;
	
}

	//stile annotazioni
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id )annotation {
    if (annotation == mapView.userLocation) {
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
	GoogleHQAnnotation *v=(GoogleHQAnnotation*)view.annotation;	
	detail = [[DettaglioEsercenti alloc] initWithNibName:@"DettaglioEsercenti" bundle:[NSBundle mainBundle]];
	[(DettaglioEsercenti*)detail setIdentificativo:[v ide]];
	[detail setTitle:@"Parco"];
		//Facciamo visualizzare la vista con i dettagli
	[self.navigationController pushViewController:detail animated:YES];
		//rilascio controller
		//[detail release];
		//detail = nil;
	
}

	//zoom su posizione utente
- (void)mapView:(MKMapView *)m didAddAnnotationViews:(NSArray *)views {
    for (MKAnnotationView *annotationView in views) {
		if (annotationView.annotation == m.userLocation) {
			MKCoordinateSpan span = MKCoordinateSpanMake(0.15,0.15);
			MKCoordinateRegion region = MKCoordinateRegionMake(m.userLocation.coordinate, span);
			[m setRegion:region animated:YES];
		}
	}
}
- (IBAction)mostraTipoMappa:(id)sender{
	if ([tipoMappa selectedSegmentIndex]==0) {
		map.mapType=MKMapTypeStandard;
	} else if ([tipoMappa selectedSegmentIndex]==1) {
		map.mapType=MKMapTypeSatellite;
	} else if ([tipoMappa selectedSegmentIndex]==2) {
		map.mapType=MKMapTypeHybrid;
	}
}

	// metodo chiamato quando l'utente inizia ad inserire la chiave di ricerca
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
		// visualizza il bottone per uscire dalla ricerca
	barraRicerca.showsCancelButton = YES;
	
		// disattiviamo la possibilità di modificare le celle della tabella
	self.navigationItem.rightBarButtonItem.enabled = FALSE;
}

	// metodo richiamato quando l'utente ha terminato la ricerca
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
		// nascondiamo il bottone "Cancel" del box di ricerca
	barraRicerca.showsCancelButton = NO;
}

	// metodo richiamato quando il bottone "Cancel" viene premuto
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
		//se l'utente esegue una ricerca valida, ma poi la annulla
		// dobbiamo inserire i valori originali nella tabella*/
	
		//ricarichiamo la tabella
	[barraRicerca resignFirstResponder];
		//azzeriamo il box di ricerca
	barraRicerca.text = @"";
	self.navigationItem.rightBarButtonItem.enabled = TRUE;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString
														  *)searchText{
	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
	[rows removeAllObjects];
	[tableview reloadData];
	NSLog(@"Testo da cercare: %@",searchText);
	NSString *chiave = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"-"]; //inserisco un carattere speciale per gli spazi, nel file php verrà risostituito dallo spazio
	url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/RicercaParco.php?chiave=%@&&lat=%f&long=%f",chiave,mylatitudine,mylongitudine]];
	
	NSLog(@"Url: %@", url);
	
	NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url];
	NSLog(@"%@",jsonreturn); // Look at the console and you can see what the restults are
	
	NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;	
	
		// In "real" code you should surround this with try and catch
	dict=[[NSMutableDictionary alloc]init ];
	dict = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error] retain];	
	NSArray* ret=[[NSArray alloc] init ];
	if (dict)
	{
		ret = [[dict objectForKey:@"Esercente"] retain];
		
	}
	[rows addObjectsFromArray: ret];
	NSLog(@"Array: %@",ret);
	indice=1000;//fa in modo che se si clicca su mostra altri, non compaiono i dati della ricerca precedente
	[jsonreturn release];
	[tableview reloadData];
	
	
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{ 
	[barraRicerca resignFirstResponder];
		//azzeriamo il box di ricerca
	barraRicerca.text = @"";
	self.navigationItem.rightBarButtonItem.enabled = TRUE;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([rows count]<6){
		return 1;
	}	
	else {
		return 2;
		
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return [rows count];
		case 1:
			return 1;
		default:
			return 0;
	}
}


	// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==1) {
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		
		if (cell == nil){
			[[NSBundle mainBundle] loadNibNamed:@"CellaFinale" owner:self options:NULL];
			cell=cellafinale;
			
		}
		UILabel *altri = (UILabel *)[cell viewWithTag:1];
		altri.text = @"Mostra altri...";
		UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
		altri2.text = @"";
		return cell;		
	}
	
	else {
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		
		if (cell == nil){
			[[NSBundle mainBundle] loadNibNamed:@"CellaElencoAltriEsercenti" owner:self options:NULL];
			cell=CellaCinema;
		}
		
		dict = [rows objectAtIndex: indexPath.row];
		
		UILabel *esercente = (UILabel *)[cell viewWithTag:1];
		esercente.text = [dict objectForKey:@"Insegna_Esercente"];
		
		UILabel *indirizzo = (UILabel *)[cell viewWithTag:2];
		indirizzo.text = [NSString stringWithFormat:@"%@, %@",[dict objectForKey:@"Indirizzo_Esercente"],[dict objectForKey:@"Citta_Esercente"]];	
		indirizzo.text= [indirizzo.text capitalizedString];

		UILabel *distanza = (UILabel *)[cell viewWithTag:3];
		distanza.text = [NSString stringWithFormat:@"a %.1f Km",[[dict objectForKey:@"Distanza"] doubleValue]];	
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(footerView == nil) {
		if(section==1) {
				//allocate the view if it doesn't exist yet
			footerView  = [[UIView alloc] init];
		}
		
    }
	
		//return the view for the footer
    return footerView;
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
	
	


- (int)aggiorna {
	indice+=20;
	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];

	url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/parchi.php?prov=%@&lat=%f&long=%f&giorno=%@&ordina=%@&from=%d&to=20",provincia,mylatitudine,mylongitudine,giorno,tiporic,indice]];
	NSLog(@"Url: %@", url);
	
	NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url];
	NSLog(@"%@",jsonreturn); // Look at the console and you can see what the restults are
	
	NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;	
	dict = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error] retain];	
		//rows=[[NSMutableArray alloc] initWithObjects:[dict allObjects],nil];
	NSMutableArray *r=[[NSMutableArray alloc] init];
	if (dict)
	{
		r = [[dict objectForKey:@"Esercente"] retain];
		
	}
	
	NSLog(@"Array: %@",r);
	
	[rows addObjectsFromArray: r];
	
	
	[jsonreturn release];
	[tableview reloadData];
	NSLog(@"Ho aggiunto %d righe",[r count]);
	return [r count];
}


- (void) ricerca:(NSString*)tiporic {
	[rows removeAllObjects];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	defaults = [NSUserDefaults standardUserDefaults];
	if([[NSString stringWithFormat:@"%@",[defaults objectForKey:@"giorno"]] isEqualToString:@"Lunedì"]){
		giorno=[[NSString alloc] initWithString:@"Lunedi"];
	}
	if([[NSString stringWithFormat:@"%@",[defaults objectForKey:@"giorno"]] isEqualToString:@"Martedì"]){
		giorno=[[NSString alloc] initWithString:@"Martedi"];
	}
	if([[NSString stringWithFormat:@"%@",[defaults objectForKey:@"giorno"]] isEqualToString:@"Mercoledì"]){
		giorno=[[NSString alloc] initWithString:@"Mercoledi"];
	}
	if([[NSString stringWithFormat:@"%@",[defaults objectForKey:@"giorno"]] isEqualToString:@"Giovedì"]){
		giorno=[[NSString alloc] initWithString:@"Giovedi"];
	}
	if([[NSString stringWithFormat:@"%@",[defaults objectForKey:@"giorno"]] isEqualToString:@"Venerdì"]){
		giorno=[[NSString alloc] initWithString:@"Venerdi"];
	}
	if([[NSString stringWithFormat:@"%@",[defaults objectForKey:@"giorno"]] isEqualToString:@"Sabato"]){
		giorno=[[NSString alloc] initWithString:@"Sabato"];
	}
	if([[NSString stringWithFormat:@"%@",[defaults objectForKey:@"giorno"]] isEqualToString:@"Domenica"]){
		giorno=[[NSString alloc] initWithString:@"Domenica"];
	}
	if([[NSString stringWithFormat:@"%@",[defaults objectForKey:@"giorno"]] isEqualToString:@"Oggi"]){
		NSDate *data = [NSDate date];
		
		int weekday = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:data] weekday];
		
		if(weekday==1){
			giorno=[[NSString alloc] initWithString:@"Domenica"];
		}
		if(weekday==2){
			giorno=[[NSString alloc] initWithString:@"Lunedi"];
		}
		if(weekday==3){
			giorno=[[NSString alloc] initWithString:@"Martedi"];
		}
		if(weekday==4){
			giorno=[[NSString alloc] initWithString:@"Mercoledi"];
		}
		if(weekday==5){
			giorno=[[NSString alloc] initWithString:@"Giovedi"];
		}
		if(weekday==6){
			giorno=[[NSString alloc] initWithString:@"Venerdi"];
		}
		if(weekday==7){
			giorno=[[NSString alloc] initWithString:@"Sabato"];
		}
		
	}
	
	indice=0;
	url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/parchi.php?prov=%@&lat=%f&long=%f&giorno=%@&ordina=%@&from=%d&to=20",provincia,mylatitudine,mylongitudine,giorno,tiporic,indice]];
	NSLog(@"Url: %@", url);
	
	NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url];
	NSLog(@"%@",jsonreturn); // Look at the console and you can see what the restults are
	
	NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;	
	
	dict = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error] retain];	
		//rows=[[NSMutableArray alloc] initWithObjects:[dict allValues],nil];
	NSMutableArray *r=[[NSMutableArray alloc] init];
	
	if (dict)
	{
		r = [[dict objectForKey:@"Esercente"] retain];
		
	}
	
	NSLog(@"Array: %@",r);	
	rows= [[NSMutableArray alloc]init];
	[rows addObjectsFromArray: r];
	
	NSLog(@"Numero totale:%d",[rows count]);
	
	[jsonreturn release];
	jsonreturn=nil;
	[r release];

	r=nil;	
}


	// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];

	tiporic=[[NSString alloc]initWithString:@"distanza"];
	indice=-1;
	self.title=@"Parchi";
	UIBarButtonItem *mapButton = [[UIBarButtonItem alloc]
								  initWithTitle:@"Mappa"
								  style:UIBarButtonItemStyleBordered
								  target:self
								  action:@selector(showMap:)];
    self.navigationItem.rightBarButtonItem = mapButton;
	[self ricerca:@"distanza"];
}


	// Metodo relativo alla selezione di una cella
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==0) {
		[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
		dict = [rows objectAtIndex: indexPath.row];
		NSInteger i=[[dict objectForKey:@"IDesercente"]integerValue];
		NSLog(@"L'id del parco da visualizzare è %d",i);
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		detail = [[DettaglioEsercenti alloc] initWithNibName:@"DettaglioEsercenti" bundle:[NSBundle mainBundle]];
		[(DettaglioEsercenti*)detail setIdentificativo:i];
		[detail setTitle:@"Parco"];
			//Facciamo visualizzare la vista con i dettagli
		[self.navigationController pushViewController:detail animated:YES];
			//rilascio controller
			//[detail release];
			//detail = nil;
	}
	else { //riga mostra altri
		int i=[self aggiorna];
		if(i<20){ // non ci sono alri esercenti
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
			altri2.text = @"Non ci sono altri esercenti da mostrare";
			
		}

	}

}
-(void)spinTheSpinner {
    NSLog(@"Spin The Spinner");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self performSelectorOnMainThread:@selector(doneSpinning) withObject:nil waitUntilDone:YES];
	
    [pool release]; 
}

-(void)doneSpinning {
    NSLog(@"done spinning");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
		// Release any cached data, images, etc that aren't in use.
}

-(void)viewWillAppear:(BOOL)animated {
	int wifi=0;
	int internet=0;
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	internet= [self check:internetReach];
	
	wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	wifi=[self check:wifiReach];	
	if( (internet==-1) &&( wifi==-1) ){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];

	}
	
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[wifiReach release];
	[internetReach release];
    [super viewWillDisappear:animated];
	
	
}

- (void)viewDidUnload {
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
	[rows release];
	[map release];
    [tableview release];
	[barraRicerca release];
	
	[detail release];
	[risultatoRicerca release];
	[dict release];
	[mappa release];
	[tiporicerca release];
	[CellaCinema release];
	[cellafinale release];
	[tipoMappa release];
	[provincia release];
	
	[giorno release];
	[tiporic release];
	[footerView release];
		//[url release];
}

- (void)dealloc {

    [super dealloc];
    
}


@end


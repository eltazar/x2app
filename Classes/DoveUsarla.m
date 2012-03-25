//
//  Home.m
//  Per Due
//
//  Created by Giuseppe Lisanti on 08/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DoveUsarla.h"
#import "CategoriaCommerciale.h"
#import "UserDefaults.h"
#import "Opzioni.h"
#import "Info.h"


@interface DoveUsarla () {
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
- (int)checkNetReachability:(Reachability*) curReach;
@end


@implementation DoveUsarla

 
@synthesize dataModel, locationManager;

// IBOutlets:
@synthesize tableHeaderLabel;


	

// ritorna il numero di righe della tabella
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return [self.dataModel count];
    else
        return 0;
}


//settiamo il contenuto delle varie celle
- (UITableViewCell *)tableView:(UITableView *)tableView	cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	// TODO: Sta riga è nel posto sbagliato
	[tableHeaderLabel setText:[UserDefaults weekDay]];
	
	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:@"cellID"];
	if (cell == nil){
        // TODO: controllare il reuse identifier di CellaHome.
		cell = [[[NSBundle mainBundle] loadNibNamed:@"DoveUsarlaCell" owner:self options:NULL] objectAtIndex:0];
	}
	
	UILabel *cat = (UILabel *)[cell viewWithTag:1];
	cat.text = [[dataModel objectAtIndex:indexPath.row] objectForKey:@"title"];
	UIImageView *img = (UIImageView*) [cell viewWithTag:2];
	img.image = [UIImage imageNamed:cat.text];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}


// Metodo relativo alla selezione di una cella
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
	
    NSDictionary *rowData = [self.dataModel objectAtIndex:indexPath.row];
    
    Class ViewController = NSClassFromString([rowData objectForKey:@"class"]);
    CategoriaCommerciale *viewController = [[[ViewController alloc] 
                                             initWithTitle:[rowData objectForKey:@"title"]
                                             phpFile:[rowData objectForKey:@"phpFile"]
                                             phpSearchFile:[rowData objectForKey:@"phpSearchFile"]
                                             latitude:latitude
                                             longitude:longitude] autorelease];
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//Facciamo visualizzare la vista con i dettagli
	[self.navigationController pushViewController:viewController animated:YES];
}


- (void)spinTheSpinner {
    NSLog(@"Spin The Spinner");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self performSelectorOnMainThread:@selector(doneSpinning) withObject:nil waitUntilDone:YES];
	
    [pool release]; 
}

- (void)doneSpinning {
    NSLog(@"done spinning");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - IBActions


- (IBAction)openCitySelector:(id)sender {
	Opzioni *opt = [[[Opzioni alloc] init] autorelease];
    [self presentModalViewController:opt animated:YES];
}


- (IBAction)openInfo:(id)sender {
	Info *info = [[[Info alloc] init] autorelease];
	[self presentModalViewController:info animated:YES];
}


#pragma mark - Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
    
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(openInfo:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalButton = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
	[self.navigationItem setRightBarButtonItem:modalButton animated:YES];
    
	self.tableView.tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"DoveUsarlaTableHeader" owner:self options:NULL] objectAtIndex:0];
	
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self;
	[self.locationManager startUpdatingLocation];
	
	self.dataModel = [[[NSArray alloc] initWithObjects:
                      [[[NSDictionary alloc] initWithObjectsAndKeys:
                       @"Ristoranti", @"title",
                       @"CategoriaCommercialeWithPrice", @"class",
                       @"ristoranti", @"phpFile",
                       @"RicercaRistorante", @"phpSearchFile", 
                       nil] autorelease],
                      [[[NSDictionary alloc] initWithObjectsAndKeys:
                       @"Pubs e Bar", @"title",
                       @"CategoriaCommercialeWithPrice", @"class",
                       @"pubsebar", @"phpFile",
                       @"RicercaPubseBar", @"phpSearchFile", 
                       nil] autorelease],
                      [[[NSDictionary alloc] initWithObjectsAndKeys:
                       @"Cinema", @"title",
                       @"CategoriaCommerciale", @"class",
                       @"cinema", @"phpFile",
                       @"RicercaCinema", @"phpSearchFile", 
                       nil] autorelease],
                      [[[NSDictionary alloc] initWithObjectsAndKeys:
                       @"Teatri", @"title",
                       @"CategoriaCommerciale", @"class",
                       @"teatri", @"phpFile",
                       @"RicercaTeatro", @"phpSearchFile", 
                       nil] autorelease],
                      [[[NSDictionary alloc] initWithObjectsAndKeys:
                       @"Musei", @"title",
                       @"CategoriaCommerciale", @"class",
                       @"musei", @"phpFile",
                       @"RicercaMuseo", @"phpSearchFile", 
                       nil] autorelease],
                      [[[NSDictionary alloc] initWithObjectsAndKeys:
                       @"Librerie", @"title",
                       @"CategoriaCommerciale", @"class",
                       @"librerie", @"phpFile",
                       @"RicercaLibreria", @"phpSearchFile", 
                       nil] autorelease],
                      [[[NSDictionary alloc] initWithObjectsAndKeys:
                       @"Benessere", @"title",
                       @"CategoriaCommerciale", @"class",
                       @"benessere", @"phpFile",
                       @"RicercaBenessere", @"phpSearchFile", 
                       nil] autorelease],
                      [[[NSDictionary alloc] initWithObjectsAndKeys:
                       @"Parchi", @"title",
                       @"CategoriaCommerciale", @"class",
                       @"parchi", @"phpFile",
                       @"RicercaParco", @"phpSearchFile", 
                       nil] autorelease],
                      [[[NSDictionary alloc] initWithObjectsAndKeys:
                       @"Viaggi", @"title",
                       @"CategoriaCommerciale", @"class",
                       @"viaggi", @"phpFile",
                       @"RicercaViaggio", @"phpSearchFile", 
                       nil] autorelease],
                      [[[NSDictionary alloc] initWithObjectsAndKeys:
                       @"Altro...", @"title",
                       @"CategoriaCommerciale", @"class",
                       @"altro", @"phpFile",
                       @"RicercaAltro", @"phpSearchFile", 
                       nil] autorelease],
                      nil] autorelease];
                    
    // TODO: a che cazzo servono gli user default se vengono sovrascritti ad ogni avvio?!
    // correggere!
    NSString *city=@"Qui";
	NSString *day=@"Oggi";

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:city forKey:@"citta"];
	[defaults setObject:day forKey:@"giorno"];

	[defaults setObject:[NSNumber numberWithInt:0] forKey:@"idcity"];
	[defaults setObject:[NSNumber numberWithInt:0] forKey:@"idday"];

	[defaults synchronize];
	NSLog(@"Ho salvato i valori: %d e %d\n",[[defaults objectForKey:@"idcity"]integerValue],[[defaults objectForKey:@"idday"]integerValue]);
    
    
    if ([[UserDefaults city] isEqualToString:@"Qui"]) {
		self.navigationItem.title = @"Qui vicino";
	} else {
		self.navigationItem.title = [UserDefaults city];
	}
	[tableHeaderLabel setText:[UserDefaults weekDay]];


}


- (void)viewWillAppear:(BOOL)animated {
    int wifi = 0;
    int internet = 0;
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
    wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
    internet = [self checkNetReachability:internetReach];
    wifi = [self checkNetReachability:wifiReach];	
    
    if( (internet == -1) &&( wifi == -1) ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
        [alert show];
        [alert release];
    }
    
    // TODO: Me pare un po' 'na zozzata fare ste cose qui... ma vabbè
    // TODO: codice duplicato in viewDidAppear
    if ([[UserDefaults city] isEqualToString:@"Qui"]){
		self.navigationItem.title = @"Qui vicino";
	} else {
		self.navigationItem.title = [UserDefaults city];
	}
	self.tableHeaderLabel.text = [UserDefaults weekDay];
}


- (void)viewWillDisappear:(BOOL)animated {
	[wifiReach release];
    wifiReach = nil;
	[internetReach release];
    internetReach = nil;
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand
    // For example: self.myOutlet = nil;
    self.tableHeaderLabel = nil;
}


- (void)dealloc {
    // Properties
    self.dataModel = nil;
    self.locationManager = nil;
    // Attributi
    [wifiReach release];
    wifiReach = nil;
    [internetReach release];
    internetReach = nil;
    // Super
    [super dealloc];
}


# pragma mark - CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	latitude  = newLocation.coordinate.latitude;
	longitude = newLocation.coordinate.longitude;
}



# pragma mark - Net Reachability


// TODO: Mi lascia perplesso
- (int)checkNetReachability:(Reachability*) curReach {
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




@end 


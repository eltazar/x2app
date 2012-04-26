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
#import "Utilita.h"


@interface DoveUsarla () {}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSArray *dataModel;
@end


@implementation DoveUsarla


// IBOutlets:
@synthesize tableHeaderLabel=_tableHeaderLabel;

// Private Properties:
@synthesize locationManager=_locationManager, dataModel=_dataModel;


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
	

#pragma mark - View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
    
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(openInfo:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalButton = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
	[self.navigationItem setRightBarButtonItem:modalButton animated:NO];
    
	self.tableView.tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"DoveUsarlaTableHeader" owner:self options:NULL] objectAtIndex:0];
	
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self;
	[self.locationManager startUpdatingLocation];
	
	self.dataModel = [[[NSArray alloc] initWithObjects:
                       [[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"Ristoranti",                     @"title",
                         @"CategoriaCommercialeWithPrice",  @"class",
                         @"ristoranti",                     @"categoria",
                         nil] autorelease],
                       [[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"Pubs e Bar",                     @"title",
                         @"CategoriaCommercialeWithPrice",  @"class",
                         @"pubsebar",                       @"categoria",
                         nil] autorelease],
                       [[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"Cinema",                         @"title",
                         @"CategoriaCommerciale",           @"class",
                         @"cinema",                         @"categoria",
                         nil] autorelease],
                       [[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"Teatri",                         @"title",
                         @"CategoriaCommerciale",           @"class",
                         @"teatri",                         @"categoria",
                         nil] autorelease],
                       [[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"Musei",                          @"title",
                         @"CategoriaCommerciale",           @"class",
                         @"musei",                          @"categoria",
                         nil] autorelease],
                       [[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"ToucHotel",                      @"title",
                         @"CategoriaCommerciale",           @"class",
                         @"touchotel",                      @"categoria",
                         nil] autorelease],
                       [[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"Librerie",                       @"title",
                         @"CategoriaCommerciale",           @"class",
                         @"librerie",                       @"categoria",
                         nil] autorelease],
                       [[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"Benessere",                      @"title",
                         @"CategoriaCommerciale",           @"class",
                         @"benessere",                      @"categoria",
                         nil] autorelease],
                       [[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"Parchi",                         @"title",
                         @"CategoriaCommerciale",           @"class",
                         @"parchi",                         @"categoria",
                         nil] autorelease],
                       [[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"Viaggi",                         @"title",
                         @"CategoriaCommerciale",           @"class",
                         @"viaggi",                         @"categoria",
                         nil] autorelease],
                       [[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"Altro...",                       @"title",
                         @"CategoriaCommerciale",           @"class",
                         @"altro",                          @"categoria",
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
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]  animated:YES];
    if( ! [Utilita networkReachable]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
        [alert show];
        [alert release];
    }
    
    // TODO: Me pare un po' 'na zozzata fare ste cose qui... ma vabbè
    if ([[UserDefaults city] isEqualToString:@"Qui"]){
		self.navigationItem.title = @"Qui vicino";
	} else {
		self.navigationItem.title = [UserDefaults city];
	}
	self.tableHeaderLabel.text = [NSString stringWithFormat:@"Dove usare Carta PerDue %@",[UserDefaults weekDay]];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand
    // For example: self.myOutlet = nil;
    // Stuff re-created in viewDidAppear:
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
	//self.tableView.tableHeaderView = nil;
    self.tableHeaderLabel = nil;
	[self.locationManager stopUpdatingLocation];
	self.locationManager.delegate = nil;
    self.locationManager = nil;
	self.dataModel = nil;
}


- (void)dealloc {
    // Properties
    self.dataModel = nil;
    // IBOutlets:
    self.tableHeaderLabel = nil;
    // Priv properties:
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    [super dealloc];
}


# pragma mark - CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	location.latitude  = newLocation.coordinate.latitude;
	location.longitude = newLocation.coordinate.longitude;
}


# pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return [self.dataModel count];
    else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView	cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	
	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:@"DoveUsarlaCell"];
	if (!cell) {
        // TODO: controllare il reuse identifier di CellaHome.
		cell = [[[NSBundle mainBundle] loadNibNamed:@"DoveUsarlaCell" owner:self options:NULL] objectAtIndex:0];
	}
	
	UILabel *cat = (UILabel *)[cell viewWithTag:1];
	cat.text = [[self.dataModel objectAtIndex:indexPath.row] objectForKey:@"title"];
	UIImageView *img = (UIImageView*) [cell viewWithTag:2];
	img.image = [UIImage imageNamed:cat.text];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}


# pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *rowData = [self.dataModel objectAtIndex:indexPath.row];
    
    if([[rowData objectForKey:@"title"] isEqualToString:@"ToucHotel"]){
        NSLog(@"touch hotel cliccato");
        [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: @"touchotel://"]] ? [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"touchotel://"]]:[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/it/app/touchotel/id358599349?mt=8"]];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else{
        Class ViewControllerClass = NSClassFromString([rowData objectForKey:@"class"]);
        CategoriaCommerciale *viewController = [[ViewControllerClass alloc]
                                                initWithTitle:[rowData objectForKey:@"title"]                                            categoria:[rowData objectForKey:@"categoria"]
                                                     location:location];
            
        //Facciamo visualizzare la vista con i dettagli
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

#pragma mark - DoveUsarla (IBActions)


- (IBAction)openCitySelector:(id)sender {
	Opzioni *opt = [[[Opzioni alloc] init] autorelease];
    [self presentModalViewController:opt animated:YES];
}


- (IBAction)openInfo:(id)sender {
	Info *info = [[[Info alloc] init] autorelease];
	[self presentModalViewController:info animated:YES];
}


@end 


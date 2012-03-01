//
//  Home.m
//  Per Due
//
//  Created by Giuseppe Lisanti on 08/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Home.h"

@implementation Home
@synthesize lista;

@synthesize myTable,giorno,citta,locationManager,head;
@synthesize myHeader;

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
	


//setta il numero di righe della tabella
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
	//numero di righe deve corrispondere al numero di elementi della lista
	return [lista count];
}


//settiamo il contenuto delle varie celle
- (UITableViewCell *)tableView:(UITableView *)tableView
	cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	defaults = [NSUserDefaults standardUserDefaults];
	
	[[NSBundle mainBundle] loadNibNamed:@"Header" owner:self options:NULL];
	self.tableView.tableHeaderView = myHeader;
	[head setText:[defaults objectForKey:@"giorno"]];
	
	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:@"cellID"];
		
	if (cell == nil){
		[[NSBundle mainBundle] loadNibNamed:@"CellaHome" owner:self options:NULL];
		cell=cellahome;
	}
	
	UILabel *cat = (UILabel *)[cell viewWithTag:1];
	cat.text = [lista objectAtIndex:indexPath.row];
	UIImageView *img = (UIImageView*) [cell viewWithTag:2];
	img.image = [UIImage imageNamed:cat.text];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}

// Metodo relativo alla selezione di una cella
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	defaults = [NSUserDefaults standardUserDefaults];
	if (indexPath.row == 0){
	//l'utente ha cliccato sull'elemento Ristoranti
		detail = [[Ristoranti alloc] initWithNibName:@"Ristoranti" bundle:[NSBundle mainBundle]];
		[(Ristoranti*)detail setMylatitudine:mylat];
		[(Ristoranti*)detail setMylongitudine:mylong];
		[(Ristoranti*)detail setProvincia:[defaults objectForKey:@"citta"]];
		NSLog(@"Ho settato la latitudine a %f",[(Ristoranti*)detail mylatitudine]);
		NSLog(@"Latitudine:%f",mylat);
		NSLog(@"Longitudine:%f",mylong);
	} 
	// ho cliccato su Pubs e bar
	if (indexPath.row == 1){
		detail = [[Pubsebar alloc] initWithNibName:@"Pubsebar" bundle:[NSBundle mainBundle]];
		[(Pubsebar*)detail setMylatitudine:mylat];
		[(Pubsebar*)detail setMylongitudine:mylong];
		[(Pubsebar*)detail setProvincia:[defaults objectForKey:@"citta"]];

	}
	
		// ho cliccato su Cinema
	if (indexPath.row == 2){
		detail = [[Cinema alloc] initWithNibName:@"Cinema" bundle:[NSBundle mainBundle]];
		[(Cinema*)detail setMylatitudine:mylat];
		[(Cinema*)detail setMylongitudine:mylong];
		[(Cinema*)detail setProvincia:[defaults objectForKey:@"citta"]];

	}
	
	if (indexPath.row == 3){
		detail = [[Teatri alloc] initWithNibName:@"Teatri" bundle:[NSBundle mainBundle]];
		[(Teatri*)detail setMylatitudine:mylat];
		[(Teatri*)detail setMylongitudine:mylong];
		[(Teatri*)detail setProvincia:[defaults objectForKey:@"citta"]];

	}
	
	if (indexPath.row == 4){
		detail = [[Musei alloc] initWithNibName:@"Musei" bundle:[NSBundle mainBundle]];
		[(Musei*)detail setMylatitudine:mylat];
		[(Musei*)detail setMylongitudine:mylong];
		[(Musei*)detail setProvincia:[defaults objectForKey:@"citta"]];

	}
	
	if (indexPath.row == 5){
		detail = [[Librerie alloc] initWithNibName:@"Librerie" bundle:[NSBundle mainBundle]];
		[(Librerie*)detail setMylatitudine:mylat];
		[(Librerie*)detail setMylongitudine:mylong];
		[(Librerie*)detail setProvincia:[defaults objectForKey:@"citta"]];

	}
	
	if (indexPath.row == 6){
		detail = [[Benessere alloc] initWithNibName:@"Benessere" bundle:[NSBundle mainBundle]];
		[(Benessere*)detail setMylatitudine:mylat];
		[(Benessere*)detail setMylongitudine:mylong];
		[(Benessere*)detail setProvincia:[defaults objectForKey:@"citta"]];

	}
	
	if (indexPath.row == 7){
		detail = [[Parchi alloc] initWithNibName:@"Parchi" bundle:[NSBundle mainBundle]];
		[(Parchi*)detail setMylatitudine:mylat];
		[(Parchi*)detail setMylongitudine:mylong];
		[(Parchi*)detail setProvincia:[defaults objectForKey:@"citta"]];

	}
	
	if (indexPath.row == 8){
		detail = [[Viaggi alloc] initWithNibName:@"Viaggi" bundle:[NSBundle mainBundle]];
		[(Viaggi*)detail setMylatitudine:mylat];
		[(Viaggi*)detail setMylongitudine:mylong];
		[(Viaggi*)detail setProvincia:[defaults objectForKey:@"citta"]];

	}
	
	if (indexPath.row == 9){
		detail = [[Altro alloc] initWithNibName:@"Altro" bundle:[NSBundle mainBundle]];
		[(Altro*)detail setMylatitudine:mylat];
		[(Altro*)detail setMylongitudine:mylong];
		[(Altro*)detail setProvincia:[defaults objectForKey:@"citta"]];

	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//Facciamo visualizzare la vista con i dettagli
	[self.navigationController pushViewController:detail animated:YES];
	//rilascio controller
    
		//[detail release];
		//detail = nil;

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

#pragma mark -
#pragma mark View lifecycle


- (IBAction)SelectCity:(id)sender {
	Opzioni *opt = [[[Opzioni alloc] init] autorelease];
    [self presentModalViewController:opt animated:YES];
}


- (IBAction)OpenInfo:(id)sender {
	Info *info = [[[Info alloc] init] autorelease];
	[self presentModalViewController:info animated:YES];

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
		// Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidLoad {
	
	UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(OpenInfo:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setRightBarButtonItem:modalButton animated:YES];
	[infoButton release];
	[modalButton release];
	
	[super viewDidLoad];
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self;
	[self.locationManager startUpdatingLocation];
	
	NSArray *array = [[NSArray alloc] initWithObjects:@"Ristoranti",@"Pubs e Bar", @"Cinema",
					  @"Teatri", @"Musei", @"Librerie",@"Benessere",@"Parchi",@"Viaggi", @"Altro...", nil];
	self.lista= array;
	NSString *city=@"Qui";
	NSString *day=@"Oggi";

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:city forKey:@"citta"];
	[defaults setObject:day forKey:@"giorno"];

	[defaults setObject:[NSNumber numberWithInt:0] forKey:@"idcity"];
	[defaults setObject:[NSNumber numberWithInt:0] forKey:@"idday"];

	[defaults synchronize];
	NSLog(@"Ho salvato i valori: %ld e %ld\n",[[defaults objectForKey:@"idcity"]integerValue],[[defaults objectForKey:@"idday"]integerValue]);
	self.navigationItem.title=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"citta"]];

}

-(void)viewWillAppear:(BOOL)animated {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	defaults = [NSUserDefaults standardUserDefaults];
	
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
	

	if([[NSString stringWithFormat:@"%@",[defaults objectForKey:@"citta"]] isEqualToString:@"Qui"]){
		self.navigationItem.title=[NSString stringWithFormat:@"Qui vicino"];
	}
	else {
		self.navigationItem.title=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"citta"]];
	}
	
	self.tableView.tableHeaderView = myHeader;
	[head setText:[defaults objectForKey:@"giorno"]];

}

- (void)viewWillDisappear:(BOOL)animated {
	[wifiReach release];
	[internetReach release];
    [super viewWillDisappear:animated];
	
	
}

- (void)locationManager:(CLLocationManager *)manager 
didUpdateToLocation:(CLLocation *)newLocation
fromLocation:(CLLocation *)oldLocation {
	NSLog(@"%f",newLocation.coordinate.latitude);
	NSLog(@"%f",newLocation.coordinate.longitude);
	mylat=newLocation.coordinate.latitude  ;
	mylong=newLocation.coordinate.longitude;
	NSLog(@"Latitudine nella classe home:%f",mylat);

	
}


- (void)viewDidUnload {
		// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
		// For example: self.myOutlet = nil;
	[detail release];
	detail=nil;

	


}


- (void)dealloc {
    [super dealloc];

}

@end 


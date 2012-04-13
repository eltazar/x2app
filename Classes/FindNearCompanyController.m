//
//  FindNearCompanyController.m
//  PerDueCItyCard
//
//  Created by mario greco on 03/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "FindNearCompanyController.h"
#import "Utilita.h"
#import "BaseCell.h"
#import "CartaPerDue.h"
#import "ValidateCardController.h"
#import "MBProgressHUD.h"
#import "UserDefaults.h"

@interface FindNearCompanyController(){
    NSString *_phpFile;
    BOOL isEmpty;
    CartaPerDue *_card;
    CLLocationCoordinate2D userCoordinate;
}
@property(nonatomic, retain) CartaPerDue *card;
@property (nonatomic, retain) NSString *phpFile;
@end

@implementation FindNearCompanyController

@synthesize urlString = _urlString, rows = _rows, phpFile = _phpFile;
@synthesize card = _card;

-(id) initWithCard:(CartaPerDue *)aCard{
    
    self = [super initWithNibName:@"FindNearCompanyController" bundle:nil];
    if(self){
        
        self.card = aCard;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - WMHTTPAccessDelegate

-(void)didReceiveJSON:(NSDictionary *)jsonDict {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString *type = [[jsonDict allKeys] objectAtIndex:0];
    NSArray *newRows = [jsonDict objectForKey:type];
    NSLog(@"esercenti = %@", jsonDict);
    NSLog(@"new rows = %d, rows = %d",newRows.count, self.rows.count);
    // Ci aspettiamo che rows sia effettivamente un array, se non lo è
    // si ignora.
    if (![newRows isKindOfClass:[NSArray class]]) return;
    
    if ([type isEqualToString:@"Esercente:FirstRows"]) {
        //table view begin updates at indexes blah blah 
//        [self.tableView beginUpdates];
//        [self.rows removeAllObjects];
//        [self.rows addObjectsFromArray:newRows];
//        [self.tableView endUpdates] ;
        [self.rows removeAllObjects];
        [self.rows addObjectsFromArray:newRows];
        //rimuovo 0 finale
        [self.rows removeObjectAtIndex:self.rows.count-1];
        [self.tableView reloadData];
        NSLog(@"rows count = %d",[self.rows count]);
    } 
    else if ([type isEqualToString:@"Esercente:MoreRows"]) {
       
        if(newRows.count > 1){
            //creo i nuovi indexPaths per le righe ricevute
            NSMutableArray *indexPaths = [[NSMutableArray alloc]initWithCapacity:newRows.count]; 
            for (int i = self.rows.count; i < self.rows.count + newRows.count-1; i++) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            
            [self.tableView beginUpdates];
            [self.rows addObjectsFromArray:newRows];
            [self.rows removeObjectAtIndex:self.rows.count-1];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            [indexPaths release];
        }
        else{
            isEmpty = TRUE;
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            //NSLog(@"cell = %@",cell);
            UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
            altri2.text = @"Non ci sono altri esercenti da mostrare";
            //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], nil] withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView reloadData];
        }
    }

}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"ERRORE CONNESSIONE = %@", [error localizedDescription]);
}

#pragma mark - metodi privati
- (void) fetchRows{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Caricamento...";

    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithCapacity:8];
    [postDict setObject:@"fetch"                forKey:@"request"];
    [postDict setObject:[UserDefaults weekDay]  forKey:@"giorno"];
    [postDict setObject:@"2"                    forKey:@"raggio"];
    [postDict setObject:@"distanza"             forKey:@"ordina"];
    [postDict setObject:@"0"                    forKey:@"from"];
    [postDict setObject:@"41.890520"            forKey:@"lat"];
    [postDict setObject:@"12.494249"            forKey:@"long"];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:self.urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:self];
}


- (void)fetchMoreRows {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];    
    
    NSString *fromString = [NSString stringWithFormat:@"%d", self.rows.count];
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithCapacity:8];
    [postDict setObject:@"fetch"                forKey:@"request"];
    [postDict setObject:[UserDefaults weekDay]  forKey:@"giorno"];
    [postDict setObject:@"2"                    forKey:@"raggio"];
    [postDict setObject:@"distanza"             forKey:@"ordina"];
    [postDict setObject:fromString              forKey:@"from"];
    [postDict setObject:@"41.890520"            forKey:@"lat"];
    [postDict setObject:@"12.494249"            forKey:@"long"];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:self.urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:self];
}

#pragma mark - CLLocationManagerDelegate protocol

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
        userCoordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    }
    // else skip the event and process the next one.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"location error = %@",[error description]);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Esercenti vicini";
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    NSLog(@"Significant Location Change Available: %d", [CLLocationManager significantLocationChangeMonitoringAvailable]);
    
    [locationManager startMonitoringSignificantLocationChanges];
    
    isEmpty = FALSE;
    
    self.urlString = @"http://www.cartaperdue.it/partner/v2.0/Esercenti.php";
    self.rows = [[[NSMutableArray alloc] init] autorelease];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    self.urlString = nil;
    self.rows = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(![Utilita networkReachable]){
        NSLog(@"ALERT INTERNET ASSENTE");
    }
    else{
        NSLog(@"USER COORDINATE LAT = %f, LONG = %f",userCoordinate.latitude,userCoordinate.longitude);
        [self fetchRows];
    }
    
    
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

- (void)dealloc {
    
    self.card = nil;
    self.phpFile = nil;
    self.urlString = nil;
    self.rows = nil;
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
        if(isEmpty)
            altri2.text = @"Non ci sono altri esercenti da mostrare";
		else altri2.text = @"";
        
		return cell;		
	} else {
        // Stiamo mostrando la cella relativa ad un esercente
		UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"FindNearCompanyCell"];
		
		if (cell == nil){
			cell = [[[NSBundle mainBundle] loadNibNamed:@"FindNearCompanyCell" owner:self options:NULL] objectAtIndex:0];
		}
		
		NSDictionary *r  = [self.rows objectAtIndex:indexPath.row];
		//NSLog(@"index path sec = %d, row = %d",indexPath.section,indexPath.row);
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 90;
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

//- (UIView *)tableView:(UITableView *)tView viewForFooterInSection:(NSInteger)section {
//    return self.footerView;
//}


//- (CGFloat)tableView:(UITableView *)tView heightForFooterInSection:(NSInteger)section {
//	switch (section) {
//		case 0:
//			return 0;	
//		case 1:
//			return 65;
//		default:
//			return 0;
//	}
//}


- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
            NSLog(@"####### \n tessera numero: %@ \n riga: %d, esercente id: %d \n######",self.card.number, indexPath.row, [[[self.rows objectAtIndex:indexPath.row] objectForKey:@"IDesercente"] intValue]);
        NSLog(@"ESERCENTE RIGA = %@",[self.rows objectAtIndex:indexPath.row]);
        ValidateCardController *validateCtr = [[ValidateCardController alloc] initWhitCard:self.card company:[self.rows objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:validateCtr animated:YES];
        [validateCtr release];
        
	}
	else { 
        //riga mostra altri
		[self fetchMoreRows];
//		if (i < 20) { // non ci sono alri esercenti
//			UITableViewCell *cell = [tView cellForRowAtIndexPath:indexPath];
//			UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
//			altri2.text = @"Non ci sono altri esercenti da mostrare";
//		}
	}
    
    [tView deselectRowAtIndexPath:indexPath animated:YES];

}

@end

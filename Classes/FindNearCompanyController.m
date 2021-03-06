//
//  FindNearCompanyController2.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FindNearCompanyController.h"
#import "CartaPerDue.h"
#import "ValidateCardController.h"
#import "Utilita.h"
#import "WMHTTPAccess.h"
#import "MBProgressHUD.h"

@interface FindNearCompanyController () {
    int firstFetchCount;
}

@property (nonatomic, retain) CartaPerDue *card;
@property (nonatomic, retain) CLLocationManager *locationManager;
@end



@implementation FindNearCompanyController

@synthesize card=_card, locationManager=_locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil card:(CartaPerDue *)card {
    if (!nibNameOrNil) {
        nibNameOrNil = [NSString stringWithFormat:@"%@", [self superclass]];
    }
    self = [self initWithNibName:nibNameOrNil bundle:nil];
    self.title = @"Esercenti Vicini";
    self.card = card;
    return self;
}


#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Esercenti vicini";
    
    firstFetchCount = 0;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    //NSLog(@"Significant Location Change Available: %d", [CLLocationManager significantLocationChangeMonitoringAvailable]);
    //[self.locationManager startMonitoringSignificantLocationChanges];
    
    //isEmpty = FALSE;
    
    [_urlString release];
    _urlString = @"http://www.cartaperdue.it/partner/v2.0/Esercenti.php";
    
    //Elimino dall'interfaccia gli elementi inutili:
    self.navigationItem.rightBarButtonItem = nil;
    CGRect frame = self.tableView.frame;
    //CGFloat deltaH = frame.size.height;
    frame.origin.y = 0;
    frame.size.height = 367;
    [self.tableView removeFromSuperview];
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:142.0/255 green:21.0/255 blue:7.0/255 alpha:1];
    [self.view insertSubview:self.tableView belowSubview:self.activityIndicator];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.activityIndicator.color = [UIColor whiteColor];
    self.activityIndicator.center = self.tableView.center;
    self.footerView = nil;
}


- (void)viewDidUnload {
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    self.card = nil;
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    [super dealloc];
}


- (void)viewWillAppear:(BOOL)animated {

    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]  animated:YES];
    
    if([CLLocationManager locationServicesEnabled]){
        
        if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Servizi di localizazione disabilitati" 
                                                            message:@"Per riabilitarli, vai su Impostazioni e seleziona ON sul servizio di localizzazione per questa app" 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else{
            // gps genereale e per l'app su ON
        }
    }
    else{
        // gps generale disabilitato
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Servizi di localizazione disabilitati" 
                                                        message:@"Per riabilitarli, vai su Impostazioni e abilita i servizi di localizzazione per questa app" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    if( ![Utilita networkReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
        [alert show];
        [alert release];
	} 
}


#pragma mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindNearCompanyCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FindNearCompanyCell" owner:self options:nil] objectAtIndex:0];
        }
        NSDictionary *r = [self.dataModel objectAtIndex:indexPath.row];
        
        UILabel *insegna  = (UILabel *)[cell viewWithTag:1];
        UILabel *indirizzo = (UILabel *)[cell viewWithTag:2];
        UILabel *distanza  = (UILabel *)[cell viewWithTag:3];

        insegna.text = [r objectForKey:@"Insegna_Esercente"];
        indirizzo.text = [NSString stringWithFormat:@"%@, %@",[r objectForKey:@"Indirizzo_Esercente"],[r objectForKey:@"Citta_Esercente"]];	
        indirizzo.text = [indirizzo.text capitalizedString];
        distanza.text = [NSString stringWithFormat:@"a %.1f km",[[r objectForKey:@"Distanza"] doubleValue]];	
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 55;
    }
    else {
        return 90;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSLog(@"####### \n tessera numero: %@ \n riga: %d, esercente id: %d \n######",self.card.number, indexPath.row, [[[self.dataModel objectAtIndex:indexPath.row] objectForKey:@"IDesercente"] intValue]);
        NSLog(@"ESERCENTE RIGA = %@",[self.dataModel objectAtIndex:indexPath.row]);
        ValidateCardController *validateCtr = [[ValidateCardController alloc] initWhitCard:self.card company:[self.dataModel objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:validateCtr animated:YES];
        [validateCtr release];
    }
    else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark - CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
    NSLog(@"LOCATION AGGIORNATA");
	location.latitude  = newLocation.coordinate.latitude;
	location.longitude = newLocation.coordinate.longitude;
    
    //fermo l'aggiornamento della posizione e lancio la query
    [self.locationManager stopUpdatingLocation];
    [self fetchRows];
    NSLog(@"latitude = %f, longitude = %f",location.latitude,location.longitude);
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"LOCATION ERROR  = %@",[error description]);
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    NSLog(@"STATUS GPS = %d", status);
    /*
     if(status != kCLAuthorizationStatusAuthorized){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled" 
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app." 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    */
}

#pragma mark - WMHTTPAccessDelegate


- (void)didReceiveJSON:(NSDictionary *)dataDict {
    
    NSLog(@"data dict find near = %@", dataDict);
    NSString *type = [[dataDict allKeys] objectAtIndex:0];
    NSMutableArray *rowsTemp = [NSMutableArray arrayWithArray:[dataDict objectForKey:type]];
    
    // Ci aspettiamo che rows sia effettivamente un array, se non lo è
    // si ignora.  
    if (![rowsTemp isKindOfClass:[NSArray class]]) return;
    
    [rowsTemp removeLastObject];
    
    if( [type isEqualToString:@"Esercente:FirstRows"]){
        //se è la prima query salvo quante righe sono state ottenute dal server
        firstFetchCount = rowsTemp.count;
        NSLog(@"firstFetchCount = %d", firstFetchCount);
    }
    else{
        //alle query successive aggiorno il contatore sommando i nuovi risultati
        firstFetchCount += rowsTemp.count;
    }
    
    NSMutableArray *rows = [NSMutableArray array];
    
    //seleziono solo gli esercenti che accettano la card virtuale
    for(int i = 0 ; i < rowsTemp.count ; i++){
        // == 0 per debug, != versione da pubblicare
        if( [[[rowsTemp objectAtIndex:i] objectForKey:@"Esercente_virtuale"] intValue] != 0){
            
            [rows addObject:[rowsTemp objectAtIndex:i]];
        }
    }
    
    NSLog(@" ROWS FILTRATO é UGUALE A = %d", rows.count);
    
    //se non ci sono risultati mostro avviso
    if( [type isEqualToString:@"Esercente:FirstRows"] && rows.count == 0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Non ci sono esercenti vicini";
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = nil;
        [hud hide:YES afterDelay:2];
       [self.activityIndicator stopAnimating];
    }
    else{

        //TODO: ricostruire il dict ricevuto con il nuovo array rows e chiamare [super didReceiveJson...];
        
        if ([type isEqualToString:@"Esercente:FirstRows"]) {
            [self.activityIndicator stopAnimating];
            //self.activityIndicator.hidden = YES;
            [self.dataModel removeAllObjects];
            [self.dataModel addObjectsFromArray:rows];        
            [self.tableView reloadData];
        } 
        else if ([type isEqualToString:@"Esercente:MoreRows"]) {
            if (rows.count == 0) {
                didFetchAllRows = YES;
            }
            else {
                NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:rows.count]; 
                for (int i = self.dataModel.count; i < self.dataModel.count + rows.count; i++) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                [self.tableView beginUpdates];
                [self.dataModel addObjectsFromArray:rows];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
                [indexPaths release];
            }
            queryingMoreRows = NO;
            [self reloadShowMoreCell];
        }       
    }
}

#pragma mark - FindNearCompanyController (metodi privati)
//@"41.890520"            forKey:@"lat"];
//[postDict setObject:@"12.494249"

- (void)fetchRows {
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.labelText = @"Caricamento...";
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithCapacity:8];
    [postDict setObject:@"fetch"                forKey:@"request"];
    [postDict setObject:[Utilita today]         forKey:@"giorno"];
    [postDict setObject:@"2"                    forKey:@"raggio"];
    [postDict setObject:@"distanza"             forKey:@"ordina"];
    [postDict setObject:@"0"                    forKey:@"from"];
    //[postDict setObject:[NSString stringWithFormat:@"%f",location.latitude] forKey:@"lat"];
    //[postDict setObject:[NSString stringWithFormat:@"%f",location.longitude] forKey:@"long"];
    
    //12.4974148,41.914047,0 via salaria
    // 12.4942486,41.8905198,0 centro roma
    [postDict setObject:@"41.914047" forKey:@"lat"];
    [postDict setObject:@"12.4974148" forKey:@"long"];
    NSLog(@"today = %@, lat = %f, long = %f",[Utilita today], location.latitude,location.longitude);
    
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:_urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:self];
}


- (void)fetchMoreRows {
    
    NSLog(@"count rows first fetch = %d", firstFetchCount);
    
    queryingMoreRows = YES;
    NSString *fromString = [NSString stringWithFormat:@"%d", firstFetchCount];
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithCapacity:8];
    [postDict setObject:@"fetch"                forKey:@"request"];
    [postDict setObject:[Utilita today]         forKey:@"giorno"];
    [postDict setObject:@"2"                    forKey:@"raggio"];
    [postDict setObject:@"distanza"             forKey:@"ordina"];
    [postDict setObject:fromString              forKey:@"from"];
    //[postDict setObject:[NSString stringWithFormat:@"%f",location.latitude] forKey:@"lat"];
    //[postDict setObject:[NSString stringWithFormat:@"%f",location.longitude] forKey:@"long"];
    //12.4974148,41.914047,0 via salaria
    // 12.494249,41.890520,0 centro roma    
    [postDict setObject:@"41.914047" forKey:@"lat"];
    [postDict setObject:@"12.4974148" forKey:@"long"];

    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:_urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:self];
}

 



@end

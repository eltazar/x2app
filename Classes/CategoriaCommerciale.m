//
//  CategoriaCommerciale.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define MAX_LEFT_X
#define MAX_RIGHT_X

#import <CoreLocation/CoreLocation.h>

#import "CategoriaCommerciale.h"
#import "UserDefaults.h"
#import "EsercenteMapAnnotation.h"
#import "CJSONDeserializer.h"
#import "Utilita.h"
#import "DettaglioEsercente.h"
#import "ShowMoreCell.h"
#import "WMHTTPAccess.h"
#import "CachedAsyncImageView.h"


//Metodi privati
@interface CategoriaCommerciale () {}
@property (nonatomic, retain) NSString *categoria;
@property (nonatomic, retain) GeoDecoder *geoDec;
@property (nonatomic, retain) NSArray *tempBuff;

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSMutableArray *dataModel;
- (NSString *)searchMethod;
- (void)fetchMoreRows;
- (void)fetchRowsBySearchKey:(NSString *)searchkey;
- (void)showMap:(id)sender;
- (void)hideMap:(id)sender;
- (void)reloadShowMoreCell;
@end




@implementation CategoriaCommerciale


// Properties


// IBOutlets
@synthesize searchBar=_searchBar, tableView=_tableView, mapView=_mapView, footerView=_footerView, activityIndicator=_activityIndicator, searchActivityIndicator=_searchActivityIndicator, searchSegCtrl=_searchSegCtrl, mapTypeSegCtrl=_mapTypeSegCtrl;

// Properties private
@synthesize categoria=_categoria, geoDec=_geoDec, tempBuff=_tempBuff;

// Properties protected
@synthesize urlString=_urlString, dataModel=_dataModel, leftPanel, sortingLbl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithTitle:(NSString *)title categoria:(NSString *)cat location:(CLLocationCoordinate2D)lo {
    self = [self initWithNibName:nil bundle:nil];
    self.title = title;
    self.categoria = cat;
    location = lo;
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
    
    leftPanel = [[PullableView alloc] initWithFrame:CGRectMake(0-300+50, self.searchBar.frame.size.height, 300, 35)];
    
    leftPanel.delegate = self;
    
    leftPanel.openedCenter = CGPointMake(100, self.searchBar.frame.size.height+ (leftPanel.frame.size.height / 2));
    leftPanel.closedCenter = CGPointMake(0-(leftPanel.frame.size.width/2)+50,self.searchBar.frame.size.height+ (leftPanel.frame.size.height / 2));

    leftPanel.center = leftPanel.closedCenter;
    leftPanel.animate = YES;
    [leftPanel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"leftPanel.png"]]];
    [leftPanel setAlpha:0.95];
    
    
    _searchSegCtrl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Distanza",@"Nome", nil]];
    [self.searchSegCtrl setFrame:CGRectMake(55, 4, 180, 26)];
    self.searchSegCtrl.selectedSegmentIndex = 0;
    self.searchSegCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.searchSegCtrl.tintColor = [UIColor colorWithRed: 180/255.0 green:21/255.0 blue:7/255.0 alpha:1.0];


    [self.searchSegCtrl addTarget:self action:@selector(didChangeSearchSegCtrlState:) forControlEvents:UIControlEventValueChanged];

    sortingLbl = [[UILabel alloc] initWithFrame:CGRectMake(253, 7, 30, 20)];
    sortingLbl.text = @"Km";
    [sortingLbl setFont:[UIFont boldSystemFontOfSize:16]];
    sortingLbl.backgroundColor = [UIColor clearColor];
    sortingLbl.textColor = [UIColor whiteColor];
    
    [leftPanel addSubview:sortingLbl];
    //[self.sortingLabel release];
    
    [leftPanel addSubview:self.searchSegCtrl];
    //[self.searchSegCtrl release];
    
    [self.view addSubview:leftPanel];
    //[self.leftPanel release];
        
    
//    UISegmentedControl *segController = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Tutti",@"Pranzo",@"Cena",nil]];
//    [segController setSegmentedControlStyle:UISegmentedControlStyleBar];
//    [segController setFrame:CGRectMake(50, 5, 150, 50)];
//    [self.filterPanel addSubview:segController];
//    [segController release];
//
//    pullRightView = [[PullableView alloc] initWithFrame:CGRectMake(0, 200, 200, 300)];
//    pullRightView.backgroundColor = [UIColor lightGrayColor];
//    pullRightView.openedCenter = CGPointMake(100, 200);
//    pullRightView.closedCenter = CGPointMake(-70, 200);
//    pullRightView.center = pullRightView.closedCenter;
//    pullRightView.animate = NO;

    
  /*
    [filterPanel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"filterPanel.png"]]];
    
    [filterPanel setFrame:CGRectMake(self.tableView.frame.size.width-30, self.tableView.frame.origin.y, filterPanel.frame.size.width, filterPanel.frame.size.height)];
    [self.view insertSubview:filterPanel aboveSubview:self.view];
    
    maxLeft = self.tableView.frame.size.width - filterPanel.frame.size.width;

    NSLog(@"DID LOAD x = %f, y = %f, maxLeft = %f,tableView x = %f",filterPanel.frame.origin.x,filterPanel.frame.origin.y,maxLeft,self.tableView.frame.origin.x);
    
//    // create a UIPanGestureRecognizer to detect when the screenshot is touched and dragged
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureMoveAround:)];
//    [panGesture setMaximumNumberOfTouches:2];
//    [panGesture setDelegate:self];
//    [filterPanel addGestureRecognizer:panGesture];
//    [panGesture release];
    
    UILongPressGestureRecognizer* longPressure = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
    [filterPanel addGestureRecognizer:longPressure];
    [longPressure release];

    */
    
    self.urlString = @"http://www.cartaperdue.it/partner/v2.0/EsercentiNonRistorazione.php";
    self.dataModel = [[[NSMutableArray alloc] init] autorelease];
    lastFetchWasASearch = NO;
    inSearchUI = NO;
    queryingMoreRows = NO;
    didFetchAllRows = NO;
	UIBarButtonItem *mapButton = [[[UIBarButtonItem alloc]
                                   initWithTitle:@"Mappa"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(showMap:)] autorelease];
    self.navigationItem.rightBarButtonItem = mapButton;
    self.searchActivityIndicator.hidden = YES;
    [self.activityIndicator startAnimating];
    self.geoDec = [[[GeoDecoder alloc] init] autorelease];
    self.geoDec.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [leftPanel setOpened:FALSE animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]  animated:YES];
    if( ![Utilita networkReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
        [alert show];
        [alert release];
	} 
    else {
        // Quando sto per visualizzare la view eseguo il fetch delle righe,
        // ma solo se non è stato già fatto. Es: apro la view -> torno alla
        // springboard -> torno all'app PerDue senza riscaricare i dati.
        if (self.dataModel.count == 0) {
            [self fetchRows];
        }
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
    
//    filterPanel removeGestureRecognizer:<#(UIGestureRecognizer *)#>
    
    // Roba ri-creata in viewDidLoad:
    
    self.sortingLbl = nil;
    self.leftPanel = nil;
    self.urlString = nil;
    self.dataModel = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.geoDec.delegate = nil;
    self.geoDec = nil;
    
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

    [leftPanel release];
    [sortingLbl release];
    self.mapView.delegate = nil;
    self.mapView = nil;
    self.tableView.delegate = nil;
    self.tableView = nil;
    self.searchBar.delegate = nil;
	self.searchBar = nil;
	self.mapTypeSegCtrl = nil;
    self.searchSegCtrl = nil;
	self.footerView = nil;
    
    self.categoria = nil; 
    self.geoDec.delegate = nil;
    self.geoDec = nil;
    
    self.urlString = nil;
    self.dataModel = nil;
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tView {
	if ([self.dataModel count] == 0) {
		return 1;
	} 
    else {
		return 2;
	}
}


- (NSInteger)tableView:(UITableView *)tView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return [self.dataModel count];
		case 1:
			return 1;
		default:
			return 0;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
        // Stiamo mostrando la cella che suggerisce la visualizzazione di ulteriori esercenti
		UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"ShowMoreCell"];
		
		if (cell == nil){
			cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowMoreCell" owner:self options:NULL] objectAtIndex:0];
            ((ShowMoreCell *)cell).doneMessage = @"Non ci sono altri elementi da mostrare";
        }
        if (didFetchAllRows) {
            ((ShowMoreCell *)cell).state = ShowMoreCellDone;
        }
        else if (queryingMoreRows) {
            ((ShowMoreCell *)cell).state = ShowMoreCellAnimating;
        }
        else {
            ((ShowMoreCell *)cell).state = ShowMoreCellBlank;
        }
		return cell;		
	} 
    else {
        // Stiamo mostrando la cella relativa ad un esercente
		UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"CategoriaCommercialeCell"];
		
		if (cell == nil){
			cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoriaCommercialeCell" owner:self options:NULL] objectAtIndex:0];
		}
		
		NSDictionary *r  = [self.dataModel objectAtIndex:indexPath.row];
		
        CachedAsyncImageView *caImageView = (CachedAsyncImageView *)[cell viewWithTag:5];
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.cartaperdue.it/partner/v2.0/ImmagineEsercente.php?id=%d", [[r objectForKey:@"IDesercente"] intValue]]];
        [caImageView loadImageFromURL:imageUrl];
        
		UILabel *insegnaEsercente   = (UILabel *)[cell viewWithTag:1];
        UILabel *indirizzo          = (UILabel *)[cell viewWithTag:2];
        UILabel *citta              = (UILabel *)[cell viewWithTag:3];
        UILabel *distanza           = (UILabel *)[cell viewWithTag:4];

		insegnaEsercente.text  = [r objectForKey:@"Insegna_Esercente"];
		indirizzo.text         = [[r objectForKey:@"Indirizzo_Esercente"] capitalizedString];
        citta.text             = [[r objectForKey:@"Citta_Esercente"] capitalizedString];
		distanza.text          = [NSString stringWithFormat:@"a %.1f km",
                                  [[r objectForKey:@"Distanza"] doubleValue]];	
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	}
}


#pragma mark - UITableViewDelegate

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

- (UIView *)tableView:(UITableView *)tView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}


- (CGFloat)tableView:(UITableView *)tView heightForFooterInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 0;	
		case 1:
			return self.footerView.frame.size.height;
		default:
			return 0;
	}
}


- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		NSDictionary* r = [self.dataModel objectAtIndex: indexPath.row];
		NSInteger i = [[r objectForKey:@"IDesercente"] integerValue];
		NSLog(@"L'id dell'esercente da visualizzare è %d",i );
		DettaglioEsercente *detail = [[DettaglioEsercente alloc] initWithNibName:nil bundle:nil couponMode:NO genericoMode:NO];
		detail.idEsercente = i;
        
       //UITableViewCell *cell = [tView cellForRowAtIndexPath:indexPath];
        //NSLog(@"immagine salvata = %@",(CachedAsyncImageView*)[cell viewWithTag:5]);
        //detail.imgString = [r objectForKey:@"IDesercente"];
		detail.title = @"Esercente";
        //Facciamo visualizzare la vista con i dettagli
//        if (inSearchUI)
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
		[self.navigationController pushViewController:detail animated:YES];
        [detail release];
	}
	else { 
		if (!didFetchAllRows) {
            [self fetchMoreRows];
            [self reloadShowMoreCell];
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    for(id subview in [self.searchBar subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
    
	//self.searchBar.text = @"";
	self.navigationItem.rightBarButtonItem.enabled = TRUE;
}

#pragma mark - View button actions



# pragma mark - GeoDecoderDelegate


- (void)didReceivedGeoDecoderData:(NSDictionary *) geoData {
    NSLog(@"DICTIONARY IS: %@", geoData);
    NSArray *resultsArray = [geoData objectForKey:@"results"];
    NSDictionary *result = [resultsArray objectAtIndex:0];
    //NSString *addressString = [ result objectForKey:@"formatted_address"];
    location.latitude = [[[[result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
    location.longitude = [[[[result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
    NSLog(@"LAT = %f LONG = %f", location.latitude,location.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.15,0.15);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    [self.mapView setRegion:region animated:YES];
}


- (void)didReceiveErrorGeoDecoder:(NSError *)error{
    NSLog(@"errore geodecoder = %@",[error description]);
}


#pragma mark - WMHTTPAccessDelegate


- (void)didReceiveJSON:(NSDictionary *)dataDict {
    NSString *type = [[dataDict allKeys] objectAtIndex:0];
    NSMutableArray *rows = [NSMutableArray arrayWithArray:[dataDict objectForKey:type]];
    
    //NSLog(@"RISULTATO = %@",dataDict);
    
    // Ci aspettiamo che rows sia effettivamente un array, se non lo è
    // si ignora.
    if (![rows isKindOfClass:[NSArray class]]) return;
    
    [rows removeLastObject];
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
    
    else if ([type isEqualToString:@"Esercente:Search"]) {
        [self.searchActivityIndicator stopAnimating];
        //self.searchActivityIndicator.hidden = YES;
        [self.dataModel removeAllObjects];
        [self.dataModel addObjectsFromArray:rows];
        [self.tableView reloadData];
    } 
}

-(void)didReceiveError:(NSError *)error{
    
    UIAlertView *alert = [[ UIAlertView alloc] initWithTitle:@"Errore di connessione" message:@"Errore di connessione, riprovare" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
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


- (void)fetchRows{
    lastFetchWasASearch = NO;
    didFetchAllRows = NO;
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithCapacity:8];
    [postDict setObject:@"fetch"                forKey:@"request"];
    [postDict setObject:self.categoria          forKey:@"categ"];
    [postDict setObject:[UserDefaults city]     forKey:@"prov"];
    [postDict setObject:[UserDefaults weekDay]  forKey:@"giorno"];
    [postDict setObject:[self searchMethod]     forKey:@"ordina"];
    [postDict setObject:[self filterMethod]     forKey:@"filtro"];
    [postDict setObject:@"0"                    forKey:@"from"];
    [postDict setObject:[NSString stringWithFormat:@"%f", location.latitude]  forKey:@"lat"];
    [postDict setObject:[NSString stringWithFormat:@"%f", location.longitude] forKey:@"long"];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:self.urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:self];
}


- (void)fetchMoreRows {
    if (lastFetchWasASearch) {
        return;
    }
    queryingMoreRows = YES;
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithCapacity:8];
    [postDict setObject:@"fetch"                forKey:@"request"];
    [postDict setObject:self.categoria          forKey:@"categ"];
    [postDict setObject:[UserDefaults city]     forKey:@"prov"];
    [postDict setObject:[UserDefaults weekDay]  forKey:@"giorno"];
    [postDict setObject:[self searchMethod]     forKey:@"ordina"];
    [postDict setObject:[self filterMethod]     forKey:@"filtro"];
    [postDict setObject:[NSString stringWithFormat:@"%d", self.dataModel.count] forKey:@"from"];
    [postDict setObject:[NSString stringWithFormat:@"%f", location.latitude]    forKey:@"lat"];
    [postDict setObject:[NSString stringWithFormat:@"%f", location.longitude]   forKey:@"long"];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:self.urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:self];
}


- (void) fetchRowsBySearchKey:(NSString *)searchKey {
    lastFetchWasASearch = YES;
    // inserisco un carattere speciale per gli spazi, nel file php verrà risostituito dallo spazio
    searchKey = [searchKey stringByReplacingOccurrencesOfString:@" " withString:@"-"]; 
    
    //self.searchActivityIndicator.hidden = NO;
    [self.searchActivityIndicator startAnimating];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithCapacity:8];
    [postDict setObject:@"search"       forKey:@"request"];
    [postDict setObject:self.categoria  forKey:@"categ"];
    [postDict setObject:searchKey       forKey:@"chiave"];
    [postDict setObject:@"distanza"     forKey:@"ordina"];
    [postDict setObject:@"0" forKey:@"from"];
    [postDict setObject:[NSString stringWithFormat:@"%f", location.latitude]    forKey:@"lat"];
    [postDict setObject:[NSString stringWithFormat:@"%f", location.longitude]   forKey:@"long"];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:self.urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:self];

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
	
	NSLog(@"Ci sono  %d esercenti da inserire in mappa", [self.dataModel count]);
	for (NSDictionary *r in self.dataModel) {
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

- (NSString *)filterMethod{
    
    return @"";
}

- (NSString *)searchMethod {
    NSInteger selection = [self.searchSegCtrl selectedSegmentIndex];
    
    //TODO: cambiare colore del pulsante selezionato
//    UIBarButtonItem *selectedItem = [self.searchSegCtrl.subviews objectAtIndex:selection];
//    [selectedItem setTintColor:[UIColor blackColor]];
//    NSLog(@"OGGETTI = %@, SELEZIOMATO = %@",self.searchSegCtrl.subviews,selectedItem);
    
    if (selection == 0) {
        sortingLbl.text = @"Km";
        return @"distanza";
    } else if (selection == 1) {
        sortingLbl.text = @"A-Z";
        return @"nome";
    } else {
        sortingLbl.text = @"";
        return @"";
    }
    
}


- (void)reloadShowMoreCell {
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], nil];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [indexPaths release];
}

- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened{
    NSLog(@"STATO DEL SIDE PANEL = %@", opened?@"aperto":@"chiuso");
}


@end

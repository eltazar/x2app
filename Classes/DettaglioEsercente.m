//
//  DettaglioEsercente.m
//  Per Due
//
//  Created by Gabriele "Whisky" Visconti on 04/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DettaglioEsercente.h"
#import "PerDueCItyCardAppDelegate.h"
#import "CJSONDeserializer.h"
#import "EsercenteMapAnnotation.h"
#import "Utilita.h"


@interface DettaglioEsercente () {}
@property (nonatomic, retain) IndexPathMapper *idxMap;
@property (nonatomic, retain) NSDictionary *dataModel;
- (void)removeNullItemsFromModel;
- (void)populateIndexPathMap; 
@end


@implementation DettaglioEsercente


// Properties:
@synthesize idEsercente=_idEsercente;

// IBOutlets:
@synthesize tableview=_tableview, activityIndicator=_activityIndicator, mapViewController=_mapViewController, mkMapView=_mkMapView, mapTypeSegCtrl=_mapTypeSegCtrl,condizioniViewController=_condizioniViewController, condizioniTextView=_condizioniTextView,  sitoViewController=_sitoViewController, sitoWebView=_sitoWebView;

//Properties private:
@synthesize idxMap=_idxMap, dataModel=_dataModel;


- (id)init {
    self = [super init];
    if (self) {
        isGenerico = FALSE;
        isCoupon = FALSE;
        isDataModelReady = FALSE;
        urlString = @"http://www.cartaperdue.it/partner/v2.0/DettaglioEsercente.php?id=%d";
        urlStringCoupon = @"http://www.cartaperdue.it/partner/DettaglioEsercente.php?id=%d";
        urlStringGenerico = @"http://www.cartaperdue.it/partner/DettaglioEsercenteGenerico.php?id=%d";
        urlStringValiditaCarta = @"http://www.cartaperdue.it/partner/Validita.php?idcontratto=%d";
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isGenerico = FALSE;
        isCoupon = FALSE;
        isDataModelReady = FALSE;
        urlString = @"http://www.cartaperdue.it/partner/v2.0/DettaglioEsercente.php?id=%d";
        urlStringCoupon = @"http://www.cartaperdue.it/partner/DettaglioEsercente.php?id=%d";
        urlStringGenerico = @"http://www.cartaperdue.it/partner/DettaglioEsercenteGenerico.php?id=%d";
        urlStringValiditaCarta = @"http://www.cartaperdue.it/partner/Validita.php?idcontratto=%d";
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil couponMode:(BOOL)couponMode genericoMode:(BOOL)genericoMode {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isGenerico = genericoMode;
        isCoupon = couponMode;
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
        
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
        }
        if(result.height == 568)
        {
            // iPhone 5
            [self.mkMapView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.mkMapView.frame.size.width,568)];
        }
    }
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow] animated:YES];
    
    if(! [Utilita networkReachable]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
		[alert show];
        [alert release];
	}
    else if (!isDataModelReady) {
        // Quando sto per visualizzare la view eseguo il fetch dei dettagli,
        // ma solo se non è stato già fatto. Es: apro la view -> torno alla
        // springboard -> torno all'app PerDue senza riscaricare i dati.
        [self.activityIndicator startAnimating];
        NSString *completedUrlString;
        if (isGenerico) {
            completedUrlString = [NSString stringWithFormat:urlStringGenerico, self.idEsercente];
        }
        else if (isCoupon) {
            completedUrlString = [NSString stringWithFormat:urlStringCoupon, self.idEsercente];
        }
        else {
            completedUrlString = [NSString stringWithFormat:urlString, self.idEsercente];
        }
        [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:completedUrlString method:WMHTTPAccessConnectionMethodGET parameters:nil delegate:self];
    }
}


- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // IBOutlets:
    self.sitoWebView.delegate = nil;
    self.sitoWebView = nil;
    self.tableview.delegate = nil;
    self.tableview.dataSource = nil;
    self.tableview = nil;
    self.activityIndicator = nil;
    self.mapViewController = nil;
    self.condizioniViewController = nil;
    self.condizioniTextView = nil;
    self.mapTypeSegCtrl = nil;
    self.mkMapView.delegate = nil;
    //UITableViewCell *_cellavalidita;
    self.sitoViewController = nil;
    
    self.idxMap = nil;
    
    // Questi verranno ricaricati nel viewWillAppear dopo il reload della view.
    self.dataModel = nil;
    isDataModelReady = NO;
    [super viewDidUnload];
}


- (void)dealloc {
    // IBOutlets:
    self.sitoWebView.delegate = nil;
    self.sitoWebView = nil;
    self.tableview.delegate = nil;
    self.tableview.dataSource = nil;
    self.tableview = nil;
    self.activityIndicator = nil;
    self.mapViewController = nil;
    self.condizioniViewController = nil;
    self.condizioniTextView = nil;
    self.mapTypeSegCtrl = nil;
    self.mkMapView.delegate = nil;
    self.sitoViewController = nil;
    
    //@private
    self.idxMap = nil;
    self.dataModel = nil;
    
    //@protected
    [urlString release];
    [urlStringCoupon release];
    [urlStringGenerico release];
    [urlStringValiditaCarta release];
    
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - WMHTTPAccessDelegate


- (void) didReceiveJSON:(NSDictionary *)jsonDict {
    if (![jsonDict isKindOfClass:[NSDictionary class]])
        return;
    // Il pacchetto json relativo all'esercente ha formato:
    // {Esercente=({....});}
    NSObject *temp = [jsonDict objectForKey:@"Esercente"];
    if (temp && [temp isKindOfClass:[NSArray class]]) {
        self.dataModel = [((NSArray *)temp) objectAtIndex:0];
        isDataModelReady = YES;
        if (!isCoupon && !isGenerico && urlStringValiditaCarta) {
            // lancio query per la validità:
            NSString *completedUrlString = [NSString stringWithFormat:urlStringValiditaCarta, [[self.dataModel objectForKey:@"IDcontratto_Contresercente"]intValue]];
            [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:completedUrlString method:WMHTTPAccessConnectionMethodGET parameters:nil delegate:self];
        }
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        [self populateIndexPathMap];
        [self removeNullItemsFromModel];
        [self.tableview reloadData];
    }
    
    temp = [jsonDict objectForKey:@"Giorni"];
    if (temp) {
        self.dataModel = [[[NSMutableDictionary alloc] initWithDictionary:self.dataModel] autorelease];
        [self.tableview beginUpdates];
        [((NSMutableDictionary *)self.dataModel) setObject:temp forKey:@"GiorniValidita"];
        NSArray *idxPaths = [NSArray arrayWithObject:[self.idxMap indexPathForKey:@"GiornoValidita"]];
        [self.tableview reloadRowsAtIndexPaths:idxPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableview endUpdates];
    }
}


- (void)didReceiveError:(NSError *)error {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
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
    NSString *key = [self.idxMap keyForIndexPath:indexPath];
    Class null = [NSNull class];
    UITableViewCell *cell = nil;
	
	
    if ([key isEqualToString:@"Indirizzo"]) {
        // Nel metodo removeNullItemsFromModel non è fatto alcun test di nullità sui
        // campi acceduti in questo blocco, quindi il test è fatto qui.
        cell = [tableView dequeueReusableCellWithIdentifier:@"DettEsercAddressCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DettEsercAddressCell" owner:self options:NULL] objectAtIndex:0];
        }
        UILabel *indirizzoLbl   = (UILabel *)[cell viewWithTag:1];
		UILabel *zonaLbl        = (UILabel *)[cell viewWithTag:2];
		// Test nullità e costruzione stringa indirizzo
        NSString *indirizzo = @"";
        NSString *citta = @"";
        NSInteger nCampiNonNulli = 0;
        if (![[self.dataModel objectForKey:@"Indirizzo_Esercente"] isKindOfClass:null]) {
            indirizzo = [self.dataModel objectForKey:@"Indirizzo_Esercente"];
            nCampiNonNulli++;
        }
        if (![[self.dataModel objectForKey:@"Citta_Esercente"] isKindOfClass:null]) {
            citta = [self.dataModel objectForKey:@"Citta_Esercente"];
            nCampiNonNulli++;
        }
        NSString *indirizzoCompleto;
        indirizzoCompleto = [NSString stringWithFormat:@"%@%@%@",
                             indirizzo, 
                             (nCampiNonNulli>1)  ? @", " : @"", 
                             citta];	
        indirizzoLbl.text = (nCampiNonNulli > 0) ? [indirizzoCompleto capitalizedString] : @"Indirizzo non disponibile";
        // Test nullità e costruzione stringa indirizzo
        if ([[self.dataModel objectForKey:@"Zona_Esercente"] isKindOfClass:null]) {
            zonaLbl.text = @"";
		}
        else {
            zonaLbl.text = [NSString stringWithFormat:@"Zona: %@",
                         [self.dataModel objectForKey:@"Zona_Esercente"]];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    else if ([key isEqualToString:@"GiornoChiusura"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DettEsercCellWithTitle"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DettEsercCellWithTitle" owner:self options:NULL] objectAtIndex:0];
        }
        UILabel *giorno = (UILabel *)[cell viewWithTag:1];
        UILabel *etich = (UILabel *)[cell viewWithTag:2];
        etich.text = @"Chiusura settimanale";
        giorno.text = [self.dataModel objectForKey:@"Giorno_chiusura_Esercente"];
        giorno.text = [giorno.text capitalizedString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    else if ([key isEqualToString:@"GiornoValidita"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DettEsercGiorniValiditaCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DettEsercGiorniValiditaCell" owner:self options:NULL] objectAtIndex:0];
        }
        UILabel *etich = (UILabel *)[cell viewWithTag:1];
        UILabel *validita = (UILabel *)[cell viewWithTag:2];
        etich.text = @"Giorni di validita della Carta PerDue";
        
        // Questo oggetto del data model viene caricato a posteriori, attraverso una query
        // specifica (fatta in didReceiveJSON del WMHTTPAccessDelegate.
        // Se la query non è ancora stata fatta, la chiave non è settata, e objectForKey
        // ritorna nil. Se la query è stata fatta invece la chiave è settata. Il suo oggetto
        // non sarà mai un <null> come per gli altri campi, bensì un array vuoto.
        
        NSArray *righe = [self.dataModel objectForKey:@"GiorniValidita"];
        
        if (!righe) {
            validita.text = @"Caricamento in corso...";
        }
        else if ([righe count] == 0){ 
            //condizioni assenti
            validita.text = @"Non disponibile";
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
    
    else if ([key isEqualToString:@"Esercente_Virtuale"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DettEsercCartaVirtualeCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DettEsercCartaVirtualeCell" owner:self options:NULL] objectAtIndex:0];
        }
        UILabel *etic = (UILabel *)[cell viewWithTag:2];
        if ([[self.dataModel objectForKey:@"Esercente_Virtuale"] isEqualToString:@"1"]) {
            etic.text = @"Sì";
        }
        else {
            etic.text = @"No";
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"%@", [[self.dataModel objectForKey:@"Esercente_Virtuale"] class]);
    }
    
    else if ([key isEqualToString:@"Telefono"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DettEsercCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DettEsercCell" owner:self options:NULL] objectAtIndex:0];
        }
        UILabel *telefono = (UILabel *)[cell viewWithTag:1];
        UILabel *etic = (UILabel *)[cell viewWithTag:2];
        etic.text = @"";
        telefono.text = [self.dataModel objectForKey:@"Telefono_Esercente"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    else if ([key isEqualToString:@"Email"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DettEsercCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DettEsercCell" owner:self options:NULL] objectAtIndex:0];
        }
        UILabel *email = (UILabel *)[cell viewWithTag:1];
        UILabel *etic = (UILabel *)[cell viewWithTag:2];
        etic.text = @"";
        email.text = [self.dataModel objectForKey:@"Email_Esercente"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    else if ([key isEqualToString:@"URL"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DettEsercCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DettEsercCell" owner:self options:NULL] objectAtIndex:0];
        }
        UILabel *sitoweb = (UILabel *)[cell viewWithTag:1];
        UILabel *etic = (UILabel *)[cell viewWithTag:2];
        etic.text=@"";
        sitoweb.text = [self.dataModel objectForKey:@"Url_Esercente"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    else {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"bogus"] autorelease];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 47)] autorelease];
    [customView setBackgroundColor: [UIColor clearColor]];
    
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.shadowColor = [UIColor blackColor];
    lbl.shadowOffset = CGSizeMake(0, 1);
    lbl.lineBreakMode = UILineBreakModeWordWrap;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont boldSystemFontOfSize:17];
    lbl.text = [self.idxMap titleForSection:section];
	    
    UIFont *txtFont = [UIFont boldSystemFontOfSize:17];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    NSInteger lblPadding = 20;
    lbl.frame = CGRectMake(lblPadding, lblPadding-10, tableView.bounds.size.width-2*lblPadding, labelSize.height);
    
    [customView addSubview:lbl];
    
    return customView;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	NSString *lblText = [self.idxMap titleForSection:section];
    UIFont *txtFont = [UIFont boldSystemFontOfSize:17];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lblText sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return labelSize.height+10+5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *key = [self.idxMap keyForIndexPath:indexPath];
    
    if ([key isEqualToString:@"Indirizzo"]) {
        // vedi il commento in cellForRow per il discorso dei check di nullità 
        // eseguiti qui 
		self.mapViewController.navigationItem.titleView = self.mapTypeSegCtrl;
        //TODO: capire se ste righe relative a map.showUserLocation devono
        //andare qui...
		self.mkMapView.showsUserLocation = YES;
		[self.navigationController pushViewController:self.mapViewController animated:YES];
		
        
        NSString *via = @"";
        NSString *citta = @"";
        NSInteger nCampiNonNulli = 0;
        if (![[self.dataModel objectForKey:@"Indirizzo_Esercente"] isKindOfClass:[NSNull class]]) {
            via = [self.dataModel objectForKey:@"Indirizzo_Esercente"];
            nCampiNonNulli++;
        }
        if (![[self.dataModel objectForKey:@"Citta_Esercente"] isKindOfClass:[NSNull class]]) {
            citta = [self.dataModel objectForKey:@"Citta_Esercente"];
            nCampiNonNulli++;
        }
        NSString *address = [[NSString stringWithFormat:@"%@%@%@",
                             via, 
                             (nCampiNonNulli>1)  ? @", " : @"", 
                             citta] capitalizedString];	
        
		CLLocationDegrees latitude  = [[self.dataModel objectForKey:@"Latitudine"]  doubleValue];
		CLLocationDegrees longitude = [[self.dataModel objectForKey:@"Longitudine"] doubleValue];
		NSString *nome = [self.dataModel objectForKey:@"Insegna_Esercente"];
        
        EsercenteMapAnnotation *ann = [[[EsercenteMapAnnotation alloc] initWithLatitudine:latitude longitudine:longitude insegna:nome indirizzo:address idEsercente:0] autorelease];
		[self.mkMapView addAnnotation:ann];
	}	
	
	if ([key isEqualToString:@"GiornoValidita"] ) {
		self.condizioniViewController.title = [self.dataModel objectForKey:@"Insegna_Esercente"];
		self.condizioniTextView.text = [self.dataModel objectForKey:@"Note_Varie_CE"];
        [self.navigationController pushViewController:self.condizioniViewController animated:YES];
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
        NSString *urlEsercString = [NSString stringWithFormat:@"http://%@",
                              [self.dataModel objectForKey:@"Url_Esercente"]];
        NSURL *url = [NSURL URLWithString:urlEsercString];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.sitoWebView loadRequest:requestObj];		
        self.sitoViewController.title = [self.dataModel objectForKey:@"Insegna_Esercente"];
        [self.navigationController pushViewController:self.sitoViewController animated:YES];
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[self.dataModel objectForKey:@"Telefono_Esercente"]]];
		[[UIApplication sharedApplication] openURL:url];
	} 
    else {
        [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow] animated:YES];
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
	if ([self.mapTypeSegCtrl selectedSegmentIndex]==0) {
		self.mkMapView.mapType=MKMapTypeStandard;
	} else if ([self.mapTypeSegCtrl selectedSegmentIndex]==1) {
		self.mkMapView.mapType=MKMapTypeSatellite;
	} else if ([self.mapTypeSegCtrl selectedSegmentIndex]==2) {
		self.mkMapView.mapType=MKMapTypeHybrid;
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


- (void)populateIndexPathMap {
    NSString *insegnaEsercente = [self.dataModel objectForKey:@"Insegna_Esercente"];
    [self.idxMap setKey:@"Indirizzo"          forSection:0 row:0];
    [self.idxMap setKey:@"GiornoChiusura"     forSection:0 row:1];
    [self.idxMap setKey:@"GiornoValidita"     forSection:0 row:2];
    [self.idxMap setKey:@"Esercente_Virtuale" forSection:0 row:3];
    [self.idxMap setTitle:insegnaEsercente    forSection:0];
    [self.idxMap setKey:@"Telefono"           forSection:1 row:0];
    [self.idxMap setKey:@"Email"              forSection:1 row:2];
    [self.idxMap setKey:@"URL"                forSection:1 row:3];
    [self.idxMap setTitle:@"Contatti"         forSection:1];
    
    if (isCoupon || isGenerico) {
        [self.idxMap removeKey:@"GiornoValidita"]; 
        [self.idxMap removeKey:@"Esercente_Virtuale"];
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

static NSString *kTitleKey = @"title";
static NSString *kElementsKey = @"elements";

- (id)init {
    self = [super init];
    if (self) {
        map = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)setTitle:(NSString *)title forSection:(NSInteger)section {
    if (section >= map.count) {
        return;
    }
    [[map objectAtIndex:section] setObject:title forKey:kTitleKey];
}


- (NSString *)titleForSection:(NSInteger)section {
    if (section >= map.count) {
        return @"";
    }
    return [[map objectAtIndex:section] objectForKey:kTitleKey];
}


- (void)setKey:(NSString *)key forSection:(NSInteger)section row:(NSInteger)row {    
    NSMutableDictionary *sectionDict;
    if (section >= map.count) {
        sectionDict = [NSMutableDictionary dictionary];
        [sectionDict setObject:@"" forKey:kTitleKey];
        [sectionDict setObject:[NSMutableArray array] forKey:kElementsKey];
        [map addObject:sectionDict];
    }
    else {
        sectionDict = [map objectAtIndex:section];
    }
    
    NSMutableArray *elementsArray = [sectionDict objectForKey:kElementsKey];
    if (row >= elementsArray.count) {
        [elementsArray addObject:key];
    }
    else {
        [elementsArray insertObject:key atIndex:row];
    }
}


- (NSString *)keyForSection:(NSInteger)section row:(NSInteger)row {
    if (section >= map.count) {
        return nil;
    }
    else {
        NSArray *elementsArray = [[map objectAtIndex:section] objectForKey:kElementsKey];
        if (row >= elementsArray.count) {
            return nil;
        }
        else {
            return [elementsArray objectAtIndex:row];
        }
    }
}


- (void)removeKeyAtSection:(NSInteger)section row:(NSInteger)row {
    NSMutableArray *elementsArray;
    if (section >= map.count) {
        return;
    }
    else {
        elementsArray = [[map objectAtIndex:section] objectForKey:kElementsKey];
    }
    
    if (row >= elementsArray.count) {
        return;
    }
    else {
        [elementsArray removeObjectAtIndex:row];
        if (elementsArray.count == 0) {
            [map removeObjectAtIndex:section];
        }
    }

}


- (void)removeKey:(NSString *)key {
    for (NSMutableDictionary *sectionDict in map) {
        NSMutableArray *elementsArray = [sectionDict objectForKey:kElementsKey];
        [elementsArray removeObject:key];
        if (elementsArray.count == 0) {
            [map removeObject:sectionDict];
        }
    }
}


- (NSInteger)sections {
    return [map count];
}


- (NSInteger)rowsInSection:(NSInteger)section {
    if (section >= map.count) {
        return 0;
    }
    return [[[map objectAtIndex:section] objectForKey:kElementsKey] count];
    
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
        NSArray *elementsArray = [[map objectAtIndex:i] objectForKey:kElementsKey]; 
        j = [elementsArray indexOfObject:key];
        if (j != NSNotFound) {
            return [NSIndexPath indexPathForRow:j inSection:i]; 
        }
    }
    return nil;
}

- (void)dealloc {
    [map release];
    [super dealloc];
}
@end


//
//  DettaglioEsercenti.m
//  Per Due
//
//  Created by Giuseppe Lisanti on 30/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DettaglioEsercenti.h"
#import "PerDueCItyCardAppDelegate.h"
#import "CJSONDeserializer.h"
#import "GoogleHQAnnotation.h"
#import "Utilita.h"
#import "DatabaseAccess.h"


@interface DettaglioEsercenti () {
@private
    DatabaseAccess *_dbAccess;
    BOOL isDataReady;
    BOOL isValiditaReady;
}
@property (nonatomic, retain) DatabaseAccess *dbAccess;
@end


@implementation DettaglioEsercenti

// Properties
@synthesize identificativo = _identificativo, dataModel = _dataModel, webView = _webView;

// IBOutlets
@synthesize tableView = _tableView, mappa = _mappa, condizioni = _condizioni, cond = _cond, tipoMappa = _tipoMappa, map = _map, cellavalidita = _cellavalidita, sito = _sito, activityIndicator = _activityIndicator;

// Properties private:
@synthesize dbAccess = _dbAccess;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark - View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
    self.dbAccess = [[DatabaseAccess alloc] init];
    self.dbAccess.delegate = self;
    isDataReady = NO;
    isValiditaReady = NO;
   
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]  animated:YES];
    if(! [Utilita networkReachable]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];
	} else {
        [self.activityIndicator startAnimating];
        NSString *detailUrlString = [NSString stringWithFormat: @"http://www.cartaperdue.it/partner/DettaglioEsercente.php?id=%d",self.identificativo];
        [self.dbAccess getConnectionToURL:detailUrlString];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.mappa = nil;
    self.condizioni = nil;
    self.cond = nil;
    self.tipoMappa = nil;
    self.map.delegate = nil;
    self.map = nil;
    self.cellavalidita = nil;
    self.sito = nil;
    [super viewDidUnload];
}


- (void)dealloc {
#warning inserire il release degli iboutlet ecc?
    self.map.delegate = nil;
    self.map = nil;
    self.dataModel = nil;
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isDataReady)
        return 2;
    else
        return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int righesecondasezione=3;
	switch (section) {
	case 0:
		if ( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Giorno_chiusura_Esercente"]] isEqualToString:@"<null>"] ){
			return 2;
			break;
		}
		else{
			return 3;
			break;
		}
	case 1:
		if( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] ){
			righesecondasezione--;
		}
		if( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] ){
			righesecondasezione--;
		}
		if( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"] ){
			righesecondasezione--;
		}
		return righesecondasezione;
		break;
		
	default:
		return 0;
		break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if( (cell == nil) && (indexPath.section==0) && (indexPath.row==0) ) {
		//cell = [[[NSBundle mainBundle] loadNibNamed:@"cellaindirizzo" owner:self options:NULL] objectAtIndex:0];
        [[NSBundle mainBundle] loadNibNamed:@"cellaindirizzo" owner:self options:NULL];
        cell = cellaindirizzo;
        
	}
	else {
		if(  ((cell == nil) && (indexPath.section==0) && (indexPath.row==1) && ([tView numberOfRowsInSection:0]==3) ) ) {
			//cell = [[[NSBundle mainBundle] loadNibNamed:@"CellaDettaglio1" owner:self options:NULL] objectAtIndex:0];
            [[NSBundle mainBundle] loadNibNamed:@"CellaDettaglio1" owner:self options:NULL] ;
            cell = CellaDettaglio1;
		}
		else {
			if( ((cell == nil) && (indexPath.section==0) && (indexPath.row==2))  ||  ((cell == nil) && (indexPath.section==0) && (indexPath.row==1) && ([tView numberOfRowsInSection:0]==2))  ) {
				[[NSBundle mainBundle] loadNibNamed:@"CellaValidita2" owner:self options:NULL];
				cell=self.cellavalidita;
			}
			else {	
				
				if( (cell == nil) && (indexPath.section==1) ){
					//cell = [[[NSBundle mainBundle] loadNibNamed:@"provacella" owner:self options:NULL] objectAtIndex:0];
                    [[NSBundle mainBundle] loadNibNamed:@"provacella" owner:self options:NULL] ;
                    cell = provacella;
				}
			
			}
		}   
	}		   	 
	
	// Configure the cell.
	if ( (indexPath.row == 0)&&(indexPath.section==0) ){
		UILabel *indirizzo = (UILabel *)[cell viewWithTag:1];
		UILabel *zona = (UILabel *)[cell viewWithTag:2];
		
		if( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Zona_Esercente"]] isEqualToString:@"<null>"] ){ //zona null
			indirizzo.text = [NSString stringWithFormat:@"%@, %@",[self.dataModel objectForKey:@"Indirizzo_Esercente"],[self.dataModel objectForKey:@"Citta_Esercente"]];	
			indirizzo.text= [indirizzo.text capitalizedString];
			zona.text = [NSString stringWithFormat:@""];	
			
		}
		else { //stampo anche la zona
			indirizzo.text = [NSString stringWithFormat:@"%@, %@",[self.dataModel objectForKey:@"Indirizzo_Esercente"],[self.dataModel objectForKey:@"Citta_Esercente"]];
			indirizzo.text= [indirizzo.text capitalizedString];
			zona.text = [NSString stringWithFormat:@"Zona: %@",[self.dataModel objectForKey:@"Zona_Esercente"]];	
			
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}	
	
	if ( (indexPath.row == 1)&&(indexPath.section==0) ){
		if ( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Giorno_chiusura_Esercente"]] isEqualToString:@"<null>"] ) { // chiusura non dispoibile, inserisco condizioni
			UILabel *etich = (UILabel *)[cell viewWithTag:1];
			UILabel *validita = (UILabel *)[cell viewWithTag:2];
			etich.text=@"Giorni di validita della Carta PerDue";
			
			NSArray *righe = nil;
			NSDictionary *diz;
			
			if (isValiditaReady) {
                righe = [self.dataModel objectForKey:@"GiorniValidita"];
            } else {
                righe = [[[NSArray alloc] initWithObjects:
                          [[NSDictionary alloc] initWithObjectsAndKeys:@"Caricamento in corso...", @"giorno_della_settimana", nil], nil
                          ] autorelease];
            }
            
            
			if ([righe count]==0){ //condizioni assenti
				validita.text=@"Non disponibile";

			}
			else { //costruisco la strinaga condizioni
				
				NSLog(@"La tessera vale per %d giorni settimanali", [righe count]);
				NSString *giorni=[NSString stringWithFormat:@""];
				for (int i=0;i<[righe count];i++) {
					diz = [righe objectAtIndex: i];
					giorni=[NSString stringWithFormat:@"%@%@ ", giorni,[diz objectForKey:@"giorno_della_settimana"]];
					
				}
				validita.text=[NSString stringWithFormat:@"%@", giorni];				

				if ( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Note_Varie_CE"]] isEqualToString:@"<null>"] ){ //non ci sono condizioni
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
				}
				else {
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				}
			}
		}
		
		else {
			UILabel *giorno = (UILabel *)[cell viewWithTag:1];
			UILabel *etich = (UILabel *)[cell viewWithTag:2];
			etich.text=@"Chiusura settimanale";
			giorno.text=[NSString stringWithFormat:@"%@", [self.dataModel objectForKey:@"Giorno_chiusura_Esercente"]];
			giorno.text= [giorno.text capitalizedString];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
		}
	
	if ( (indexPath.row == 2)&&(indexPath.section==0) ){ // la validità va alla terza riga perchè c'è il giorno di chiusura alla seconda
		UILabel *etich = (UILabel *)[cell viewWithTag:1];
		UILabel *validita = (UILabel *)[cell viewWithTag:2];
		etich.text=@"Giorni di validita della Carta PerDue";
		
		NSArray *righe = nil;
		NSDictionary *diz;
		
		if (isValiditaReady) {
            righe = [self.dataModel objectForKey:@"GiorniValidita"];
        } else {
            righe = [[[NSArray alloc] initWithObjects:
                      [[NSDictionary alloc] initWithObjectsAndKeys:@"Caricamento in corso...", @"giorno_della_settimana", nil], nil
                      ] autorelease];
        }

                
		if ([righe count]==0){ //condizioni non disponibili
			validita.text=[NSString stringWithFormat:@"Non disponibile"];
		}
		else {
			NSLog(@"La tessera vale per %d giorni settimanali", [righe count]);
			NSString *giorni=[NSString stringWithFormat:@""];
			for (int i=0;i<[righe count];i++) {
				diz = [righe objectAtIndex: i];
				giorni=[NSString stringWithFormat:@"%@%@ ", giorni,[diz objectForKey:@"giorno_della_settimana"]];
				
			}
			validita.text=[NSString stringWithFormat:@"%@", giorni];			
			if ( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Note_Varie_CE"]] isEqualToString:@"<null>"] ){ //non ci sono condizioni
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			else {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		}
	}
	
	
	
	if ( (indexPath.row == 0)&&(indexPath.section==1) ){
		
		if(!( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"]) ){
			UILabel *telefono = (UILabel *)[cell viewWithTag:1];
			UILabel *etic = (UILabel *)[cell viewWithTag:2];
			etic.text=@"";
			telefono.text = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Telefono_Esercente"]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else {
			if(!( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"]) ){
				UILabel *email = (UILabel *)[cell viewWithTag:1];
				UILabel *etic = (UILabel *)[cell viewWithTag:2];
				etic.text=@"";
				email.text = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Email_esercente"]];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			else {
				if(!( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"] )){
					UILabel *sitoweb = (UILabel *)[cell viewWithTag:1];
					UILabel *etic = (UILabel *)[cell viewWithTag:2];
					etic.text=@"";
					sitoweb.text = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Url_Esercente"]];
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				}
			}
		}
	}	
	
	
	if ( (indexPath.row == 1)&&(indexPath.section==1) ){
		if( (!( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] ))&& (!( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] )) ){ 
			UILabel *email = (UILabel *)[cell viewWithTag:1];
			UILabel *etic = (UILabel *)[cell viewWithTag:2];
			etic.text=@"";
			email.text = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Email_Esercente"]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else {
			if(!( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"] )){
				UILabel *sitoweb = (UILabel *)[cell viewWithTag:1];
				UILabel *etic = (UILabel *)[cell viewWithTag:2];
				etic.text=@"";
				sitoweb.text = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Url_Esercente"]];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		}
	}
	
	if ( (indexPath.row == 2)&&(indexPath.section==1) ){
		if((! [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"]) ){
			UILabel *sitoweb = (UILabel *)[cell viewWithTag:1];
			UILabel *etic = (UILabel *)[cell viewWithTag:2];
			etic.text=@"";
			sitoweb.text = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Url_Esercente"]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
	}

	   return cell;
}


#pragma mark - UITableViewDelegate


- (UIView *)tableView:(UITableView *)tView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tView.bounds.size.width, 44.0)] autorelease];
    [customView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.lineBreakMode = UILineBreakModeWordWrap;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont boldSystemFontOfSize:18];
    
	
	if (section == 0)
	{
		lbl.text = [self.dataModel objectForKey:@"Insegna_Esercente"];
	}
		
	if (section == 1){
		if( ( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] ) &&( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] )
		   &&( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"])  ){ // non ci sono contatti
			lbl.text = @"";
		}
		else {
			lbl.text = @"Contatti";	
		}
		
	}
    
    UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    lbl.frame = CGRectMake(10, 0, tView.bounds.size.width-20, labelSize.height+6);
    
    [customView addSubview:lbl];
    
    return customView;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	NSString *lblText;
	
	if (section == 0) {
		lblText = [self.dataModel objectForKey:@"Insegna_Esercente"];
	} else if (section == 1){
		if( ( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] ) &&( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] )
		   &&( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"])  ){ // non ci sono contatti
			lblText = @"";
		} else {
			lblText = @"Contatti";	
		}
	} else {
        lblText = @"";
    }
    UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lblText sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height+6;
}


- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( (indexPath.row == 0)&&(indexPath.section==0) ){ //apri mappa
        self.mappa.navigationItem.titleView = self.tipoMappa;
		
		[self.navigationController pushViewController:self.mappa animated:YES];
		
		self.map.delegate = self;
		self.map.showsUserLocation = YES;
		float lati, longi;
		int d;
		lati=[[self.dataModel objectForKey:@"Latitudine"] doubleValue];
		longi=[[self.dataModel objectForKey:@"Longitudine"] floatValue];
		d=[[self.dataModel objectForKey:@"IDesercente"]intValue];
		NSString *nome = [self.dataModel objectForKey:@"Insegna_Esercente"];
		//NSString *address=[NSString alloc];		
		//address=[self.dict objectForKey:@"Indirizzo_Esercente"];
		NSString *address=[[[NSString alloc ]initWithFormat:@"%@, %@",[[self.dataModel objectForKey:@"Indirizzo_Esercente"]capitalizedString],[[self.dataModel objectForKey:@"Citta_Esercente"]capitalizedString]] autorelease];

		int ident=d;
		
		[self.map addAnnotation:[[[GoogleHQAnnotation alloc] init:lati:longi:nome:address:ident] autorelease]];
	}	
	
	if ( ((indexPath.row == 2)&&(indexPath.section==0)) || ((indexPath.row == 1)&&(indexPath.section==0)&& ([tView numberOfRowsInSection:0]==2)) ) { //condizioni
		self.condizioni.title = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Insegna_Esercente"]];
		[self.navigationController pushViewController:self.condizioni animated:YES];
		self.cond.text=[NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Note_Varie_CE"]];
	}
	
	
	if ( (indexPath.row == 0)&&(indexPath.section==1) ){ //telefona o mail o sito
		if(!( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"]) ){ //la cella esprime un num di tel
			PerDueCItyCardAppDelegate *appDelegate = (PerDueCItyCardAppDelegate*)[[UIApplication sharedApplication]delegate];
			UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Vuoi chiamare\n%@?",[self.dataModel objectForKey:@"Insegna_Esercente"]] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Chiama", nil];

			[aSheet showInView:appDelegate.window];
			[aSheet release];						
		}
		else {
			if(!( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"]) ){ //la cella esprime un indirizzo email
				MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
				[[controller navigationBar] setTintColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
				NSArray *to = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Email_Esercente"]]];
				[controller setToRecipients:to];
				controller.mailComposeDelegate = self;
				[controller setMessageBody:@"" isHTML:NO];
				[self presentModalViewController:controller animated:YES];
				[controller release];
			}
			else { //la cella esprime un url
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[self.dataModel objectForKey:@"Url_Esercente"]]];
				NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
				[self.webView loadRequest:requestObj];		
				[self.navigationController pushViewController:self.sito animated:YES];
				self.sito.title = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Insegna_Esercente"]];
				[self.webView release];
				self.webView=nil;

			}
			
		}
		
	}	
	
	if ( (indexPath.row == 1)&&(indexPath.section==1) ){ // mail o sito
		if( (!( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] ))&& (!( [ [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] )) ){ //indirizzo mail
			MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
			[[controller navigationBar] setTintColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
			NSArray *to = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Email_Esercente"]]];
			[controller setToRecipients:to];
			controller.mailComposeDelegate = self;
			[controller setMessageBody:@"" isHTML:NO];
			[self presentModalViewController:controller animated:YES];
			[controller release];
		}
		else { //sito web
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[self.dataModel objectForKey:@"Url_Esercente"]]];
			NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
			[self.webView loadRequest:requestObj];		
			[self.navigationController pushViewController:self.sito animated:YES];
			self.sito.title = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Insegna_Esercente"]];
			[self.webView release];
			self.webView=nil;
		}
	}	
	
	if ( (indexPath.row == 2)&&(indexPath.section==1) ){ // sito web
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[self.dataModel objectForKey:@"Url_Esercente"]]];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[self.webView loadRequest:requestObj];		
		[self.navigationController pushViewController:self.sito animated:YES];
		self.sito.title = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"Insegna_Esercente"]];
		[self.webView release];
		self.webView=nil;
	}
}


#pragma mark - UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[self.dataModel objectForKey:@"Telefono_Esercente"]]];
		[[UIApplication sharedApplication] openURL:url];
	} else {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}


#pragma mark - MFMailComposeViewControllerDelegate


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark MKMapViewDelegate


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


//zoom su posizione utente
- (void)mapView:(MKMapView *)m didAddAnnotationViews:(NSArray *)views {
    for (MKAnnotationView *annotationView in views) {
		if (annotationView.annotation != m.userLocation) {
			MKCoordinateSpan span = MKCoordinateSpanMake(0.01,0.01);
			MKCoordinateRegion region = MKCoordinateRegionMake(annotationView.annotation.coordinate, span);
			[m setRegion:region animated:YES];
		}
	}
}


#pragma mark - DatabaseAccessDelegate


- (void) didReceiveCoupon:(NSDictionary *)data {
    if (![data isKindOfClass:[NSDictionary class]])
        return;
    // Il pacchetto json relativo all'esercente ha formato:
    // {Esercente=({....});}
    NSObject *temp = [data objectForKey:@"Esercente"];
    if (temp) {
        self.dataModel = [((NSArray *)temp) objectAtIndex:0];
        isDataReady = YES;
        // lancio query per la validità:
        NSString *urlString = [NSString stringWithFormat: @"http://www.cartaperdue.it/partner/Validita.php?idcontratto=%d", [[self.dataModel objectForKey:@"IDcontratto_Contresercente"]intValue]];
        [self.dbAccess getConnectionToURL:urlString];
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        [self.tableView reloadData];
    }
    
    temp = [data objectForKey:@"Giorni"];
    if (temp) {
        self.dataModel = [[NSMutableDictionary alloc] initWithDictionary:self.dataModel];
        [((NSMutableDictionary *)self.dataModel) setObject:temp forKey:@"GiorniValidita"];
        isValiditaReady = YES;
        [self.tableView reloadData];
    }
}

#pragma mark - DettaglioEsercenti (IBActions)


- (IBAction)mostraTipoMappa:(id)sender{
	if ([self.tipoMappa selectedSegmentIndex]==0) {
		self.map.mapType=MKMapTypeStandard;
	} else if ([self.tipoMappa selectedSegmentIndex]==1) {
		self.map.mapType=MKMapTypeSatellite;
	} else if ([self.tipoMappa selectedSegmentIndex]==2) {
		self.map.mapType=MKMapTypeHybrid;
	}
}


@end

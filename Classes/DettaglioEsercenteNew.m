//
//  DettaglioEsercente.m
//  Per Due
//
//  Created by Gabriele "Whisky" Visconti on 04/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DettaglioEsercenteNew.h"
#import "PerDueCItyCardAppDelegate.h"
#import "CJSONDeserializer.h"
#import "GoogleHQAnnotation.h"
#import "Utilita.h"


@implementation DettaglioEsercenteNew


// Properties:
@synthesize identificativo=_identificativo, dict=_dict, webView=_webView;

// IBOutlets:
@synthesize activityIndicator=_activityIndicator, mappa=_mappa, condizioni=_condizioni, cond=_cond, tipoMappa=_tipoMappa, map=_map, cellavalidita=_cellavalidita, sito=_sito;


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


#pragma  mark - View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
    
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/DettaglioEsercente.php?id=%d",self.identificativo]];
	//NSLog(@"Url: %@", url);
	
	NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url];
	//NSLog(@"%@",jsonreturn); // Look at the console and you can see what the restults are
	
	NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	
    //In "real" code you should surround this with try and catch
	NSArray *rows = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error] objectForKey:@"Esercente"];
	
	//NSLog(@"Array: %@", rows);
	[jsonreturn release];
	jsonreturn=nil;
	self.dict = [rows objectAtIndex: 0];		
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(void)viewWillAppear:(BOOL)animated {
    
    if(! [Utilita networkReachable]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];
	}
}


- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.activityIndicator = nil;
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
    self.dict = nil;
    [super dealloc];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


# pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int righesecondasezione=3;
	switch (section) {
	case 0:
		if ( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Giorno_chiusura_Esercente"]] isEqualToString:@"<null>"] ){
			return 2;
			break;
		}
		else{
			return 3;
			break;
		}
	case 1:
		if( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] ){
			righesecondasezione--;
		}
		if( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] ){
			righesecondasezione--;
		}
		if( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"] ){
			righesecondasezione--;
		}
		return righesecondasezione;
		break;
		
	default:
		return 0;
		break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if( (cell == nil) && (indexPath.section==0) && (indexPath.row==0) ) {
		//cell = [[[NSBundle mainBundle] loadNibNamed:@"cellaindirizzo" owner:self options:NULL] objectAtIndex:0];
        [[NSBundle mainBundle] loadNibNamed:@"cellaindirizzo" owner:self options:NULL];
        cell = cellaindirizzo;
        
	}
	else {
		if(  ((cell == nil) && (indexPath.section==0) && (indexPath.row==1) && ([tableView numberOfRowsInSection:0]==3) ) ) {
			//cell = [[[NSBundle mainBundle] loadNibNamed:@"CellaDettaglio1" owner:self options:NULL] objectAtIndex:0];
            [[NSBundle mainBundle] loadNibNamed:@"CellaDettaglio1" owner:self options:NULL] ;
            cell = CellaDettaglio1;
		}
		else {
			if( ((cell == nil) && (indexPath.section==0) && (indexPath.row==2))  ||  ((cell == nil) && (indexPath.section==0) && (indexPath.row==1) && ([tableView numberOfRowsInSection:0]==2))  ) {
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
		
		if( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Zona_Esercente"]] isEqualToString:@"<null>"] ){ //zona null
			indirizzo.text = [NSString stringWithFormat:@"%@, %@",[self.dict objectForKey:@"Indirizzo_Esercente"],[self.dict objectForKey:@"Citta_Esercente"]];	
			indirizzo.text= [indirizzo.text capitalizedString];
			zona.text = [NSString stringWithFormat:@""];	
			
		}
		else { //stampo anche la zona
			indirizzo.text = [NSString stringWithFormat:@"%@, %@",[self.dict objectForKey:@"Indirizzo_Esercente"],[self.dict objectForKey:@"Citta_Esercente"]];
			indirizzo.text= [indirizzo.text capitalizedString];
			zona.text = [NSString stringWithFormat:@"Zona: %@",[self.dict objectForKey:@"Zona_Esercente"]];	
			
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}	
	
	if ( (indexPath.row == 1)&&(indexPath.section==0) ){
		if ( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Giorno_chiusura_Esercente"]] isEqualToString:@"<null>"] ) { // chiusura non dispoibile, inserisco condizioni
			UILabel *etich = (UILabel *)[cell viewWithTag:1];
			UILabel *validita = (UILabel *)[cell viewWithTag:2];
			etich.text=@"Giorni di validita della Carta PerDue";
			
			NSArray *righe = nil;
			NSDictionary *diz;
			int idcontr=[[self.dict objectForKey:@"IDcontratto_Contresercente"]intValue];
			NSURL *link = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/Validita.php?idcontratto=%d",idcontr]];
			//NSLog(@"Url: %@", link);
			
			NSString *jsonret = [[[NSString alloc] initWithContentsOfURL:link] autorelease];
           // NSLog(@"%@",jsonret); // Look at the console and you can see what the restults are
			
			NSData *jsonRet = [jsonret dataUsingEncoding:NSUTF8StringEncoding];
			NSError *error = nil;
			
			diz = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonRet error:&error];
			
			if (diz) {
				righe = [diz objectForKey:@"Giorni"];
			}

			if ([righe count]==0){ //condizioni assenti
				validita.text=@"Non disponibile";

			}
			else { //costruisco la strinaga condizioni
				
				//NSLog(@"La tessera vale per %d giorni settimanali", [righe count]);
				NSString *giorni=[NSString stringWithFormat:@""];
				for (int i=0;i<[righe count];i++) {
					diz = [righe objectAtIndex: i];
					giorni=[NSString stringWithFormat:@"%@%@ ", giorni,[diz objectForKey:@"giorno_della_settimana"]];
					
				}
				validita.text=[NSString stringWithFormat:@"%@", giorni];				

				if ( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Note_Varie_CE"]] isEqualToString:@"<null>"] ){ //non ci sono condizioni
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
			giorno.text=[NSString stringWithFormat:@"%@", [self.dict objectForKey:@"Giorno_chiusura_Esercente"]];
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
		int idcontr=[[self.dict objectForKey:@"IDcontratto_Contresercente"]intValue];
		NSURL *link = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/Validita.php?idcontratto=%d",idcontr]];
		//NSLog(@"Url: %@", link);
		
		NSString *jsonret = [[[NSString alloc] initWithContentsOfURL:link] autorelease];
        //NSLog(@"%@",jsonret); // Look at the console and you can see what the restults are
		
		NSData *jsonRet = [jsonret dataUsingEncoding:NSUTF8StringEncoding];
		NSError *error = nil;
		
		diz = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonRet error:&error];
		
		if (diz) {
			righe = [diz objectForKey:@"Giorni"];
			}
		
		if ([righe count]==0){ //condizioni non disponibili
			validita.text=[NSString stringWithFormat:@"Non disponibile"];
		}
		else {
			//NSLog(@"La tessera vale per %d giorni settimanali", [righe count]);
			NSString *giorni=[NSString stringWithFormat:@""];
			for (int i=0;i<[righe count];i++) {
				diz = [righe objectAtIndex: i];
				giorni=[NSString stringWithFormat:@"%@%@ ", giorni,[diz objectForKey:@"giorno_della_settimana"]];
				
			}
			validita.text=[NSString stringWithFormat:@"%@", giorni];			
			if ( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Note_Varie_CE"]] isEqualToString:@"<null>"] ){ //non ci sono condizioni
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			else {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		}
	}
	
	
	
	if ( (indexPath.row == 0)&&(indexPath.section==1) ){
		
		if(!( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"]) ){
			UILabel *telefono = (UILabel *)[cell viewWithTag:1];
			UILabel *etic = (UILabel *)[cell viewWithTag:2];
			etic.text=@"";
			telefono.text = [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Telefono_Esercente"]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else {
			if(!( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"]) ){
				UILabel *email = (UILabel *)[cell viewWithTag:1];
				UILabel *etic = (UILabel *)[cell viewWithTag:2];
				etic.text=@"";
				email.text = [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Email_esercente"]];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			else {
				if(!( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"] )){
					UILabel *sitoweb = (UILabel *)[cell viewWithTag:1];
					UILabel *etic = (UILabel *)[cell viewWithTag:2];
					etic.text=@"";
					sitoweb.text = [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Url_Esercente"]];
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				}
			}
		}
	}	
	
	
	if ( (indexPath.row == 1)&&(indexPath.section==1) ){
		if( (!( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] ))&& (!( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] )) ){ 
			UILabel *email = (UILabel *)[cell viewWithTag:1];
			UILabel *etic = (UILabel *)[cell viewWithTag:2];
			etic.text=@"";
			email.text = [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Email_Esercente"]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else {
			if(!( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"] )){
				UILabel *sitoweb = (UILabel *)[cell viewWithTag:1];
				UILabel *etic = (UILabel *)[cell viewWithTag:2];
				etic.text=@"";
				sitoweb.text = [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Url_Esercente"]];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		}
	}
	
	if ( (indexPath.row == 2)&&(indexPath.section==1) ){
		if((! [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"]) ){
			UILabel *sitoweb = (UILabel *)[cell viewWithTag:1];
			UILabel *etic = (UILabel *)[cell viewWithTag:2];
			etic.text=@"";
			sitoweb.text = [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Url_Esercente"]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
	}

	   return cell;
}


#pragma mark - UITableViewDelegate


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)] autorelease];
    [customView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.lineBreakMode = UILineBreakModeWordWrap;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont boldSystemFontOfSize:18];
    
	
	if (section == 0)
	{
		lbl.text = [self.dict objectForKey:@"Insegna_Esercente"];
	}
		
	if (section == 1){
		if( ( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] ) &&( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] )
		   &&( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"])  ){ // non ci sono contatti
			lbl.text = @"";
		}
		else {
			lbl.text = @"Contatti";	
		}
		
	}
    
    UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    lbl.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, labelSize.height+6);
    
    [customView addSubview:lbl];
    
    return customView;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	NSString *lblText;
	
	if (section == 0) {
		lblText = [self.dict objectForKey:@"Insegna_Esercente"];
	} else if (section == 1){
		if( ( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] ) &&( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] )
		   &&( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"])  ){ // non ci sono contatti
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( (indexPath.row == 0)&&(indexPath.section==0) ){ //apri mappa
		[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
		self.mappa.navigationItem.titleView = self.tipoMappa;
		
		[self.navigationController pushViewController:self.mappa animated:YES];
		
		self.map.delegate = self;
		self.map.showsUserLocation = YES;
		float lati, longi;
		int d;
		lati=[[self.dict objectForKey:@"Latitudine"] doubleValue];
		longi=[[self.dict objectForKey:@"Longitudine"] floatValue];
		d=[[self.dict objectForKey:@"IDesercente"]intValue];
		NSString *nome = [self.dict objectForKey:@"Insegna_Esercente"];
		//NSString *address=[NSString alloc];		
		//address=[self.dict objectForKey:@"Indirizzo_Esercente"];
		NSString *address=[[[NSString alloc ]initWithFormat:@"%@, %@",[[self.dict objectForKey:@"Indirizzo_Esercente"]capitalizedString],[[self.dict objectForKey:@"Citta_Esercente"]capitalizedString]] autorelease];

		int ident=d;
		
		[self.map addAnnotation:[[[GoogleHQAnnotation alloc] init:lati:longi:nome:address:ident] autorelease]];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];




	}	
	
	if ( ((indexPath.row == 2)&&(indexPath.section==0)) || ((indexPath.row == 1)&&(indexPath.section==0)&& ([tableView numberOfRowsInSection:0]==2)) ) { //condizioni
		self.condizioni.title = [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Insegna_Esercente"]];
		[self.navigationController pushViewController:self.condizioni animated:YES];
		self.cond.text=[NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Note_Varie_CE"]];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	
	
	if ( (indexPath.row == 0)&&(indexPath.section==1) ){ //telefona o mail o sito
		if(!( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"]) ){ //la cella esprime un num di tel
			PerDueCItyCardAppDelegate *appDelegate = (PerDueCItyCardAppDelegate*)[[UIApplication sharedApplication]delegate];
			UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Vuoi chiamare\n%@?",[self.dict objectForKey:@"Insegna_Esercente"]] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Chiama", nil];

			[aSheet showInView:appDelegate.window];
			[aSheet release];			
			
			[tableView deselectRowAtIndexPath:indexPath animated:YES];		
		}
		else {
			if(!( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"]) ){ //la cella esprime un indirizzo email
				MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
				[[controller navigationBar] setTintColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
				NSArray *to = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Email_Esercente"]]];
				[controller setToRecipients:to];
				controller.mailComposeDelegate = self;
				[controller setMessageBody:@"" isHTML:NO];
				[self presentModalViewController:controller animated:YES];
				[controller release];
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
			}
			else { //la cella esprime un url
				[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
				NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[self.dict objectForKey:@"Url_Esercente"]]];
				NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
				[self.webView loadRequest:requestObj];		
				[self.navigationController pushViewController:self.sito animated:YES];
				self.sito.title = [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Insegna_Esercente"]];
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
				[self.webView release];
				self.webView=nil;

			}
			
		}
		
	}	
	
	if ( (indexPath.row == 1)&&(indexPath.section==1) ){ // mail o sito
		if( (!( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] ))&& (!( [ [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] )) ){ //indirizzo mail
			MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
			[[controller navigationBar] setTintColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
			NSArray *to = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Email_Esercente"]]];
			[controller setToRecipients:to];
			controller.mailComposeDelegate = self;
			[controller setMessageBody:@"" isHTML:NO];
			[self presentModalViewController:controller animated:YES];
			[controller release];
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
		else { //sito web
			[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[self.dict objectForKey:@"Url_Esercente"]]];
			NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
			[self.webView loadRequest:requestObj];		
			[self.navigationController pushViewController:self.sito animated:YES];
			self.sito.title = [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Insegna_Esercente"]];
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			[self.webView release];
			self.webView=nil;


		}
		
	}	
	
	if ( (indexPath.row == 2)&&(indexPath.section==1) ){ // sito web
		[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[self.dict objectForKey:@"Url_Esercente"]]];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[self.webView loadRequest:requestObj];		
		[self.navigationController pushViewController:self.sito animated:YES];
		self.sito.title = [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"Insegna_Esercente"]];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[self.webView release];
		self.webView=nil;
		
		
	}
	
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[self.dict objectForKey:@"Telefono_Esercente"]]];
		[[UIApplication sharedApplication] openURL:url];
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
	if ([self.tipoMappa selectedSegmentIndex]==0) {
		self.map.mapType=MKMapTypeStandard;
	} else if ([self.tipoMappa selectedSegmentIndex]==1) {
		self.map.mapType=MKMapTypeSatellite;
	} else if ([self.tipoMappa selectedSegmentIndex]==2) {
		self.map.mapType=MKMapTypeHybrid;
	}
}


@end



/*********************************************************************/


@interface IndexPathMapper () {
    NSMutableArray *map;
}
@end



@implementation IndexPathMapper


- (id) init {
    self = [super init];
    if (self) {
        map = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void) setKey:(NSString *)key forSection:(NSInteger)section row:(NSInteger)row {    
    NSMutableArray *sectionArray;
    if (section >= map.count) {
        sectionArray = [[[NSMutableArray alloc] init] autorelease];
        [map addObject:sectionArray];
    }
    else {
        sectionArray = [map objectAtIndex:section];
    }
    
    if (row >= sectionArray.count) {
        [sectionArray addObject:key];
    }
    else {
        [sectionArray insertObject:key atIndex:row];
    }
}


- (NSString *) keyForSection:(NSInteger)section row:(NSInteger)row {
    if (section >= map.count) {
        return nil;
    }
    else {
        NSArray *sectionArray = [map objectAtIndex:section];
        if (row >= sectionArray.count) {
            return nil;
        }
        else {
            return [sectionArray objectAtIndex:row];
        }
    }
}


- (void) removeKeyAtSecion:(NSInteger)section row:(NSInteger)row {
    NSMutableArray *sectionArray;
    if (section >= map.count) {
        sectionArray = [[[NSMutableArray alloc] init] autorelease];
        [map addObject:sectionArray];
    }
    else {
        return;
    }
    
    if (row >= sectionArray.count) {
        return;
    }
    else {
        [sectionArray removeObjectAtIndex:row];
    }

}


- (void) setKey:(NSString *)key forIndexPath:(NSIndexPath *)indexPath {
    [self setKey:key forSection:indexPath.section row:indexPath.row];
}


- (NSString *) keyForIndexPath:(NSIndexPath *)indexPath {
    return [self keyForSection:indexPath.section row:indexPath.row];
}


- (void) removeKeyAtIndexPath:(NSIndexPath *)indexPath {
    [self removeKeyAtSecion:indexPath.section row:indexPath.row];
}

- (void) dealloc {
    [map release];
}
@end


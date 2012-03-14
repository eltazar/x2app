//
//  AltreOfferte.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AltreOfferte.h"
#import "Utilita.h"
#import "OpzioniCoupon.h"
#import "DatabaseAccess.h"
#import "Reachability.h"

@implementation AltreOfferte
@synthesize footerView,CellSpinner,tableview,rows,dict;

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if([rows count]==0){
		return 0;
	}
	else {
			if( ([rows count]<3) && ([rows count] >0) ){
				return 1;
			}	
			else {
				return 2;			
			}
	}
}

	// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return [rows count];

		default:
			return 0;
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


	// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section==0){
		static NSString *CellIdentifier = @"Cell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil){
			[[NSBundle mainBundle] loadNibNamed:@"cellaofferte" owner:self options:NULL];
			cell=cellaofferte;
			[CellSpinner startAnimating];
		
		}
		else {
				[CellSpinner stopAnimating];
				AsyncImageView* oldImage = (AsyncImageView*)
				[cell.contentView viewWithTag:999];
				[oldImage removeFromSuperview];
		}
			
		dict = [rows objectAtIndex: indexPath.row];
		
		CGRect frame;
		frame.size.width=86; frame.size.height=107;
		frame.origin.x=10; frame.origin.y=10;
		AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
		asyncImage.tag = 999;
		
		NSString *img=[NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[dict objectForKey:@"offerta_foto_big"]];
		
		NSURL *urlfoto = [NSURL URLWithString:img];
		
			
		[asyncImage loadImageFromURL:urlfoto];
		
		[cell.contentView addSubview:asyncImage];		
		
		
		
		
		UILabel *intestazione = (UILabel *)[cell viewWithTag:3];
		intestazione.text =[NSString stringWithFormat:@"Solo € %@ invece di € %@",[dict objectForKey:@"coupon_valore_acquisto"],[dict objectForKey:@"coupon_valore_facciale"]]; 
		
		UILabel *titolo = (UILabel *)[cell viewWithTag:1];
		titolo.text =[dict objectForKey:@"offerta_titolo_breve"]; 
	
		/*UIImageView *foto=(UIImageView *)[cell viewWithTag:2];
		NSString *img=[NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[dict objectForKey:@"offerta_foto_vetrina"]];
	
		NSURL *urlfoto = [NSURL URLWithString:img];

		NSData *urlData = [NSData dataWithContentsOfURL:urlfoto];
		UIImage *image = [UIImage imageWithData:urlData];
		foto.image = image;*/
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;		
		}
}



	// Metodo relativo alla selezione di una cella
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];

	dict = [rows objectAtIndex: indexPath.row];
	detail = [[Offerta alloc] initWithNibName:@"Offerta" bundle:[NSBundle mainBundle]];
	NSInteger identificativo=[[dict objectForKey:@"idofferta"]integerValue]; 
	[(Offerta*)detail setIdentificativo:identificativo];
	[detail setTitle:@"Offerta"];
		//Facciamo visualizzare la vista con i dettagli
	[self.navigationController pushViewController:detail animated:YES];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

}
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (IBAction)Opzioni:(id)sender{
	OpzioniCoupon *opt = [[OpzioniCoupon alloc] init];
    [self presentModalViewController:opt animated:YES];
    [opt release];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ALTRE OFFERTE DID LOAD");
    
//	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    UIBarButtonItem *cittaBtn = [[UIBarButtonItem alloc] initWithTitle:@"Città" style:UIBarButtonItemStyleBordered target:self action:@selector(Opzioni:)];
    self.navigationItem.rightBarButtonItem = cittaBtn;
    [cittaBtn release];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    citta.text  = [defaults objectForKey:@"cittacoupon"];
    
	dbAccess = [[DatabaseAccess alloc]init];
    dbAccess.delegate = self;
    
    rows=[[NSMutableArray alloc] init];
    
}

-(void)didReceiveCoupon:(NSDictionary *)coupon{
    
    dict = [NSMutableDictionary dictionaryWithDictionary:coupon];
    
    NSMutableArray *r=[[NSMutableArray alloc] init];
    
    NSLog(@"MARIO DICT \n %@",dict);
    
    if (dict)
    {
        r = [[dict objectForKey:@"Esercente"] retain];
        
    }
    
    //NSLog(@"Array: %@",r);
    //rows=[[NSMutableArray alloc] init];
    [rows removeAllObjects];
    [rows addObjectsFromArray: r];
    
    NSLog(@"Numero totale:%d",[rows count]);
    if([rows count]==0){ //tabella vuota
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"In questo momento non ci sono altre offerte per questa città" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
        [alert show];
        [alert release];
        //[self.navigationController popViewControllerAnimated:YES];
    }
    
    [self.tableview reloadData];

    
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"ALTRE OFFERTE VIEW WILL APPEAR");
//	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
//	int wifi=0;
//	int internet=0;
//	internetReach = [[Reachability reachabilityForInternetConnection] retain];
//	internet= [self check:internetReach];
//	
//	wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
//	wifi=[self check:wifiReach];	
//	if( (internet==-1) &&( wifi==-1) ){
    if(! [Utilita networkReachable]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];
		
	}
    else{
	
        NSString *citycoupon;	
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        citycoupon=[defaults objectForKey:@"cittacoupon"];
        
        citta.text = citycoupon;
        
        NSString *prov= [citycoupon stringByReplacingOccurrencesOfString:@" " withString:@"!"]; //inserisco un carattere speciale per gli spazi, nel file php verrà risostituito dallo spazio
        //url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner//altreofferte.php?prov=%@",prov]];
        //NSLog(@"Url: %@", url);
        
        [dbAccess getAltreOfferteFromServer:prov];
        
//        NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url];
//        //NSLog(@"%@",jsonreturn); // Look at the console and you can see what the restults are
//        
//        NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *error = nil;	
        
        //dict = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error] retain];	
            //rows=[[NSMutableArray alloc] initWithObjects:[dict allValues],nil];
//        NSMutableArray *r=[[NSMutableArray alloc] init];
//        
//        NSLog(@"MARIO DICT \n %@",dict);
//        
//        if (dict)
//        {
//            r = [[dict objectForKey:@"Esercente"] retain];
//            
//        }
//        
//        //NSLog(@"Array: %@",r);
//        rows=[[NSMutableArray alloc] init];
//        
//        [rows addObjectsFromArray: r];
//        
//        NSLog(@"Numero totale:%d",[rows count]);
//        if([rows count]==0){ //tabella vuota
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"In questo momento non ci sono altre offerte per questa città" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
//            [alert show];
//            [alert release];
//                //[self.navigationController popViewControllerAnimated:YES];
//        }
//        
//        else {
//            [jsonreturn release];
//            jsonreturn=nil;
//            [r release];
//            r=nil;	
//        }
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

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
	
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {

    dict = nil;
    rows = nil;
    
    [super viewDidUnload];
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    dbAccess.delegate = nil;
    [dbAccess release];
	[tableview release];
	[rows release];
	[detail release];
	[dict release];
	//[url release];
	[footerView release];
	[CellSpinner release];
    [citta release];
//	[wifiReach release];
//	[internetReach release];
    [super dealloc];
}


@end

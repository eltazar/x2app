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
#import "Coupon.h"
#import <QuartzCore/QuartzCore.h>

@interface AltreOfferte () {}
@property (nonatomic, retain) NSMutableArray *dataModel;
@property (nonatomic, retain) DatabaseAccess *dbAccess;
@end



@implementation AltreOfferte


@synthesize tableview=_tableview, footerView=_footerView, cellSpinner=_cellSpinner, citta=_citta, spinnerView=_spinnerView;

@synthesize dataModel=_dataModel, dbAccess=_dbAccess;


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
    
    NSLog(@"ALTRE OFFERTE DID LOAD");
    
    UIBarButtonItem *cittaBtn = [[UIBarButtonItem alloc] initWithTitle:@"Città" style:UIBarButtonItemStyleBordered target:self action:@selector(opzioni:)];
    self.navigationItem.rightBarButtonItem = cittaBtn;
    [cittaBtn release];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _citta.text  = [defaults objectForKey:@"cittacoupon"];
    
	self.dbAccess = [[[DatabaseAccess alloc] init] autorelease];
    self.dbAccess.delegate = self;
    
    self.dataModel = [[[NSMutableArray alloc] init] autorelease];
    
    self.spinnerView.layer.cornerRadius = 6;
}


- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"ALTRE OFFERTE VIEW WILL APPEAR");
    if(! [Utilita networkReachable]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];
		
	}
    else{
        
        NSString *citycoupon;	
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        citycoupon=[defaults objectForKey:@"cittacoupon"];
        
        _citta.text = citycoupon;
        
        //inserisco un carattere speciale per gli spazi, nel file php verrà risostituito dallo spazio
        NSString *prov= [citycoupon stringByReplacingOccurrencesOfString:@" " withString:@"!"];       
        [self.spinnerView startAnimating];
        [self.dbAccess getAltreOfferteFromServer:prov];        
    }
    [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow]  animated:YES];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload {    
    [super viewDidUnload];
    self.dataModel = nil;
    self.dbAccess.delegate = nil;
    self.dbAccess = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableview.dataSource = nil;
    self.tableview.delegate = nil;
    self.tableview = nil;
    self.footerView = nil;
    self.cellSpinner = nil;
    self.citta = nil;
    self.spinnerView = nil;
}


- (void)dealloc {
    self.dataModel = nil;
    self.dbAccess.delegate = nil;
    self.dbAccess = nil;
    self.tableview.dataSource = nil;
    self.tableview.delegate = nil;
    self.tableview = nil;
    self.footerView = nil;
    self.cellSpinner = nil;
    self.citta = nil;
    self.spinnerView = nil;
    [super dealloc];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.dataModel.count == 0) {
		return 0;
	}
	else {
        if( (self.dataModel.count < 3) && (self.dataModel.count > 0) ){
            return 1;
        }	
        else {
            return 2;			
        }
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return self.dataModel.count;

		default:
			return 0;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
	if (indexPath.section == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"AltreOfferteCell"];
		if (cell == nil) {
			cell = [[[NSBundle mainBundle] loadNibNamed:@"AltreOfferteCell" owner:self options:NULL] objectAtIndex:0];
			[self.cellSpinner startAnimating];
            
		}
		else {
            [self.cellSpinner stopAnimating];
            AsyncImageView* oldImage = (AsyncImageView*)
            [cell.contentView viewWithTag:999];
            [oldImage removeFromSuperview];
		}
        
		NSDictionary *offertaDict = [self.dataModel objectAtIndex: indexPath.row];
		
		CGRect frame;
		frame.size.width=86; frame.size.height=107;
		frame.origin.x=10; frame.origin.y=10;
		AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
		asyncImage.tag = 999;
		
		NSString *img = [NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[offertaDict objectForKey:@"offerta_foto_big"]];
		
		NSURL *urlfoto = [NSURL URLWithString:img];
		
        
		[asyncImage loadImageFromURL:urlfoto];
		
		[cell.contentView addSubview:asyncImage];		
		
		
		UILabel *intestazione = (UILabel *)[cell viewWithTag:4];
		intestazione.text =[NSString stringWithFormat:@"Solo € %@ invece di € %@",[offertaDict objectForKey:@"coupon_valore_acquisto"],[offertaDict objectForKey:@"coupon_valore_facciale"]]; 
		
		UILabel *titolo = (UILabel *)[cell viewWithTag:3];
		titolo.text = [offertaDict objectForKey:@"offerta_titolo_breve"]; 
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"bogus"] autorelease];
    }
    return cell;
}


#pragma mark - UITableViewDelegate


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.footerView == nil) {
		if (section == 1) {
			//allocate the view if it doesn't exist yet
			self.footerView  = [[[UIView alloc] init] autorelease];
		}
    }
    //return the view for the footer
    return self.footerView;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *offertaDict = [self.dataModel objectAtIndex: indexPath.row];
    Coupon *couponSelezionatoController = [[Coupon alloc] initWithNibName:nil bundle:nil isOffertaDelGiorno:NO];
    NSInteger identificativoOfferta = [[offertaDict objectForKey:@"idofferta"] integerValue];
    [couponSelezionatoController setIdCoupon:identificativoOfferta];
    [self.navigationController pushViewController:couponSelezionatoController animated:YES];
    
    [couponSelezionatoController release];
}


#pragma mark - DatabaseAccessDelegate


- (void)didReceiveError:(NSError *)error{
    NSLog(@"ALTRE OFFERTE ERRORE SERVER = %@",[error description]);
    [self.spinnerView stopAnimating];
}


- (void)didReceiveCoupon:(NSDictionary *)coupon {
    [self.spinnerView stopAnimating];
    
    NSObject *temp = [coupon objectForKey:@"Esercente"];
    if (![temp isKindOfClass:[NSArray class]]) {
        return;
    }
    
    [self.dataModel removeAllObjects];
    [self.dataModel addObjectsFromArray: (NSArray *)temp];
    
    NSLog(@"Numero totale:%d",[self.dataModel count]);
    if (self.dataModel.count == 0) { 
        //tabella vuota
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"In questo momento non ci sono altre offerte per questa città" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
        [alert show];
        [alert release];
    }
    [self.tableview reloadData];
}


#pragma mark - AltreOfferte (IBActions)


- (IBAction)opzioni:(id)sender{
	OpzioniCoupon *opt = [[OpzioniCoupon alloc] init];
    [self presentModalViewController:opt animated:YES];
    [opt release];
}



@end

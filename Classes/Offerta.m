//
//  Offerta.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Offerta.h"


@implementation Offerta
@synthesize titolo,sconto,risparmio,compra,tableview,identificativo,riepilogo,compratermini,compradipiu,comprasintesi,CellSpinner,fotoingrandita,faqwebview;

/*facebook*/
@synthesize facebookAlert;
@synthesize usersession;
@synthesize username;
@synthesize post;
#define _APP_KEY @"223476134356120"
#define _SECRET_KEY @"6d2eaf75967fc247ac45aac716a4dd64"

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

-(void)Paga:(id)sender{
	if ([rows count]>0){
		if(secondsLeft>0) {
			detail = [[Pagamento2 alloc] initWithNibName:@"Pagamento2" bundle:[NSBundle mainBundle]];
			[(Pagamento2*)detail setValore:[[dict objectForKey:@"coupon_valore_acquisto"]doubleValue]];
			[(Pagamento2*)detail setIdentificativo:[[dict objectForKey:@"idofferta"]integerValue]];

			NSString *tit=[NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_titolo_breve"]];
			NSLog(@"Titolo:%@",tit);
			[(Pagamento2*)detail setTitolo:tit];	
			[detail setTitle:@"Acquisto"];
			[self.navigationController pushViewController:detail animated:YES];
		}
		else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offerta scaduta!" message:@"Questa offerta non è più disponibile" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
			[alert show];
			[alert release];
		}
	}
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1;
			break;
		case 1: 				
			if ( ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_descrizione_estesa"]] isEqualToString:@"<null>"]) || ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_descrizione_estesa"]] isEqualToString:@""])){
				return 3;
				break;
				}
			else {
				return 4;
				break;
			}
		case 2:
			return 3;
			break;
		default:
			return 0;
			break;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.section==0)
		return 155;
	if( (indexPath.section==1) &&(indexPath.row==2) )
		return 60;
	if( (indexPath.section==1) &&( (indexPath.row==0) || (indexPath.row==1) || (indexPath.row==3) ) )
		return 44;
	if(indexPath.section==2)
		return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:@"cellID"];
	
	if (indexPath.section==0){
		if (cell==nil){
			[[NSBundle mainBundle] loadNibNamed:@"infocoupon" owner:self options:NULL];
			cell=cellainfocoupon;
			[CellSpinner startAnimating];
			} 
		else {
			[CellSpinner stopAnimating];
			AsyncImageView* oldImage = (AsyncImageView*)
			[cell.contentView viewWithTag:999];
			[oldImage removeFromSuperview];
		}
			
	[compra setTitle: [NSString stringWithFormat:@"Compra subito! Solo %@€",[dict objectForKey:@"coupon_valore_acquisto"]] forState:UIControlStateNormal];
	riepilogo.text=[NSString stringWithFormat:@"Solo %@€ invece di %@€",[dict objectForKey:@"coupon_valore_acquisto"],[dict objectForKey:@"coupon_valore_facciale"]]; 
	sconto.text=[NSString stringWithFormat:@"Sconto: %@",[dict objectForKey:@"offerta_sconto_per"]];
	risparmio.text=[NSString stringWithFormat:@"Risparmio: %@€",[dict objectForKey:@"offerta_sconto_va"]];
	
	NSDateFormatter *formatoapp = [[NSDateFormatter alloc] init];
	[formatoapp setDateFormat:@"dd-MM-YYYY HH:mm"];
	NSString *datadb = [NSString stringWithFormat:@"%@",[dict objectForKey:@"coupon_periodo_dal"]];
	NSDateFormatter *formatodb=[[NSDateFormatter alloc] init];
	[formatodb setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *d1=[formatodb dateFromString:datadb];
	NSString *dataapp = [formatoapp stringFromDate:d1];
	
	CGRect frame;
	frame.size.width=101; frame.size.height=135;
	frame.origin.x=10; frame.origin.y=10;
	AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
	NSString *img=[NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[dict objectForKey:@"offerta_foto_big"]];
	NSURL *urlfoto = [NSURL URLWithString:img];
	asyncImage.tag = 999;
	
	[asyncImage loadImageFromURL:urlfoto];
		
	[cell.contentView addSubview:asyncImage];

	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];  
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];  
		
	[doubleTap setNumberOfTapsRequired:2];  
		
	[asyncImage addGestureRecognizer:singleTap];  
	[asyncImage addGestureRecognizer:doubleTap];  
		
	[singleTap release];  
	[doubleTap release];  	

		
	NSDate *now = [[NSDate alloc] init];
	NSString *scad = [NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_periodo_al"]];
	NSDate *datascadenza=[formatodb dateFromString:scad];
	secondsLeft =[datascadenza timeIntervalSinceDate:now];
	int days, hours, minutes, seconds;
	secondsLeft=secondsLeft-1;
	days= secondsLeft/(3600*24);
	hours = (secondsLeft - (days*24*3600))/3600;
	minutes = (secondsLeft - ((hours*3600)+(days*24*3600) ) ) / 60;
	seconds = secondsLeft % 60;
	//NSLog(@"time =%02d:%02d:%02d:%02d",days,hours, minutes, seconds);
	tempo.text=[NSString stringWithFormat:@"%dg %02d:%02d:%02d",days,hours, minutes, seconds];
	//timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
	}
	
	else{
		if(indexPath.section==1){
			
			switch (indexPath.row) {
				case 0:
					if (cell == nil){	
						[[NSBundle mainBundle] loadNibNamed:@"CellaCoupon" owner:self options:NULL];
						cell=cellacoupon;
					}
					UILabel *t1 = (UILabel *)[cell viewWithTag:1];
					t1.text = @"In sintesi";
					break;
				case 1:
					if (cell == nil){	
						[[NSBundle mainBundle] loadNibNamed:@"CellaCoupon" owner:self options:NULL];
						cell=cellacoupon;
					}
					UILabel *t2 = (UILabel *)[cell viewWithTag:1];
					t2.text = @"Termini e condizioni";
					break;
				case 2:
					if (cell == nil){	
						[[NSBundle mainBundle] loadNibNamed:@"CellaCouponesercente" owner:self options:NULL];
						cell=cellanomesercente;
					}
					UILabel *t3 = (UILabel *)[cell viewWithTag:1];
					t3.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"esercente_nome"]];
					UILabel *t4 = (UILabel *)[cell viewWithTag:2];
					t4.text = [NSString stringWithFormat:@"%@, %@",[dict objectForKey:@"esercente_indirizzo"],[dict objectForKey:@"esercente_comune"]];
					break;
				case 3:
					if (cell == nil){	
						[[NSBundle mainBundle] loadNibNamed:@"CellaCoupon" owner:self options:NULL];
						cell=cellacoupon;
					}
					UILabel *t5 = (UILabel *)[cell viewWithTag:1];
					t5.text = @"Per saperne di più...";
					break;
				default:
					break;
			}
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		else {
			if(indexPath.section==2){
				switch (indexPath.row) {
					case 0:
						if (cell == nil){	
							[[NSBundle mainBundle] loadNibNamed:@"CellaCoupon" owner:self options:NULL];
							cell=cellacoupon;
						}
						UILabel *testo = (UILabel *)[cell viewWithTag:1];
						testo.text = @"Condividi questa offerta";
						break;
					case 1:
						if (cell == nil){	
							[[NSBundle mainBundle] loadNibNamed:@"CellaCoupon" owner:self options:NULL];
							cell=cellacoupon;
						}
						UILabel *lbl = (UILabel *)[cell viewWithTag:1];
						lbl.text = @"Contatta PerDue";
						break;
					case 2:
						if (cell == nil){	
							[[NSBundle mainBundle] loadNibNamed:@"CellaCoupon" owner:self options:NULL];
							cell=cellacoupon;
						}
						UILabel *faq = (UILabel *)[cell viewWithTag:1];
						faq.text = @"F.A.Q.";
						break;
				}
			}
		}
	}
	return cell;
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {  
	NSString *img=[NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[dict objectForKey:@"offerta_foto_big"]];
	NSURL *urlfoto = [NSURL URLWithString:img];
	NSData *data = [[NSData alloc] initWithContentsOfURL:urlfoto];
	UIImage *tempImage = [[UIImage alloc] initWithData:data];

	photobig.image = tempImage;
	[self presentModalViewController:fotoingrandita animated:YES];
	

}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {  
	NSString *img=[NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[dict objectForKey:@"offerta_foto_big"]];
	NSURL *urlfoto = [NSURL URLWithString:img];
	NSData *data = [[NSData alloc] initWithContentsOfURL:urlfoto];
	UIImage *tempImage = [[UIImage alloc] initWithData:data];
	
	photobig.image = tempImage;
	[self presentModalViewController:fotoingrandita animated:YES];
}

- (IBAction)chiudi:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)countDown {
	int days, hours, minutes, seconds;
	if (secondsLeft>0) {
		secondsLeft=secondsLeft-1;
		days= secondsLeft/(3600*24);
		hours = (secondsLeft - (days*24*3600))/3600;
		minutes = (secondsLeft - ((hours*3600)+(days*24*3600) ) ) / 60;
		seconds = secondsLeft % 60;
			//NSLog(@"time =%02d:%02d:%02d:%02d",days,hours, minutes, seconds);
		tempo.text=[NSString stringWithFormat:@"%dg %02d:%02d:%02d",days,hours, minutes, seconds];
	}
	else{
		[timer invalidate];
		secondsLeft=0;
		tempo.text=[NSString stringWithFormat:@"%i", secondsLeft];
	}
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( (indexPath.section==1) && (indexPath.row == 0)){
		[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
		[insintesi setTitle:@"In sintesi"];
		NSString *tit=[NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_titolo_breve"]];
		titololabel.text=tit;
		sintesitxt=[NSString stringWithFormat:@"<body bgcolor=\"#8E1507\"><font face=\"Helvetica regular\"><span style=\"color: #FFFFFF;\"><span style=\"font-size: 60%;\">%@</body>",[dict objectForKey:@"offerta_descrizione_breve"]];
		[insintesitext loadHTMLString:sintesitxt baseURL:nil];
		[comprasintesi setTitle: [NSString stringWithFormat:@"Compra subito! Solo €%@",[dict objectForKey:@"coupon_valore_acquisto"]] forState:UIControlStateNormal];
		[[comprasintesi layer] setCornerRadius:8.0f];
		[[comprasintesi layer] setMasksToBounds:YES];
		[comprasintesi setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
		
		
		[self.navigationController pushViewController:insintesi animated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
	}
	if ( (indexPath.section==1) && (indexPath.row == 1)){
		[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
		[termini setTitle:@"Termini e condizioni"];
		condizionitext=[NSString stringWithFormat:@"<body bgcolor=\"#8E1507\"><font face=\"Helvetica regular\"><span style=\"color: #FFFFFF;\"><span style=\"font-size: 60%;\">%@</body>",[dict objectForKey:@"offerta_condizioni_sintetiche"]];
		[condizionitxt loadHTMLString:condizionitext baseURL:nil];
		[compratermini setTitle: [NSString stringWithFormat:@"Compra subito! Solo €%@",[dict objectForKey:@"coupon_valore_acquisto"]] forState:UIControlStateNormal];
		[[compratermini layer] setCornerRadius:8.0f];
		[[compratermini layer] setMasksToBounds:YES];
		[compratermini setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
		
		[self.navigationController pushViewController:termini animated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	if ( (indexPath.section==1) && (indexPath.row == 2)){
		[contatti setTitle:@"Info Esercente"];
		if(tipodettaglio==1){ //dettglio ristopub
			[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
			detail = [[DettaglioRistoCoupon alloc] initWithNibName:@"DettaglioRistoCoupon" bundle:[NSBundle mainBundle]];
			[(DettaglioRistoCoupon*)detail setIdentificativo:identificativoesercente];
			[detail setTitle:@"Esercente"];
				//Facciamo visualizzare la vista con i dettagli
			[self.navigationController pushViewController:detail animated:YES];
			
		}	
		else {
			if (tipodettaglio==2) { //esercente generico
				[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
				detail = [[DettaglioEsercenteCoupon alloc] initWithNibName:@"DettaglioEsercenteCoupon" bundle:[NSBundle mainBundle]];
				[(DettaglioEsercenteCoupon*)detail setIdentificativo:identificativoesercente];
				[detail setTitle:@"Esercente"];				//Facciamo visualizzare la vista con i dettagli
				[self.navigationController pushViewController:detail animated:YES];
			}
			else { //esercente generico senza contratto
				[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
				detail = [[DettaglioEsercenteGenerico alloc] initWithNibName:@"DettaglioEsercenteGenerico" bundle:[NSBundle mainBundle]];
				[(DettaglioEsercenteGenerico*)detail setIdentificativo:identificativoesercente];
				[detail setTitle:@"Esercente"];				
					//Facciamo visualizzare la vista con i dettagli
				[self.navigationController pushViewController:detail animated:YES];
			}
		}
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	if ( (indexPath.section==1) && (indexPath.row == 3)){
		[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
		[dipiu setTitle:@"Per saperne di più..."];
		dipiutxt=[NSString stringWithFormat:@"<body bgcolor=\"#8E1507\"><font face=\"Helvetica regular\"><span style=\"color: #FFFFFF;\"><span style=\"font-size: 60%;\">%@</body>",[dict objectForKey:@"offerta_descrizione_estesa"]];
		[dipiutext loadHTMLString:dipiutxt baseURL:nil];
		[compradipiu setTitle: [NSString stringWithFormat:@"Compra subito! Solo €%@",[dict objectForKey:@"coupon_valore_acquisto"]] forState:UIControlStateNormal];
		[[compradipiu layer] setCornerRadius:8.0f];
		[[compradipiu layer] setMasksToBounds:YES];
		[compradipiu setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
		
		
		[self.navigationController pushViewController:dipiu animated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
	}
	if ( (indexPath.section==2) && (indexPath.row == 0)){
		PerDueCItyCardAppDelegate *appDelegate = (PerDueCItyCardAppDelegate*)[[UIApplication sharedApplication]delegate];
		aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Condividi questa offerta con i tuoi amici"] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Invia email", @"Condividi su Facebook", nil];
		
		[aSheet showInView:appDelegate.window];
		[aSheet release];			
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
	}
	if ( (indexPath.section==2) && (indexPath.row == 1)){
		PerDueCItyCardAppDelegate *appDelegate = (PerDueCItyCardAppDelegate*)[[UIApplication sharedApplication]delegate];
		aSheet2 = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Contatta PerDue"] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Telefona", @"Invia mail", nil];
		
		[aSheet2 showInView:appDelegate.window];
		[aSheet2 release];			
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
	}
	if ( (indexPath.section==2) && (indexPath.row == 2)){
		
		[self presentModalViewController:faq animated:YES];
		NSURL *infos = [NSURL URLWithString:@"http://www.cartaperdue.it/partner/faq.html"];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:infos];
		[faqwebview loadRequest:requestObj];		
		[faqwebview release];
		faqwebview=nil;
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}		
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(actionSheet==aSheet) {
		if (buttonIndex == 0) { //mail
			MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
			[[controller navigationBar] setTintColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
			controller.mailComposeDelegate = self;
			[controller setMessageBody:[NSString stringWithFormat:@"Ciao! Guarda questa offerta che ho trovato sul mio Iphone con l'applicazione PerDue:<br/><br/> %@ <br/> %@ <br/> %@",[dict objectForKey:@"offerta_titolo_breve"],[dict objectForKey:@"offerta_descrizione_breve"],[dict objectForKey:@"offerta_condizioni_sintetiche"]] isHTML:YES];
			[controller setSubject:@"Coupon PerDue"];
			
			[self presentModalViewController:controller animated:YES];
			[controller release];
		} 
		if (buttonIndex == 1) { //facebook
			if (appDelegate._session.isConnected) {
				[self postToWall];
			} else {
				FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:appDelegate._session] autorelease];
				[dialog show];
			}
		}
	}
	if(actionSheet==aSheet2) {
		if (buttonIndex == 0) { //telefona
			NSURL *numtel = [NSURL URLWithString:[NSString stringWithFormat:@"tel:800737383"]];
			[[UIApplication sharedApplication] openURL:numtel];
		}
		if (buttonIndex == 1) { //mail
			MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
			[[controller navigationBar] setTintColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
			NSArray *to = [NSArray arrayWithObject:[NSString stringWithFormat:@"redazione@cartaperdue.it"]];
			[controller setToRecipients:to];
			controller.mailComposeDelegate = self;
			[controller setMessageBody:@"" isHTML:NO];
			[self presentModalViewController:controller animated:YES];
			[controller release];
		}
	}	
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}


	// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:UIApplicationDidBecomeActiveNotification object:nil];
	[[compra layer] setCornerRadius:8.0f];
	[[compra layer] setMasksToBounds:YES];
	[compra setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
	
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
	if( ([rows count]>0) && (timer ==nil))
		timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];

	if( ([rows count]==0) && (timer !=nil))
		[timer invalidate];
    /*facebook*/
    appDelegate =(PerDueCItyCardAppDelegate *)   [[UIApplication sharedApplication]delegate];
    if (appDelegate._session == nil){
        appDelegate._session = [FBSession sessionForApplication:_APP_KEY secret:_SECRET_KEY delegate:self];
    }
    else{
        [[appDelegate._session delegates] addObject:self];
        [[appDelegate._session delegates] removeObjectAtIndex:0];
    }        
    
		//NSLog(@"Delegates: %@", [appDelegate._session delegates]);
}

- (void)viewWillAppear:(BOOL)animated {
	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
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
	
	url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/offerta.php?id=%d",identificativo]];
	NSLog(@"Url: %@", url);
	
	NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url];
	NSLog(@"%@",jsonreturn); // Look at the console and you can see what the restults are
	
	NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;	
	
	dict = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error] retain];	
	
	NSMutableArray *r=[[NSMutableArray alloc] init];
	
	if (dict)
	{
		r = [[dict objectForKey:@"Esercente"] retain];
		
	}
	
	NSLog(@"Array: %@",r);	
	rows= [[NSMutableArray alloc]init];
	[rows addObjectsFromArray: r];
	
	NSLog(@"Numero totale:%d",[rows count]);
	
	[jsonreturn release];
	jsonreturn=nil;
	[r release];
	r=nil;
	
	dict = [rows objectAtIndex: 0];		
	titolo.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_titolo_breve"]];
	identificativoesercente=[[dict objectForKey:@"idesercente"]integerValue];
	url2 = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/tipoesercente.php?id=%d",identificativoesercente]];
	NSLog(@"Url2: %@", url2);
	
	NSString *jsonreturn2 = [[NSString alloc] initWithContentsOfURL:url2];
	NSLog(@"%@",jsonreturn2); // Look at the console and you can see what the restults are
	
	NSData *jsonData2 = [jsonreturn2 dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error2 = nil;	
	
	dict2 = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData2 error:&error2] retain];	
	
	NSMutableArray *r2=[[NSMutableArray alloc] init];
	
	if (dict2)
	{
		r2 = [[dict2 objectForKey:@"Esercente"] retain];
		
	}
	
	NSLog(@"Array2: %@",r2);
	if ([r2 count]==0){ //l'eserncente non ha contratto nel db, il suo dettaglio sarà una view più semplice (senza condizioni, commenti ec..)
		tipodettaglio=3;
	}
	if ([r2 count]!=0){
		dict2 = [r2 objectAtIndex: 0];	
		NSInteger tipo=[[dict2 objectForKey:@"IdTipologia_Esercente"]integerValue];
		NSLog(@"Tipologia: %d",tipo);
		
		if( (tipo==2) || (tipo==5) || (tipo==6) || (tipo==9) || (tipo==59) || (tipo==60) || (tipo==61) || (tipo==27)){ //per dettaglio ristopub
			tipodettaglio=1;
		}
		else { //per dettaglio esercente generico
			tipodettaglio=2;
		}
	}
	NSLog(@"Tipo dettaglio settato: %d",tipodettaglio);
	[tableview reloadData];
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
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
		// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[rows release];
	[dict2 release];
	[url release];
	[url2 release];
	[dict release];
	[detail release];
	[tableview release];		
	[sintesitxt release];
	[condizionitext release];
	[dipiutxt release];
	[timer release];
	[wifiReach release];
	[internetReach release];
	[photobig release];
	[faq release];
	
}
#pragma mark -
#pragma mark facebook

- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	self.usersession =session;
	NSLog(@"User with id %lld logged in.", uid);
	[self getFacebookName];
}

- (void)getFacebookName {
	NSString* fql = [NSString stringWithFormat:@"select uid,name from user where uid == %lld", self.usersession.uid];
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
	self.post=YES;
}

- (void)request:(FBRequest*)request didLoad:(id)result {
	if ([request.method isEqualToString:@"facebook.fql.query"]) {
		NSArray* users = result;
		NSDictionary* user = [users objectAtIndex:0];
		NSString* name = [user objectForKey:@"name"];
		self.username = name;
		
		if (self.post) {
			[self postToWall];
			self.post = NO;
		}
	}
}


- (void)postToWall {
	FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease];
	
	NSString *name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_titolo_breve"]] ; 
    NSString *href = @"http://www.cartaperdue.it";
	
    NSString *caption = @"Carta PerDue - Sconti da vivere subito nella tua citta!";
    NSString *description = [NSString stringWithFormat:@"Scopri l'offerta del giorno - Acquista il coupon - Decidi quando utilizzarlo. Semplice, utile e versatile: questo è il tempo libero con PerDue!"]; 
    NSString *imageSource = [NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[dict objectForKey:@"offerta_foto_vetrina"]];
    NSString *imageHref =[NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[dict objectForKey:@"offerta_foto_big"]];
	
    NSString *linkTitle = @"Per ulteriori dettagli";
    NSString *linkText = @"Vedi l'offerta";
    NSString *linkHref = [NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/dettaglio_affare.jsp?idofferta=%@",[dict objectForKey:@"idofferta"]];
    dialog.attachment = [NSString stringWithFormat:
						 @"{ \"name\":\"%@\","
						 "\"href\":\"%@\","
						 "\"caption\":\"%@\",\"description\":\"%@\","
						 "\"media\":[{\"type\":\"image\","
						 "\"src\":\"%@\","
						 "\"href\":\"%@\"}],"
						 "\"properties\":{\"%@\":{\"text\":\"%@\",\"href\":\"%@\"}}}", name, href, caption, description, imageSource, imageHref, linkTitle, linkText, linkHref];
    [dialog show];
	
}

@end

//
//  Coupon.m
//  Per Due
//
//  Created by Giuseppe Lisanti on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Coupon.h"
#import "FBConnect.h"
#import "FBDialog.h"
#import "Facebook.h"
#import "PerDueCItyCardAppDelegate.h"
#import "DatabaseAccess.h"
#import "Utilita.h"
#import "LoginControllerBis.h"
#import "DettaglioEsercente.h"
#import "DettaglioEsercenteRistorazione.h"


typedef enum {CouponEsercente, CouponEsercenteRistorazione, CouponEsercenteSenzaContratto} tipoEsercente;

@interface Coupon () {
    BOOL isOffertaDelGiorno;
    tipoEsercente tipodettaglio;
    NSTimer *_timer;
    int secondsLeft;
    float altezzaCella;
    DatabaseAccess *_dbAccess;
    PerDueCItyCardAppDelegate *_appDelegate;	//Ci dovrebbe essere un modo per ottenerlo programmaticamente

    UIActionSheet *_aSheet;   //Mario, se passi di qui, dacci dei nomi più significativi :D
	UIActionSheet *_aSheet2;
    
    /*facebook*/
    NSArray *_permissions;    
	UIAlertView *_facebookAlert;
	NSString *_username;
	BOOL post;
    BOOL waitingForFacebook;
}
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) DatabaseAccess *dbAccess;
@property (nonatomic, retain) PerDueCItyCardAppDelegate *appDelegate;	
@property (nonatomic, retain) UIActionSheet *aSheet;   
@property (nonatomic, retain) UIActionSheet *aSheet2;
/*facebook*/
@property (nonatomic, retain) NSArray *permissions;    
@property (nonatomic, retain) UIAlertView *facebookAlert;
@property (nonatomic, retain) NSString *username;
@end


@implementation Coupon

@synthesize dataModel=_dataModel, idCoupon=_idCoupon;

@synthesize prezzoCouponLbl=_prezzoCouponLbl, scontoLbl=_scontoLbl, risparmioLbl=_risparmioLbl, prezzoOrigLbl=_prezzoOrigLbl, caricamentoImmagineSpinner=_caricamentoImmagineSpinner, titoloOffertaLbl=_titoloOffertaLbl, compraBtn=_compraBtn, reloadBtn=_reloadBtn, caricamentoSpinner=_caricamentoSpinner, tempoLbl=_tempoLbl, tableview=_tableview, FotoIngranditaViewController=_FotoIngranditaViewController, FotoIngranditaImageView=_FotoIngranditaImageView, dettagliOffertaViewContr=_dettagliOffertaViewContr, terminiViewContr=_terminiViewContr, diPiuViewContr=_diPiuViewContr, contattiViewContr=_contattiViewContr, faqViewController=_faqViewController, dettagliOffertaWebView=_dettagliOffertaWebView, condizioniWebView=_condizioniWebView, diPiuWebView=_diPiuWebView, faqWebView=_faqWebView;

@synthesize cellacoupon=_cellacoupon, cellainfocoupon=_cellainfocoupon,  cellanomesercente=_cellanomesercente, cellaDescrizioneOfferta=_cellaDescrizioneOfferta, cellaDescrizioneOffertaLbl;

@synthesize timer=_timer, dbAccess=_dbAccess, appDelegate=_appDelegate;	
@synthesize aSheet=_aSheet, aSheet2=_aSheet2;
/*facebook*/
@synthesize permissions=_permissions, facebookAlert=_facebookAlert, username=_username;



#define _APP_KEY @"223476134356120"
#define _SECRET_KEY @"6d2eaf75967fc247ac45aac716a4dd64"



- (id)init {
    self = [super init];
    if (self) {
        isOffertaDelGiorno = TRUE;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        isOffertaDelGiorno = TRUE;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isOffertaDelGiorno = TRUE;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isOffertaDelGiorno:(BOOL)isODG {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isOffertaDelGiorno = isODG;
    }
    return self;
}


#pragma mark - UITableViewDataSourceDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.dataModel)
		return 3;
	else 
		return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (!self.dataModel) //coupon non disponibile
		return 0;

    if (section == 0) {
        return 2;
	} else if (section == 1) {    
        NSString *descEstesa = [self.dataModel objectForKey:@"offerta_descrizione_estesa"];
        if (([descEstesa isEqualToString:@"<null>"]) || 
            ([descEstesa isEqualToString:@""])) {
            return 3;
        } else {
            return 4;
        }
    } else if (section == 2) {
        return 3;
    } else {
        return 0;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:@"cellID"];
	
	if (indexPath.section==0){
        
        switch(indexPath.row){
            case 0:
                if (cell == nil){
                    [[NSBundle mainBundle] loadNibNamed:@"CouponDescrOffertaCell" owner:self options:NULL];
                    cell=self.cellaDescrizioneOfferta;                    
                } 
                self.cellaDescrizioneOffertaLbl.numberOfLines = 0;
                self.cellaDescrizioneOffertaLbl.text = [self.dataModel objectForKey:@"offerta_titolo_breve"];
                [self.cellaDescrizioneOffertaLbl sizeToFit];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 1:
                if (cell == nil) {
                    [[NSBundle mainBundle] loadNibNamed:@"CouponDiscountTimeCell" owner:self options:NULL];
                    cell=self.cellainfocoupon;
                    [self.caricamentoImmagineSpinner startAnimating];
                } else {
                    [self.caricamentoImmagineSpinner stopAnimating];
                    AsyncImageView* oldImage = (AsyncImageView*)
                    [cell.contentView viewWithTag:999];
                    [oldImage removeFromSuperview];
                }
                
                [self.compraBtn setTitle: [NSString stringWithFormat:@"Compra",[self.dataModel objectForKey:@"coupon_valore_acquisto"]] forState:UIControlStateNormal];
                self.prezzoCouponLbl.text=[NSString stringWithFormat:@"%@€",[self.dataModel objectForKey:@"coupon_valore_acquisto"]]; 
                self.scontoLbl.text=[NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"offerta_sconto_per"]];
                self.risparmioLbl.text=[NSString stringWithFormat:@"%@€",[self.dataModel objectForKey:@"offerta_sconto_va"]];
                self.prezzoOrigLbl.text = [NSString stringWithFormat:@"%@€",[self.dataModel objectForKey:@"coupon_valore_facciale"]];
                
                NSDateFormatter *formatoapp = [[NSDateFormatter alloc] init];
                [formatoapp setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
                NSString *datadb = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"coupon_periodo_dal"]];
                NSDateFormatter *formatodb=[[NSDateFormatter alloc] init];
                [formatodb setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                CGRect frame;
                frame.size.width=101; frame.size.height=135;
                frame.origin.x=10; frame.origin.y=10;
                AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
                NSString *img=[NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[self.dataModel objectForKey:@"offerta_foto_big"]];
                NSURL *urlfoto = [NSURL URLWithString:img];
                asyncImage.tag = 999;
                
                [asyncImage loadImageFromURL:urlfoto];
                [cell.contentView addSubview:asyncImage];
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];  
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];  
                
                [doubleTap setNumberOfTapsRequired:2];  
                
                [asyncImage addGestureRecognizer:singleTap];  
                [asyncImage addGestureRecognizer:doubleTap];  
                
                NSDate *now = [[NSDate alloc] init];
                NSString *scad = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"offerta_periodo_al"]];
                NSDate *datascadenza=[formatodb dateFromString:scad];
                secondsLeft =[datascadenza timeIntervalSinceDate:now];
                int days, hours, minutes, seconds;
                days= secondsLeft/(3600*24);
                hours = (secondsLeft - (days*24*3600))/3600;
                minutes = (secondsLeft - ((hours*3600)+(days*24*3600) ) ) / 60;
                seconds = secondsLeft % 60;
                //NSLog(@"time =%02d:%02d:%02d:%02d",days,hours, minutes, seconds);
                self.tempoLbl.text=[NSString stringWithFormat:@"%dg %02dh:%02dm:%02ds",days,hours, minutes, seconds];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            default:
                break;
        }
    } else if(indexPath.section==1){
            
        switch (indexPath.row) {
            case 0:
                if ( cell == nil) {	
                    [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:NULL];
                    cell=self.cellacoupon;
                }
                UILabel *t1 = (UILabel *)[cell viewWithTag:1];
                t1.text = @"Dettagli offerta";
                break;
                
            case 1:
                if (cell == nil){	
                    [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:NULL];
                    cell=self.cellacoupon;
                }
                UILabel *t2 = (UILabel *)[cell viewWithTag:1];
                t2.text = @"Condizioni";
                break;
                
            case 2:
                if (cell == nil){	
                    [[NSBundle mainBundle] loadNibNamed:@"CouponEsercCell" owner:self options:NULL];
                    cell=self.cellanomesercente;
                }
                UILabel *t3 = (UILabel *)[cell viewWithTag:1];
                t3.text = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"esercente_nome"]];
                UILabel *t4 = (UILabel *)[cell viewWithTag:2];
                t4.text = [NSString stringWithFormat:@"%@, %@",[self.dataModel objectForKey:@"esercente_indirizzo"],[self.dataModel objectForKey:@"esercente_comune"]];
                break;
                
            case 3:
                if (cell == nil){	
                    [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:NULL];
                    cell=self.cellacoupon;
                }
                UILabel *t5 = (UILabel *)[cell viewWithTag:1];
                t5.text = @"Per saperne di più...";
                break;
                
            default:
                break;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    } else if (indexPath.section==2) {
        switch (indexPath.row) {
            case 0:
                if (cell == nil) {	
                    [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:NULL];
                    cell=self.cellacoupon;
                }
                UILabel *testo = (UILabel *)[cell viewWithTag:1];
                testo.text = @"Condividi questa offerta";
                break;
            case 1:
                if (cell == nil) {	
                    [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:NULL];
                    cell=self.cellacoupon;
                }
                UILabel *lbl = (UILabel *)[cell viewWithTag:1];
                lbl.text = @"Contatta PerDue";
                break;
            case 2:
                if (cell == nil) {	
                    [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:NULL];
                    cell=self.cellacoupon;
                }
                UILabel *faq = (UILabel *)[cell viewWithTag:1];
                faq.text = @"F.A.Q.";
                break;
        }
    }

	return cell;
}


#pragma mark - UITtableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return altezzaCella;
                break;
                
            case 1:
                return 155;
                break;
                
            default:
                break;
        }
    }
	if ( (indexPath.section==1) && (indexPath.row==2) )
		return 60;
	if ((indexPath.section==1) && 
        ( (indexPath.row==0) || (indexPath.row==1) || (indexPath.row==3) ) )
	return 44;
	if (indexPath.section == 2)
		return 44;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
    //mostra dettaglio offerta controller, è in questo controller, i dati sono stati già scaricati asincronamente
    if (indexPath.section == 0 && indexPath.row == 0) {
        return;
    }
    
	if ( (indexPath.section == 1) && (indexPath.row == 0) ) {
		[self.dettagliOffertaViewContr setTitle:@"Dettagli offerta"];
		NSString *tit=[NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"offerta_titolo_breve"]];
        NSString *sintesitxt = [NSString stringWithFormat:@"<body bgcolor=\"#8E1507\"><div style=\"background-color:8b1800; font-style:Helvetica regular;text-align:center;color:white;font-weight:bold;\"><p style=\"font-size:60px;\"><b>%@</b></p></div> <div style=\"background-color:#8b1800; font-style:Helvetica regular;font-size:55px; color:white;\">%@</div></body>", [self.dataModel objectForKey:@"offerta_title"],[self.dataModel objectForKey:@"offerta_descrizione_breve"]];
        [self.dettagliOffertaWebView loadHTMLString:sintesitxt baseURL:nil];
		[self.navigationController pushViewController:self.dettagliOffertaViewContr animated:YES]; 
        
	} else if ( (indexPath.section == 1) && (indexPath.row == 1) ) {
        //stessa filosofia di sopra
		[self.terminiViewContr setTitle:@"Termini e condizioni"];
		NSString *condizionitext=[NSString stringWithFormat:@"<body bgcolor=\"#8E1507\"><font face=\"Helvetica regular\"><span style=\"color: #FFFFFF;\"><span style=\"font-size: 60%;\">%@</body>",[self.dataModel objectForKey:@"offerta_condizioni_sintetiche"]];
        [self.condizioniWebView loadHTMLString:condizionitext baseURL:nil];		
		[self.navigationController pushViewController:self.terminiViewContr animated:YES];	
        
	} else if ( (indexPath.section == 1) && (indexPath.row == 2) ) {
        [self.contattiViewContr setTitle:@"Info Esercente"];
        DettaglioEsercente *dettaglioEsercente;
        NSInteger idEsercente = [[self.dataModel objectForKey:@"idesercente"]integerValue];
        if (tipodettaglio == CouponEsercenteRistorazione) { //dettglio ristopub
            NSLog(@"ESERCENTE RISTOPUB");
            dettaglioEsercente = [[DettaglioEsercenteRistorazione alloc] initWithNibName:nil bundle:nil couponMode:YES genericoMode:NO];
		} else if (tipodettaglio == CouponEsercente) { //esercente normale
            NSLog(@"ESERCENTE NORMALE");
            dettaglioEsercente = [[DettaglioEsercente alloc] initWithNibName:nil bundle:nil couponMode:YES genericoMode:NO];
        } else if (tipodettaglio == CouponEsercenteSenzaContratto ){ //esercente senza contratto
            dettaglioEsercente = [[DettaglioEsercente alloc] initWithNibName:nil bundle:nil couponMode:YES genericoMode:YES];
        }
        dettaglioEsercente.idEsercente = idEsercente;
        dettaglioEsercente.title = @"Esercente";
        [self.navigationController pushViewController:dettaglioEsercente animated:YES];
        
    } else if ( (indexPath.section == 1) && (indexPath.row == 3) ) {
		[self.diPiuViewContr setTitle:@"Per saperne di più..."];
		NSString *dipiutxt=[NSString stringWithFormat:@"<body bgcolor=\"#8E1507\"><font face=\"Helvetica regular\"><span style=\"color: #FFFFFF;\"><span style=\"font-size: 60%;\">%@</body>",[self.dataModel objectForKey:@"offerta_descrizione_estesa"]];
		[self.diPiuWebView loadHTMLString:dipiutxt baseURL:nil];
		[self.navigationController pushViewController:self.diPiuViewContr animated:YES];
		
	} else if ( (indexPath.section == 2) && (indexPath.row == 0) ) {
        //mostra il tasto per il logout se connesso
        if([self.appDelegate.facebook isSessionValid]){
            NSLog(@"DID LOAD CONNECTED");
            self.aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Condividi questa offerta con i tuoi amici"] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:@"Logout da Facebook" otherButtonTitles:@"Invia email", @"Condividi su Facebook", nil];
        } else {
            NSLog(@"DID LOAD NOT CONNECTED");
            self.aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Condividi questa offerta con i tuoi amici"] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Invia email", @"Condividi su Facebook", nil];
        }
		[self.aSheet showInView:self.appDelegate.window];
		[self.aSheet release];			
        
	} else if ( (indexPath.section == 2) && (indexPath.row == 1) ) {
		self.aSheet2 = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Contatta PerDue"] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Telefona", @"Invia mail", nil];
		[self.aSheet2 showInView:self.appDelegate.window];
		[self.aSheet2 release];			
		
	} else if ( (indexPath.section==2) && (indexPath.row == 2)){
		[self presentModalViewController:self.faqViewController animated:YES];
		NSURL *infos = [NSURL URLWithString:@"http://www.cartaperdue.it/partner/faq.html"];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:infos];
		[self.faqWebView loadRequest:requestObj];		
		[self.faqWebView release];
		self.faqWebView=nil;		
	}
}

#pragma mark - LoginControllerDelegate

- (void)didLogin:(int)idUtente {
    NSLog(@"IN COUPON DOPO LOGIN id = %d",idUtente);
    [self dismissModalViewControllerAnimated:YES];
    
    //identificativo è relativo all'offerta
    Pagamento2 *pagamentoController = [[Pagamento2 alloc] initWithNibName:nil bundle:nil];
    pagamentoController.idUtente = idUtente;
    [pagamentoController setValore:[[self.dataModel objectForKey:@"coupon_valore_acquisto"]doubleValue]];
    NSLog(@"Valore:%f",[[self.dataModel objectForKey:@"coupon_valore_acquisto"]doubleValue]);
    //NSLog(@"PREMUTO TASTO COMPRA IDENTIFICATIVO = %d",identificativo);
    [pagamentoController setIdentificativo:self.idCoupon];
    NSString *tit=[NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"offerta_titolo_breve"]];
    NSLog(@"%@", tit);
    pagamentoController.titolo = tit;
    [pagamentoController setTitle:@"Acquisto"];
    [self.navigationController pushViewController:pagamentoController animated:YES];
    [pagamentoController release];
}


-(void)didAbortLogin{
    NSLog(@"Abortito login da parte dell'utente");
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Gestione view e bottoni


-(IBAction)refreshView:(id)sender {
    [self viewDidAppear:YES];
}



-(void)Paga:(id)sender{
    if (![Utilita networkReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (!self.dataModel) //coupon non disponibile
        return;
    
    if (secondsLeft <= 0)
        return;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSNumber *idUtente = [prefs objectForKey:@"_idUtente"];
    
    if(!idUtente){
        //lancio view modale per il login
        LoginControllerBis *loginController = [[LoginControllerBis alloc] initWithNibName:@"LoginControllerBis" bundle:nil];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
        loginController.delegate = self;
        [loginController release];
        
        
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:navController animated:YES];
        [navController release];
        
    } else {
        Pagamento2 *pagamentoController = [[Pagamento2 alloc] initWithNibName:nil bundle:nil];
        [pagamentoController setValore:[[self.dataModel objectForKey:@"coupon_valore_acquisto"]doubleValue]];
        NSLog(@"Valore:%f",[[self.dataModel objectForKey:@"coupon_valore_acquisto"]doubleValue]);
        //NSLog(@"PREMUTO TASTO COMPRA IDENTIFICATIVO = %d",identificativo);
        [pagamentoController setIdentificativo:self.idCoupon];
        NSString *tit=[NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"offerta_titolo_breve"]];
        NSLog(@"%@",tit);
        pagamentoController.titolo = tit;
        [pagamentoController setTitle:@"Acquisto"];
        [self.navigationController pushViewController:pagamentoController animated:YES];
        [pagamentoController release];
    }
}


//codice da inserire nei metodi di ritorno delle query login
/*
if(1==1){
    LoginController *logController = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
    [self.navigationController pushViewController:logController animated:YES];
    [logController release];
    return;
}

if ([rows count]>0) {//coupon disponibile
    if(secondsLeft>0) {            
        Pagamento2 *pagamentoController = [[Pagamento2 alloc] initWithNibName:@"Pagamento2" bundle:[NSBundle mainBundle]];
        [pagamentoController setValore:[[dict objectForKey:@"coupon_valore_acquisto"]doubleValue]];
        NSLog(@"Valore:%f",[[dict objectForKey:@"coupon_valore_acquisto"]doubleValue]);
        //NSLog(@"PREMUTO TASTO COMPRA IDENTIFICATIVO = %d",identificativo);
        [pagamentoController setIdentificativo:identificativo];
        NSString *tit=[NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_titolo_breve"]];
        NSLog(@"%@",tit);
        pagamentoController.titolo = tit;
        [pagamentoController setTitle:@"Acquisto"];
        [self.navigationController pushViewController:pagamentoController animated:YES];
        [pagamentoController release];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offerta scaduta!" message:@"Questa offerta non è più disponibile" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
        [alert show];
        [alert release];
    }
}

*/


- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {  
	NSString *img=[NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[self.dataModel objectForKey:@"offerta_foto_big"]];
	NSURL *urlfoto = [NSURL URLWithString:img];
	NSData *data = [[NSData alloc] initWithContentsOfURL:urlfoto];
	UIImage *tempImage = [[UIImage alloc] initWithData:data];
	
	self.FotoIngranditaImageView.image = tempImage;
	[self presentModalViewController:self.FotoIngranditaViewController animated:YES];
	[tempImage release];
	
}


- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {  
	NSString *img=[NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[self.dataModel objectForKey:@"offerta_foto_big"]];
	NSURL *urlfoto = [NSURL URLWithString:img];
	NSData *data = [[NSData alloc] initWithContentsOfURL:urlfoto];
	UIImage *tempImage = [[UIImage alloc] initWithData:data];
	
	self.FotoIngranditaImageView.image = tempImage;
	[self presentModalViewController:self.FotoIngranditaViewController animated:YES];
    [tempImage release];
}


- (IBAction)chiudi:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}


- (void)countDown{
    //NSLog(@"RICHIAMATO COUNT DOWN");
	int days, hours, minutes, seconds;
	if (secondsLeft > 0) {
		secondsLeft=secondsLeft-1;
		days= secondsLeft/(3600*24);
		hours = (secondsLeft - (days*24*3600))/3600;
		minutes = (secondsLeft - ((hours*3600)+(days*24*3600) ) ) / 60;
		seconds = secondsLeft % 60;
		self.tempoLbl.text=[NSString stringWithFormat:@"%dg %02dh:%02dm:%02ds",days,hours, minutes, seconds];
	} else {
		secondsLeft=0;
		self.tempoLbl.text=[NSString stringWithFormat:@"Offerta scaduta!"];
		[self.timer invalidate];
        self.timer = nil;
	}
}

- (IBAction)AltreOfferte:(id)sender {
    AltreOfferte *altreOfferteController = [[AltreOfferte alloc] initWithNibName:nil bundle:nil];
    altreOfferteController.title = @"Altre Offerte";
    [self.navigationController pushViewController:altreOfferteController animated:YES];
    [altreOfferteController release];
	
}

#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    if (actionSheet == self.aSheet) {
        NSLog(@" numero di bottoni = %d", actionSheet.numberOfButtons);
        if (actionSheet.numberOfButtons == 4) {
            if(buttonIndex == 0){
                NSLog(@"richiamo logout facebook");
                [self logoutFromFB];
                return;
            } else {
                buttonIndex -= 1;
            }
        }
        
        if (buttonIndex == 0) { //mail
			MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
			[[controller navigationBar] setTintColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
			controller.mailComposeDelegate = self;
			[controller setMessageBody:[NSString stringWithFormat:@"Ciao! Guarda questa offerta che ho trovato sul mio Iphone con l'applicazione PerDue:<br/><br/> %@ <br/> %@ <br/> %@",[self.dataModel objectForKey:@"offerta_titolo_breve"],[self.dataModel objectForKey:@"offerta_descrizione_breve"],[self.dataModel objectForKey:@"offerta_condizioni_sintetiche"]] isHTML:YES];
			[controller setSubject:@"Coupon PerDue"];

			[self presentModalViewController:controller animated:YES];
			[controller release];
		} 
		if (buttonIndex == 1) { //facebook
//			if (appDelegate._session.isConnected) {
//				[self postToWall];
//			} else {
//				FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:appDelegate._session] autorelease];
//				[dialog show];
//			}
            if (![self.appDelegate.facebook isSessionValid]) {
                [self.appDelegate logIntoFacebook];
                waitingForFacebook = YES;
                //                [self postOnFacebookWall];
            }
            else{
                [self postToWall];
            }
            
		}
	}
	if(actionSheet==self.aSheet2) {
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

#pragma mark - MailComposerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View life cycle
	
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.reloadBtn setHidden:YES];
    [self.compraBtn setHidden:NO];
    [self.compraBtn setEnabled:NO];
	    
	if ( ![Utilita networkReachable]) {
        NSLog(@"INTERNET ASSENTE");
        self.titoloOffertaLbl.text = @" Connessione non disponibile!";
        [self.compraBtn setHidden:YES];
        [self.compraBtn setEnabled:NO];
        [self.reloadBtn setHidden:NO];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];
        return;
    }    
	
    NSLog(@"INTERNET PRESENTE");
    NSLog(@"VIEW DID APPEAR TIMER prima dell'invalidazione = %@",self.timer);
    [self.timer invalidate];
    self.timer = nil;
    
    self.titoloOffertaLbl.text = @" Caricamento...";
    if (isOffertaDelGiorno) {
        NSString *citycoupon;	
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        defaults = [NSUserDefaults standardUserDefaults];
        citycoupon=[defaults objectForKey:@"cittacoupon"];
        if ( (citycoupon ==nil) || ([citycoupon length]==0)){
            citycoupon=@"Roma";
            [defaults setObject:citycoupon forKey:@"cittacoupon"];
            [defaults setObject:[NSNumber numberWithInt:85] forKey:@"idcitycoupon"];	
            [defaults synchronize];
        }
        
        NSLog(@"Ho salvato il valore: %d",[[defaults objectForKey:@"idcitycoupon"]integerValue]);
        //self.navigationItem.title=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"cittacoupon"]];
        
        NSString *prov = [citycoupon stringByReplacingOccurrencesOfString:@" " withString:@"!"]; //inserisco un carattere speciale per gli spazi, nel file php verrà risostituito dallo spazio
        if(self.view.window){
            [self.caricamentoSpinner startAnimating];
            [self.dbAccess getCouponFromServer:prov];
        }
        
    } else { // !isOffertaDelGiorno
        if(self.view.window){
            [self.caricamentoSpinner startAnimating];
            [self.dbAccess getCouponFromServerWithId:self.idCoupon];
        }
    }
}


	
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (isOffertaDelGiorno)
        NSLog(@"Coupon::viewWillLoad: questa istanza rappresenta l'offerta del giorno.");
    else
        NSLog(@"Coupon::viewWillLoad: questa istanza rappresenta un coupon generico.");
    
    altezzaCella = 44.0;
    
    self.prezzoCouponLbl.layer.cornerRadius = 6;
    self.reloadBtn.layer.cornerRadius = 6;
    self.reloadBtn.layer.masksToBounds = YES;
    [self.reloadBtn setHidden:YES];
    
    NSLog(@"CLASSE COUPON DID LOAD");
    
    if (isOffertaDelGiorno) {
        self.navigationItem.title = @"Coupon del giorno";
    } else {
        self.navigationItem.title = @"Coupon";
    }
    
    //[compra setHidden:YES];
    [self.compraBtn setEnabled:NO];
    [self.compraBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    self.dbAccess = [[DatabaseAccess alloc] init];
    self.dbAccess.delegate = self;
    
    //quando passa da back a foreground rilancia la query per aggiornare la vista
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
	[[self.compraBtn layer] setCornerRadius:8.0f];
	[[self.compraBtn layer] setMasksToBounds:YES];
	[self.compraBtn setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
    
    if (isOffertaDelGiorno) {
        // Questo fa si che il button sinistro della navigation bar sia quadrato invece
        // che a freccia verso sx, e che apra la schermata Altre Offerte
        UIBarButtonItem *altreOfferteBtn = [[UIBarButtonItem alloc] initWithTitle:@"Altre offerte" style:UIBarButtonItemStyleBordered target:self action:@selector(AltreOfferte:)];
        self.navigationItem.leftBarButtonItem = altreOfferteBtn;
        [altreOfferteBtn release];
    }
    
    
    //FACEBOOK
    //###### FACEBOOK ########

    
    //logoutBtn = [[UIBarButtonItem alloc] initWithCustomView:tmpButton];
    
    self.appDelegate = (PerDueCItyCardAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    //controllo se ci sono token e sessione precedenti valide
    [self.appDelegate checkForPreviouslySavedAccessTokenInfo];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(FBdidLogout)
                                                 name:@"FBdidLogout"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(FBdidLogin)
                                                 name:@"FBdidLogin"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(FBerrLogin)
                                                 name:@"FBerrLogin"
                                               object:nil];
    
    waitingForFacebook = NO;

    
    

}	



- (void)viewWillAppear:(BOOL)animated {

    //[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
    
    [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow]  animated:YES];
    
    if(self.dataModel){
        NSLog(@"VIEW WILL APPEAR: allineo counter");
        NSDateFormatter *formatodb=[[NSDateFormatter alloc] init];
        [formatodb setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *now = [[NSDate alloc] init];
        NSString *scad = [NSString stringWithFormat:@"%@",[self.dataModel objectForKey:@"offerta_periodo_al"]];
        NSDate *datascadenza=[formatodb dateFromString:scad];
        secondsLeft =[datascadenza timeIntervalSinceDate:now];
        int days, hours, minutes, seconds;
        days= secondsLeft/(3600*24);
        hours = (secondsLeft - (days*24*3600))/3600;
        minutes = (secondsLeft - ((hours*3600)+(days*24*3600) ) ) / 60;
        seconds = secondsLeft % 60;
        //NSLog(@"time =%02d:%02d:%02d:%02d",days,hours, minutes, seconds);
        self.tempoLbl.text=[NSString stringWithFormat:@"%dg %02dh:%02dm:%02ds",days,hours, minutes, seconds];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    NSLog(@"WIEW WILL DISAPPEAR TIMER prima di invalidazione = %@",self.timer);
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"WIEW WILL DISAPPEAR TIMER dopo di invalidazione = %@", self.timer);
    [super viewDidDisappear:animated];
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    
    self.compraBtn = nil;
    [self.dataModel release];
    self.dataModel = nil;
    [super viewDidUnload];



}


- (void)dealloc {
    
    self.dbAccess.delegate = nil;
    self.dbAccess = nil;
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.reloadBtn release];
    [self.caricamentoSpinner release];
	//[url release];
	[self.dataModel release];
	[self.tableview release];		
	[self.timer release];
//	[wifiReach release];
//	[internetReach release];
	[self.FotoIngranditaImageView release];
	[self.faqViewController release];
//    [logoutBtn release];
//    logoutBtn = nil;
    [super dealloc];
}

#pragma mark - DatabaseAccessDelegate

-(void)didReceiveCoupon:(NSDictionary *)coupon;{
    [self.caricamentoSpinner stopAnimating];
    [self.compraBtn setEnabled:YES];
    
    /**/
    
    NSObject *a = [coupon objectForKey:@"Esercente"];
    if ((![a isKindOfClass:[NSArray class]])  ||  (((NSArray *) a).count == 0)) {
        self.dataModel = nil;
    }
    
    self.dataModel = [((NSArray *)a) objectAtIndex:0];
    
    /**/
    
    	
	if (!self.dataModel) { //niente coupon 
		self.titoloOffertaLbl.text=@"";
        [self.compraBtn setEnabled:NO];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Spiacenti" message:@"In questo momento non ci sono offerte per questa città" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
		[alert show];
		[alert release];
        
	} else { //offerta esite
		//[compra setHidden:NO];
        [self.compraBtn setEnabled:YES];
		self.titoloOffertaLbl.text=[NSString stringWithFormat:@"  Solo %@€, sconto %@%",[self.dataModel objectForKey:@"coupon_valore_acquisto"],[self.dataModel objectForKey:@"offerta_sconto_per"]];
        //identificativo è relativo all'offerta
		self.idCoupon=[[self.dataModel objectForKey:@"idofferta"]integerValue];
        
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,50,284,31)];
        myLabel.numberOfLines = 0;
        myLabel.lineBreakMode = UILineBreakModeWordWrap;
        myLabel.text = [self.dataModel objectForKey:@"offerta_titolo_breve"];
        [myLabel sizeToFit];
        CGSize labelSize = [myLabel.text sizeWithFont:myLabel.font 
                                    constrainedToSize:myLabel.frame.size 
                                        lineBreakMode:UILineBreakModeWordWrap];
        NSLog(@"ALTEZZA = %f",myLabel.frame.size.height);
        
        if(myLabel.frame.size.height <=21)
            altezzaCella = 44;
        else if(myLabel.frame.size.height <= 42)
            altezzaCella = 55;
        else if(myLabel.frame.size.height <= 63)
            altezzaCella = 67;
        else if(myLabel.frame.size.height <= 84)
            altezzaCella = 90;
        else if(myLabel.frame.size.height <= 105)
            altezzaCella = 110;
        
        [myLabel release];
         
        //MARIO: da qui recupero dati dell'esercente per la cella di informazioni relative ad esso(nuova view con dentro tutto, luogo, commenti ecc..)
        //MARIO: fa richiesta bloccante, quindi renderla asincrona  e soprattutto farla DOPO che si apre la pagina relativa all'esercente
        
        NSInteger idEsercente = [[self.dataModel objectForKey:@"idesercente"]integerValue];
        NSLog(@"L'id del ristorante da visualizzare è %d", idEsercente);
        NSURL *tipoEsercenteURL = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/tipoesercente.php?id=%d", idEsercente]];
        NSLog(@"tipoEsercenteURL: %@", tipoEsercenteURL);
		
		NSString *jsonreturn2 = [[NSString alloc] initWithContentsOfURL:tipoEsercenteURL];
		
		NSData *jsonData2 = [jsonreturn2 dataUsingEncoding:NSUTF8StringEncoding];
		NSError *error2 = nil;	
		
		NSDictionary *dict2 = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData2 error:&error2] retain];	
		
		NSMutableArray *r2=[[NSMutableArray alloc] init];
		
		if (dict2)
		{
			r2 = [[dict2 objectForKey:@"Esercente"] retain];
			
		}
		
		NSLog(@"Array2: %@",r2);
		if ([r2 count]==0){ //l'eserncente non ha contratto nel db, il suo dettaglio sarà una view più semplice (senza condizioni, commenti ecc..)
			tipodettaglio=CouponEsercenteSenzaContratto;
		}
		if ([r2 count]!=0){
			dict2 = [r2 objectAtIndex: 0];	
			NSInteger tipo=[[dict2 objectForKey:@"IdTipologia_Esercente"]integerValue];
			NSLog(@"Tipologia: %d",tipo);
			
			if( (tipo==2) || (tipo==5) || (tipo==6) || (tipo==9) || (tipo==59) || (tipo==60) || (tipo==61) || (tipo==27)){ //per dettaglio ristopub
				tipodettaglio=CouponEsercenteRistorazione;
			}
			else { //per dettaglio esercente generico
				tipodettaglio=CouponEsercente;
			}
		}				
	}
    

	[self.tableview reloadData];
    
    if(self.view.window){
        NSLog(@"DID RECEIVE COUPON prima di attivazione timer = %@",self.timer);
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        NSLog(@"DID RECEIVE COUPON dopo di attivazione timer = %@",self.timer);
    }
    [coupon release];
}


-(void)didReceiveError:(NSError *)error{
    NSLog(@"coupon: errore connessione: %@",[error description]);
    [self.caricamentoSpinner stopAnimating];
    [self.compraBtn setHidden:YES];
    self.titoloOffertaLbl.text = @" Errore caricamento, riprovare.";
    [self.reloadBtn setHidden:NO];
}

#pragma mark - FACEBOOK

-(void)logoutFromFB{
    //eseguo logout e rimuovo token
    [self.appDelegate.facebook logout:self.appDelegate];
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    //    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    //    [defaults synchronize];
}

-(void)FBdidLogout{
    //[self.navigationItem setRightBarButtonItem:nil animated:YES];
    
}

-(void)FBdidLogin{
    
    NSLog(@"fblogin");
    if(waitingForFacebook){
        [self postToWall];
        waitingForFacebook = NO;
    }
    [self.tableview reloadData];
}

-(void)FBerrLogin{
    waitingForFacebook = NO;
}

- (void)postToWall {
	
    NSString *linkHref = [NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/dettaglio_affare.jsp?idofferta=%@",[self.dataModel objectForKey:@"idofferta"]];
    
    NSString *stringCaption = [NSString stringWithFormat:@"<b>Descrizione:</b> %@, <b>Prezzo coupon:</b> %@€, <b>Invece di:</b> %@€, </b>Risparmio: </b>%@€ ",[self.dataModel objectForKey:@"offerta_titolo_breve"],[self.dataModel objectForKey:@"coupon_valore_acquisto"],[self.dataModel objectForKey:@"coupon_valore_facciale"],[self.dataModel objectForKey:@"offerta_sconto_va"]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"175161829247160", @"app_id",
                                   linkHref, @"link",
                                   @"http://www.cartaperdue.it/partner/icon.png", @"picture",
                                   @"Offerta da non perdere da PerDue - click per dettagli",@"name",
                                   stringCaption, @"caption",
                                   @"Scopri l'offerta del giorno - Acquista il coupon - Decidi quando utilizzarlo. Semplice, utile e versatile: questo è il tempo libero con PerDue!",@"description",
                                   nil];             
    [self.appDelegate.facebook dialog:@"feed" andParams:params andDelegate:self];
}


#pragma mark - FacebookDialogDelegate

- (void) dialogDidNotComplete:(FBDialog *)dialog
{
        NSLog(@"DIALOG DID NOT COMPLETE");
}

- (void)dialogCompleteWithUrl:(NSURL *)url{
    
    NSLog(@"DIALOG COMPLETE WITH URL : %@", [url absoluteString]);
    
    if ([[url absoluteString] rangeOfString:@"?post_id="].location == NSNotFound )
    {
        NSLog(@"post non inserito");
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messaggio pubblicato sulla tua bacheca" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
}


- (void) dialogDidNotCompleteWithUrl:(NSURL *)url{
    NSLog(@"DIALOG NOT COMPLETE WITH URL : %@", [url absoluteString]);
}


- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error{
    
    NSLog(@"DIALOG FAIL WITH ERROR: %@", error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"Non è stato possibile condividere questo contenuto su facebook, riprova" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


- (void)dialogDidComplete:(FBDialog *)dialog{
}


@end

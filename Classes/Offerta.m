//
//  Coupon.m
//  Per Due
//
//  Created by Giuseppe Lisanti on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Offerta.h"
#import "FBConnect.h"
#import "FBDialog.h"
#import "Facebook.h"
#import "PerDueCItyCardAppDelegate.h"
#import "DatabaseAccess.h"
#import "Utilita.h"

@implementation Offerta
@synthesize titolo,tempo,prezzoCoupon,prezzoOrig,sconto,risparmio,compra,tableview,timer,compratermini,comprasintesi,compradipiu,CellSpinner,fotoingrandita,photobig,faq,faqwebview,titololabel, offerta,identificativo;
/*facebook*/
@synthesize facebookAlert;
@synthesize username;
@synthesize post;
#define _APP_KEY @"223476134356120"
#define _SECRET_KEY @"6d2eaf75967fc247ac45aac716a4dd64"




//-(int)check:(Reachability*) curReach{
//	NetworkStatus netStatus = [curReach currentReachabilityStatus];
//	
//	switch (netStatus){
//		case NotReachable:{
//			return -1;
//			break;
//		}
//		default:
//			return 0;
//	}
//}



#pragma mark - UITableViewDataSourceDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if(rows>0)
		return 3;
	else 
		return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([rows count]==0) //coupon non disponibile
		return 0;
    
	switch (section) {
		case 0:
			return 2;
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:@"cellID"];
	
	if (indexPath.section==0){
        
        switch(indexPath.row){
            case 0:
                if (cell==nil){
                    [[NSBundle mainBundle] loadNibNamed:@"descrizioneOfferta" owner:self options:NULL];
                    cell=cellaDescrizioneOfferta;                    
                } 
                offerta.text = [dict objectForKey:@"offerta_titolo_breve"];
                //UILabel *offertaLabel = [[UILabel alloc] init];
                
                offerta.numberOfLines = 0;
                //                offertaLabel.minimumFontSize = 10.0;
                //                [offertaLabel setAdjustsFontSizeToFitWidth:YES];
                [offerta sizeToFit];
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                break;
            case 1:
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
                
                //offerta.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_titolo_breve"]];		
                [compra setTitle: [NSString stringWithFormat:@"Compra",[dict objectForKey:@"coupon_valore_acquisto"]] forState:UIControlStateNormal];
                prezzoCoupon.text=[NSString stringWithFormat:@"%@€",[dict objectForKey:@"coupon_valore_acquisto"]]; 
                sconto.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_sconto_per"]];
                risparmio.text=[NSString stringWithFormat:@"%@€",[dict objectForKey:@"offerta_sconto_va"]];
                prezzoOrig.text = [NSString stringWithFormat:@"%@€",[dict objectForKey:@"coupon_valore_facciale"]];
                
                NSDateFormatter *formatoapp = [[NSDateFormatter alloc] init];
                [formatoapp setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
                NSString *datadb = [NSString stringWithFormat:@"%@",[dict objectForKey:@"coupon_periodo_dal"]];
                NSDateFormatter *formatodb=[[NSDateFormatter alloc] init];
                [formatodb setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                //NSDate *d1=[formatodb dateFromString:datadb];
                //NSString *dataapp = [formatoapp stringFromDate:d1];
                
                CGRect frame;
                frame.size.width=101; frame.size.height=135;
                frame.origin.x=10; frame.origin.y=10;
                AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
                NSString *img=[NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[dict objectForKey:@"offerta_foto_big"]];
                NSURL *urlfoto = [NSURL URLWithString:img];
                asyncImage.tag = 999;
                
                [asyncImage loadImageFromURL:urlfoto];
                //[asyncImage setUserInteractionEnabled:YES];
                [cell.contentView addSubview:asyncImage];
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];  
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];  
                
                [doubleTap setNumberOfTapsRequired:2];  
                
                [asyncImage addGestureRecognizer:singleTap];  
                [asyncImage addGestureRecognizer:doubleTap];  
                
                NSDate *now = [[NSDate alloc] init];
                NSString *scad = [NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_periodo_al"]];
                NSDate *datascadenza=[formatodb dateFromString:scad];
                secondsLeft =[datascadenza timeIntervalSinceDate:now];
                int days, hours, minutes, seconds;
                days= secondsLeft/(3600*24);
                hours = (secondsLeft - (days*24*3600))/3600;
                minutes = (secondsLeft - ((hours*3600)+(days*24*3600) ) ) / 60;
                seconds = secondsLeft % 60;
                //NSLog(@"time =%02d:%02d:%02d:%02d",days,hours, minutes, seconds);
                tempo.text=[NSString stringWithFormat:@"%dg %02d:%02d:%02d",days,hours, minutes, seconds];
                //			timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            default:
                break;
        }
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
					t1.text = @"Dettagli offerta";
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


#pragma mark - UITtableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.section==0){
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
	if( (indexPath.section==1) &&(indexPath.row==2) )
		return 60;
	if( (indexPath.section==1) &&( (indexPath.row==0) || (indexPath.row==1) || (indexPath.row==3) ) )
        return 44;
	if(indexPath.section==2)
		return 44;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
    //mostra dettaglio offerta controller, è in questo controller, i dati sono stati già scaricati asincronamente
    
	if ( (indexPath.section==1) && (indexPath.row == 0)){
		//[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
		[insintesi setTitle:@"Dettagli offerta"];
		NSString *tit=[NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_titolo_breve"]];
		titololabel.text=tit;
		NSString *sitesiText=[NSString stringWithFormat:@"<body bgcolor=\"#8E1507\"><font face=\"Helvetica regular\"><span style=\"color: #FFFFFF;\"><span style=\"font-size: 60%;\">%@</body>",[dict objectForKey:@"offerta_descrizione_breve"]];
		[insintesitextWebView loadHTMLString:sitesiText baseURL:nil];
        //		[comprasintesi setTitle: [NSString stringWithFormat:@"Compra subito! Solo %@€",[dict objectForKey:@"coupon_valore_acquisto"]] forState:UIControlStateNormal];
        //		[[comprasintesi layer] setCornerRadius:8.0f];
        //		[[comprasintesi layer] setMasksToBounds:YES];
        //		[comprasintesi setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
        
		
		[self.navigationController pushViewController:insintesi animated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
        
	}
    
    //stessa filosofia di sopra
	if ( (indexPath.section==1) && (indexPath.row == 1)){
        //		[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
		[termini setTitle:@"Termini e condizioni"];
		NSString *condizioniText=[NSString stringWithFormat:@"<body bgcolor=\"#8E1507\"><font face=\"Helvetica regular\"><span style=\"color: #FFFFFF;\"><span style=\"font-size: 60%;\">%@</body>",[dict objectForKey:@"offerta_condizioni_sintetiche"]];
		[condizionitxtWebView loadHTMLString:condizioniText baseURL:nil];
        //		[compratermini setTitle: [NSString stringWithFormat:@"Compra subito! Solo €%@",[dict objectForKey:@"coupon_valore_acquisto"]] forState:UIControlStateNormal];
        //		[[compratermini layer] setCornerRadius:8.0f];
        //		[[compratermini layer] setMasksToBounds:YES];
        //		[compratermini setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
		
		[self.navigationController pushViewController:termini animated:YES];
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
    
    
	if ( (indexPath.section==1) && (indexPath.row == 2)){
        //		[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
		
        [contatti setTitle:@"Info Esercente"];
		
        if(tipodettaglio==1){ //dettglio ristopub
            //			detail = [[DettaglioRistoCoupon alloc] initWithNibName:@"DettaglioRistoCoupon" bundle:[NSBundle mainBundle]];
            //			[(DettaglioRistoCoupon*)detail setIdentificativo:identificativoesercente];
            //			[detail setTitle:@"Esercente"];
            //			//Facciamo visualizzare la vista con i dettagli
            //			[self.navigationController pushViewController:detail animated:YES];
            
            NSLog(@" OFFERTA: ESERCENTE RISTOPUB");
            
            DettaglioRistoCoupon *dettaglioRistoCoup = [[DettaglioRistoCoupon alloc] initWithNibName:@"DettaglioRistoCoupon" bundle:[NSBundle mainBundle]];
            [dettaglioRistoCoup setIdentificativo:identificativoesercente];
            [dettaglioRistoCoup setTitle:@"Esercente"];
            [self.navigationController pushViewController:dettaglioRistoCoup animated:YES];
		}	
		else if (tipodettaglio==2) {
                //esercente generico
                NSLog(@"OFFERTA: ESERCENTE GENERICO");
                //				[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
                //				detail = [[DettaglioEsercenteCoupon alloc] initWithNibName:@"DettaglioEsercenteCoupon" bundle:[NSBundle mainBundle]];
                //				[(DettaglioEsercenteCoupon*)detail setIdentificativo:identificativoesercente];
                //				[detail setTitle:@"Esercente"];				//Facciamo visualizzare la vista con i dettagli
                //				[self.navigationController pushViewController:detail animated:YES];
                
                DettaglioEsercenteCoupon *dettaglioEseCoup = [[DettaglioEsercenteCoupon alloc] initWithNibName:@"DettaglioEsercenteCoupon" bundle:[NSBundle mainBundle]];
                [dettaglioEseCoup setIdentificativo:identificativoesercente];
                [dettaglioEseCoup setTitle:@"Esercente"];
                [self.navigationController pushViewController:dettaglioEseCoup animated:YES];
        }
		else { 
            NSLog(@"OFFERTA: ESERCENTE GENERICO SENZA CONTRATTO");
                //esercente generico senza contratto
                //				[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
                //				detail = [[DettaglioEsercenteGenerico alloc] initWithNibName:@"DettaglioEsercenteGenerico" bundle:[NSBundle mainBundle]];
                //				[(DettaglioEsercenteGenerico*)detail setIdentificativo:identificativoesercente];
                //				[detail setTitle:@"Esercente"];				
                //				//Facciamo visualizzare la vista con i dettagli
                //				[self.navigationController pushViewController:detail animated:YES];
                DettaglioEsercenteGenerico *dettaglioEseGen = [[DettaglioEsercenteGenerico alloc] initWithNibName:@"DettaglioEsercenteGenerico" bundle:[NSBundle mainBundle]];
                [dettaglioEseGen setIdentificativo:identificativoesercente];
                [dettaglioEseGen setTitle:@"Esercente"];
                [self.navigationController pushViewController:dettaglioEseGen animated:YES];
		}
        
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
    
	if ( (indexPath.section==1) && (indexPath.row == 3)){
		//[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
		[dipiu setTitle:@"Per saperne di più..."];
		NSString *dipiuText=[NSString stringWithFormat:@"<body bgcolor=\"#8E1507\"><font face=\"Helvetica regular\"><span style=\"color: #FFFFFF;\"><span style=\"font-size: 60%;\">%@</body>",[dict objectForKey:@"offerta_descrizione_estesa"]];
		[dipiutextWebView loadHTMLString:dipiuText baseURL:nil];
        //		[compradipiu setTitle: [NSString stringWithFormat:@"Compra subito! Solo €%@",[dict objectForKey:@"coupon_valore_acquisto"]] forState:UIControlStateNormal];
        //		[[compradipiu layer] setCornerRadius:8.0f];
        //		[[compradipiu layer] setMasksToBounds:YES];
        //		[compradipiu setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
		
		[self.navigationController pushViewController:dipiu animated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
	}
	if ( (indexPath.section==2) && (indexPath.row == 0)){
		//PerDueCItyCardAppDelegate *appDelegate = (PerDueCItyCardAppDelegate*)[[UIApplication sharedApplication]delegate];
		
        //mostra il tasto per il logout se connesso
        if([appDelegate.facebook isSessionValid]){
            NSLog(@"DID LOAD CONNECTED");
            aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Condividi questa offerta con i tuoi amici"] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:@"Logout da Facebook" otherButtonTitles:@"Invia email", @"Condividi su Facebook", nil];
        }
        else{
            NSLog(@"DID LOAD NOT CONNECTED");
            aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Condividi questa offerta con i tuoi amici"] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Invia email", @"Condividi su Facebook", nil];
        }
        
        //        aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Condividi questa offerta con i tuoi amici"] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Invia email", @"Condividi su Facebook", nil];
		
		[aSheet showInView:appDelegate.window];
		[aSheet release];			
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
        
	}
	if ( (indexPath.section==2) && (indexPath.row == 1)){
        //		PerDueCItyCardAppDelegate *appDelegate = (PerDueCItyCardAppDelegate*)[[UIApplication sharedApplication]delegate];
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

#pragma mark - Gestione view e bottoni

//- (IBAction)Opzioni:(id)sender{
//	OpzioniCoupon *opt = [[[OpzioniCoupon alloc] init] autorelease];
//    if ( [timer isValid]){
//        [timer invalidate];
//        timer=nil;
//    }
//    [self presentModalViewController:opt animated:YES];
//    
//}



-(void)Paga:(id)sender{
	if ([rows count]>0) {//coupon disponibile
		if(secondsLeft>0) {
            //			detail = [[Pagamento2 alloc] initWithNibName:@"Pagamento2" bundle:[NSBundle mainBundle]];
            //			[(Pagamento2*)detail setValore:[[dict objectForKey:@"coupon_valore_acquisto"]doubleValue]];
            //			NSLog(@"Valore:%f",[[dict objectForKey:@"coupon_valore_acquisto"]doubleValue]);
            //			[(Pagamento2*)detail setIdentificativo:identificativo];
            //            
            //			NSString *tit=[NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_titolo_breve"]];
            //			NSLog(@"Titolo:%@",tit);
            //			[(Pagamento2*)detail setTitolo:tit];
            //            
            //			[detail setTitle:@"Acquisto"];
            //			[self.navigationController pushViewController:detail animated:YES];
            
            Pagamento2 *pagamentoController = [[Pagamento2 alloc] initWithNibName:@"Pagamento2" bundle:[NSBundle mainBundle]];
            [pagamentoController setValore:[[dict objectForKey:@"coupon_valore_acquisto"]doubleValue]];
            NSLog(@"Valore:%f",[[dict objectForKey:@"coupon_valore_acquisto"]doubleValue]);
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
}


- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {  
	NSString *img=[NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[dict objectForKey:@"offerta_foto_big"]];
	NSURL *urlfoto = [NSURL URLWithString:img];
	NSData *data = [[NSData alloc] initWithContentsOfURL:urlfoto];
	UIImage *tempImage = [[UIImage alloc] initWithData:data];
	
	photobig.image = tempImage;
	[self presentModalViewController:fotoingrandita animated:YES];
    [tempImage release];
	
	
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {  
	NSString *img=[NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[dict objectForKey:@"offerta_foto_big"]];
	NSURL *urlfoto = [NSURL URLWithString:img];
	NSData *data = [[NSData alloc] initWithContentsOfURL:urlfoto];
	UIImage *tempImage = [[UIImage alloc] initWithData:data];
	
	photobig.image = tempImage;
	[self presentModalViewController:fotoingrandita animated:YES];
    [tempImage release];
}

- (IBAction)chiudi:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}
- (void)countDown{
    
    //NSLog(@"RICHIAMATO COUNT DOWN");
	int days, hours, minutes, seconds;
	if (secondsLeft>0) {
		secondsLeft=secondsLeft-1;
		days= secondsLeft/(3600*24);
		hours = (secondsLeft - (days*24*3600))/3600;
		minutes = (secondsLeft - ((hours*3600)+(days*24*3600) ) ) / 60;
		seconds = secondsLeft % 60;
		tempo.text=[NSString stringWithFormat:@"%dg %02d:%02d:%02d",days,hours, minutes, seconds];
	}
	else{
		secondsLeft=0;
		tempo.text=[NSString stringWithFormat:@"Offerta scaduta!"];
		[timer invalidate];
        timer = nil;
	}
}

- (IBAction)AltreOfferte:(id)sender {
	//[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
    
    //	detail = [[AltreOfferte alloc] initWithNibName:@"AltreOfferte" bundle:[NSBundle mainBundle]];
    //	[detail setTitle:@"Altre Offerte"];
    //	//Facciamo visualizzare la vista con i dettagli
    //	[self.navigationController pushViewController:detail animated:YES];
    
    AltreOfferte *altreOfferteController = [[AltreOfferte alloc] initWithNibName:@"AltreOfferte" bundle:[NSBundle mainBundle]];
    altreOfferteController.title = @"Altre Offerte";
    [self.navigationController pushViewController:altreOfferteController animated:YES];
    [altreOfferteController release];
	
}

#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(actionSheet==aSheet) {
		
        NSLog(@" numero di bottoni = %d", actionSheet.numberOfButtons);
        
        
        if(actionSheet.numberOfButtons == 4){
            if(buttonIndex == 0){
                NSLog(@"richiamo logout facebook");
                [self logoutFromFB];
                return;
                
            }
            else{
                buttonIndex -= 1;
            }
        }
        
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
            //			if (appDelegate._session.isConnected) {
            //				[self postToWall];
            //			} else {
            //				FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:appDelegate._session] autorelease];
            //				[dialog show];
            //			}
            if (![appDelegate.facebook isSessionValid]) {
                [appDelegate logIntoFacebook];
                waitingForFacebook = YES;
                //                [self postOnFacebookWall];
            }
            else{
                [self postToWall];
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

#pragma mark - MailComposerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View life cycle

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [compra setHidden:YES];
    
    //	timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    //    int wifi=0;
    //	int internet=0;
    //	internetReach = [[Reachability reachabilityForInternetConnection] retain];
    //	internet= [self check:internetReach];
    //	
    //	wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
    //	wifi=[self check:wifiReach];	
    
	if( ! [Utilita networkReachable]){
        NSLog(@"INTERNET ASSENTE");
        
        titolo.text = @" Internet assente!";
        [compra setHidden:YES];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];
        
	}
    else{
        
        NSLog(@"INTERNET PRESENTE");
        
        NSLog(@"VIEW DID APPEAR TIMER prima dell'invalidazione = %@",timer);
        [timer invalidate];
        timer = nil;
        
        titolo.text = @" Caricamento...";
//        NSString *citycoupon;	
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        defaults = [NSUserDefaults standardUserDefaults];
//        citycoupon=[defaults objectForKey:@"cittacoupon"];
//        if ( ([citycoupon length]==0) ||  (citycoupon ==nil) ){
//            citycoupon=@"Roma";
//            [defaults setObject:citycoupon forKey:@"cittacoupon"];
//            [defaults setObject:[NSNumber numberWithInt:85] forKey:@"idcitycoupon"];	
//            [defaults synchronize];
//        }
//        
//        NSLog(@"Ho salvato il valore: %d",[[defaults objectForKey:@"idcitycoupon"]integerValue]);
       // self.navigationItem.title=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"cittacoupon"]];
        
        
        
        //NSString *prov= [citycoupon stringByReplacingOccurrencesOfString:@" " withString:@"!"]; //inserisco un carattere speciale per gli spazi, nel file php verrà risostituito dallo spazio
        
        //[dbAccess getCouponFromServer:prov];
        
        //url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/coupon.php?prov=%@",prov]];
        
        //NSLog(@"Url: %@", url);
        
        //NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url];
        //NSLog(@"%@",jsonreturn); // Look at the console and you can see what the restults are
        
        //NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF8StringEncoding];
        //NSError *error = nil;	
        
        //dict = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error] retain];	
        
        if(self.view.window){
        [caricamentoSpinner startAnimating];
        [dbAccess getCouponFromServerWithId:identificativo];
        }
    }
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"CLASSE OFFERTA DID LOAD");
    
    [compra setHidden:YES];
    
    altezzaCella = 44.0;
    
    dbAccess = [[DatabaseAccess alloc] init];
    dbAccess.delegate = self;
    
    //quando passa da back a foreground rilancia la query per aggiornare la vista
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
	[[compra layer] setCornerRadius:8.0f];
	[[compra layer] setMasksToBounds:YES];
	[compra setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
    
    //    UIBarButtonItem *cittaBtn = [[UIBarButtonItem alloc] initWithTitle:@"Città" style:UIBarButtonItemStyleBordered target:self action:@selector(Opzioni:)];
    //    self.navigationItem.leftBarButtonItem = cittaBtn;
    //    [cittaBtn release];
    
    //FACEBOOK
    //###### FACEBOOK ########
    
    
    //logoutBtn = [[UIBarButtonItem alloc] initWithCustomView:tmpButton];
    
    appDelegate = (PerDueCItyCardAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    //controllo se ci sono token e sessione precedenti valide
    [appDelegate checkForPreviouslySavedAccessTokenInfo];
    
    
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
    
    
    
    if(dict){
        NSLog(@"VIEW WILL APPEAR: allineo counter");
        NSDateFormatter *formatodb=[[NSDateFormatter alloc] init];
        [formatodb setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *now = [[NSDate alloc] init];
        NSString *scad = [NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_periodo_al"]];
        NSDate *datascadenza=[formatodb dateFromString:scad];
        secondsLeft =[datascadenza timeIntervalSinceDate:now];
        int days, hours, minutes, seconds;
        days= secondsLeft/(3600*24);
        hours = (secondsLeft - (days*24*3600))/3600;
        minutes = (secondsLeft - ((hours*3600)+(days*24*3600) ) ) / 60;
        seconds = secondsLeft % 60;
        //NSLog(@"time =%02d:%02d:%02d:%02d",days,hours, minutes, seconds);
        tempo.text=[NSString stringWithFormat:@"%dg %02d:%02d:%02d",days,hours, minutes, seconds];
    }
    
    
    
    //    [timer invalidate];
    //    timer = nil;
    
    /*
     
     int wifi=0;
     int internet=0;
     internetReach = [[Reachability reachabilityForInternetConnection] retain];
     internet= [self check:internetReach];
     
     wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
     wifi=[self check:wifiReach];	
     if( (internet==-1) &&( wifi==-1) ){
     NSLog(@"INTERNET ASSENTE");
     
     titolo.text = @" Internet assente!";
     [compra setHidden:YES];
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
     [alert show];
     [alert release];
     
     }
     else{
     
     NSLog(@"INTERNET PRESENTE");
     
     NSLog(@"VIEW WILL APPEAR TIMER prima dell'invalidazione = %@",timer);
     [timer invalidate];
     timer = nil;
     
     [compra setHidden:NO];
     titolo.text = @" Caricamento...";
     NSString *citycoupon;	
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     defaults = [NSUserDefaults standardUserDefaults];
     citycoupon=[defaults objectForKey:@"cittacoupon"];
     if ( ([citycoupon length]==0) ||  (citycoupon ==nil) ){
     citycoupon=@"Roma";
     [defaults setObject:citycoupon forKey:@"cittacoupon"];
     [defaults setObject:[NSNumber numberWithInt:85] forKey:@"idcitycoupon"];	
     [defaults synchronize];
     }
     
     NSLog(@"Ho salvato il valore: %ld",[[defaults objectForKey:@"idcitycoupon"]integerValue]);
     self.navigationItem.title=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"cittacoupon"]];
     
     
     
     NSString *prov= [citycoupon stringByReplacingOccurrencesOfString:@" " withString:@"!"]; //inserisco un carattere speciale per gli spazi, nel file php verrà risostituito dallo spazio
     
     //[dbAccess getCouponFromServer:prov];
     
     //url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/coupon.php?prov=%@",prov]];
     
     NSLog(@"Url: %@", url);
     
     //NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url];
     //NSLog(@"%@",jsonreturn); // Look at the console and you can see what the restults are
     
     //NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF8StringEncoding];
     //NSError *error = nil;	
     
     //dict = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error] retain];	
     
     if(self.view.window){
     [caricamentoSpinner startAnimating];
     [dbAccess getCouponFromServer:prov];
     }
     }
     
     */
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //	if([rows count]>0){ //c'è un coupon
    //        [timer invalidate];
    //	}
    
    //    NSLog(@"WIEW WILL DISAPPEAR TIMER prima di invalidazione = %@",timer);
    //    //if(timer){
    //        //NSLog(@"INVALIDO TIMEE");
    //        //if([timer isValid]){
    //            //NSLog(@"TIMER VALIDO");
    //            [timer invalidate];
    //            timer = nil;
    //            NSLog(@"WIEW WILL DISAPPEAR TIMER dopo di invalidazione = %@", timer);
    //}
    //}
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    NSLog(@"WIEW WILL DISAPPEAR TIMER prima di invalidazione = %@",timer);
    [timer invalidate];
    timer = nil;
    NSLog(@"WIEW WILL DISAPPEAR TIMER dopo di invalidazione = %@", timer);
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
    
    self.compra = nil;
    [dict release];
    dict = nil;
    [super viewDidUnload];
    
    
    
}


- (void)dealloc {
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [caricamentoSpinner release];
	
    [rows release];
	[dict2 release];
	[dict release];
	
    [tableview release];		
	[timer release];
	[photobig release];
	[faq release];
    
    dbAccess.delegate = nil;
    [dbAccess release];
    
    [insintesi release];
    [termini release];
    [contatti release];
    [dipiu release];
    
    [insintesitextWebView release];
    [condizionitxtWebView release];
    [dipiutextWebView release];
    
    [fotoingrandita release];
    
    [super dealloc];
}

#pragma mark - DatabaseAccessDelegate

-(void)didReceiveCoupon:(NSDictionary *)coupon;
{
    [caricamentoSpinner stopAnimating];
    [compra setHidden:NO];
    
    dict = [coupon retain];
    
    //NSLog(@"DICT MARIOz \n: %@",dict);
    
    NSMutableArray *r=[[NSMutableArray alloc] init];
	
	if (dict)
	{
        //NSLog(@"dict = %@", dict);
		r = [[dict objectForKey:@"Esercente"] retain];
		//NSLog(@"R MARIO \n %@",r);
	}
	
	//NSLog(@"Array: %@",r);	
	rows= [[NSMutableArray alloc]init];
	[rows addObjectsFromArray: r];
	
	NSLog(@"Numero totale di rows:%d",[rows count]);
	
    //	[jsonreturn release];
    //	jsonreturn=nil;
	[r release];
	r=nil;
	
	if([rows count]==0){ //niente coupon 
		titolo.text=@"";
		
		[compra setHidden:YES];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Spiacenti" message:@"In questo momento non ci sono offerte per questa città" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
		[alert show];
		[alert release];
	}
	
	else { //offerta esite
		[compra setHidden:NO];
		dict = [rows objectAtIndex: 0];
		titolo.text=[NSString stringWithFormat:@"  Solo %@€, sconto %@%",[dict objectForKey:@"coupon_valore_acquisto"],[dict objectForKey:@"offerta_sconto_per"]];
        //identificativo è relativo all'offerta
		//identificativo=[[dict objectForKey:@"idofferta"]integerValue];
		identificativoesercente=[[dict objectForKey:@"idesercente"]integerValue];
        
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,50,284,31)];
        myLabel.numberOfLines = 0;
        myLabel.lineBreakMode = UILineBreakModeWordWrap;
        myLabel.text = [dict objectForKey:@"offerta_titolo_breve"];
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
        else altezzaCella = 44;
        
        [myLabel release];
        
        //MARIO: da qui recupero dati dell'esercente per la cella di informazioni relative ad esso(nuova view con dentro tutto, luogo, commenti ecc..)
        //MARIO: fa richiesta bloccante, quindi renderla asincrona  e soprattutto farla DOPO che si apre la pagina relativa all'esercente
        
        NSLog(@"L'id del ristorante da visualizzare è %d",identificativoesercente);
		NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/tipoesercente.php?id=%d",identificativoesercente]];
		NSLog(@"Url2: %@", url2);
		
		NSString *jsonreturn2 = [[NSString alloc] initWithContentsOfURL:url2];
		//NSLog(@"%@",jsonreturn2); // Look at the console and you can see what the restults are
		
		NSData *jsonData2 = [jsonreturn2 dataUsingEncoding:NSUTF8StringEncoding];
		NSError *error2 = nil;	
		
		dict2 = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData2 error:&error2] retain];	
		
		NSMutableArray *r2=[[NSMutableArray alloc] init];
		
		if (dict2)
		{
			r2 = [[dict2 objectForKey:@"Esercente"] retain];
			
		}
		
		NSLog(@"Array2: %@",r2);
		if ([r2 count]==0){ //l'eserncente non ha contratto nel db, il suo dettaglio sarà una view più semplice (senza condizioni, commenti ecc..)
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
	}
	
	
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //defaults = [NSUserDefaults standardUserDefaults];
	//self.navigationItem.title=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"cittacoupon"]];
    
    
	[tableview reloadData];
    
    if(self.view.window){
        NSLog(@"DID RECEIVE COUPON prima di attivazione timer = %@",timer);
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        NSLog(@"DID RECEIVE COUPON dopo di attivazione timer = %@",timer);
    }
    //DA METTERE [dict release];
    
}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"OFFERTA: errore connessione: %@",[error description]);
    [caricamentoSpinner stopAnimating];
    [compra setHidden:YES];
}

#pragma mark - FACEBOOK

-(void)logoutFromFB{
    //eseguo logout e rimuovo token
    [appDelegate.facebook logout:appDelegate];
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
	
    //FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease];
	
	NSString *name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"offerta_titolo_breve"]] ; 
    NSString *href = @"http://www.cartaperdue.it";
	
    NSString *caption = @"Carta PerDue - Sconti da vivere subito nella tua citta!";
    NSString *description = [NSString stringWithFormat:@"Scopri l'offerta del giorno - Acquista il coupon - Decidi quando utilizzarlo. Semplice, utile e versatile: questo è il tempo libero con PerDue!"]; 
    NSString *imageSource = [NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[dict objectForKey:@"offerta_foto_vetrina"]];
    NSString *imageHref =[NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/img_offerte/%@",[dict objectForKey:@"offerta_foto_big"]];
	
    NSString *linkTitle = @"Per ulteriori dettagli";
    NSString *linkText = @"Vedi l'offerta";
    NSString *linkHref = [NSString stringWithFormat:@"http://www.cartaperdue.it/coupon/dettaglio_affare.jsp?idofferta=%@",[dict objectForKey:@"idofferta"]];
    /* dialog.attachment = [NSString stringWithFormat:
     @"{ \"name\":\"%@\","
     "\"href\":\"%@\","
     "\"caption\":\"%@\",\"description\":\"%@\","
     "\"media\":[{\"type\":\"image\","
     "\"src\":\"%@\","
     "\"href\":\"%@\"}],"
     "\"properties\":{\"%@\":{\"text\":\"%@\",\"href\":\"%@\"}}}", name, href, caption, description, imageSource, imageHref, linkTitle, linkText, linkHref];*/
    //[dialog show];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"223476134356120", @"app_id",
                                   @"www.google.it", @"link",
                                   @"", @"picture",
                                   @"Segnalazione di un'offerta", @"name",
                                   [NSString stringWithFormat:
                                    @"{ \"name\":\"%@\","
                                    "\"href\":\"%@\","
                                    "\"caption\":\"%@\",\"description\":\"%@\","
                                    "\"media\":[{\"type\":\"image\","
                                    "\"src\":\"%@\","
                                    "\"href\":\"%@\"}],"
                                    "\"properties\":{\"%@\":{\"text\":\"%@\",\"href\":\"%@\"}}}", name, href, caption, description, imageSource, imageHref, linkTitle, linkText, linkHref],@"caption",
                                   [NSString stringWithFormat:
                                    @"{ \"name\":\"%@\","
                                    "\"href\":\"%@\","
                                    "\"caption\":\"%@\",\"description\":\"%@\","
                                    "\"media\":[{\"type\":\"image\","
                                    "\"src\":\"%@\","
                                    "\"href\":\"%@\"}],"
                                    "\"properties\":{\"%@\":{\"text\":\"%@\",\"href\":\"%@\"}}}", name, href, caption, description, imageSource, imageHref, linkTitle, linkText, linkHref],@"description",
                                   nil];                
    //[facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self]; 
    
    [appDelegate.facebook dialog:@"feed" andParams:params andDelegate:self];
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

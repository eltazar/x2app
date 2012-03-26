//
//  Pagamento2.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Pagamento2.h"
#import "DatiPagamentoController.h"
//#import "DatiUtenteController.h"
#import "DatabaseAccess.h"
#import "DataLoginController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface Pagamento2() {
    UIAlertView *buyAlert;
}
@end


@implementation Pagamento2
@synthesize titolo,valore,identificativo,tablegenerale,totale,datopersonale,vistadatipagamento,vistadatipersonali,info, titololabel, idUtente,utente,email;

/*
-(BOOL)validaDatiUtente{
    
    //dati persona
    NSString *nome = [[NSUserDefaults standardUserDefaults] objectForKey:@"_nomeUtente"];
	NSString *cognome = [[NSUserDefaults standardUserDefaults] objectForKey:@"_cognome"];
	NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"_email"];
	NSString *telefono = [[NSUserDefaults standardUserDefaults] objectForKey:@"_telefono"];
    
    //NSLog(@" nome = %@, cognome = %@, email = %@, telefono = %@", nome,cognome,email, telefono);
    
    if( (nome && nome.length > 0) && (cognome && cognome.length > 0) &&
       (email && email.length > 0) && (telefono && telefono.length >0)){
        return TRUE;
    }
    
    return FALSE;
}
*/

-(BOOL)validaDatiCartaCredito{
    
    //dati carta
	NSString *tipocarta = [[NSUserDefaults standardUserDefaults] objectForKey:@"_tipoCarta"];
	NSString *numerocarta = [[NSUserDefaults standardUserDefaults] objectForKey:@"_numero"];
	NSString *scadenza = [[NSUserDefaults standardUserDefaults] objectForKey:@"_scadenza"];
    NSArray *componentiScadenza = [scadenza componentsSeparatedByString:@"/"];
    NSString *mesescadenza = [componentiScadenza objectAtIndex:0];
    NSString *annoscadenza = [componentiScadenza objectAtIndex:1];
    NSLog(@"scadenza = %@, mese = %@, anno %@",scadenza,mesescadenza, annoscadenza);
	NSString *cvv = [[NSUserDefaults standardUserDefaults] objectForKey:@"_cvv"];
	NSString *intestatario = [[NSUserDefaults standardUserDefaults] objectForKey:@"_nome"];
    
    NSLog(@"tipo carta = %@, numero = %@, mese  = %@, anno = %@, cvv = %@, intestatario = %@", tipocarta, numerocarta, mesescadenza, annoscadenza, cvv, intestatario);
    
    if( (tipocarta && tipocarta.length > 0) && (numerocarta && numerocarta.length > 0) &&
       (mesescadenza && mesescadenza.length >0) && (annoscadenza && annoscadenza.length > 0) &&
       (cvv && cvv.length > 0) && (intestatario && intestatario.length > 0)){
           return TRUE;
    }
       
    return FALSE;
}


- (IBAction)compra:(id)sender {    

    if( /*! [self validaDatiUtente] ||*/ ! [self validaDatiCartaCredito]){

        NSLog(@"dati utenti mancanti");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Inserire tutti i dati" message:@"Devi inserire tutti i dati della carta di credito per effettuare l'acquisto" delegate:self cancelButtonTitle:@"Non ora" otherButtonTitles:@"Inserisci",nil];
        [alert show];
        [alert release];
	}
    else if(quant <= 0){
        
        NSLog(@"quantità 0 o minore");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Acquista almeno un coupon" message:@"Il numero di coupon per procedere con l'acquisto deve essere maggiore di zero" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];

    }
    else{
//        PerDueCItyCardAppDelegate *appDelegate = (PerDueCItyCardAppDelegate*)[[UIApplication sharedApplication]delegate];
//        UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Vuoi comprare il coupon?"] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Compra", nil];
//        
//        [aSheet showInView:appDelegate.window];
//        [aSheet release];
        
        [buyAlert show];
    }
	
	
}

//sheet relativo a "compra" o "annulla" 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
	
        //recupera dati pagamento e dati cliente
        
        /*
        NSString *nome = [[NSUserDefaults standardUserDefaults] objectForKey:@"_nomeUtente"];
		NSString *cognome = [[NSUserDefaults standardUserDefaults] objectForKey:@"_cognome"];
		//mario: perchè rimuove spazi :|???
        //cognome=[cognome stringByReplacingOccurrencesOfString:@" " withString:@""]; //elimino eventuali spazi        
		NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"_email"];
		NSString *telefono = [[NSUserDefaults standardUserDefaults] objectForKey:@"_telefono"];
         */
        
		NSString *tipocarta = [[NSUserDefaults standardUserDefaults] objectForKey:@"_tipoCarta"];
		tipocarta=[tipocarta stringByReplacingOccurrencesOfString:@" " withString:@""]; //elimino spazi
		NSString *numerocarta = [[NSUserDefaults standardUserDefaults] objectForKey:@"_numero"];
        
		NSString *scadenza = [[NSUserDefaults standardUserDefaults] objectForKey:@"_scadenza"];
        NSArray *componentiScadenza = [scadenza componentsSeparatedByString:@"/"];
        NSString *mesescadenza = [componentiScadenza objectAtIndex:0];
        NSString *annoscadenza = [componentiScadenza objectAtIndex:1];
        //NSLog(@"scadenza = %@, mese = %@, anno %@",scadenza,mesescadenza, annoscadenza);
        
        NSString *cvv = [[NSUserDefaults standardUserDefaults] objectForKey:@"_cvv"];
        NSString *intestatario = [[NSUserDefaults standardUserDefaults] objectForKey:@"_nome"];	
        
       //mario: perchè deve eliminare gli spazi :| ???
        //intestatario=[intestatario stringByReplacingOccurrencesOfString:@" " withString:@""]; //elimino eventuali spazi
		
        NSString *idiphone=[[NSString alloc ]initWithFormat:@"%@", [[UIDevice currentDevice] uniqueIdentifier]];
        
        NSLog(@"PAGAMENTO AVVIATO IDENTIFICATIVO = %d",identificativo);
      
        NSLog(@"PAGAMENTO: ID UTENTE da server = %d",idUtente);
        
        //se il controller è stato richiamato senza login idutente lo devo recuperare dall'iphone
        if(idUtente == -1){
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

            idUtente = [[prefs objectForKey:@"_idUtente"] intValue];
             NSLog(@"PAGAMENTO: ID UTENTE da prefs = %d",idUtente);
        }
       

        //identificativo è relativo all'offerta, cioè è id coupon
        
        [dbAccess buyCouponRequest:[NSString stringWithFormat: @"identificativo=%d&idiphone=%@&quantita=%d&valore=%.2f&importo=%f&idUtente=%d&tipocarta=%@&numerocarta=%@&mesescadenza=%d&annoscadenza=%d&intestatario=%@&cvv=%@",identificativo,idiphone,quant,valore,totale,idUtente,tipocarta,numerocarta,[mesescadenza integerValue],[annoscadenza integerValue],intestatario,cvv]];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_cvv"];
        
	} 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {  
   
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];  
	    
    if([title isEqualToString:@"Inserisci"])  { 
        /*
		if( ! [self validaDatiUtente] ){
            //dati personali incompleti
            DatiUtenteController *userDetail = [[DatiUtenteController alloc] initWithNibName:@"DatiUtenteController" bundle:nil];
            userDetail.delegate = self;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:userDetail];
            [userDetail release];
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentModalViewController:navController animated:YES];
            [navController release];
		}*/
        
        if( ! [self validaDatiCartaCredito] ) {
            
            //dati personali completi, vado ai dati pagamento            
            DatiPagamentoController *paymentDetail = [[DatiPagamentoController alloc] initWithNibName:@"DatiPagamentoController" bundle:nil];
            paymentDetail.delegate = self;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:paymentDetail];
            [paymentDetail release];
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentModalViewController:navController animated:YES];
            [navController release];
		}

		
	}
    if([alertView.title isEqualToString:@"Complimenti"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    //alert view di conferma acquiso coupon
    if([alertView.title isEqualToString:@"Vuoi comprare il coupon?"]){
        if(buttonIndex == 1){
            NSString *tipocarta = [[NSUserDefaults standardUserDefaults] objectForKey:@"_tipoCarta"];
            tipocarta=[tipocarta stringByReplacingOccurrencesOfString:@" " withString:@""]; //elimino spazi
            NSString *numerocarta = [[NSUserDefaults standardUserDefaults] objectForKey:@"_numero"];
            
            NSString *scadenza = [[NSUserDefaults standardUserDefaults] objectForKey:@"_scadenza"];
            NSArray *componentiScadenza = [scadenza componentsSeparatedByString:@"/"];
            NSString *mesescadenza = [componentiScadenza objectAtIndex:0];
            NSString *annoscadenza = [componentiScadenza objectAtIndex:1];
            //NSLog(@"scadenza = %@, mese = %@, anno %@",scadenza,mesescadenza, annoscadenza);
            
            NSString *cvv = [[NSUserDefaults standardUserDefaults] objectForKey:@"_cvv"];
            NSString *intestatario = [[NSUserDefaults standardUserDefaults] objectForKey:@"_nome"];	
            
            //mario: perchè deve eliminare gli spazi :| ???
            //intestatario=[intestatario stringByReplacingOccurrencesOfString:@" " withString:@""]; //elimino eventuali spazi
            
            NSString *idiphone=[[NSString alloc ]initWithFormat:@"%@", [[UIDevice currentDevice] uniqueIdentifier]];
            
            NSLog(@"PAGAMENTO AVVIATO IDENTIFICATIVO = %d",identificativo);
            
            NSLog(@"PAGAMENTO: ID UTENTE da server = %d",idUtente);
            
            //se il controller è stato richiamato senza login idutente lo devo recuperare dall'iphone
            if(idUtente == -1){
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                
                idUtente = [[prefs objectForKey:@"_idUtente"] intValue];
                NSLog(@"PAGAMENTO: ID UTENTE da prefs = %d",idUtente);
            }
            
            
            //identificativo è relativo all'offerta, cioè è id coupon
            
            [dbAccess buyCouponRequest:[NSString stringWithFormat: @"identificativo=%d&idiphone=%@&quantita=%d&valore=%.2f&importo=%f&idUtente=%d&tipocarta=%@&numerocarta=%@&mesescadenza=%d&annoscadenza=%d&intestatario=%@&cvv=%@",identificativo,idiphone,quant,valore,totale,idUtente,tipocarta,numerocarta,[mesescadenza integerValue],[annoscadenza integerValue],intestatario,cvv]];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_cvv"];
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
					//break;
			case 1:
				return 1;
					//break;
			case 2:
				return 1;
					//break;
			default:
				return 1;
					//break;
		}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	switch (indexPath.section) {
		case 0:
			return 55;
		case 1:
			return 40;
		case 2:
			return 45;
		default:
			return 50;
	}
}

			
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
		switch (section) {
			case 0:
				return 5;
				break;
			case 1:
				return 25;
				break;
			case 2:
				return 25;
				break;
			default:
				return 25;
				break;
		}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
		UIView *customView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		[customView setBackgroundColor:[UIColor clearColor]];
    
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textColor = [UIColor whiteColor];
		lbl.lineBreakMode = UILineBreakModeWordWrap;
		//lbl.numberOfLines = 0;
		lbl.font = [UIFont boldSystemFontOfSize:18];
    
		if (section == 1)
		{
			lbl.text =@"Utente";
		}
		if (section == 2)
		{
			lbl.text = @"Inserisci la tua carta di credito";
		}
	
		//UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
		//CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
		//	CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		lbl.frame = CGRectMake(10, -5, tablegenerale.bounds.size.width, 30);

		[customView addSubview:lbl];
    
#warning FAR SALIRE LE CELLE RELATIVE AI NOMI SEZIONE!
    
		return customView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString *CellIdentifier = @"Cell"; 
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];  
		
    if(indexPath.section==0) {
			if (cell == nil){	
				[[NSBundle mainBundle] loadNibNamed:@"cellatotalepagamento" owner:self options:NULL];
				cell=cellapag;	
			}
			UILabel *prezzo = (UILabel *)[cell viewWithTag:1];
			[prezzo setText:[NSString stringWithFormat:@"%.2f€", valore]];
            
			UITextField *quantita= (UITextField *)[cell viewWithTag:2];
        NSLog(@"QUANTITA = %d", quant);
            quantita.text = [NSString stringWithFormat:@"%d", quant];
            //[quantita setInputView:myActionSheet];
				
			//quantita.text=[arrayQuantita objectAtIndex:[quantitaPicker selectedRowInComponent:0]];
			//quant=[quantita.text integerValue];
			UILabel *tot = (UILabel *)[cell viewWithTag:3];
			//totale=quant*valore;
			[tot setText:[NSString stringWithFormat:@"%.2f€", totale]];
	
			
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
    
		if(indexPath.section==1) {
			if (cell == nil){	
				[[NSBundle mainBundle] loadNibNamed:@"DatiUtenteLogin" owner:self options:NULL];
				cell=celladatipagamento;	
			}
			
				//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				UILabel *_nome = (UILabel *)[cell viewWithTag:1];				
				UILabel *mail = (UILabel *)[cell viewWithTag:2];				
				
            _nome.text = self.utente;
            mail.text = self.email;
            
            //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//				NSString *nomesalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"_nomeUtente"];
//				NSString *cognomesalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"_cognome"];
//				
//				NSString *mailsalvata = [[NSUserDefaults standardUserDefaults] objectForKey:@"_email"];
                        
//                if(nomesalvato && cognomesalvato)
//                    nome.text = [NSString stringWithFormat:@"%@ %@", nomesalvato, cognomesalvato];
//                else nome.text = @"";
//            
//                if(mailsalvata)
//                    mail.text = mailsalvata;
//                else mail.text = @"";
                    
//				if ( ([mailsalvata length]==0) ||  (mailsalvata ==nil) )
//					mailsalvata=@"";
//				mail.text = [[NSString alloc] initWithFormat:@"%@", mailsalvata];
//
//
//				if(([nomesalvato length]==0) || ([nomesalvato length]==0) ||   ((nomesalvato ==nil) ||  (cognomesalvato ==nil)) )
//					nome.text = [[NSString alloc] initWithFormat:@""];
//				else 
//					nome.text = [[NSString alloc] initWithFormat:@"%@ %@", nomesalvato,cognomesalvato];
				
		}
    
		if(indexPath.section==2) {
			if (cell == nil){	
				[[NSBundle mainBundle] loadNibNamed:@"riepilogocartadicredito" owner:self options:NULL];
				cell=celladaticarta;	
		 }
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				UILabel *numero = (UILabel *)[cell viewWithTag:1];				
				UILabel *tipo = (UILabel *)[cell viewWithTag:2];	
            
				NSString *numerosalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"_numero"];
				NSString *tiposalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"_tipoCarta"];
                if(numerosalvato)
                    numero.text = [[NSString alloc] initWithFormat:@"%@", numerosalvato];
                else numero.text =@"";
            
                if(tiposalvato)
                    tipo.text = [[NSString alloc] initWithFormat:@"%@", tiposalvato];
                else tipo.text = @"";

				
		}
		return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if(indexPath.section == 0){
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSLog(@"########## = %@", [cell.accessoryView viewWithTag:2]);
    }
    else if(indexPath.section == 1 && indexPath.row == 0){
        
        DataLoginController *dataLogin = [[DataLoginController alloc] initWithNibName:@"DataLoginController" bundle:nil];
        dataLogin.delegate = self;        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:dataLogin];
        [dataLogin release];
        
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentModalViewController:navController animated:YES];
        
        [navController release];
    }
    /*
		if(indexPath.section==1) {			
//			detail = [[DatiPers alloc] initWithNibName:@"DatiPers" bundle:[NSBundle mainBundle]];
//			detail.title = [NSString stringWithFormat:@"Dati Cliente"];
//			[self.navigationController pushViewController:detail animated:YES];
//			[tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            DatiUtenteController *userDetail = [[DatiUtenteController alloc] initWithNibName:@"DatiUtenteController" bundle:nil];
            
            userDetail.delegate = self;
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:userDetail];
            [userDetail release];
            
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            [self presentModalViewController:navController animated:YES];
            
            [navController release];
            
            //[self.navigationController pushViewController:detail animated:YES];
            //[self.navigationController presentModalViewController:detail animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];

		}
    */
	else if(indexPath.section==2) {
//			detail = [[DatiPag alloc] initWithNibName:@"DatiPag" bundle:[NSBundle mainBundle]];
//			detail.title = [NSString stringWithFormat:@"Dati Pagamento"];
//			[self.navigationController pushViewController:detail animated:YES];
//			[tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            DatiPagamentoController *paymentDetail = [[DatiPagamentoController alloc] initWithNibName:@"DatiPagamentoController" bundle:nil];
            
            paymentDetail.delegate = self;
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:paymentDetail];
            [paymentDetail release];
            
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            [self presentModalViewController:navController animated:YES];
            
            [navController release];
            
            //[self.navigationController pushViewController:detail animated:YES];
            //[self.navigationController presentModalViewController:detail animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
		}			
	
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


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"iniziato editing");

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"finito editing");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)addButtonToKeyboard {
	// create custom button
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(0, 163, 106, 53);
	doneButton.adjustsImageWhenHighlighted = NO;
 
    [doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
    [doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];


	[doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	// locate keyboard view
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
	UIView* keyboard;
	for(int i=0; i<[tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard found, add the button
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
			if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
				[keyboard addSubview:doneButton];
		} else {
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
                
				[keyboard addSubview:doneButton];
		}
	}
}

- (void)keyboardDidShow:(NSNotification *)note 
{
   
        [self addButtonToKeyboard];
    
}

- (void)doneButtonClicked:(NSNotification *)note
{    
    //[[cellapag.accessoryView viewWithTag:2] resignFirstResponder];
    UITextField *quantitaTextField= (UITextField *)[cellapag viewWithTag:2];
    
    quant=[quantitaTextField.text integerValue];
    UILabel *tot = (UILabel *)[cellapag viewWithTag:3];
    totale=quant*valore;
    [tot setText:[NSString stringWithFormat:@"%.2f€", totale]];
    
    [quantitaTextField resignFirstResponder];
    //NSLog(@"accessory view = %@",[cellapag viewWithTag:2] );
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    buyAlert = [[UIAlertView alloc] initWithTitle:@"Vuoi comprare il coupon?" message:@"L'importo sarà effettivamente addebitato sulla tua carta di credito solamente se il processo di acquisto sarà completato e confermato" delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"Compra", nil];
    
    dbAccess = [[DatabaseAccess alloc] init];
    dbAccess.delegate = self;
    
    isQtField = FALSE;
    idUtente = -1;
    
    quant = 1;
    totale = quant * valore;
    
    
	[[compra layer] setCornerRadius:8.0f];
	[[compra layer] setMasksToBounds:YES];
	[compra setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
	
	UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(OpenContatti:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setRightBarButtonItem:modalButton animated:YES];
	//[infoButton release];
	[modalButton release];
	titololabel.text=[NSString stringWithFormat:@"%@",titolo];
	
    
//	NSString *value=@"";
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	[defaults setObject:value forKey:@"NumeroCarta"];
//	[defaults setObject:value forKey:@"TipoCarta"];
//	[defaults setObject:value forKey:@"MeseScadenza"];
//	[defaults setObject:value forKey:@"AnnoScadenza"];
//	[defaults setObject:value forKey:@"Intestatario"];
//	[defaults setObject:value forKey:@"Cvv"];
//	[defaults synchronize];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    self.utente = [NSString stringWithFormat:@"%@ %@", [prefs objectForKey:@"_nomeUtente"],[prefs objectForKey:@"_cognome"]];
    self.email = [prefs objectForKey:@"_email"];
	[tablegenerale reloadData];


}

- (IBAction)OpenContatti:(id)sender {
	Contatti *cnt = [[Contatti alloc] initWithNibName:@"Contatti" bundle:nil];
	[self presentModalViewController:cnt animated:YES];
    [cnt release];
	
}
- (IBAction)chiudi:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark - DatabaseAccessDelegate

-(void)didReceiveError:(NSError *)error{
    
    NSLog(@"ERRORE SERVER NELL'ACQUISTO DEL COUPON = %@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"Ci sono stati problemi nell'invio della richiesta di acquisto, Riprovare!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
    [alert show];
    [alert release];

}

-(void)didReceiveResponsFromServer:(NSString *)receivedData{
    
    NSLog(@"DATI RICEVUTI DAL SERVER ACQUISTO COUPON = %@", receivedData);
    if([receivedData isEqualToString:@"Ok"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Complimenti" message:@"La tua richiesta verrà processata dai nostri sistemi e a breve riceverai una mail di conferma.\n Condividi subito questa offerta!" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore" message:@"Non è stato possibile processare la tua richiesta, riprovare!" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - DatiPagamentoDelegate e DataloginDelegate 

//-(void)didSaveUserDetail{
//    
//    [self.navigationController dismissModalViewControllerAnimated:YES];    
//}
//
//
//-(void)didAbortUserDetail{
//    
//    [self.navigationController dismissModalViewControllerAnimated:YES];
//    
//}

-(void)didAbortLogout{    

    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}

-(void)didSavePaymentDetail{

    [self.navigationController dismissModalViewControllerAnimated:YES];    
}


-(void)didAbortPaymentDetail{
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}

-(void)didLogout{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[tablegenerale reloadData];
	
}
- (void)viewWillDisappear:(BOOL)animated {

	
	
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    self.compra = nil;
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
}


- (void)dealloc {
		
    [buyAlert release];
    self.utente = nil;
    self.email = nil;
    
    [dbAccess release];
    
    [compra release];
    
	[titolo release];
	
	//[url release];
	[tablegenerale release];
	
	
	[rows release];
	[dict release]; 
	
    [super dealloc];
	
}


@end

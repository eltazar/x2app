//
//  prova.m
//  Per Due
//
//  Created by Giuseppe Lisanti on 28/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DettaglioRistoPub.h"
#import "Utilita.h"

@implementation DettaglioRistoPub
@synthesize rows, identificativo,mappa;
@synthesize dict,tableview,sito,webView,condizioni,cond;

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int righesecondasezione=5;
	int righeterzasezione=3;
	switch (section) {
		case 0:
				if ( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Giorno_chiusura_Esercente"]] isEqualToString:@"<null>"] ){
					return 2;
					break;
				}
				else{
					return 3;
					break;
				}

		case 1:
			if( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Ambiente_Esercente"]] isEqualToString:@"<null>"] ){
				righesecondasezione--;
			}
			if ( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Subtipo_STeser"]] isEqualToString:@"<null>"] ){
				righesecondasezione--;
			}
			if( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Specialita_CE"]] isEqualToString:@"<null>"] ){
				righesecondasezione--;
			}
			if( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Fasciaprezzo_Esercente"]] isEqualToString:@"<null>"] ){
				righesecondasezione--;
			}
			return righesecondasezione;
			break;
			
		case 2:
			if( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] ){
				righeterzasezione--;
			}
			if( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] ){
				righeterzasezione--;
			}
			if( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"] ){
				righeterzasezione--;
			}
			return righeterzasezione;
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
		[[NSBundle mainBundle] loadNibNamed:@"cellaindirizzo" owner:self options:NULL];
		cell=cellaindirizzo;

	}
	else {
		if(  ((cell == nil) && (indexPath.section==0) && (indexPath.row==1) && ([tableView numberOfRowsInSection:0]==3) ) ) {
			[[NSBundle mainBundle] loadNibNamed:@"CellaDettaglio1" owner:self options:NULL];
			cell=CellaDettaglio1;
		}
		else {
				if( ((cell == nil) && (indexPath.section==0) && (indexPath.row==2))  ||  ((cell == nil) && (indexPath.section==0) && (indexPath.row==1) && ([tableView numberOfRowsInSection:0]==2))  ) {
					[[NSBundle mainBundle] loadNibNamed:@"CellaValidita" owner:self options:NULL];
					cell=cellavalidita;
			}
			else {	
				if( (cell == nil)&& (indexPath.section==1) ){
					[[NSBundle mainBundle] loadNibNamed:@"CellaDettaglio1" owner:self options:NULL];
					cell=CellaDettaglio1;
				   }
				else {
					if( (cell == nil) && (indexPath.section==2) ){
						[[NSBundle mainBundle] loadNibNamed:@"provacella" owner:self options:NULL];
						cell=provacella;
					}

				}
			}
		}
	}
			   
	// Configure the cell.
	if ( (indexPath.row == 0)&&(indexPath.section==0) ){
		UILabel *indirizzo = (UILabel *)[cell viewWithTag:1];
		UILabel *zona = (UILabel *)[cell viewWithTag:2];

		if( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Zona_Esercente"]] isEqualToString:@"<null>"] ){ //zona null
			indirizzo.text = [NSString stringWithFormat:@"%@, %@",[dict objectForKey:@"Indirizzo_Esercente"],[dict objectForKey:@"Citta_Esercente"]];	
			indirizzo.text= [indirizzo.text capitalizedString];
			zona.text = [NSString stringWithFormat:@""];	

		}
		else { //stampo anche la zona
			indirizzo.text = [NSString stringWithFormat:@"%@, %@",[dict objectForKey:@"Indirizzo_Esercente"],[dict objectForKey:@"Citta_Esercente"]];
			indirizzo.text= [indirizzo.text capitalizedString];

			zona.text = [NSString stringWithFormat:@"Zona: %@",[dict objectForKey:@"Zona_Esercente"]];	

		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}	

	if ( (indexPath.row == 1)&&(indexPath.section==0) ){
		if ( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Giorno_chiusura_Esercente"]] isEqualToString:@"<null>"] ) { // chiusura non dispoibile, inserisco condizioni
			NSString *lunedipranzo;
			NSString *martedipranzo;
			NSString *mercoledipranzo;
			NSString *giovedipranzo;
			NSString *venerdipranzo;
			NSString *sabatopranzo;
			NSString *domenicapranzo;
			NSString *lunedicena;
			NSString *martedicena;
			NSString *mercoledicena;
			NSString *giovedicena;
			NSString *venerdicena;
			NSString *sabatocena;
			NSString *domenicacena;
			
			UILabel *etic = (UILabel *)[cell viewWithTag:1];
			UILabel *pra= (UILabel *)[cell viewWithTag:2];
			UILabel *cen= (UILabel *)[cell viewWithTag:3];

			if ( ([[dict objectForKey:@"Lunedi_mat_CE"]intValue]==0)) {
				lunedipranzo=  @"";	
			}
			
			else	{	
				lunedipranzo= @"Lu ";	
			}
			
			if ( ([[dict objectForKey:@"Martedi_mat_CE"]intValue]==0)) {
				martedipranzo= @"";	
				
			}
			else	{	
				martedipranzo= @"Ma ";	
			}
			
			if ( ([[dict objectForKey:@"Mercoledi_mat_CE"]intValue]==0)) {
				mercoledipranzo= @"";	
				
			}
			else	{	
				mercoledipranzo= @"Me ";	
			}
			
			
			if ( ([[dict objectForKey:@"Giovedi_mat_CE"]intValue]==0)) {
				giovedipranzo= @"";	
				
			}
			else	{	
				giovedipranzo= @"Gi ";	
			}
			
			if ( ([[dict objectForKey:@"Venerdi_mat_CE"]intValue]==0)) {
				venerdipranzo= @"";	
				
			}
			else	{	
				venerdipranzo= @"Ve ";	
			}
			
			
			if ( ([[dict objectForKey:@"Sabato_mat_CE"]intValue]==0)) {
				sabatopranzo= @"";	
				
			}
			else	{	
				sabatopranzo= @"Sa ";	
			}
			
			if ( ([[dict objectForKey:@"Domenica_mat_CE"]intValue]==0) ) {
				domenicapranzo= @"";	
				
			}
			else	{	
				domenicapranzo= @"Do ";	
			}
			
			if ( ([[dict objectForKey:@"Lunedi_sera_CE"]intValue]==0)) {
				lunedicena=  @"";	
			}
			
			else	{	
				lunedicena= @"Lu ";	
			}
			
			if ( ([[dict objectForKey:@"Martedi_sera_CE"]intValue]==0)) {
				martedicena= @"";	
				
			}
			else	{	
				martedicena= @"Ma ";	
			}
			
			if ( ([[dict objectForKey:@"Mercoledi_sera_CE"]intValue]==0)) {
				mercoledicena= @"";	
				
			}
			else	{	
				mercoledicena= @"Me ";	
			}
			
			
			if ( ([[dict objectForKey:@"Giovedi_sera_CE"]intValue]==0)) {
				giovedicena= @"";	
				
			}
			else	{	
				giovedicena= @"Gi ";	
			}
			
			if ( ([[dict objectForKey:@"Venerdi_sera_CE"]intValue]==0)) {
				venerdicena= @"";	
				
			}
			else	{	
				venerdicena= @"Ve ";	
			}
			
			
			if ( ([[dict objectForKey:@"Sabato_sera_CE"]intValue]==0)) {
				sabatocena= @"";	
				
			}
			else	{	
				sabatocena= @"Sa ";	
			}
			
			if ( ([[dict objectForKey:@"Domenica_sera_CE"]intValue]==0) ) {
				domenicacena= @"";	
				
			}
			else	{	
				domenicacena= @"Do ";	
			}
			
			pra.text=[NSString stringWithFormat:@"%@%@%@%@%@%@%@", lunedipranzo, martedipranzo,mercoledipranzo,giovedipranzo,venerdipranzo,sabatopranzo,domenicapranzo];
			cen.text= [NSString stringWithFormat:@"%@%@%@%@%@%@%@",lunedicena, martedicena,mercoledicena,giovedicena,venerdicena,sabatocena,domenicacena];
			etic.text=@"Giorni di validità della Carta PerDue";
			if ( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Note_Varie_CE"]] isEqualToString:@"<null>"] ){ //non ci sono condizioni
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			else {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		}
		
	else {
		UILabel *giorno = (UILabel *)[cell viewWithTag:1];
		UILabel *etic = (UILabel *)[cell viewWithTag:2];
		etic.text=@"Chiusura settimanale";
		giorno.text=[NSString stringWithFormat:@"%@", [dict objectForKey:@"Giorno_chiusura_Esercente"]];
		giorno.text= [giorno.text capitalizedString];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		}
	}		
	if ( (indexPath.row == 2)&&(indexPath.section==0) ){ // la validità va alla terza riga perchè c'è il giorno di chiusura alla seconda
		NSString *lunedipranzo=[[NSMutableString alloc] init];
		NSString *martedipranzo=[[NSMutableString alloc] init];
		NSString *mercoledipranzo=[[NSMutableString alloc] init];
		NSString *giovedipranzo=[[NSMutableString alloc] init];
		NSString *venerdipranzo=[[NSMutableString alloc] init];
		NSString *sabatopranzo=[[NSMutableString alloc] init];;
		NSString *domenicapranzo=[[NSMutableString alloc] init];
		NSString *lunedicena=[[NSMutableString alloc] init];
		NSString *martedicena=[[NSMutableString alloc] init];
		NSString *mercoledicena=[[NSMutableString alloc] init];
		NSString *giovedicena=[[NSMutableString alloc] init];
		NSString *venerdicena=[[NSMutableString alloc] init];
		NSString *sabatocena=[[NSMutableString alloc] init];
		NSString *domenicacena=[[NSMutableString alloc] init];
		
		UILabel *etic = (UILabel *)[cell viewWithTag:1];
		UILabel *pra= (UILabel *)[cell viewWithTag:2];
		UILabel *cen= (UILabel *)[cell viewWithTag:3];

		if ( ([[dict objectForKey:@"Lunedi_mat_CE"]intValue]==0)) {
			lunedipranzo=  @"";	
		}
		
		else	{	
			lunedipranzo= @"Lu ";	
		}
		
		if ( ([[dict objectForKey:@"Martedi_mat_CE"]intValue]==0)) {
			martedipranzo= @"";	
			
		}
		else	{	
			martedipranzo= @"Ma ";	
		}
		
		if ( ([[dict objectForKey:@"Mercoledi_mat_CE"]intValue]==0)) {
			mercoledipranzo= @"";	
			
		}
		else	{	
			mercoledipranzo= @"Me ";	
		}
		
		
		if ( ([[dict objectForKey:@"Giovedi_mat_CE"]intValue]==0)) {
			giovedipranzo= @"";	
			
		}
		else	{	
			giovedipranzo= @"Gi ";	
		}
		
		if ( ([[dict objectForKey:@"Venerdi_mat_CE"]intValue]==0)) {
			venerdipranzo= @"";	
			
		}
		else	{	
			venerdipranzo= @"Ve ";	
		}
		
		
		if ( ([[dict objectForKey:@"Sabato_mat_CE"]intValue]==0)) {
			sabatopranzo= @"";	
			
		}
		else	{	
			sabatopranzo= @"Sa ";	
		}
		
		if ( ([[dict objectForKey:@"Domenica_mat_CE"]intValue]==0) ) {
			domenicapranzo= @"";	
			
		}
		else	{	
			domenicapranzo= @"Do ";	
		}
		
		if ( ([[dict objectForKey:@"Lunedi_sera_CE"]intValue]==0)) {
			lunedicena=  @"";	
		}
		
		else	{	
			lunedicena= @"Lu ";	
		}
		
		if ( ([[dict objectForKey:@"Martedi_sera_CE"]intValue]==0)) {
			martedicena= @"";	
			
		}
		else	{	
			martedicena= @"Ma ";	
		}
		
		if ( ([[dict objectForKey:@"Mercoledi_sera_CE"]intValue]==0)) {
			mercoledicena= @"";	
			
		}
		else	{	
			mercoledicena= @"Me ";	
		}
		
		
		if ( ([[dict objectForKey:@"Giovedi_sera_CE"]intValue]==0)) {
			giovedicena= @"";	
			
		}
		else	{	
			giovedicena= @"Gi ";	
		}
		
		if ( ([[dict objectForKey:@"Venerdi_sera_CE"]intValue]==0)) {
			venerdicena= @"";	
			
		}
		else	{	
			venerdicena= @"Ve ";	
		}
		
		
		if ( ([[dict objectForKey:@"Sabato_sera_CE"]intValue]==0)) {
			sabatocena= @"";	
			
		}
		else	{	
			sabatocena= @"Sa ";	
		}
		
		if ( ([[dict objectForKey:@"Domenica_sera_CE"]intValue]==0) ) {
			domenicacena= @"";	
			
		}
		else	{	
			domenicacena= @"Do ";	
		}
		
		pra.text=[NSString stringWithFormat:@"%@%@%@%@%@%@%@", lunedipranzo, martedipranzo,mercoledipranzo,giovedipranzo,venerdipranzo,sabatopranzo,domenicapranzo];
		cen.text= [NSString stringWithFormat:@"%@%@%@%@%@%@%@",lunedicena, martedicena,mercoledicena,giovedicena,venerdicena,sabatocena,domenicacena];
		etic.text=@"Giorni di validità della Carta PerDue";

		if ( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Note_Varie_CE"]] isEqualToString:@"<null>"] ){ //non ci sono condizioni
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}
			

	
	if ( (indexPath.row == 0)&&(indexPath.section==1) ){
		if(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Ambiente_Esercente"]] isEqualToString:@"<null>"] )){ //ambiente presente
			UILabel *ambiente = (UILabel *)[cell viewWithTag:1];
			ambiente.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Ambiente_Esercente"]];
			UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
			etichetta.text = [NSString stringWithFormat:@"Ambiente"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

		}
		else { //ambiente non presente, provo il tipo cucina
			if(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Subtipo_STeser"]] isEqualToString:@"<null>"] )){ //ambiente non presente
				UILabel *cucina = (UILabel *)[cell viewWithTag:1];
				cucina.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Subtipo_STeser"]];
				UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
				etichetta.text = [NSString stringWithFormat:@"Cucina"];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;

			}
			else {
				if(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Specialita_CE"]] isEqualToString:@"<null>"] )){ //ambiente e cucina non presenti
					UILabel *specialita = (UILabel *)[cell viewWithTag:1];
					specialita.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Specialita_CE"]];
					UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
					etichetta.text = [NSString stringWithFormat:@"Specialità"];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;

				}
				else {
					if(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Fasciaprezzo_Esercente"]] isEqualToString:@"<null>"] )){ //ambiente  cucina specialità non presenti
						UILabel *prezzo = (UILabel *)[cell viewWithTag:1];
						prezzo.text = [NSString stringWithFormat:@"%@€",[dict objectForKey:@"Fasciaprezzo_Esercente"]]; //provo prezzo medio
						UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
						etichetta.text = [NSString stringWithFormat:@"Prezzo Medio"];
						cell.selectionStyle = UITableViewCellSelectionStyleNone;

					}
					else {
						UILabel *commenti = (UILabel *)[cell viewWithTag:1]; //altrimenti i commenti occupano la prima riga
						commenti.text = [NSString stringWithFormat:@"Commenti"];
						UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
						etichetta.text = [NSString stringWithFormat:@""];
						cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
							
						}
						
					}

				}
			}
	}	
	
	if ( (indexPath.row == 1)&&(indexPath.section==1) ){
		if( (!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Subtipo_STeser"]] isEqualToString:@"<null>"] ))&& (!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Ambiente_Esercente"]] isEqualToString:@"<null>"] )) ){ 
			UILabel *cucina = (UILabel *)[cell viewWithTag:1];
			cucina.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Subtipo_STeser"]];
			UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
			etichetta.text = [NSString stringWithFormat:@"Cucina"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

		}
		else {
			if(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Specialita_CE"]] isEqualToString:@"<null>"] )){ //  cucina non presente
				UILabel *specialita = (UILabel *)[cell viewWithTag:1];
				specialita.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Specialita_CE"]];
				UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
				etichetta.text = [NSString stringWithFormat:@"Specialità"];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;

			}
			else {
				if(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Fasciaprezzo_Esercente"]] isEqualToString:@"<null>"] )){ // cucina e specialità non presenti
					UILabel *prezzo = (UILabel *)[cell viewWithTag:1];
					prezzo.text = [NSString stringWithFormat:@"%@€",[dict objectForKey:@"Fasciaprezzo_Esercente"]];
					UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
					etichetta.text = [NSString stringWithFormat:@"Prezzo Medio"];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					
				}
				else {
					UILabel *commenti = (UILabel *)[cell viewWithTag:1]; //commenti occupano la seconda riga
					commenti.text = [NSString stringWithFormat:@"Commenti"];
					UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
					etichetta.text = [NSString stringWithFormat:@""];
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
						
					}
			}

		}

	}
	
	if ( (indexPath.row == 2)&&(indexPath.section==1) ){
		if( (!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Specialita_CE"]] isEqualToString:@"<null>"] )) && (!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Subtipo_STeser"]] isEqualToString:@"<null>"] ))&& (!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Ambiente_Esercente"]] isEqualToString:@"<null>"] )) ){ //ambiente presente
			UILabel *specialita = (UILabel *)[cell viewWithTag:1];
			specialita.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Specialita_CE"]];
			UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
			etichetta.text = [NSString stringWithFormat:@"Specialità"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

		}
		else {
			if(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Fasciaprezzo_Esercente"]] isEqualToString:@"<null>"] )){ // cucina e specialità non presenti
				UILabel *prezzo = (UILabel *)[cell viewWithTag:1];
				prezzo.text = [NSString stringWithFormat:@"%@€",[dict objectForKey:@"Fasciaprezzo_Esercente"]];
				UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
				etichetta.text = [NSString stringWithFormat:@"Prezzo Medio"];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;

			}
			else {
				UILabel *commenti = (UILabel *)[cell viewWithTag:1]; //commenti occupano la terza riga
				commenti.text = [NSString stringWithFormat:@"Commenti"];
				UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
				etichetta.text = [NSString stringWithFormat:@""];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				
			}

		}	

	}
	
	if ( (indexPath.row == 3)&&(indexPath.section==1) ){
		if( (!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Fasciaprezzo_Esercente"]] isEqualToString:@"<null>"])) && (!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Ambiente_Esercente"]] isEqualToString:@"<null>"]))&&(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Subtipo_STeser"]] isEqualToString:@"<null>"]))&&(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Specialita_CE"]] isEqualToString:@"<null>"])) ){ 
			UILabel *prezzo = (UILabel *)[cell viewWithTag:1];
			prezzo.text = [NSString stringWithFormat:@"%@€",[dict objectForKey:@"Fasciaprezzo_Esercente"]];
			UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
			etichetta.text = [NSString stringWithFormat:@"Prezzo Medio"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

		}	
		else {
			UILabel *commenti = (UILabel *)[cell viewWithTag:1]; //commenti alla quarta riga
			commenti.text = [NSString stringWithFormat:@"Commenti"];
			UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
			etichetta.text = [NSString stringWithFormat:@""];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				
			}

	}
	if ( (indexPath.row == 4)&&(indexPath.section==1) ){ //commenti alla quinta riga
		UILabel *commenti = (UILabel *)[cell viewWithTag:1];
		commenti.text = [NSString stringWithFormat:@"Commenti"];
		UILabel *etichetta = (UILabel *)[cell viewWithTag:2];
		etichetta.text = [NSString stringWithFormat:@""];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}
	
	if ( (indexPath.row == 0)&&(indexPath.section==2) ){

		if(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"]) ){
			UILabel *telefono = (UILabel *)[cell viewWithTag:1];
			UILabel *etic = (UILabel *)[cell viewWithTag:2];
			etic.text=@"";
			telefono.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Telefono_Esercente"]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else {
			if(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"]) ){
				UILabel *email = (UILabel *)[cell viewWithTag:1];
				UILabel *etic = (UILabel *)[cell viewWithTag:2];
				etic.text=@"";
				email.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Email_esercente"]];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			else {
				if(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"] )){
					UILabel *sitoweb = (UILabel *)[cell viewWithTag:1];
					UILabel *etic = (UILabel *)[cell viewWithTag:2];
					etic.text=@"";
					sitoweb.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Url_Esercente"]];
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				}
			}
		}
	}

			
		
	if ( (indexPath.row == 1)&&(indexPath.section==2) ){
		if( (!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] ))&& (!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] )) ){ 
			UILabel *email = (UILabel *)[cell viewWithTag:1];
			UILabel *etic = (UILabel *)[cell viewWithTag:2];
			etic.text=@"";
			email.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Email_Esercente"]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			else {
				if(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"] )){
					UILabel *sitoweb = (UILabel *)[cell viewWithTag:1];
					UILabel *etic = (UILabel *)[cell viewWithTag:2];
					etic.text=@"";
					sitoweb.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Url_Esercente"]];
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				}
			}
	}
	
	if ( (indexPath.row == 2)&&(indexPath.section==2) ){
		if((! [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"]) ){
			UILabel *sitoweb = (UILabel *)[cell viewWithTag:1];
			UILabel *etic = (UILabel *)[cell viewWithTag:2];
			etic.text=@"";
			sitoweb.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Url_Esercente"]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}

	}
	
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)] autorelease];
    [customView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.lineBreakMode = UILineBreakModeWordWrap;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont boldSystemFontOfSize:18];
    
	
	if (section == 0)
	{
		lbl.text = [dict objectForKey:@"Insegna_Esercente"];
	}
	if (section == 1){
		lbl.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Tipo_Teser"]];

	}
	
	if (section == 2){
		if( ( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] ) &&( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] )
		   &&( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"])  ){ // non ci sono contatti
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
	
	if (section == 0)
	{
		lblText = [dict objectForKey:@"Insegna_Esercente"];
	}
	if (section == 1){
		lblText = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Tipo_Teser"]];
		
	}
	
	if (section == 2){
		if( ( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] ) &&( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] )
		   &&( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Url_Esercente"]] isEqualToString:@"<null>"])  ){ // non ci sono contatti
			lblText = @"";
		}
		else {
			lblText = @"Contatti";	
		}
	}
    UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lblText sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height+6;
}



	// Metodo relativo alla selezione delle celle selezionabili
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if ( (indexPath.row == 0)&&(indexPath.section==0) ){ //apri mappa
		mappa.navigationItem.titleView = tipoMappa;
		[self.navigationController pushViewController:mappa animated:YES];
		
		map.delegate = self;
		map.showsUserLocation = YES;
		float lati, longi;
		int d;
		lati=[[dict objectForKey:@"Latitudine"] doubleValue];
		longi=[[dict objectForKey:@"Longitudine"] floatValue];
		d=[[dict objectForKey:@"IDesercente"]intValue];
		NSString *nome=[[NSString alloc]init];
		nome=[dict objectForKey:@"Insegna_Esercente"];
		//NSString *address=[NSString alloc];		
		//address=[dict objectForKey:@"Indirizzo_Esercente"];		
		NSString *address=[[NSString alloc ]initWithFormat:@"%@, %@",[[dict objectForKey:@"Indirizzo_Esercente"]capitalizedString],[[dict objectForKey:@"Citta_Esercente"]capitalizedString] ];
		int ident=d;
		
		[map addAnnotation:[[[GoogleHQAnnotation alloc] init:lati:longi:nome:address:ident] autorelease]];
	}	
	
	if ( ((indexPath.row == 2)&&(indexPath.section==0)) || ((indexPath.row == 1)&&(indexPath.section==0)&& ([tableView numberOfRowsInSection:0]==2)) ) { //condizioni
		condizioni.title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Insegna_Esercente"]];
		[self.navigationController pushViewController:condizioni animated:YES];
		cond.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Note_Varie_CE"]];
		[cond release];
		cond=nil;
	}
	
	if( (indexPath.section==1) && ([tableView numberOfRowsInSection:1] == indexPath.row+1) ) { //commenti
		detail = [[Commenti alloc] initWithNibName:@"Commenti" bundle:[NSBundle mainBundle]];
		[(Commenti*)detail setIdentificativo:identificativo];
		[detail setTitle:@"Commenti"];
		[detail setNome:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Insegna_Esercente"]]];

		//Facciamo visualizzare la vista con i dettagli
		[self.navigationController pushViewController:detail animated:YES];
		//rilascio controller
		[detail release];
		 detail = nil; 

	}
	
	if ( (indexPath.row == 0)&&(indexPath.section==2) ){ //telefona o mail o sito
		if(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"]) ){ //la cella esprime un num di tel
			PerDueCItyCardAppDelegate *appDelegate = (PerDueCItyCardAppDelegate*)[[UIApplication sharedApplication]delegate];
			UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Vuoi chiamare\n%@?",[dict objectForKey:@"Insegna_Esercente"]] delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Chiama", nil];
			[aSheet showInView:appDelegate.window];
			[aSheet release];			
        }
		else {
			if(!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"]) ){ //la cella esprime un indirizzo email
				MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
				[[controller navigationBar] setTintColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
				NSArray *to = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Email_Esercente"]]];
				[controller setToRecipients:to];
				controller.mailComposeDelegate = self;
				[controller setMessageBody:@"" isHTML:NO];
				[self presentModalViewController:controller animated:YES];
				[controller release];
				controller=nil;				
			}
			else { //la cella esprime un url
				NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[dict objectForKey:@"Url_Esercente"]]];
				NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
				[webView loadRequest:requestObj];		
				[self.navigationController pushViewController:sito animated:YES];
				sito.title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Insegna_Esercente"]];
				[webView release];
				webView=nil;


			}

		}

	}	
	
	if ( (indexPath.row == 1)&&(indexPath.section==2) ){ // mail o sito
		if( (!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Email_Esercente"]] isEqualToString:@"<null>"] ))&& (!( [ [NSString stringWithFormat:@"%@",[dict objectForKey:@"Telefono_Esercente"]] isEqualToString:@"<null>"] )) ){ //indirizzo mail
			MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
			[[controller navigationBar] setTintColor:[UIColor colorWithRed:142/255.0 green:21/255.0 blue:7/255.0 alpha:1.0]];
			NSArray *to = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Email_Esercente"]]];
			[controller setToRecipients:to];
			controller.mailComposeDelegate = self;
			[controller setMessageBody:@"" isHTML:NO];
			[self presentModalViewController:controller animated:YES];
			[controller release];
			controller=nil;			
		}
		else { //sito web
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[dict objectForKey:@"Url_Esercente"]]];
			NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
			[webView loadRequest:requestObj];		
			[self.navigationController pushViewController:sito animated:YES];
			sito.title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Insegna_Esercente"]];
			[webView release];
			webView=nil;

		}
	}	
	
	if ( (indexPath.row == 2)&&(indexPath.section==2) ){ // sito web	
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[dict objectForKey:@"Url_Esercente"]]];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[webView loadRequest:requestObj];		
		[self.navigationController pushViewController:sito animated:YES];
		sito.title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Insegna_Esercente"]];
		[webView release];
		webView=nil;
	}		


}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[dict objectForKey:@"Telefono_Esercente"]]];
		[[UIApplication sharedApplication] openURL:url];
	} else {
        [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow] animated:YES];
    }
}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}




- (IBAction)mostraTipoMappa:(id)sender{
	if ([tipoMappa selectedSegmentIndex]==0) {
		map.mapType=MKMapTypeStandard;
	} else if ([tipoMappa selectedSegmentIndex]==1) {
		map.mapType=MKMapTypeSatellite;
	} else if ([tipoMappa selectedSegmentIndex]==2) {
		map.mapType=MKMapTypeHybrid;
	}
}

	//stile annotazioni
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/DettaglioRistorantePub.php?id=%d",identificativo]];
	NSLog(@"Url: %@", url);
	
	NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url];
	NSLog(@"%@",jsonreturn); // Look at the console and you can see what the restults are
	
	NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	
	
	
	//In "real" code you should surround this with try and catch
	dict = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error] retain];
	

	
	if (dict)
	{
		rows = [[dict objectForKey:@"Esercente"] retain];
		
	}
	
 
	NSLog(@"Array: %@",rows);
		//[jsonreturn release];
		//jsonreturn=nil;
	dict = [rows objectAtIndex: 0];	
    [self.navigationController setNavigationBarHidden:NO animated:YES];


}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)viewWillAppear:(BOOL)animated {
//	int wifi=0;
//	int internet=0;
//	internetReach = [[Reachability reachabilityForInternetConnection] retain];
//	internet= [self check:internetReach];
//	
//	wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
//	wifi=[self check:wifiReach];	
//	if( (internet==-1) &&( wifi==-1) ){
    [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow]  animated:YES];
    if(! [Utilita networkReachable]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];

	}
	
	
}

- (void)viewWillDisappear:(BOOL)animated {
//	[wifiReach release];
//	[internetReach release];
    [super viewWillDisappear:animated];
	
	
}

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
    map.delegate = nil;
    [map release];
    self.dict = nil;
    [super dealloc];
}


@end

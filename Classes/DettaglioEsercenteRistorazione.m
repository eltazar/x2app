//
//  DettaglioEsercenteRistorazione.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DettaglioEsercenteRistorazione.h"
#import "Commenti.h"
#import "Utilita.h"



@interface DettaglioEsercenteRistorazione () {}
- (void)removeNullItemsFromModel;
- (void)populateIndexPathMap;
@end



@implementation DettaglioEsercenteRistorazione


- (id)init {
    self = [super init];
    if (self) {
        [urlString release];
        [urlStringCoupon release];
        [urlStringGenerico release];
        [urlStringValiditaCarta release];
        urlString = @"http://www.cartaperdue.it/partner/v2.0/DettaglioRistorantePub.php?id=%d";
        urlStringCoupon = @"http://www.cartaperdue.it/partner/DettaglioRistoCoupon.php?id=%d";
        urlStringGenerico = @"http://www.cartaperdue.it/partner/DettaglioRistoCoupon.php?id=%d";
        urlStringValiditaCarta = nil;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!nibNameOrNil) {
        nibNameOrNil = [NSString stringWithFormat:@"%@", [self superclass]];
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [urlString release];
        [urlStringCoupon release];
        [urlStringGenerico release];
        [urlStringValiditaCarta release];
        urlString = @"http://www.cartaperdue.it/partner/v2.0/DettaglioRistorantePub.php?id=%d";
        urlStringCoupon = @"http://www.cartaperdue.it/partner/DettaglioRistoCoupon.php?id=%d";
        urlStringGenerico = @"http://www.cartaperdue.it/partner/DettaglioRistoCoupon.php?id=%d";
        urlStringValiditaCarta = nil;

    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil couponMode:(BOOL)couponMode genericoMode:(BOOL)genericoMode {
    if (!nibNameOrNil) {
        nibNameOrNil = [NSString stringWithFormat:@"%@", [self superclass]];
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil couponMode:couponMode genericoMode:genericoMode];
    if (self) {
        [urlString release];
        [urlStringCoupon release];
        [urlStringGenerico release];
        [urlStringValiditaCarta release];
        urlString = @"http://www.cartaperdue.it/partner/v2.0/DettaglioRistorantePub.php?id=%d";
        urlStringCoupon = @"http://www.cartaperdue.it/partner/DettaglioRistoCoupon.php?id=%d";
        urlStringGenerico = @"http://www.cartaperdue.it/partner/DettaglioRistoCoupon.php?id=%d";
        urlStringValiditaCarta = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - DatabaseAccessDelegate


//- (void) didReceiveCoupon:(NSDictionary *)data {
//    [super didReceiveCoupon:data];
//    if (self.dataModel) {
//    }
//}


#pragma  mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.idxMap keyForIndexPath:indexPath];
    
    UITableViewCell *cell;
	
	
    if ([key isEqualToString:@"PastiValidita"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DettEsercRistorazionePastiValiditaCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DettEsercRistorazionePastiValiditaCell" owner:self options:NULL] objectAtIndex:0];
        }
        NSMutableString *pranzo = [[[NSMutableString alloc] init] autorelease];
        NSMutableString *cena   = [[[NSMutableString alloc] init] autorelease];
			
        UILabel *etic       = (UILabel *)[cell viewWithTag:1];
        UILabel *pranzoLbl  = (UILabel *)[cell viewWithTag:2];
        UILabel *cenaLbl    = (UILabel *)[cell viewWithTag:3];
            
        if ([[self.dataModel objectForKey:@"Lunedi_mat_CE"]intValue] != 0) {
            [pranzo appendString:@"Lu "];;	
        }
        if ([[self.dataModel objectForKey:@"Martedi_mat_CE"]intValue] != 0) {
            [pranzo appendString:@"Ma "];	
        }
        if ([[self.dataModel objectForKey:@"Mercoledi_mat_CE"]intValue] != 0) {
            [pranzo appendString:@"Me "];
        }
        if ([[self.dataModel objectForKey:@"Giovedi_mat_CE"]intValue] != 0) {
            [pranzo appendString:@"Gi "];
        }
        if ([[self.dataModel objectForKey:@"Venerdi_mat_CE"]intValue] != 0) {
            [pranzo appendString:@"Ve "];
        }
        if ([[self.dataModel objectForKey:@"Sabato_mat_CE"]intValue] != 0) {
            [pranzo appendString:@"Sa "];
        }
        if ([[self.dataModel objectForKey:@"Domenica_mat_CE"]intValue] != 0) {
            [pranzo appendString:@"Do "];
        }
        
        if ([[self.dataModel objectForKey:@"Lunedi_sera_CE"]intValue] != 0) {
            [cena appendString:@"Lu "];;	
        }
        if ([[self.dataModel objectForKey:@"Martedi_sera_CE"]intValue] != 0) {
            [cena appendString:@"Ma "];	
        }
        if ([[self.dataModel objectForKey:@"Mercoledi_sera_CE"]intValue] != 0) {
            [cena appendString:@"Me "];
        }
        if ([[self.dataModel objectForKey:@"Giovedi_sera_CE"]intValue] != 0) {
            [cena appendString:@"Gi "];
        }
        if ([[self.dataModel objectForKey:@"Venerdi_sera_CE"]intValue] != 0) {
            [cena appendString:@"Ve "];
        }
        if ([[self.dataModel objectForKey:@"Sabato_sera_CE"]intValue] != 0) {
            [cena appendString:@"Sa "];
        }
        if ([[self.dataModel objectForKey:@"Domenica_sera_CE"]intValue] != 0) {
            [cena appendString:@"Do "];
        }

        pranzoLbl.text = pranzo;
        cenaLbl.text = cena;
        etic.text = @"Giorni e condizioni di validità della Carta PerDue";
        if ([[self.dataModel objectForKey:@"Note_Varie_CE"] isKindOfClass:[NSNull class]]) {
            //non ci sono condizioni
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    
    else if ([key isEqualToString:@"Ambiente"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DettEsercCellWithTitle"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DettEsercCellWithTitle" owner:self options:NULL] objectAtIndex:0];
        }
        UILabel *titolo   = (UILabel *)[cell viewWithTag:-1];
        UILabel *descrizione  = (UILabel *)[cell viewWithTag:1];
        titolo.text = @"Ambiente";
        descrizione.text = [self.dataModel objectForKey:@"Ambiente_Esercente"];
        [Utilita resizeCell:cell];
    }
		
    else if ([key isEqualToString:@"Subtipo_STeser"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DettEsercCellWithTitle"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DettEsercCellWithTitle" owner:self options:NULL] objectAtIndex:0];
        }
        UILabel *titolo     = (UILabel *)[cell viewWithTag:-1];
        UILabel *descrizione  = (UILabel *)[cell viewWithTag:1];
        titolo.text = @"Cucina";
        descrizione.text = [self.dataModel objectForKey:@"Subtipo_STeser"];
        [Utilita resizeCell:cell];
    }
                
    else if ([key isEqualToString:@"Specialita_CE"] ) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DettEsercCellWithTitle"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DettEsercCellWithTitle" owner:self options:NULL] objectAtIndex:0];
        }
        UILabel *titolo = (UILabel *)[cell viewWithTag:-1];
        UILabel *descrizione  = (UILabel *)[cell viewWithTag:1];
        titolo.text = @"Specialità";
        descrizione.text  = [self.dataModel objectForKey:@"Specialita_CE"];
        [Utilita resizeCell:cell];
    }
	
    else if ([key isEqualToString:@"Fasciaprezzo"]) { 
        cell = [tableView dequeueReusableCellWithIdentifier:@"DettEsercCellWithTitle"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DettEsercCellWithTitle" owner:self options:NULL] objectAtIndex:0];
        }
        UILabel *titolo     = (UILabel *)[cell viewWithTag:-1];
        UILabel *descrizione  = (UILabel *)[cell viewWithTag:1];
        titolo.text = @"Prezzo Medio";

        descrizione.text = [NSString stringWithFormat:@"%@€",[self.dataModel objectForKey:@"Fasciaprezzo_Esercente"]];         
    }
    
    else if ([key isEqualToString:@"Commenti"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellStyleDefault"];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellStyleDefault"] autorelease];
        }
        cell.textLabel.text = @"Commenti";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }

    else {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *key = [self.idxMap keyForIndexPath:indexPath];
    
    if ([key isEqualToString:@"PastiValidita"]) {
		self.condizioniViewController.title = [self.dataModel objectForKey:@"Insegna_Esercente"];
		self.condizioniTextView.text = [self.dataModel objectForKey:@"Note_Varie_CE"];
		[self.navigationController pushViewController:self.condizioniViewController animated:YES];
	}

    
    else if ([key isEqualToString:@"Commenti"]) {
        Commenti *detail = [[Commenti alloc] initWithNibName:nil bundle:nil];
        [detail setIdEsercente:self.idEsercente];
        [detail setTitle:@"Commenti"];
        [detail setInsegnaEsercente:[self.dataModel objectForKey:@"Insegna_Esercente"]];
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
    }
    
    else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}



#pragma mark - DettagioEsercenteRistorazione (metodi privati)


- (void)removeNullItemsFromModel {
    //NSLog(@"DettaglioEsercenteRistorazione::removeNullItemsFromModel");
    Class null = [NSNull class];
    if ([[self.dataModel objectForKey:@"Giorno_chiusura_Esercente"] isKindOfClass:null]){
        [self.idxMap removeKey:@"GiornoChiusura"];
    }
    
    if ([[self.dataModel objectForKey:@"Ambiente_Esercente"] isKindOfClass:null]){
        [self.idxMap removeKey:@"Ambiente"];
    }
    if ([[self.dataModel objectForKey:@"Subtipo_STeser"] isKindOfClass:null]){
        [self.idxMap removeKey:@"Subtipo_STeser"];
    }
    if ([[self.dataModel objectForKey:@"Specialita_CE"] isKindOfClass:null]){
        [self.idxMap removeKey:@"Specialita_CE"];
    }
    if ([[self.dataModel objectForKey:@"Fasciaprezzo_Esercente"] isKindOfClass:null]){
        [self.idxMap removeKey:@"Fasciaprezzo"];
    }
    if ([[self.dataModel objectForKey:@"Commenti"] isKindOfClass:null]){
        [self.idxMap removeKey:@"Commenti"];
    }
    if ([[self.dataModel objectForKey:@"Ulteriori_Informazioni"] boolValue] == false) {
        [self.idxMap removeKey:@"UlterioriInfo"];
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
    NSString *tipoEsercente    = [self.dataModel objectForKey:@"Tipo_Teser"];

    [self.idxMap setKey:@"Indirizzo"        forSection:0 row:0];
    [self.idxMap setKey:@"GiornoChiusura"   forSection:0 row:1];
    [self.idxMap setKey:@"PastiValidita"    forSection:0 row:2];
    [self.idxMap setTitle:@""               forSection:0];
    
    [self.idxMap setKey:@"Ambiente"         forSection:1 row:0];
    [self.idxMap setKey:@"Subtipo_STeser"   forSection:1 row:1];
    [self.idxMap setKey:@"Specialita_CE"    forSection:1 row:2];
    [self.idxMap setKey:@"Fasciaprezzo"     forSection:1 row:3];
    [self.idxMap setKey:@"Commenti"         forSection:1 row:4];
    [self.idxMap setKey:@"UlterioriInfo"    forSection:1 row:5];
    [self.idxMap setTitle:tipoEsercente     forSection:1];
    
    [self.idxMap setKey:@"Telefono"         forSection:2 row:0];
    [self.idxMap setKey:@"Email"            forSection:2 row:1];
    [self.idxMap setKey:@"URL"              forSection:2 row:2];
    [self.idxMap setTitle:@"Contatti"       forSection:2];
    
    if (isCoupon || isGenerico) {
        [self.idxMap removeKey:@"PastiValidita"]; 
    }
}


@end

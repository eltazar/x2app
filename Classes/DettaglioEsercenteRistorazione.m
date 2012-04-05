//
//  DettaglioEsercenteRistorazione.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DettaglioEsercenteRistorazione.h"
#import "Commenti.h"



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
        urlString = @"http://www.cartaperdue.it/partner/DettaglioRistorantePub.php?id=%d";
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
        urlString = @"http://www.cartaperdue.it/partner/DettaglioRistorantePub.php?id=%d";
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
        urlString = @"http://www.cartaperdue.it/partner/DettaglioRistorantePub.php?id=%d";
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


#pragma  mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    NSString *key = [self.idxMap keyForIndexPath:indexPath];
    
    
#warning mettere il riuso al posto giusto
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	
    if ([key isEqualToString:@"PastiValidita"]) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CellaValidita" owner:self options:NULL] objectAtIndex:0];
        //cell = cellavalidita;
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
        etic.text=@"Giorni di validità della Carta PerDue";
        if ( [[self.dataModel objectForKey:@"Note_Varie_CE"] isKindOfClass:[NSNull class]]) {
            //non ci sono condizioni
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    
    else if ([key isEqualToString:@"Ambiente"]) {
        [[NSBundle mainBundle] loadNibNamed:@"CellaDettaglio1" owner:self options:NULL];
        cell=CellaDettaglio1;
        UILabel *ambiente   = (UILabel *)[cell viewWithTag:1];
        UILabel *etichetta  = (UILabel *)[cell viewWithTag:2];
        ambiente.text = [self.dataModel objectForKey:@"Ambiente_Esercente"];
        etichetta.text = @"Ambiente";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
		
    else if ([key isEqualToString:@"Subtipo_STeser"]) {
        [[NSBundle mainBundle] loadNibNamed:@"CellaDettaglio1" owner:self options:NULL];
        cell=CellaDettaglio1;
        UILabel *cucina     = (UILabel *)[cell viewWithTag:1];
        UILabel *etichetta  = (UILabel *)[cell viewWithTag:2];
        cucina.text = [self.dataModel objectForKey:@"Subtipo_STeser"];
        etichetta.text = @"Cucina";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
                
    else if ([key isEqualToString:@"Specialita_CE"] ) {
        [[NSBundle mainBundle] loadNibNamed:@"CellaDettaglio1" owner:self options:NULL];
        cell=CellaDettaglio1;
        UILabel *specialita = (UILabel *)[cell viewWithTag:1];
        UILabel *etichetta  = (UILabel *)[cell viewWithTag:2];
        specialita.text = [self.dataModel objectForKey:@"Specialita_CE"];
        etichetta.text = @"Specialità";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
	
    else if ([key isEqualToString:@"Fasciaprezzo"]) { 
        [[NSBundle mainBundle] loadNibNamed:@"CellaDettaglio1" owner:self options:NULL];
        cell=CellaDettaglio1;
        UILabel *prezzo     = (UILabel *)[cell viewWithTag:1];
        UILabel *etichetta  = (UILabel *)[cell viewWithTag:2];
        prezzo.text = [NSString stringWithFormat:@"%@€",[self.dataModel objectForKey:@"Fasciaprezzo_Esercente"]]; 
        etichetta.text = @"Prezzo Medio";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    else if ([key isEqualToString:@"Commenti"]) {
        [[NSBundle mainBundle] loadNibNamed:@"CellaDettaglio1" owner:self options:NULL];
        cell=CellaDettaglio1;
        UILabel *commenti   = (UILabel *)[cell viewWithTag:1]; 
        UILabel *etichetta  = (UILabel *)[cell viewWithTag:2];
        commenti.text = @"Commenti";
        etichetta.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }

    else {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
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
    
	
	if (section == 0) {
		lbl.text = [self.dataModel objectForKey:@"Insegna_Esercente"];
	}
	else if (section == 1) {
        lbl.text = @"Contatti";	
    } 
    else if (section == 2) {
        lbl.text = [self.dataModel objectForKey:@"Tipo_Teser"];
    }
	else {	
        lbl.text = @"";
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
		lblText = [self.dataModel objectForKey:@"Insegna_Esercente"];
	}
	else if (section == 1) {
        lblText = @"Contatti";	
    } 
    else if (section == 2) {
        lblText = [self.dataModel objectForKey:@"Tipo_Teser"];
    }
	else {	
        lblText = @"";
    }
    UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lblText sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height+6;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *key = [self.idxMap keyForIndexPath:indexPath];
    
    if ([key isEqualToString:@"Commenti"]) {
        Commenti *detail = [[Commenti alloc] initWithNibName:nil bundle:nil];
        [detail setIdentificativo:self.identificativo];
        [detail setTitle:@"Commenti"];
        [detail setNome:[self.dataModel objectForKey:@"Insegna_Esercente"]];
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
    }
    
    else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}



#pragma mark - DettagioEsercenteRistorazione (metodi privati)


- (void)removeNullItemsFromModel {
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
    if ([[self.dataModel objectForKey:@"Fasciaprezzo"] isKindOfClass:null]){
        [self.idxMap removeKey:@"Fasciaprezzo"];
    }
    if ([[self.dataModel objectForKey:@"Commenti"] isKindOfClass:null]){
        [self.idxMap removeKey:@"Commenti"];
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
    [self.idxMap setKey:@"Indirizzo"        forSection:0 row:0];
    [self.idxMap setKey:@"GiornoChiusura"   forSection:0 row:1];
    [self.idxMap setKey:@"PastiValidita"    forSection:0 row:2];
    
    [self.idxMap setKey:@"Ambiente"         forSection:1 row:0];
    [self.idxMap setKey:@"Subtipo_STeser"   forSection:1 row:1];
    [self.idxMap setKey:@"Specialita_CE"    forSection:1 row:2];
    [self.idxMap setKey:@"Fasciaprezzo"     forSection:1 row:3];
    [self.idxMap setKey:@"Commenti"         forSection:1 row:4];
    
    [self.idxMap setKey:@"Telefono"         forSection:2 row:0];
    [self.idxMap setKey:@"Email"            forSection:2 row:1];
    [self.idxMap setKey:@"URL"              forSection:2 row:2];
    
    if (isCoupon || isGenerico) {
        [self.idxMap removeKey:@"GiornoValidita"]; 
    }
}


@end

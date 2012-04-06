//
//  CategoriaCommercialeWithPrice.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 24/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoriaCommercialeWithPrice.h"
#import "DettaglioEsercenteRistorazione.h"
#import "EsercenteMapAnnotation.h"

@implementation CategoriaCommercialeWithPrice


# pragma mark - View lifecycle


- (void) viewDidLoad {
    [super viewDidLoad];
    NSLog (@"sto cambiando il valore di urlString");
    self.urlString = @"http://www.cartaperdue.it/partner/v2.0/EsercentiRistorazione.php";
}


# pragma mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
        // Stiamo mostrando la cella relativa ad un esercente
		static NSString *CellIdentifier = @"Cell";
		UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil){
			cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoriaCommercialeWithPriceCell" owner:self options:NULL] objectAtIndex:0];
		}
		
		NSDictionary *r  = [super.rows objectAtIndex:indexPath.row];
		
		UILabel *esercente = (UILabel *)[cell viewWithTag:1];
		esercente.text = [r objectForKey:@"Insegna_Esercente"];
		
		UILabel *prezzo = (UILabel *)[cell viewWithTag:2];
        if( [ [NSString stringWithFormat:@"%@",[r objectForKey:@"Fasciaprezzo_Esercente"]] isEqualToString:@"<null>"] ){
            prezzo.text=@"Prezzo medio: Non disponibile";
        }
        else {
            prezzo.text =[NSString stringWithFormat:@"Prezzo medio: %@€",[r objectForKey:@"Fasciaprezzo_Esercente"]];	
        
        }
        UILabel *indirizzo = (UILabel *)[cell viewWithTag:3];
		indirizzo.text = [NSString stringWithFormat:@"%@, %@",[r objectForKey:@"Indirizzo_Esercente"],[r objectForKey:@"Citta_Esercente"]];	
		indirizzo.text= [indirizzo.text capitalizedString];
        
		UILabel *distanza = (UILabel *)[cell viewWithTag:4];
		distanza.text = [NSString stringWithFormat:@"a %.1f Km",[[r objectForKey:@"Distanza"] doubleValue]];	
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	} else {
        return [super tableView:tView cellForRowAtIndexPath:indexPath];
    }
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
		NSDictionary* r = [super.rows objectAtIndex: indexPath.row];
		NSInteger i = [[r objectForKey:@"IDesercente"] integerValue];
		NSLog(@"L'id dell'esercente da visualizzare è %d",i );
        DettaglioEsercenteRistorazione *detail = [[DettaglioEsercenteRistorazione alloc]initWithNibName:nil bundle:nil couponMode:NO genericoMode:NO];
		detail.idEsercente = i;
		detail.title = @"Esercente";
        //Facciamo visualizzare la vista con i dettagli
		[self.navigationController pushViewController:detail animated:YES];
        [detail release];
	} else {
        [super tableView:(UITableView *)tView didSelectRowAtIndexPath:indexPath];
	}
}


#pragma mark - MKMapViewDelegate


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	EsercenteMapAnnotation *ann = (EsercenteMapAnnotation *)view.annotation;	
	DettaglioEsercenteRistorazione *detail = [[DettaglioEsercenteRistorazione alloc] initWithNibName:nil bundle:nil couponMode:NO genericoMode:NO];
	detail.idEsercente = ann.idEsercente;
	detail.title = @"Esercente";
	[self.navigationController pushViewController:detail animated:YES];
    //rilascio controller
    [detail release];
}


#pragma mark - CategoriaCommercialeWithPrice (metodi privati)

- (NSString *)searchMethod {
    NSInteger selection = [self.searchSegCtrl selectedSegmentIndex];
    if (selection == 0) {
        return @"distanza";
    } else if (selection == 1) {
        return @"prezzo";
    } else if (selection == 2) {
        return @"nome";
    } else {
        return @"";
    }
}


@end

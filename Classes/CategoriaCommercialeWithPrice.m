//
//  CategoriaCommercialeWithPrice.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 24/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoriaCommercialeWithPrice.h"
#import "DettaglioRistoPub.h"

@implementation CategoriaCommercialeWithPrice

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
        // Stiamo mostrando la cella relativa ad un esercente
		static NSString *CellIdentifier = @"Cell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
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
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
		//[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
		NSDictionary* r = [super.rows objectAtIndex: indexPath.row];
		NSInteger i = [[r objectForKey:@"IDesercente"] integerValue];
		NSLog(@"L'id dell'esercente da visualizzare è %d",i );
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		DettaglioRistoPub *detail = [[[DettaglioRistoPub alloc] initWithNibName:@"DettaglioRistoPub" bundle:[NSBundle mainBundle]] autorelease];
		[detail setIdentificativo:i];
		[detail setTitle:@"Esercente"];
        //Facciamo visualizzare la vista con i dettagli
		[self.navigationController pushViewController:detail animated:YES];
	} else {
        [super tableView:(UITableView *)tableView didSelectRowAtIndexPath:indexPath];
	}
}


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

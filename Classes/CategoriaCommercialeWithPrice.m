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
#import "CachedAsyncImageView.h"

@implementation CategoriaCommercialeWithPrice


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!nibNameOrNil) {
        nibNameOrNil = [NSString stringWithFormat:@"%@", [self superclass]];
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

# pragma mark - View lifecycle


- (void) viewDidLoad {
    [super viewDidLoad];
    //NSLog (@"sto cambiando il valore di urlString");
    [_urlString release];
    _urlString = @"http://www.cartaperdue.it/partner/v2.0/EsercentiRistorazione_con_img.php";
    [self.searchSegCtrl insertSegmentWithTitle:@"Prezzo" atIndex:1 animated:NO];
    CGRect frame = self.searchSegCtrl.frame;
    frame.size.width = 236;
    self.searchSegCtrl.frame = frame;
    CGPoint center = self.searchSegCtrl.center;
    center.x = self.view.center.x;
    self.searchSegCtrl.center = center;
    
    self.filterPanel = [[PullableView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width-30, self.tableView.frame.origin.y, 296, 56)];
    
    filterPanel.openedCenter = CGPointMake(self.tableView.frame.size.width-100, self.tableView.frame.origin.y+ (filterPanel.frame.size.height / 2));
    filterPanel.closedCenter = CGPointMake(self.tableView.frame.size.width +( (self.filterPanel.frame.size.width / 2)-30), self.tableView.frame.origin.y+ (filterPanel.frame.size.height / 2));
    
    filterPanel.center = filterPanel.closedCenter;
    filterPanel.animate = YES;
    [filterPanel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"filterPanel.png"]]];
    [self.filterPanel setAlpha:0.95];
    [self.view addSubview:self.filterPanel];
    [self.filterPanel release];
    
    UIImageView *imageFilter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filtroDisattivato.png"]];
    [imageFilter setFrame:CGRectMake(13, 8, imageFilter.frame.size.width, imageFilter.frame.size.height)];
    
    [self.filterPanel addSubview:imageFilter];
    [imageFilter release];
    
    segCtrlFilter = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Tutti",@"Pranzo",@"Cena", nil]];
    segCtrlFilter.selectedSegmentIndex = 0;
    
    [segCtrlFilter setFrame:CGRectMake(60, self.filterPanel.frame.size.height/4, 161, 30)];
    
    UIColor *newTintColor = [UIColor colorWithRed: 251/255.0 green:175/255.0 blue:93/255.0 alpha:1.0];
    segCtrlFilter.segmentedControlStyle = UISegmentedControlStyleBar;
    segCtrlFilter.tintColor = newTintColor;
    
    [segCtrlFilter addTarget:self action:@selector(didChangeFilterSegCtrlState:) forControlEvents:UIControlEventValueChanged];
    
//    UIColor *newSelectedTintColor = [UIColor colorWithRed: 0/255.0 green:175/255.0 blue:0/255.0 alpha:1.0];
//    [[[segCtrlFilter subviews] objectAtIndex:0] setTintColor:newSelectedTintColor];
    
    [self.filterPanel addSubview:segCtrlFilter];
    
}

-(void)dealloc{
    
    [segCtrlFilter release];
    [super dealloc];
}

-(void)viewDidUnload{
    
    [segCtrlFilter release];
    segCtrlFilter = nil;
}

# pragma mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
        // Stiamo mostrando la cella relativa ad un esercente
		UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"CategoriaCommercialeWithPrice"];
		
		if (cell == nil){
			cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoriaCommercialeWithPriceCell" owner:self options:NULL] objectAtIndex:0];
		}
		
		NSDictionary *r  = [super.dataModel objectAtIndex:indexPath.row];
		
        CachedAsyncImageView *caImageView = (CachedAsyncImageView *)[cell viewWithTag:5];
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.cartaperdue.it/partner/v2.0/ImmagineEsercente.php?id=%d", [[r objectForKey:@"IDesercente"] intValue]]];
        [caImageView loadImageFromURL:imageUrl];
        
        UILabel *cucina = (UILabel*)[cell viewWithTag:6];
        if([[r objectForKey:@"Subtipo_STeser"] isEqualToString:@"Non Disponibile"])
            cucina.text = [NSString stringWithFormat:@"Cucina: --"];
        else cucina.text = [NSString stringWithFormat:@"Cucina: %@",[r objectForKey:@"Subtipo_STeser"]];
        
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
		indirizzo.text = [NSString stringWithFormat:@"%@,\n%@",[r objectForKey:@"Indirizzo_Esercente"],[r objectForKey:@"Citta_Esercente"]];	
		indirizzo.text= [indirizzo.text capitalizedString];
        
		UILabel *distanza = (UILabel *)[cell viewWithTag:4];
		distanza.text = [NSString stringWithFormat:@"a %.1f km",[[r objectForKey:@"Distanza"] doubleValue]];	
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	} else {
        return [super tableView:tView cellForRowAtIndexPath:indexPath];
    }
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
		NSDictionary* r = [super.dataModel objectAtIndex: indexPath.row];
		NSInteger i = [[r objectForKey:@"IDesercente"] integerValue];
		//NSLog(@"L'id dell'esercente da visualizzare è %d",i );
        DettaglioEsercenteRistorazione *detail = [[DettaglioEsercenteRistorazione alloc]initWithNibName:nil bundle:nil couponMode:NO genericoMode:NO];
		detail.idEsercente = i;
        UITableViewCell *cell = [tView cellForRowAtIndexPath:indexPath];
        detail.img = ((CachedAsyncImageView*)[cell viewWithTag:5]).image;
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

- (NSString *)filterMethod{
    
    switch(segCtrlFilter.selectedSegmentIndex)
    {
        case 0:
            return @"Tutti";
            break;
        case 1:
            return @"Pranzo";
            break;
        case 2:
            return @"Cena";
        default:
            return @"";
            break;
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

-(IBAction)didChangeFilterSegCtrlState:(id)sender{

    [super fetchRows];
    
    switch(segCtrlFilter.selectedSegmentIndex)
    {
        case 0:
            NSLog(@"TUTTI");
            break;
        case 1:
            NSLog(@"PRANZO");
            break;
        case 2:
            NSLog(@"CENA");
        default:
            break;
    }
}



@end

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
@synthesize filterPanel, filterImg;

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
    _urlString = @"http://www.cartaperdue.it/partner/v2.0/EsercentiRistorazione.php";
    [self.searchSegCtrl insertSegmentWithTitle:@"Prezzo" atIndex:1 animated:NO];
    CGRect frame = self.searchSegCtrl.frame;
    frame.size.width = 190;
    frame.origin.x = 55;
    self.searchSegCtrl.frame = frame;
//    CGPoint center = self.searchSegCtrl.center;
//    center.x = self.view.center.x;
//    self.searchSegCtrl.center = center;
    
    
    filterPanel = [[PullableView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width-50,self.searchBar.frame.size.height, 340, 35)];
    
    filterPanel.delegate = self;
    
//    self.filterPanel.openedCenter = CGPointMake(self.tableView.frame.size.width-100, self.tableView.frame.origin.y+ (self.filterPanel.frame.size.height / 2));
//    self.filterPanel.closedCenter = CGPointMake(self.tableView.frame.size.width +( (self.filterPanel.frame.size.width / 2)-30), self.tableView.frame.origin.y+ (self.filterPanel.frame.size.height / 2));
//    
//    self.filterPanel.center = self.filterPanel.closedCenter;
    filterPanel.openedCenter = CGPointMake(self.tableView.frame.size.width-80, self.searchBar.frame.size.height+ (self.filterPanel.frame.size.height / 2));
    filterPanel.closedCenter = CGPointMake(self.tableView.frame.size.width+( (self.filterPanel.frame.size.width / 2)-50), self.searchBar.frame.size.height+ (self.filterPanel.frame.size.height / 2));
    filterPanel.center = self.filterPanel.closedCenter;
    filterPanel.animate = YES;
    [filterPanel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rightPanel.png"]]];
    [filterPanel setAlpha:0.95];
    
    
    segCtrlFilter = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Tutti",@"Pranzo",@"Cena", nil]];
    segCtrlFilter.selectedSegmentIndex = 0;
    [segCtrlFilter setFrame:CGRectMake(56, 4, 190, 26)];
    UIColor *newTintColor = [UIColor colorWithRed: 180/255.0 green:21/255.0 blue:7/255.0 alpha:1.0];
    //UIColor *newTintColor = [UIColor colorWithRed: 251/255.0 green:175/255.0 blue:93/255.0 alpha:1.0];
    segCtrlFilter.segmentedControlStyle = UISegmentedControlStyleBar;
    segCtrlFilter.tintColor = newTintColor;
        
    [segCtrlFilter addTarget:self action:@selector(didChangeFilterSegCtrlState:) forControlEvents:UIControlEventValueChanged];

    filterImg = [[UIImageView alloc] initWithFrame:CGRectMake(22, 8, 20, 20)];
    filterImg.backgroundColor = [UIColor clearColor];
    filterImg.image = [UIImage imageNamed:@"filterImg.png"];
    [filterPanel addSubview:filterImg];
    
    [filterPanel addSubview:segCtrlFilter];
    [self.view addSubview:self.filterPanel];
    //[self.filterPanel release];
    //[self.filterImg release];    
    
    
    /* //vecchia barra filtro
     
    self.filterPanel = [[PullableView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width-30, self.tableView.frame.origin.y, 296, 56)];
    
    self.filterPanel.openedCenter = CGPointMake(self.tableView.frame.size.width-100, self.tableView.frame.origin.y+ (self.filterPanel.frame.size.height / 2));
    self.filterPanel.closedCenter = CGPointMake(self.tableView.frame.size.width +( (self.filterPanel.frame.size.width / 2)-30), self.tableView.frame.origin.y+ (self.filterPanel.frame.size.height / 2));
    
    self.filterPanel.center = self.filterPanel.closedCenter;
    self.filterPanel.animate = YES;
    [self.filterPanel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"filterPanel.png"]]];
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
     
     */
    
}

-(void)dealloc{

    [filterImg release];
    [filterPanel release];
//    self.filterImg = nil;
//    self.filterPanel = nil;
    [segCtrlFilter release];
    [super dealloc];
}

-(void)viewDidUnload{
    
    self.filterImg = nil;
    self.filterPanel = nil;
    [segCtrlFilter release];
    segCtrlFilter = nil;
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.filterPanel setOpened:FALSE animated:YES];
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
		
        CachedAsyncImageView *caImageView = (CachedAsyncImageView *)[cell viewWithTag:7];
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.cartaperdue.it/partner/v2.0/ImmagineEsercente.php?id=%d", [[r objectForKey:@"IDesercente"] intValue]]];
        [caImageView loadImageFromURL:imageUrl];
        
        UILabel *esercente  = (UILabel *)[cell viewWithTag:1];
        UILabel *cucina     = (UILabel *)[cell viewWithTag:2];
        UILabel *indirizzo  = (UILabel *)[cell viewWithTag:3];
        UILabel *citta      = (UILabel *)[cell viewWithTag:4];
        UILabel *prezzo     = (UILabel *)[cell viewWithTag:5];
        UILabel *distanza   = (UILabel *)[cell viewWithTag:6];

        esercente.text  = [r objectForKey:@"Insegna_Esercente"];
        cucina.text     = [NSString stringWithFormat:@"Cucina: %@",
                           [r objectForKey:@"Subtipo_STeser"]];
        indirizzo.text  = [[r objectForKey:@"Indirizzo_Esercente"] capitalizedString];
        citta.text      = [[r objectForKey:@"Citta_Esercente"] capitalizedString];
        prezzo.text     = [NSString stringWithFormat:@"%@€",
                           [r objectForKey:@"Fasciaprezzo_Esercente"]];
        distanza.text   = [NSString stringWithFormat:@"a %.1f km",
                           [[r objectForKey:@"Distanza"] doubleValue]];
                
        if ([prezzo.text isEqualToString:@"<null>€"]) {
            prezzo.text = @"";
        }

		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	} 
    else {
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

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    
    [super searchBarTextDidBeginEditing:searchBar];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [segCtrlFilter setEnabled:NO];
    segCtrlFilter.alpha = 0.5;
    [UIView commitAnimations];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [super searchBarCancelButtonClicked:searchBar];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [segCtrlFilter setEnabled:YES];
    segCtrlFilter.alpha = 1.0;
    [UIView commitAnimations];
    
}

#pragma mark - CategoriaCommercialeWithPrice (metodi privati)

- (NSString *)filterMethod{
    
    switch(segCtrlFilter.selectedSegmentIndex)
    {
        case 0:
            self.filterImg.image = [UIImage imageNamed:@"filterImg.png"];
            return @"Tutti";
            break;
        case 1:
            self.filterImg.image = [UIImage imageNamed:@"sun.png"];
            return @"Pranzo";
            break;
        case 2:
            self.filterImg.image = [UIImage imageNamed:@"moon.png"];
            return @"Cena";
        default:
            self.filterImg.image = [UIImage imageNamed:@"filterImg.png"];
            return @"";
            break;
    }
    
}

- (NSString *)searchMethod {
    NSInteger selection = [self.searchSegCtrl selectedSegmentIndex];
    if (selection == 0) {
        self.sortingLbl.text = @"Km";
        return @"distanza";
    } else if (selection == 1) {
        self.sortingLbl.text = @"  €";
        return @"prezzo";
    } else if (selection == 2) {
        self.sortingLbl.text = @"A-Z";
        return @"nome";
    } else {
        self.sortingLbl.text = @"";
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

#pragma mark - PullableView Delegate

- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened{
    NSLog(@"STATO DEL SIDE PANEL = %@", opened?@"aperto":@"chiuso");
    
    if([pView isEqual:self.filterPanel] && opened){
        [leftPanel setOpened:FALSE animated:YES];
    }
    else if([pView isEqual:leftPanel] && opened){
        [self.filterPanel setOpened:FALSE animated:YES];
    }
}



@end

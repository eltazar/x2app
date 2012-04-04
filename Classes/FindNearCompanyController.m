//
//  FindNearCompanyController.m
//  PerDueCItyCard
//
//  Created by mario greco on 03/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FindNearCompanyController.h"
#import "Utilita.h"
#import "BaseCell.h"
#import "DatabaseAccess.h"

@interface FindNearCompanyController(){
    DatabaseAccess *dbAccess;
     NSString *_phpFile;
}
@property (nonatomic, retain) NSString *phpFile;
@end

@implementation FindNearCompanyController

@synthesize urlString = _urlString, rows = _rows, phpFile = _phpFile;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - DatabaseAccessDelegate
-(void)didReceiveCoupon:(NSDictionary *)dataDict{
    NSLog(@"ESERCENTI VICINI = %@", dataDict); 
    
    NSString *type = [[dataDict allKeys] objectAtIndex:0];
    NSArray *newRows = [dataDict objectForKey:type]s;
    
    // Ci aspettiamo che rows sia effettivamente un array, se non lo è
    // si ignora.
    if (![newRows isKindOfClass:[NSArray class]]) return;
    
    if ([type isEqualToString:@"Esercente:FirstRows"]) {
        //table view begin updates at indexes blah blah 
        [self.tableView beginUpdates];
        [self.rows removeAllObjects];
        [self.rows addObjectsFromArray:newRows];
        [self.tableView endUpdates] ;

    } 
    else if ([type isEqualToString:@"Esercente:MoreRows"]) {
       
        //creo i nuovi indexPaths per le righe ricevute
        NSMutableArray *indexPaths = [[NSMutableArray alloc]initWithCapacity:newRows.count]; 
        for (int i = self.rows.count; i < self.rows.count + newRows.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [self.tableView beginUpdates];
        [self.rows addObjectsFromArray:newRows];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [indexPaths release];
        
        //aggiorno la riga "mostra"
        if(newRows.count < 20){
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
            altri2.text = @"Non ci sono altre news da mostrare";
        }
    }

}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"ERRORE CONNESSIONE = %@", [error localizedDescription]);
}

#pragma mark - metodi privati
- (void) fetchRows{
    
    NSString *postString = [NSString stringWithFormat:
                            @"request=fetch&lat=41.890520&long=12.494249&giorno=Mercoledi&raggio=%d&ordina=distanza&from=%d",1,0];
    NSLog(@"urlString is: [%@]", self.urlString);
    NSLog(@"postString is: [%@]", postString);
    [dbAccess postConnectionToURL:self.urlString withData:postString];

    //[self.tableView reloadData];
}


- (void)fetchMoreRows {
    
    NSString *postString = [NSString stringWithFormat:
                            @"request=fetch&lat=%f&long=%f&giorno=%@&raggio=%d&ordina=distanza&from=%d",0.0,0.0,10, self.rows.count];
    [dbAccess postConnectionToURL:self.urlString withData:postString];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.urlString = @"http://www.cartaperdue.it/partner/v2.0/Esercenti.php";
    self.rows = [[[NSMutableArray alloc] init] autorelease];
    
    dbAccess = [[DatabaseAccess alloc]init];
    dbAccess.delegate = self;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    self.urlString = nil;
    self.rows = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(![Utilita networkReachable]){
        NSLog(@"ALERT INTERNET ASSENTE");
    }
    else{
        [self fetchRows];
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    
    self.phpFile = nil;
    self.urlString = nil;
    self.rows = nil;
    dbAccess.delegate = nil;
    [dbAccess release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tView {
	if ([self.rows count] < 6) {
		return 1;
	} else {
		return 2;
	}
}


- (NSInteger)tableView:(UITableView *)tView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return [self.rows count];
		case 1:
			return 1;
		default:
			return 0;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
        // Stiamo mostrando la cella che suggerisce la visualizzazione di ulteriori esercenti
		static NSString *CellIdentifier = @"LastCell";
		UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil){
			cell = [[[NSBundle mainBundle] loadNibNamed:@"LastCell" owner:self options:NULL] objectAtIndex:0];
		}
		UILabel *altri = (UILabel *)[cell viewWithTag:1];
		altri.text = @"Mostra altri...";
		UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
		altri2.text = @"";
		return cell;		
	} else {
        // Stiamo mostrando la cella relativa ad un esercente
		static NSString *CellIdentifier = @"CategoriaCommercialeCell";
		UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil){
			cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoriaCommercialeCell" owner:self options:NULL] objectAtIndex:0];
		}
		
		NSDictionary *r  = [self.rows objectAtIndex:indexPath.row];
		
		UILabel *esercente = (UILabel *)[cell viewWithTag:1];
		esercente.text = [r objectForKey:@"Insegna_Esercente"];
		
		UILabel *indirizzo = (UILabel *)[cell viewWithTag:2];
		indirizzo.text = [NSString stringWithFormat:@"%@, %@",[r objectForKey:@"Indirizzo_Esercente"],[r objectForKey:@"Citta_Esercente"]];	
		indirizzo.text= [indirizzo.text capitalizedString];
        
		UILabel *distanza = (UILabel *)[cell viewWithTag:3];
		distanza.text = [NSString stringWithFormat:@"a %.1f Km",[[r objectForKey:@"Distanza"] doubleValue]];	
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	}
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - UITableViewDelegate


//- (UIView *)tableView:(UITableView *)tView viewForFooterInSection:(NSInteger)section {
//    return self.footerView;
//}


//- (CGFloat)tableView:(UITableView *)tView heightForFooterInSection:(NSInteger)section {
//	switch (section) {
//		case 0:
//			return 0;	
//		case 1:
//			return 65;
//		default:
//			return 0;
//	}
//}


- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
        /*
		NSDictionary* r = [self.rows objectAtIndex: indexPath.row];
		NSInteger i = [[r objectForKey:@"IDesercente"] integerValue];
		NSLog(@"L'id dell'esercente da visualizzare è %d",i );
		DettaglioEsercenti *detail = [[DettaglioEsercenti alloc] initWithNibName:@"DettaglioEsercenti" bundle:[NSBundle mainBundle]];//] autorelease];
		[(DettaglioEsercenti*)detail setIdentificativo:i];
		[detail setTitle:@"Esercente"];
        //Facciamo visualizzare la vista con i dettagli
        //        if (inSearchUI)
        //            [self.navigationController setNavigationBarHidden:NO animated:YES];
		[self.navigationController pushViewController:detail animated:YES];
        [detail release];*/
	}
	else { 
        //riga mostra altri
		[self fetchMoreRows];
//		if (i < 20) { // non ci sono alri esercenti
//			UITableViewCell *cell = [tView cellForRowAtIndexPath:indexPath];
//			UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
//			altri2.text = @"Non ci sono altri esercenti da mostrare";
//		}
	}
}

@end

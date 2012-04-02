//
//  AcquistoOnlineController.m
//  PerDueCItyCard
//
//  Created by mario greco on 08/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "AcquistoOnlineController.h"
#import "BaseCell.h"
#import "Utilita.h"
#import "IAPHelper.h"
//

@implementation AcquistoOnlineController
@synthesize hud = _hud;

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

#pragma mark - Gestioni caricamenti 

- (void)timeout:(id)arg {
    
    _hud.labelText = @"Tempo scaduto!";
    _hud.detailsLabelText = @"Spiacenti, riprovare più tardi!";
    _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
	_hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    
}

- (void)dismissHUD:(id)arg {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.hud = nil;
    
}

- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.tableView.hidden = FALSE;    
    
    [self.tableView reloadData];
    
}

#pragma mark - Gestion bottoni
- (IBAction)buyButtonTapped:(id)sender {
    
    NSLog(@"bottone premuto numero = %d", ((UIButton*)sender).tag);
    
   
    UIButton *buyButton = (UIButton *)sender;    
    SKProduct *product = [[IAPHelper sharedHelper].products objectAtIndex:buyButton.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[IAPHelper sharedHelper] buyProductIdentifier:product];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"Acquisto carta...";
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
   
}

#pragma mark - DatabaseACcessDelegate

-(void)didReceiveCoupon:(NSDictionary *)coupon{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    //NSLog(@"RICEVUTA LISTA ID PRODOUCT = %@, tipo = %@",coupon, [[coupon objectForKey:@"CatalogoIAP"] class]);
    //NSLog(@"oggetto 1 = %@", [[[coupon objectForKey:@"CatalogoIAP"] objectAtIndex:0] class]);
    
    
    //recupero gli id dei product dal server aziendale
    if(coupon){
        for(NSDictionary *tempDict in [coupon objectForKey:@"CatalogoIAP"]){
            
            [((NSMutableSet*)productsId) addObject: [tempDict objectForKey:@"product_id"]];
        }
    }
    
    NSLog(@"SET = %@",productsId);
    
    if([Utilita networkReachable]){
        //recuperati gli id creo istanza del manager in app purchase
    
        NSLog(@"product id = %@", productsId);
        [IAPHelper sharedHelper].productIdentifiers = productsId;
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"Caricamento catalogo...";
        
        //lancio richiesta prodotti ai server apple
        [[IAPHelper sharedHelper] requestProducts];

        //dopo 30 secondi di attesa viene lanciato il metodo
        //[self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
    }
    else{
        NSLog(@"lancio query prodotti alla apple: internet assente");
    }
    
}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"RICEZIONE CATALOGO AZIENDA ERRORE SERVER = %@", [error description]);
    [self dismissHUD:nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Acquisti";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    
    NSLog(@"define = %@",kProductsLoadedNotification);
    
    dbAccess = [[DatabaseAccess alloc] init];
    dbAccess.delegate = self;
    
    productsId = [[NSMutableSet alloc] init];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    self.hud = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    
    [_hud release];
    _hud = nil;
    
    [productsId release];
    dbAccess.delegate = nil;
    [dbAccess release];

    
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#warning inserire canMakePurchase prima di visualizzare store
    
    if([Utilita networkReachable]){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"Caricamento catalogo...";
        [dbAccess getCatalogIAP];
    }
    else{
        NSLog(@"ACQUISTO ONLINE VIEW: INTERNET NON DISPONIBILE");
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{   
    //return [iapHelper.products count];
    return 3;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
       // cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        [[NSBundle mainBundle] loadNibNamed:@"CellProdottoListino" owner:self options:nil];
		cell = cellProdotto;
    }
    
	// Configure the cell.
    
    /*
     SKProduct *product = [iapHelper.products objectAtIndex:indexPath.row];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:product.price];
    */
    //cell.textLabel.text = product.localizedTitle;
    //cell.detailTextLabel.text = formattedString;
    
    /*
    cell.textLabel.text = @"prova";
    cell.detailTextLabel.text = @"prova 2";
    */
    
    UILabel *prodotto = (UILabel *)[cell viewWithTag:1];
    UILabel *descrizione = (UILabel *)[cell viewWithTag:2];
    UILabel *prezzo = (UILabel *)[cell viewWithTag:3];
    
    if(indexPath.row == 0){
        prodotto.text = @"Carta PerDue Biennale";
        descrizione.text = @"Carta vantaggi valida 24 mesi";
        prezzo.text = @"prezzo: 54,99€";
    }
    else if(indexPath.row == 1)
    {
        prodotto.text = @"Carta PerDue Annuale";
        descrizione.text = @"Carta vantaggi valida 12 mesi";
        prezzo.text = @"prezzo: 35,99€";
        
    }
    else if(indexPath.row == 2)
    {
        prodotto.text = @"Carta PerDue Semestrale";
        descrizione.text = @"Carta vantaggi valida 6 mesi";
        prezzo.text = @"Prezzo: 19,99€";
        
    }
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.frame = CGRectMake(0, 0, 65, 32);
    [buyButton setTitle:@"Compra" forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    buyButton.tag = indexPath.row;
    [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setBackgroundImage:[UIImage imageNamed:@"greenButton.png"] forState:UIControlStateNormal];
    buyButton.layer.cornerRadius = 5.0f;
    buyButton.layer.masksToBounds = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = buyButton;   
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
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

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 78;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end

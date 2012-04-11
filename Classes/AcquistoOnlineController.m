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

@interface AcquistoOnlineController()

@property(nonatomic, retain) NSArray *products;
@end

@implementation AcquistoOnlineController
@synthesize products;

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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Tempo scaduto!";
    hud.detailsLabelText = @"Spiacenti, riprovare più tardi!";
    hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
	hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    
}

- (void)dismissHUD:(id)arg {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];    
}

- (void)productsLoaded:(NSNotification *)notification {
    
    //ho recuperato catalogo da server apple e lo mostro
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.tableView.hidden = FALSE;    
    
    self.products = [IAPHelper sharedHelper].products;
    
    [self.tableView reloadData];
    
}

- (void)productPurchased:(NSNotification *)notification {
    
   [MBProgressHUD hideHUDForView:self.view animated:YES];    
    
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
        
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;    
    if (transaction.error.code != SKErrorPaymentCancelled) {    
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Errore!" 
                                                         message:transaction.error.localizedDescription 
                                                        delegate:nil 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
    }
    
}

#pragma mark - Gestion bottoni
- (IBAction)buyButtonTapped:(id)sender {
    
    NSLog(@"bottone premuto numero = %d", ((UIButton*)sender).tag);
   
    UIButton *buyButton = (UIButton *)sender;    
    SKProduct *product = [[IAPHelper sharedHelper].products objectAtIndex:buyButton.tag];
    
    //NSLog(@"Buying %@...", product.productIdentifier);
    
    //lancio hud per processo di acquisto
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Acquisto carta...";
    
    //lancio procedura di acquisto
    [[IAPHelper sharedHelper] buyProductIdentifier:product];
    
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
   
}

#pragma mark - DatabaseACcessDelegate

-(void)didReceiveCoupon:(NSDictionary *)coupon{
    
    //sono stati caricati i codici dal catalogo sul nostro server
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    //NSLog(@"RICEVUTA LISTA ID PRODOUCT = %@, tipo = %@",coupon, [[coupon objectForKey:@"CatalogoIAP"] class]);
    //NSLog(@"oggetto 1 = %@", [[[coupon objectForKey:@"CatalogoIAP"] objectAtIndex:0] class]);
    
    
    //recupero gli id dei product dal server aziendale
    if(coupon){
        for(NSDictionary *tempDict in [coupon objectForKey:@"CatalogoIAP"]){
            
            [((NSMutableSet*)productsId) addObject: [tempDict objectForKey:@"product_id"]];
        }
    }
        
    if([Utilita networkReachable]){
    
        NSLog(@"product id = %@", productsId);
        [IAPHelper sharedHelper].productIdentifiers = productsId;
        
        //carico catalogo sui server apple
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Caricamento catalogo...";
        
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    
    self.products = nil;
    
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
        //carico codici da catalogo sul nostro server
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Caricamento catalogo...";
        
        [dbAccess getCatalogIAP];
    }
    else{
#warning inserire alert
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
    return self.products.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AcquistoOnlineCell"];
    if (cell == nil) {
       // cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        [[NSBundle mainBundle] loadNibNamed:@"AcquistoOnlineCell" owner:self options:nil];
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
    
    SKProduct *pd = (SKProduct*)[self.products objectAtIndex:indexPath.row];
    
    prodotto.text = pd.localizedTitle;
    descrizione.text = pd.localizedDescription;
    prezzo.text = [NSString stringWithFormat:@"%@€",pd.price];
    
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

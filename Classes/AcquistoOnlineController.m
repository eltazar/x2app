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
#import "PDHTTPAccess.h"
#import "DataLoginController.h"
#import "LocalDatabaseAccess.h"

#warning quando l'utente procede all'acquisto e quindi c'è 
// la schermata "acquisto..." bloccare l'intera view, e non dare all'utente la possibilità di tornare indietro o cambiare tab? VALUTARE STA COSA!!!!!

@interface AcquistoOnlineController()

@property(nonatomic, retain) NSArray *products;
@end

@implementation AcquistoOnlineController
@synthesize products;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self){
        // Custom initialization
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductsLoadedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchaseFailedNotification object:nil];  
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
        
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kCardServerError object:nil];    
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(cardDownloadError:) name:kCardServerError object: nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kCardDownloaded object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(cardDownloaded:) name:kCardDownloaded object: nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kCardDownloading object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(cardDownloading:) name:kCardDownloading object: nil];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
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
    
#warning quando parte questo hud, "acquisto carta" rimane comunque -> risolvere e valutare l'effettiva utilità di questo timeout
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
    
    //NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"ACQUISTO ONLINE CONTROLLER : Card acquistata: %@, notification = %@ ", notification.object, notification);
        
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

#pragma mark - gestione acquisto card

-(void) cardDownloadError:(NSNotification*) notification{
    NSLog(@"ACQUISTO ONLINE CONTROLLER : errore lato server nel recupero carta");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void) cardDownloaded:(NSNotification*) notification{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"ACQUISTO ONLINE CONTROLLER : carta scaricata = %@",notification.object);
    //mostrare alert

    //TODO: creare la carta con i dati ricevuti e nome e cognome presi da userdefault, quindi salvare sul db locale
    
    NSDictionary *cardReceived = (NSDictionary*)notification.object;
    
    CartaPerDue *card = [[CartaPerDue alloc] init];
    card.name = [[NSUserDefaults standardUserDefaults] objectForKey:@"originalName"];
    card.surname = [[NSUserDefaults standardUserDefaults] objectForKey:@"originalSurname"];     
    card.number = [cardReceived objectForKey:@"number"];
    
    card.expiryString = [cardReceived objectForKey:@"expiryDate"];
    
    NSError *error;
    if (![[LocalDatabaseAccess getInstance]storeCard:card AndWriteErrorIn:&error]) {
        NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
    } else{
        //[self didAssociateNewCard];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPurchasedCard object:nil];
    }
    
    [card release];
    
}

-(void) cardDownloading:(NSNotification*) notification{
    NSLog(@"ACQUISTO ONLINE CONTROLLER : downloading carta acquistata");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Acquisto effettuato";
    hud.detailsLabelText = @"Download carta...";
}

#pragma mark - Gestion bottoni
- (IBAction)priceButtonTapped:(id)sender {
    
    //NSLog(@"bottone premuto numero = %d", ((UIButton*)sender).tag);
   
    //UITableViewCell *clickedCell = (UITableViewCell *)[sender superview];
    //NSIndexPath *clickedButtonPath = [self.tableView indexPathForCell:clickedCell];
    CGRect frame = ((UIButton*)sender).frame;
    
    //NSLog(@"cell = %@, index path = %@",clickedCell,clickedButtonPath);

    [UIView animateWithDuration:0.2
                     animations:^(void){
                         ((UIButton*)sender).frame = CGRectMake(frame.origin.x, frame.origin.y, 70, frame.size.height); 
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2
                                          animations:^(void){
                                              [((UIButton*)sender) setTitle:@"Acquista" forState:UIControlStateNormal];
                                          }
                          ];
                         
                     }
     ];
    
    [((UIButton*)sender) addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
   
}

-(void)buyButtonTapped:(id)sender{
 
    //lancio acquisto
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

-(void)didLogout{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WMHTTPAccessDelegate

-(void)didReceiveJSON:(NSDictionary *)jsonDict {
    
    //sono stati caricati i codici dal catalogo sul nostro server
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    //NSLog(@"RICEVUTA LISTA ID PRODOUCT = %@, tipo = %@",coupon, [[coupon objectForKey:@"CatalogoIAP"] class]);
    //NSLog(@"oggetto 1 = %@", [[[coupon objectForKey:@"CatalogoIAP"] objectAtIndex:0] class]);
    
    
    //recupero gli id dei product dal server aziendale
    if (jsonDict) {
        for(NSDictionary *tempDict in [jsonDict objectForKey:@"CatalogoIAP"]){
            
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
    
    self.tableView.scrollEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:kDidLogoutNotification object:nil];
    
    [retrieveView setHidden:YES];
    
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:[IAPHelper sharedHelper]];
    
    self.title = @"Acquisti";
  
    /*
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchaseFailedNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCardServerError object:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(cardDownloadError:) name:kCardServerError object: nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCardDownloaded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(cardDownloaded:) name:kCardDownloaded object: nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCardDownloading object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(cardDownloading:) name:kCardDownloading object: nil];
    
     */
    
    productsId = [[NSMutableSet alloc] init];
    
    //salvo dati dell'utente appena loggato nel negozio online, per usarli quando creo la carta acquistata e inviare i dati al server, nel caso in cui durante la procedura di acquisto l'utente si slogghi da altre parti
    
    NSString *originalName = [[NSUserDefaults standardUserDefaults] objectForKey:@"_nomeUtente"];
    NSString *originalSurname = [[NSUserDefaults standardUserDefaults] objectForKey:@"_cognome"];
    NSString *originalUserId = [[NSUserDefaults standardUserDefaults] objectForKey:@"_idUtente"];
   
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"originalName"];
    [[NSUserDefaults standardUserDefaults] setObject:originalName forKey:@"originalName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"originalSurname"];
    [[NSUserDefaults standardUserDefaults] setObject:originalSurname forKey:@"originalSurname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"originalUserId"];
    [[NSUserDefaults standardUserDefaults] setObject:originalUserId forKey:@"originalUserId"];
  
    [[NSUserDefaults standardUserDefaults] synchronize];
 
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    self.products = nil;
    [productsId release];
    productsId = nil;
    
    [retrieveView release];
    retrieveView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    
    //TODO: fare removing dell'observer inapp purchase?
    //removeTransactionObserver:
    
    [retrieveView release];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchaseFailedNotification object:nil];  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCardServerError object:nil];    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCardDownloaded object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCardDownloading object:nil];
    
    self.products = nil;
    
    [productsId release];
    [super dealloc];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"error_purchase"]){
        
        [retrieveView setHidden:NO];
        [self.view addSubview:retrieveView];
        return;
    }
    
#warning inserire canMakePurchase prima di visualizzare store
    
    if([Utilita networkReachable]){
        //carico codici da catalogo sul nostro server
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Caricamento catalogo...";
        [PDHTTPAccess getIAPCatalogWithDelegate:self];
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
    prezzo.text = [NSString stringWithFormat:@"%@ €",pd.price];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.frame = CGRectMake(0, 0, 65, 32);
    [buyButton setTitle:[NSString stringWithFormat:@"%@ €",pd.price] forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    buyButton.tag = indexPath.row;
    [buyButton addTarget:self action:@selector(priceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setBackgroundImage:[UIImage imageNamed:@"greenButton.png"] forState:UIControlStateNormal];
    buyButton.layer.cornerRadius = 5.0f;
    buyButton.layer.masksToBounds = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = buyButton;   
    //[cell.contentView addSubview:buyButton];
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

//
//  IAPHelper.m
//  PerDueCItyCard
//
//  Created by mario greco on 21/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IAPHelper.h"

#import "PDHTTPAccess.h"
#import "Utilita.h"
#import "MBProgressHUD.h"
@implementation IAPHelper

@synthesize productIdentifiers = _productIdentifiers;
@synthesize products = _products;
//@synthesize purchasedProducts = _purchasedProducts;
@synthesize request = _request;

static IAPHelper * _sharedHelper;


+ (IAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[IAPHelper alloc] init];
    return _sharedHelper;
    
}


- (id)init {
    self = [super init];
    if(self){

    }
    return self;
    
}

//- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
//    if ((self = [super init])) {
//        
//        // Store product identifiers
//        _productIdentifiers = [productIdentifiers retain];
//        
//    }
//    return self;
//}

- (void)requestProducts {
    
    NSLog(@"_product = %@", _productIdentifiers);
    self.request = [[[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers] autorelease];
    _request.delegate = self;
    [_request start];
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Received products results...");   
    self.products = response.products;
    NSLog(@"products = %@",self.products);
    
    for (SKProduct *pd in self.products) {
        NSLog(@"PRODOTTO = %@, %@, %@", pd.localizedTitle,pd.localizedDescription,pd.price);
    }
    
    self.request = nil;    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];    
}

#pragma mark - WMHTTPAccessDelegate

-(void)didReceiveJSON:(NSDictionary *)jsonDict {
    // Nota di Whisky: usare questo metodo per qualsiasi risposta dal server, si distingue ciò che si sta facendo in base alla chiave del dict più esterno.
    
    //NSLog(@"iap helper ricevuto dati = %@", jsonDict);
    //riceve carta perdue se tutto è stato verificato
    
    if([jsonDict objectForKey:@"Buyed_card"]){
        NSLog(@"didReceiveJson -> lancio notifica downloaded");
        [[NSNotificationCenter defaultCenter] postNotificationName:kCardDownloaded object:jsonDict];
    }
    else if([jsonDict objectForKey:@"CartaRecuperata"]){
        NSLog(@"CARTA RECUPERATA");
        [[NSNotificationCenter defaultCenter] postNotificationName:kCardRetrieved object:jsonDict];
    }
    else if([jsonDict objectForKey:@"Buyed_card_error"]){
        NSLog(@"errore scrittura carta su db");
    }
/*
    //debug
   static int i = 1;
    if( i ==1 ){
        [self didReceiveError:nil];
        i++;
    }
 */
    
}


-(void)didReceiveError:(NSError *)error{
    
    //se ricevo errore
    //mostro pulsante recupera in cardsViewController e blocco lo store
    //NO : riprovare tipo 3 volte a scaricare la carta, magari con un avviso e un pulsante "riprova" per rifare la query che mi deve ritornare la carta x2 acquistata dalla transaction -> quindi in teoria ripassare l'id utente e l'id della transaction e recuperare dal db il relativo record
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCardServerError object:nil];
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Errore connessione" message:@"Errore di connessione, premi Ricarica per scaricare l'acquisto effettuato"  delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"Ricarica", nil]autorelease];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        
    if([alertView.title isEqualToString:@"Errore connessione"] && buttonIndex == 1){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCardDownloading object:nil];
        
        //questo sembra funzionare
        [PDHTTPAccess retrieveCardFromServer:[[[NSUserDefaults standardUserDefaults] objectForKey:@"_idUtente"] intValue] delegate:self];
    }
    else if([alertView.title isEqualToString:@"Connessione assente"] && buttonIndex == 1){
       // [self recordTransaction:lastTransaction];
    }
}


#pragma mark - Metodi delegati per l'acquisto

- (void)recordTransaction:(SKPaymentTransaction *)transaction {            
    //ricevuta da inviare al server
    //transaction.transactionReceipt.data
    
    NSLog(@"record transaction invocato");
    
    //se arrivato fin qui vuol dire che transaction è andata a buon fine, quindi notifico
    NSLog(@"record transaction -> lancio notifica purchased");
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:transaction];
    
    //NSLog(@"iapHelper userId = %d, transId = %@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"_idUtente"] intValue],transaction.transactionIdentifier);
    
    if([Utilita networkReachable]){
        //invio su db ricevuta e dati utente
        NSLog(@"record transaction -> lancio notifica downloading");
        [[NSNotificationCenter defaultCenter] postNotificationName:kCardDownloading object:nil];
        
        [PDHTTPAccess sendReceipt:transaction.transactionReceipt userId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"_idUtente"] intValue] transactionId:transaction.transactionIdentifier udid:[[UIDevice currentDevice] uniqueIdentifier] delegate:self];
    }
    else{
#warning alert per errore rete e per riprovare a fare la scrittura sul db
        NSLog(@"connessione assente");
        lastTransaction = transaction;
        
        //alert da mostrare in interfaccia acquisto
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Connessione assente, premi Riprova per completare l'acquisto"  delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"Riprova", nil]autorelease];
        [alert show];
    }
}

- (void)provideContent:(NSString *)productIdentifier {
    
//    NSLog(@"Toggling flag for: %@", productIdentifier);
//    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [_purchasedProducts addObject:productIdentifier];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:productIdentifier];
//    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    //NSLog(@"completeTransaction id = %@, receipt = %@, state = %d...", transaction.transactionIdentifier, transaction.transactionReceipt,transaction.transactionState);
    
    NSLog(@"completeTransaction...");
    
    //se interrotto a questo punto, la transazione viene recuperata all'avvio dell'app e viene chiesta la psw, dopo di che viene richiamato [self recordTransaction:] e quindi la chiamata al db ecc ---> GESTIRE STA COSA
    //IDEA: A questo punto mostrare un avviso tipo: "acquisto effettuato, a breve riceverai la carta" e intanto scaricare in background la tessera dal nostro server. Salvare qualcosa che indichi il fatto che la TRANSAZIONE è andata a buon fine: se durante il download c'è qlc errore poi da qualche interfaccia (cardsViewController?) reperire questo tipo di stato e fare in modo di recuperare l'acquisto fatto, ovvero la carta x2.
        
    [self recordTransaction: transaction];
    //[self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"restoreTransaction...");
        
    //[self recordTransaction: transaction];
    //[self provideContent: transaction.originalTransaction.payment.productIdentifier];
    //[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
        NSLog(@"transaction error 2: %@",transaction.error);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)buyProductIdentifier:(SKProduct*)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)dealloc {
    [_productIdentifiers release];
    _productIdentifiers = nil;
    [_products release];
    _products = nil;
//    [_purchasedProducts release];
//    _purchasedProducts = nil;
    [_request release];
    _request = nil;
    [super dealloc];
}
@end

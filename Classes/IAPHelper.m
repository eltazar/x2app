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
#import "UIDevice+IdentifierAddition.h"

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
 
    if([jsonDict objectForKey:@"Bought_card"]){
        
        //oggetto ricevuto, quindi transazione finita
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"error_purchase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[SKPaymentQueue defaultQueue] finishTransaction: lastTransaction];
        
        NSLog(@"buyed_Card -> lancio notifica downloaded");
        [[NSNotificationCenter defaultCenter] postNotificationName:kCardDownloaded object:[jsonDict objectForKey:@"Bought_card"]];
    }
    else if([jsonDict objectForKey:@"Bought_existing_card"]){ //--> deve diventare tipo idtrans_record_esistente
        
        //oggetto ricevuto, quindi transazione finita
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"error_purchase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[SKPaymentQueue defaultQueue] finishTransaction: lastTransaction];
        NSLog(@"buyed_existing_card -> lancio notifica downloaded");
        [[NSNotificationCenter defaultCenter] postNotificationName:kCardDownloaded object:[jsonDict objectForKey:@"Bought_existing_card"]];
    }
    else if([jsonDict objectForKey:@"Receipt_error"]){
        
        //reicevuta non valida, quindi transazione finita
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"error_purchase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[SKPaymentQueue defaultQueue] finishTransaction: lastTransaction];
        NSLog(@"ricevuta acquisto non valida");
        
    }
    
    
    //debug
    
    if([jsonDict objectForKey:@"Buyed_card_error"]){
        //[[SKPaymentQueue defaultQueue] finishTransaction: lastTransaction];
        //NSLog(@"errore scrittura carta su db");
    }
    
   static int i = 1;
    if( i ==1 ){
        //[self didReceiveError:nil];
        i++;
    }
    
    
}


-(void)didReceiveError:(NSError *)error{
    
    //di fatto non  so se la scrittura sul db è avvenuta e quindi manca solo il ritorno dei dati dal server, o se magari proprio la richiesta di scrittura non è arrivata al server. cmq la transaction non è rimossa dalla queue in questo caso
    
    //se ricevo errore
    //mostro pulsante recupera in cardsViewController e blocco lo store
    //NO : riprovare tipo 3 volte a scaricare la carta, magari con un avviso e un pulsante "riprova" per rifare la query che mi deve ritornare la carta x2 acquistata dalla transaction -> quindi in teoria ripassare l'id utente e l'id della transaction e recuperare dal db il relativo record
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCardServerError object:nil];
    
    NSLog(@"DEBUG ERRORE  SERVER");
    
    //salvo il fatto che c'è stato un errore e quindi la transazione non è finita
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"error_purchase"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Errore connessione" message:@"Errore di connessione, premi Ricarica per recuperare l'acquisto effettuato"  delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"Ricarica", nil]autorelease];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     
    if([alertView.title isEqualToString:@"Errore connessione"] && buttonIndex == 0){
        //premuto annulla
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCardServerError object:nil];        
    }
    else if([alertView.title isEqualToString:@"Errore connessione"] && buttonIndex == 1){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCardDownloading object:nil];
        
        //se c'è stato un errore server, faccio ripartire la procedura per scrivere sul db  la transaction: se già presente ritorna la carta, altrimenti verifica la ricevuta, crea la carta, scrive sul db e ritorna la carta
        [self recordTransaction:lastTransaction];
    }
}


#pragma mark - Metodi delegati per l'acquisto

- (void)recordTransaction:(SKPaymentTransaction *)transaction {            
    
    NSLog(@"record transaction invocato");
    
    //salvo la transaction attuale
    lastTransaction = transaction;
    
    //se arrivato fin qui vuol dire che transaction è andata a buon fine, quindi notifico
    NSLog(@"record transaction -> lancio notifica purchased");
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:transaction];
    
    NSLog(@"iapHelper userId = %d, transId = %@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"_idUtente"] intValue],transaction.transactionIdentifier);
    
    if([Utilita networkReachable]){
        //invio su db ricevuta e dati utente
        NSLog(@"record transaction -> lancio notifica downloading");
        [[NSNotificationCenter defaultCenter] postNotificationName:kCardDownloading object:nil];

        //invio l'id dell'utente che si è loggato e ha confermato l'acquisto, così da evitare che in seguito a un logout-login da qualche altra interfaccia con un eventuale utente diverso, venga associato l'acquisto ad un utente sbagliato
        [PDHTTPAccess sendReceipt:transaction.transactionReceipt userId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"originalUserId"] intValue] transactionId:transaction.transactionIdentifier udid:[[UIDevice currentDevice] uniqueDeviceIdentifier] delegate:self];
        
        
        //debug
        /*
        static int i = 0;
        if(i > 0){
            [PDHTTPAccess sendReceipt:transaction.transactionReceipt userId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"_idUtente"] intValue] transactionId:transaction.transactionIdentifier udid:[[UIDevice currentDevice] uniqueIdentifier] delegate:self];
            
        }else{
            //debug
            [self didReceiveError:nil];
            i++;
        }
        */
    }
    else{
        NSLog(@"connessione assente");
        //stessa funzione dell'altro alert
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Errore connessione" message:@"Errore di connessione, premi Ricarica per recuperare l'acquisto effettuato"  delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"Ricarica", nil]autorelease];
        [alert show];
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    //NSLog(@"completeTransaction id = %@, receipt = %@, state = %d...", transaction.transactionIdentifier, transaction.transactionReceipt,transaction.transactionState);
    
    NSLog(@"completeTransaction...");
    
    
    //se interrotto a questo punto, la transazione viene recuperata all'avvio dell'app e viene chiesta la psw, dopo di che viene richiamato [self recordTransaction:] e quindi la chiamata al db ecc ---> GESTIRE STA COSA
    //IDEA: A questo punto mostrare un avviso tipo: "acquisto effettuato, a breve riceverai la carta" e intanto scaricare in background la tessera dal nostro server. Salvare qualcosa che indichi il fatto che la TRANSAZIONE è andata a buon fine: se durante il download c'è qlc errore poi da qualche interfaccia (cardsViewController?) reperire questo tipo di stato e fare in modo di recuperare l'acquisto fatto, ovvero la carta x2.
        
    [self recordTransaction: transaction];
    //[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"restoreTransaction...");
        
    [self recordTransaction: transaction];
   // [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
        NSLog(@"transaction error 2: %@",transaction.error);
    }

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"error_purchase"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"payment queue");
    
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
    
    //di default setto come acquisto fallito
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"error_purchase"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}


- (void)dealloc {

    [lastTransaction release];
    
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

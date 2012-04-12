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
    
    NSLog(@"RISPOSTA PER LA RECEIPT = %@", jsonDict);
    //riceve carta perdue se tutto è stato verificato
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:data];
}


-(void)didReceiveError:(NSError *)error{
    
    //se ricevo errore
    //mostro pulsante recupera in cardsViewController e blocco lo store
}


#pragma mark - Metodi delegati per l'acquisto

- (void)recordTransaction:(SKPaymentTransaction *)transaction {            
    //ricevuta da inviare al server
    //transaction.transactionReceipt.data
    
    NSLog(@"iapHelper userId = %d, transId = %@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"_idUtente"] intValue],transaction.transactionIdentifier);
    
    if([Utilita networkReachable]){
        [PDHTTPAccess sendReceipt:transaction.transactionReceipt userId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"_idUtente"] intValue] transactionId:transaction.transactionIdentifier udid:[[UIDevice currentDevice] uniqueIdentifier] delegate:self];
    }
    else{
#warning alert per errore rete
        NSLog(@"connessione assente");
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
    
    [self recordTransaction: transaction];
    //[self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"restoreTransaction...");
    
    [self recordTransaction: transaction];
    //[self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
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

- (void)dealloc
{
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

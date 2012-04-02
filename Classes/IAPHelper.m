//
//  IAPHelper.m
//  PerDueCItyCard
//
//  Created by mario greco on 21/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IAPHelper.h"

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
        dbAccess = [[DatabaseAccess alloc] init];
        dbAccess.delegate = self;
        transactions = [NSMutableArray alloc] init];
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
    self.request = nil;    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];    
}

#pragma mark - DatabaseAccessDelegate

-(void)didReceiveResponsFromServer:(NSString *)receivedData{

    //riceve carta perdue se tutto è stato verificato
    
    //recupero e completo la transazione
    for (SKPaymentTransaction *t in transactions){
        if (/*transIdRicevuto == t.transactionIdentifier*/ 1==1) {
            //[[SKPaymentQueue defaultQueue] finishTransaction: t];
        }
    }    
    
    //aggiungo la carta ricevuta
    //notifica inviata a cardsViewController -> che aggiorna il model
}

-(void)didReceiveError:(NSError *)error{
    
    //se ricevo errore
    //mostro pulsante recupera in cardsViewController e blocco lo store
}


#pragma mark - Metodi delegati per l'acquisto

- (void)recordTransaction:(SKPaymentTransaction *)transaction {    
    // Optional: Record the transaction on the server side... 
    
    //aggiungo la transaction all'array per poterla recuperare succesivamente
    [transactions addObject:transaction];
    
    //ricevuta da inviare al server
    //transaction.transactionReceipt.data
    //[dbAccess sendReceipt:transaction.transactionReceipt.data transactionId:transactionId ];
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
    
    NSLog(@"completeTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    //[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"restoreTransaction...");
    
    [self recordTransaction: transaction];
    //[self provideContent: transaction.originalTransaction.payment.productIdentifier];
    //[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
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
    dbAccess.delegate = nil;
    [dbAccess release];
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

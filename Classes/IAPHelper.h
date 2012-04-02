//
//  IAPHelper.h
//  PerDueCItyCard
//
//  Created by mario greco on 21/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"
#import "DatabaseAccess.h"

//notifica per caricamento listino
#define kProductsLoadedNotification         @"ProductsLoaded"
//notifiche per acquisto
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver, DatabaseAccessDelegate> {
    NSSet * _productIdentifiers;    
    NSArray * _products;
//    NSMutableSet * _purchasedProducts;
    SKProductsRequest * _request;
    DatabaseAccess *dbAccess;
    
    NSMutableArray *transactions;
    
}

@property (retain) NSSet *productIdentifiers;
@property (retain) NSArray * products;
//@property (retain) NSMutableSet *purchasedProducts;
@property (retain) SKProductsRequest *request;

- (void)requestProducts;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
+ (IAPHelper *) sharedHelper;
//metodo per far partire l'acquisto
- (void)buyProductIdentifier:(SKProduct *)product;

@end
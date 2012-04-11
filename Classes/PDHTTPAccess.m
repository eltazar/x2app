//
//  PDHTTPAccess.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDHTTPAccess.h"
#import "UIDevice+IdentifierAddition.h"
#import "NSString+Base64Addition.h"



@implementation PDHTTPAccess


+ (void)sendReceipt:(NSData *)receipt userId:(NSInteger)userId transactionId:(NSString *)transactionId udid:(NSString *)udid delegate:(id<WMHTTPAccessDelegate>)delegate {
    // TODO: togliere udid dai parametri?
    NSLog(@"DBACCESS sendReceipt");
    
    NSString *urlString = @"https://cartaperdue.it/partner/v2.0/InAppPurchase.php";

    NSString *receiptString = [NSString base64StringFromData:receipt length:[receipt length]];
    NSString *userIdString  = [NSString stringWithFormat:@"%d", userId];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              receiptString, @"receipt",
                              userIdString, @"userId",
                              transactionId, @"transactionId",
                              udid, @"udid",
                              nil];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];    
}


+ (void)sendValidateRequest:(CartaPerDue*)card companyID:(NSInteger)companyID delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSLog(@"DBACCESS validate request");
    
    NSString *urlString = @"https://cartaperdue.it/partner/app_esercenti/notify.php";
    
    NSString *companyIDString = [NSString stringWithFormat:@"%d", companyID];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              card.name, @"name",
                              card.surname, @"surname",
                              card.number, @"number",
                              companyIDString, @"companyID",
                              nil];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];    
}



+ (void)registerUserOnServer:(NSArray*)userData delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSLog(@"DBACCESS REGISTER  --> user = %@", userData);
    
    NSString *urlString = @"https://cartaperdue.it/coupon/registrazione_utente_app_exe.jsp";
    
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [userData objectAtIndex:0], @"mail",
                              [userData objectAtIndex:1], @"telefono",
                              [userData objectAtIndex:2], @"nome",
                              [userData objectAtIndex:3], @"cognome",
                              nil];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}


+ (void)checkUserFields:(NSArray*)usr delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSLog(@"DBACCESS CHECK  EMAIL --> user = %@",usr);
    
    NSString *urlString = @"";
    NSDictionary *postDict = nil;
    
    if (usr.count == 1) {
        urlString = @"https://cartaperdue.it/partner/checkEmail.php";
        postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    [usr objectAtIndex:0], @"usr", nil];
    }
    else if (usr.count == 2) {
        urlString = @"https://cartaperdue.it/partner/login.php";
        postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    [usr objectAtIndex:0], @"usr",
                    [usr objectAtIndex:1], @"psw",
                    nil];
    }
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}


+ (void)sendRetrievePswForUser:(NSString*)usr delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSLog(@"DBACCESS RECUPERA PASSWORD");
    
    NSString *urlString = @"http://www.cartaperdue.it/partner/recuperaPsw.php";
    
    NSDictionary *postDict =[NSDictionary dictionaryWithObjectsAndKeys:
                             usr, @"usr",
                             nil];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}


+ (void)buyCouponRequest:(NSString*)string delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSString *urlString = @"https://cartaperdue.it/partner/acquistoCoupon.php";
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithCapacity:10];
    NSArray *pairs = [string componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        [postDict setObject:[keyValue objectAtIndex:1] forKey:[keyValue objectAtIndex:0]];
    }
    NSLog(@"[%@ buyCouponRequest] string = [%@], \n\tpostDict = %@", [self class], string, postDict);
    
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}


+ (void)getAltreOfferteFromServer:(NSString*)prov delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSLog(@"QUERY: altre offerte");
    
    NSString *urlString = [NSString stringWithFormat: @"http://www.cartaperdue.it/partner/altreofferte.php?prov=%@", prov];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodGET parameters:nil delegate:delegate];
}


+ (void)getIAPCatalogWithDelegate:(id<WMHTTPAccessDelegate>)delegate {
    NSString *urlString = @"http://www.cartaperdue.it/partner/catalogoIAP.php";
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodGET parameters:nil delegate:delegate];
}


+ (void)getCouponFromServerWithId:(NSInteger)idCoupon delegate:(id<WMHTTPAccessDelegate>) delegate {
    NSLog(@"QUERY PER COUPON CON ID");
    
	NSString *urlString = [NSString stringWithFormat: @"http://www.cartaperdue.it/partner/offerta2.php?id=%d", idCoupon];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodGET parameters:nil delegate:delegate];
}

+ (void)getCouponFromServer:(NSString*)prov delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSLog(@"QUERY PER COUPON");
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.cartaperdue.it/partner/coupon2.php?prov=%@",prov];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodGET parameters:nil delegate:delegate];
}


+ (void)checkCardExistence:(CartaPerDue *)card delegate:(id<WMHTTPAccessDelegate>)delegate {
    // Inizializzazione della URLRequest
    NSLog(@"DatabaseAccess::checkCardExistence");
    NSString *urlString = @"http://www.cartaperdue.it/partner/Card.php";

    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              card.name, @"name",
                              card.surname, @"surname",
                              card.number, @"number",
                              @"blah", @"expiration",
                              nil];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}


+ (void)retrieveCardFromServer:(NSInteger)userId delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSLog(@"DBACCESS retriveCard");
    NSString *urlString = @"https://cartaperdue.it/partner/v2.0/RecuperaCartaOnline.php";
        
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%d", userId], @"userId",
                              nil];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
       
}


+ (void)cardDeviceAssociation:(NSString *)cardNumber request:(NSString *)r delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSLog(@"DatabaseAccess::checkCardExistence [%@][%@]", r, cardNumber);
    NSString *urlString = @"http://www.cartaperdue.it/partner/CardDeviceAssociation.php";
    
    NSString *udid = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              r, @"request",
                              cardNumber, @"card_number",
                              udid, @"device_udid",
                              nil];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}


@end








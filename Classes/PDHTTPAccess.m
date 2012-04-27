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

+ (void)requestACard:(NSArray*)data delegate:(id<WMHTTPAccessDelegate>)delegate {
    
    NSString *urlString = @"https://cartaperdue.it/partner/v2.0/RichiediCarta.php";
    
    
    NSDictionary *postDict =[NSDictionary dictionaryWithObjectsAndKeys:
                             [data objectAtIndex:0], @"cardType",
                             [data objectAtIndex:1], @"name",
                             [data objectAtIndex:2], @"surname",
                             [data objectAtIndex:3], @"phone",
                             [data objectAtIndex:4], @"email",
                             nil];
    
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}


+ (void)getAltreOfferteFromServer:(NSString*)prov delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSLog(@"QUERY: altre offerte");
    
    NSString *urlString = [NSString stringWithFormat: @"http://www.cartaperdue.it/partner/altreofferte.php?prov=%@", prov];
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




@end








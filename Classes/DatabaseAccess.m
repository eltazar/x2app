 //
//  DatabaseAccess.m
//  jobFinder
//
//  Created by mario greco on 25/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatabaseAccess.h"
#import "NSDictionary_JSONExtensions.h"
#import "CJSONDeserializer.h"

@interface NSString (NSStringAdditions)
+ (NSString *)base64StringFromData:(NSData *)data length:(int)length;
@end

@implementation DatabaseAccess
@synthesize delegate;


#warning sistemare questa classe
// cercare di riciclare il codice invece di duplicare sempre le stesse istruzioni

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        //connectionDictionary = [[NSMutableDictionary alloc] init];
        dataDictionary = [[NSMutableDictionary alloc] init];
        readConnections = [[NSMutableArray alloc]init];
        writeConnections = [[NSMutableArray alloc]init];
    }
    
    return self;
}

NSString* key(NSURLConnection* con)
{
    return [NSString stringWithFormat:@"%p",con];
}

//[dbAccess sendReceipt:transaction.transactionReceipt.data transactionId:transactionId ];

- (void)sendReceipt:(NSData *)receipt userId:(NSInteger)userId transactionId:(NSString *)transactionId udid:(NSString *)udid {
    // TODO: togliere udid dai parametri?
    NSLog(@"DBACCESS sendReceipt");
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://cartaperdue.it/partner/v2.0/InAppPurchase.php"];
    
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSURL *url = [NSURL URLWithString:urlString]; 
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *postFormatString = @"receipt=%@&userId=%d&transactionId=%@&udid=%@";
    NSString *postString = [NSString stringWithFormat:postFormatString, [NSString base64StringFromData:receipt length:[receipt length]], userId, transactionId, udid];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];  
    
    
    
    if(connection){
        //NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [readConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }
    
}


-(void)sendValidateRequest:(CartaPerDue*)card companyID:(NSInteger)companyID{
    NSLog(@"DBACCESS validate request");
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://cartaperdue.it/partner/app_esercenti/notify.php"];
    
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *postFormatString = @"name=%@&surname=%@&number=%@&companyID=%d";
    NSString *postString = [NSString stringWithFormat:postFormatString, card.name,card.surname,card.number,companyID];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];  
    
    
    
    if(connection){
        //NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [writeConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }

}


- (void)getConnectionToURL:(NSString *)urlString {
    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Lancio della connessione
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    
    // Accodamento della connessione e impostazione del buffer in cui ricevere i dati
    if(connection){
        NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        // TODO: Ri-approfondire lo scopo di st'oggetto, che lo ricordo solo vagamente
        [readConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }

}


- (void)postConnectionToURL:(NSString *)urlString withData:(NSString *)postString {
    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    // Ulteriori impostazioni della URLRequest
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    // Lancio della connessione
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    
    // Accodamento della connessione e impostazione del buffer in cui ricevere i dati
    if(connection){
        NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        // TODO: Ri-approfondire lo scopo di st'oggetto, che lo ricordo solo vagamente
        [readConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }
    
    
}


-(void)registerUserOnServer:(NSArray*)userData{
    
    [userData retain];
    NSLog(@"DBACCESS REGISTER  --> user = %@",userData);
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://cartaperdue.it/coupon/registrazione_utente_app_exe.jsp"];
    
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *postFormatString = @"mail=%@&telefono=%@&nome=%@&cognome=%@";
    NSString *postString = [NSString stringWithFormat:postFormatString, [userData objectAtIndex:0],[userData objectAtIndex:1],[userData objectAtIndex:2],[userData objectAtIndex:3]];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];  
    
    
    
    if(connection){
        //NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [writeConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }
  
    [userData release];
    
}


-(void)checkUserFields:(NSArray*)usr{
    
    NSLog(@"DBACCESS CHECK  EMAIL --> user = %@",usr);
    
    [usr retain];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@""];
    
    if(usr.count == 1)
        urlString = [NSMutableString stringWithFormat:@"https://cartaperdue.it/partner/checkEmail.php"];
    else if(usr.count == 2)
        urlString  = [NSMutableString stringWithFormat:@"https://cartaperdue.it/partner/login.php"];
    
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *postFormatString = @"";
    NSString *postString = @"";
    
    if(usr.count == 1){
        postFormatString = @"usr=%@";
        postString = [NSString stringWithFormat:postFormatString, [usr objectAtIndex:0]];
    }
    else if(usr.count == 2){
        postFormatString = @"usr=%@&psw=%@";
        postString = [NSString stringWithFormat:postFormatString, [usr objectAtIndex:0],[usr objectAtIndex:1]];
    }
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];    
    if(connection){
        //NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [readConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }
    
    [usr release];
}

-(void)sendRetrievePswForUser:(NSString*)usr{
    
    NSLog(@"DBACCESS RECUPERA PASSWORD");
    
    [usr retain];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.cartaperdue.it/partner/recuperaPsw.php"];
    
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *postFormatString = @"usr=%@";
    NSString *postString = [NSString stringWithFormat:postFormatString, usr];    

    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];    
    if(connection){
        //NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [writeConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }
    
    [usr release];
}




-(void)buyCouponRequest:(NSString*)string{
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://cartaperdue.it/partner/acquistoCoupon.php"];
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    
    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    NSData *postData = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
   [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    
    if(connection){
        //NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [writeConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }

}


-(void)getAltreOfferteFromServer:(NSString*)prov{
    
    NSLog(@"QUERY: altre offerte");
    
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/altreofferte.php?prov=%@",prov]]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    
    if(connection){
        //NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [readConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }
    
    
    
}

-(void)getCatalogIAP{
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/catalogoIAP.php"]]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    
    if(connection){
        //NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [readConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }

}


-(void)getCouponFromServerWithId:(NSInteger)idCoupon{
    NSLog(@"QUERY PER COUPON CON ID");
    
	//url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/coupon.php?prov=%@",prov]];   
    
    
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/offerta2.php?id=%d",idCoupon]]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    
    if(connection){
        //NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [readConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }

}

-(void)getCouponFromServer:(NSString*)prov{
	
    NSLog(@"QUERY PER COUPON");
    
	//url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/coupon.php?prov=%@",prov]];   
    
    
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/coupon2.php?prov=%@",prov]]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    
    if(connection){
        //NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [readConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }
    
    
}


- (void)checkCardExistence:(CartaPerDue *)card {
    // Inizializzazione della URLRequest
    NSLog(@"DatabaseAccess::checkCardExistence");
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.cartaperdue.it/partner/Card.php"];
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Costruzione POST
    NSString *postFormatString = @"name=%@&surname=%@&number=%@&expiration=blah";
    NSString *postString = [NSString stringWithFormat:postFormatString,
                            card.name, card.surname, card.number];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    // Ulteriori impostazioni della URLRequest
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    // Lancio della connessione
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    
    // Accodamento della connessione e impostazione del buffer in cui ricevere i dati
    if(connection){
        NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        // TODO: Ri-approfondire lo scopo di st'oggetto, che lo ricordo solo vagamente
        [readConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }

    
}



- (void)cardDeviceAssociation:(NSString *)cardNumber request:(NSString *)r {
    
    // Inizializzazione della URLRequest
    NSLog(@"DatabaseAccess::checkCardExistence [%@]", r);
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.cartaperdue.it/partner/CardDeviceAssociation.php"];
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Costruzione POST
    NSString *postFormatString = @"request=%@&card_number=%@&device_udid=%@";
    NSString *postString = [NSString stringWithFormat:postFormatString,
                            r,
                            cardNumber,
                            [[UIDevice currentDevice] uniqueDeviceIdentifier]];
                                
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    // Ulteriori impostazioni della URLRequest
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    // Lancio della connessione
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    
    // Accodamento della connessione e impostazione del buffer in cui ricevere i dati
    if(connection){
        //NSLog(@"IS CONNECTION TRUE");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        // TODO: Ri-approfondire lo scopo di st'oggetto, che lo ricordo solo vagamente
        [readConnections addObject:connection];
        
        NSMutableData *receivedData = [[NSMutableData data] retain];
        //[connectionDictionary setObject:connection forKey:key(connection)];
        [dataDictionary setObject:receivedData forKey:key(connection)];
        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
    }
    else{
        NSLog(@"theConnection is NULL");
        //mostrare alert all'utente che la connessione è fallita??
    }
    
}


////invia richiesta registrazione token device sul db
//-(void)registerDevice:(NSString*)token typeRequest:(NSString*)type{
//    
//    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.sapienzaapps.it/jobfinder/registerDevice2.php"];
//
//    
//    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
//    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
//    
//    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
//    NSString *typeRequest = ((jobFinderAppDelegate*)[[UIApplication sharedApplication] delegate]).typeRequest;
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    
//    NSString *postFormatString = @"token=%@&latitude=%f&longitude=%f&fields=%@&type=%@";
//    NSString *postString = [NSString stringWithFormat:postFormatString,
//                            token,
//                            [[pref objectForKey:@"lat"] doubleValue],
//                            [[pref objectForKey:@"long"] doubleValue], 
//                            [Utilities createFieldsString],
//                            typeRequest
//                            ];
//
//    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
//    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
//    
//    [request setHTTPMethod:@"POST"];
//    
//    [request setHTTPBody:postData];
//    
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    if(connection){
//        //NSLog(@"IS CONNECTION TRUE");
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        
//        [writeConnections addObject:connection];
//        
//        NSMutableData *receivedData = [[NSMutableData data] retain];
//        //[connectionDictionary setObject:connection forKey:key(connection)];
//        [dataDictionary setObject:receivedData forKey:key(connection)];
//        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
//    }
//    else{
//        NSLog(@"theConnection is NULL");
//        //mostrare alert all'utente che la connessione è fallita??
//    }
//
//    
//    
//}
//
////invia richiesta lettura da db
//-(void)jobReadRequestOldRegion:(MKCoordinateRegion)oldRegion newRegion:(MKCoordinateRegion)newRegion field:(NSString*)field
//{    
//    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.sapienzaapps.it/jobfinder/read2.php"];
//    
//    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
//    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    NSString *postFormatString = @"oldLatitude=%f&oldLongitude=%f&oldLatSpan=%f&oldLongSpan=%f&newLatitude=%f&newLongitude=%f&newLatSpan=%f&newLongSpan=%f&field=%@";
//    NSString *postString = [NSString stringWithFormat:postFormatString,
//                            oldRegion.center.latitude,oldRegion.center.longitude,oldRegion.span.latitudeDelta,oldRegion.span.longitudeDelta,
//                                newRegion.center.latitude,newRegion.center.longitude,newRegion.span.latitudeDelta,newRegion.span.longitudeDelta,field];
//    
//    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
//    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
//    
//    [request setHTTPMethod:@"POST"];
//    
//    [request setHTTPBody:postData];
//    
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
//    
//    
//    if(connection){
//        //NSLog(@"IS CONNECTION TRUE");
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        
//        [readConnections addObject:connection];
//        
//        NSMutableData *receivedData = [[NSMutableData data] retain];
//        //[connectionDictionary setObject:connection forKey:key(connection)];
//        [dataDictionary setObject:receivedData forKey:key(connection)];
//        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
//    }
//    else{
//        NSLog(@"theConnection is NULL");
//        //mostrare alert all'utente che la connessione è fallita??
//    }
//}   
//
//-(void)jobReadRequest:(MKCoordinateRegion)region field:(NSString*)field
//{
//     //NSLog(@"DATABASE ACCESS FIELD 2 = %@",field);
//    
//    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.sapienzaapps.it/jobfinder/read.php"];
//    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
//    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    NSString *postFormatString = @"latitude=%f&longitude=%f&latSpan=%f&longSpan=%f&field=%@";
//    NSString *postString = [NSString stringWithFormat:postFormatString,
//                            region.center.latitude,region.center.longitude,region.span.latitudeDelta,region.span.longitudeDelta,field];
//    
//    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
//    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
//    
//    [request setHTTPMethod:@"POST"];
//    
//    [request setHTTPBody:postData];
//    
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
//    
//    if(connection){
//        //NSLog(@"IS CONNECTION TRUE");
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        
//        [readConnections addObject:connection];
//        
//        NSMutableData *receivedData = [[NSMutableData data] retain];
//        //[connectionDictionary setObject:connection forKey:key(connection)];
//        [dataDictionary setObject:receivedData forKey:key(connection)];
//        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
//    }
//    else{
//        NSLog(@"theConnection is NULL");
//        //mostrare alert all'utente che la connessione è fallita
//    }
//}   
//
//-(void)jobModRequest:(Job *)job
//{
//    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.sapienzaapps.it/jobfinder/edit.php"];    
//    //Replace Spaces with a '+' character.
//    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];  
//    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease]; //aggiunto autorelease
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    NSString *postFormatString = @"jobId=%d&time=%@&description=%@&phone=%@&phone2=%@&email=%@&url=%@&field=%@";
//    
//    NSMutableString *phoneTmp;
//    NSMutableString *phone2Tmp;
//    
//    if(![job.phone isEqualToString:@""] && [[job.phone substringWithRange:NSMakeRange(0,1)] isEqualToString:@"+"]){
//        phoneTmp = [NSMutableString stringWithFormat:@"%@",job.phone];
//        [phoneTmp setString:[phoneTmp stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]];
//    }
//    else{
//        phoneTmp = [NSMutableString stringWithFormat:@"%@",job.phone];
//    }
//    
//    if(![job.phone2 isEqualToString:@""] && [[job.phone2 substringWithRange:NSMakeRange(0,1)] isEqualToString:@"+"]){
//        phone2Tmp = [NSMutableString stringWithFormat:@"%@",job.phone2];
//        [phone2Tmp setString:[phone2Tmp stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]];
//    }
//    else{
//        phone2Tmp = [NSMutableString stringWithFormat:@"%@",job.phone2];
//    }
//    
//    NSString *postString = [NSString stringWithFormat:postFormatString,
//                            job.idDb,
//                            job.time,
//                            job.description,
//                            phoneTmp,
//                            phone2Tmp,
//                            job.email,
//                            job.urlAsString,
//                            job.code
//                            ];
//    
//    
//    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
//    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
//    
//    [request setHTTPMethod:@"POST"];
//    
//    [request setHTTPBody:postData];
//    
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    if(connection){
//        //NSLog(@"IS CONNECTION TRUE");
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        
//        [writeConnections addObject:connection];
//        
//        NSMutableData *receivedData = [[NSMutableData data] retain];
//        //[connectionDictionary setObject:connection forKey:key(connection)];
//        [dataDictionary setObject:receivedData forKey:key(connection)];
//        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
//    }
//    else{
//        NSLog(@"theConnection is NULL");
//        //mostrare alert all'utente che la connessione è fallita
//    }
//
//}
//
//-(void)jobDelRequest:(Job*)job
//{
//    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.sapienzaapps.it/jobfinder/delete.php"];    
//    //Replace Spaces with a '+' character.
//    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];  
//    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease]; //aggiunto autorelease
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    NSString *postFormatString = @"jobId=%d";
//    
//    NSString *postString = [NSString stringWithFormat:postFormatString,job.idDb];
//    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
//    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
//    
//    [request setHTTPMethod:@"POST"];
//    
//    [request setHTTPBody:postData];
//    
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    if(connection){
//        //NSLog(@"IS CONNECTION TRUE");
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        
//        [writeConnections addObject:connection];
//        
//        NSMutableData *receivedData = [[NSMutableData data] retain];
//        //[connectionDictionary setObject:connection forKey:key(connection)];
//        [dataDictionary setObject:receivedData forKey:key(connection)];
//        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
//    }
//    else{
//        NSLog(@"theConnection is NULL");
//        //mostrare alert all'utente che la connessione è fallita
//    }
//
//    
//}
//
//
////invia richiesta scrittura su db
//-(void)jobWriteRequest:(Job *)job
//{ 
//    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.sapienzaapps.it/jobfinder/write2.php"];    
//    //Replace Spaces with a '+' character.
//    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];  
//    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease]; //aggiunto autorelease
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    NSString *postFormatString = @"time=%@&description=%@&phone=%@&phone2=%@&email=%@&url=%@&date=%@&latitude=%f&longitude=%f&field=%@&user=%@";
//    
//    NSMutableString *phoneTmp;
//    NSMutableString *phone2Tmp;
//    
//    if(![job.phone isEqualToString:@""] && [[job.phone substringWithRange:NSMakeRange(0,1)] isEqualToString:@"+"]){
//        phoneTmp = [NSMutableString stringWithFormat:@"%@",job.phone];
//        [phoneTmp setString:[phoneTmp stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]];
//    }
//    else{
//        phoneTmp = [NSMutableString stringWithFormat:@"%@",job.phone];
//    }
//    
//    if(![job.phone2 isEqualToString:@""] && [[job.phone2 substringWithRange:NSMakeRange(0,1)] isEqualToString:@"+"]){
//        phone2Tmp = [NSMutableString stringWithFormat:@"%@",job.phone2];
//        [phone2Tmp setString:[phone2Tmp stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]];
//    }
//    else{
//        phone2Tmp = [NSMutableString stringWithFormat:@"%@",job.phone2];
//    }
//    
//    
//    NSString *postString = [NSString stringWithFormat:postFormatString,
//        job.time,
//        job.description,
//        phoneTmp,
//        phone2Tmp,
//        job.email,
//        job.urlAsString,
//        job.date,
//        job.coordinate.latitude,
//        job.coordinate.longitude,
//        job.code,
//        job.user
//    ];
//    
//    
//    NSLog(@"JOB WRITE PHONE = %@",job.phone);
//    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
//    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
//    
//    [request setHTTPMethod:@"POST"];
//  
//    [request setHTTPBody:postData];
//    
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    if(connection){
//        //NSLog(@"IS CONNECTION TRUE");
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//
//        [writeConnections addObject:connection];
//        
//        NSMutableData *receivedData = [[NSMutableData data] retain];
//        //[connectionDictionary setObject:connection forKey:key(connection)];
//        [dataDictionary setObject:receivedData forKey:key(connection)];
//        //NSLog(@"RECEIVED DATA FROM DICTIONARY : %p",[dataDictionary objectForKey:connection]);
//    }
//    else{
//        NSLog(@"theConnection is NULL");
//        //mostrare alert all'utente che la connessione è fallita
//    }
//}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"DID RECEIVE RESPONSE");
    
    NSMutableData *receivedData = [dataDictionary objectForKey:key(connection)];

    [receivedData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //sto log crea memory leak
    //NSLog(@"XXXX %@",[[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSASCIIStringEncoding]);
    NSMutableData *receivedData = [dataDictionary objectForKey:key(connection)];

    [receivedData appendData:data];
    //NSLog(@"RECEIVED DATA AFTER APPENDING %@",receivedData);
}

//If an error is encountered during the download, the delegate receives a connection:didFailWithError:
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSMutableData *receivedData = [dataDictionary objectForKey:key(connection)];
    [dataDictionary removeObjectForKey:key(connection)];
    
    [readConnections removeObject:connection];
    [writeConnections removeObject:connection];
    
    //esempio se richiedo connessione quando rete non disponibile, mostrare allert view?
    NSLog(@"ERROR with theConenction");
    
    if(delegate && [delegate respondsToSelector:@selector(didReceiveError:)])
        [delegate didReceiveError:error];
    
    [connection release];
    [receivedData release];
}

//if the connection succeeds in downloading the request, the delegate receives the connectionDidFinishLoading:
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSMutableData *receivedData = [dataDictionary objectForKey:key(connection)];

    //NSLog(@"DONE. Received Bytes: %d", [receivedData length]);
    NSString *json = [[NSString alloc] initWithBytes: [receivedData mutableBytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
    NSLog(@"JSON  %@", json);
    
    
    
    if([readConnections containsObject:connection]){
        //creo array di job
        NSError *theError = NULL;
        //NSArray *dictionary = [NSMutableDictionary dictionaryWithJSONString:json error:&theError];
       // NSLog(@"TIPO DEL DIZIONARIO %@",[dictionary class]);
       // NSLog(@"%@",dictionary);
      
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&theError] retain];
        
        if(dic){
            //NSLog(@"DIZIONARIO MARIO \n: %@",dic);
            if(delegate &&[delegate respondsToSelector:@selector(didReceiveCoupon:)])
                [delegate didReceiveCoupon:dic];
        }
        else if (delegate && [delegate respondsToSelector:@selector(didReceiveData:)]) {
            [delegate didReceiveData:receivedData];
        }
        
        if (theError) NSLog(@"DatabaseAccess, JSONError: reason[%@] desc[%@,%@]", [theError localizedFailureReason], [theError description], [theError localizedDescription]);
        
//        if(dictionary != nil){
//            NSMutableArray *jobsArray = [[NSMutableArray alloc]initWithCapacity:dictionary.count];
//        
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy-MM-dd"];
//            //    return [f dateFromString:dateString];
//            //NSLog(@"FORMATTER = %p",formatter);
//           for(int i=0; i < dictionary.count-1; i++){
//               NSDictionary *tempDict = [dictionary objectAtIndex:i];
//               CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[tempDict objectForKey:@"latitude"] doubleValue],[[tempDict objectForKey:@"longitude"] doubleValue]);        
//               Job *job = [[[Job alloc] initWithCoordinate:coordinate] autorelease]; //aggiunto 7 nov
//                           
//                //sistemare il tipo ritornato da field e da date
//               //job.employee = [Utilities sectorFromCode:[tempDict objectForKey:@"field"]];
//               job.time = [tempDict objectForKey:@"time"];
//               job.idDb = [[tempDict objectForKey:@"id"] integerValue];
//               job.code = [tempDict objectForKey:@"field"];
//               job.date = [formatter dateFromString: [tempDict objectForKey:@"date"]];
//               job.description = [tempDict objectForKey:@"description"];
//               job.address = @"";
//               job.phone = [tempDict objectForKey:@"phone"];
//               job.phone2 = [tempDict objectForKey:@"phone2"];
//               //NSLog(@"########### email = %@",[tempDict objectForKey:@"email"] );
//               job.email = [tempDict objectForKey:@"email"];
//               [job setUrlWithString:[tempDict objectForKey:@"url"]];
//               job.user = [tempDict objectForKey:@"user"];
//                
//                [jobsArray addObject:job];
//            }
//            
//            if(delegate != nil &&[delegate respondsToSelector:@selector(didReceiveJobList:)])
//                [delegate didReceiveJobList:jobsArray];
//            
//            [jobsArray release];
//            [formatter release];
//            formatter = nil;
//        }
        
        [readConnections removeObject:connection];
       
    }else{ 
        if(delegate && [delegate respondsToSelector:@selector(didReceiveResponsFromServer:)])
             [delegate didReceiveResponsFromServer:json];
        [writeConnections removeObject:connection];
    }
        //rilascio risorse, come spiegato sula documentazione apple
    [json release];
    
    [dataDictionary removeObjectForKey:key(connection)];
    
//    [readConnections removeObject:connection];
//    [writeConnections removeObject:connection];
    
    [connection release];
    [receivedData release];
}


-(void)dealloc
{
    [readConnections release];
    [writeConnections release];
    [dataDictionary release];
    [super dealloc];
}

@end











static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSString (NSStringAdditions)

+ (NSString *)base64StringFromData: (NSData *)data length: (int)length {
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length]; 
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0; 
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0) 
            break;        
        for (i = 0; i < 3; i++) { 
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1: 
                ctcopy = 2; 
                break;
            case 2: 
                ctcopy = 3; 
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }     
    return result;
}

@end

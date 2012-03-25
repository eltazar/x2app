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

-(void)registerUserOnServer:(NSArray*)userData{
    
    [userData retain];
    NSLog(@"DBACCESS REGISTER  --> user = %@",userData);
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.cartaperdue.it/partner/registra.php"];
    
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *postFormatString = @"nome=%@&cognome=%@&email=%@&telefono=%d";
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
        urlString = [NSMutableString stringWithFormat:@"http://www.cartaperdue.it/partner/checkEmail.php"];
    else if(usr.count == 2)
        urlString  = [NSMutableString stringWithFormat:@"http://www.cartaperdue.it/partner/login.php"];
    
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
    
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.cartaperdue.it/partner/recuperaPassword.php"];
    
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




-(void)buyCouponRequest:(NSString*)string{
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.cartaperdue.it/partner/provamario.php"];
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

-(void)getNewsFromServer:(int)indice{
    
    NSLog(@"QUERY: get news");
    
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner//news.php?from=%d&to=10",indice]]];
    
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
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.cartaperdue.it/partner/CardExists.php"];
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



- (void)checkThisDeviceAssociatedWithCard:(NSString *)cardNumber{
    
    // Inizializzazione della URLRequest
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.cartaperdue.it/partner/CardDeviceAssociation.php"];
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Costruzione POST
    NSString *postFormatString = @"card_number=%@&device_udid=%@";
    NSString *postString = [NSString stringWithFormat:postFormatString,
                            cardNumber,
                            [[UIDevice currentDevice] uniqueIdentifier]];
                                
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
    //NSLog(@"JSON  %@", json);
    
    
    
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

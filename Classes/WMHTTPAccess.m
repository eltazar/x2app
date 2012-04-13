//
//  WMHTTPAccess.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WMHTTPAccess.h"
#import "CJSONDeserializer.h"

NSString *_key(NSURLConnection *conn);

@interface WMHTTPAccess () 
@property (atomic, retain) NSMutableDictionary *connectionDict;
@property (atomic, retain) NSMutableDictionary *dataDict;
@property (atomic, retain) NSMutableDictionary *delegateDict;
- (void)tearDownTerminatedConnection:(NSURLConnection *)conn;
@end




@implementation WMHTTPAccess


@synthesize connectionDict=_connectionDict, dataDict=_dataDict, delegateDict=_delegateDict;


static WMHTTPAccess *__sharedInstance = nil;


+ (WMHTTPAccess *)sharedInstance {
    @synchronized([WMHTTPAccess class])	{
		if (!__sharedInstance)
			__sharedInstance = [[self alloc] init];
		return __sharedInstance;
	}
	return nil;
}


+ (id)alloc {
	@synchronized([WMHTTPAccess class])	{
		NSAssert(__sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		__sharedInstance = [super alloc];
		return __sharedInstance;
	}
	return nil;
}


- (id)init {
	self = [super init];
	if (self != nil) {
        self.connectionDict = [NSMutableDictionary dictionary];
        self.dataDict       = [NSMutableDictionary dictionary];
        self.delegateDict   = [NSMutableDictionary dictionary];
	}
	return self;
}


- (void)dealloc {
    // Ma il dealloc di un singleton viene mai richiamato? :/ Bah, nel dubbio, implementarlo male di sicuro non fa :P
    for (NSURLConnection *c in self.connectionDict) {
        [c cancel];
        [self tearDownTerminatedConnection:c];
    }
    self.connectionDict = nil;
    self.dataDict = nil;
    self.delegateDict = nil;
    [super dealloc];
}


#pragma mark - NSURLConnectionDelegate


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {    
    NSMutableData *receivedData = [self.dataDict objectForKey:_key(connection)];
    [receivedData setLength: 0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSMutableData *receivedData = [self.dataDict objectForKey:_key(connection)];
    [receivedData appendData:data];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"ERROR with the connection");
    id<WMHTTPAccessDelegate> delegate = [self.delegateDict objectForKey:_key(connection)];
    [delegate didReceiveError:error];
    
    [self tearDownTerminatedConnection:connection];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *k = _key(connection);
    NSMutableData *data                 = [self.dataDict     objectForKey:k];
    id<WMHTTPAccessDelegate> delegate   = [self.delegateDict objectForKey:k];
    
    //Debug:
    NSLog(@"Dal Server è arrivato: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
    
    if ([delegate respondsToSelector:@selector(didReceiveJSON:)]) {
        NSError *error = nil;
        NSDictionary *jsonDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:&error];
        if (error) {
            NSLog(@"JSONError: reason[%@] desc[%@]", 
                  [error localizedFailureReason], 
                  [error localizedDescription]);
        } else {
            [delegate didReceiveJSON:jsonDict];
        }
    }
    
    else if ([delegate respondsToSelector:@selector(didReceiveString:)]) {
        NSString *receivedString = [[[NSString alloc] initWithBytes:[data mutableBytes] 
                                                             length:[data length] 
                                                           encoding:NSUTF8StringEncoding
                                     ] autorelease];
        [delegate didReceiveString:receivedString];
    }
    
    else if ([delegate respondsToSelector:@selector(didReceiveData:)]) {
        [delegate didReceiveData:data];
    }
    
    [self tearDownTerminatedConnection:connection];
}


#pragma mark - WMHTTPAccess


- (void)startHTTPConnectionWithURL:(NSURL *)url method:(WMHTTPAccessConnectionMethod)method parameters:(NSDictionary *)parameters delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if (method == WMHTTPAccessConnectionMethodPOST) {
        NSMutableString *postString = [NSMutableString string];
        for (NSString *key in [parameters allKeys]) {
            [postString appendFormat:@"%@=%@&", key, [parameters objectForKey:key]];
        }
        if (postString.length > 0) {
            // Se abbiamo una postString, dobbiamo eliminare l'ampersand finale
            [postString deleteCharactersInRange:NSMakeRange(postString.length-1, 1)];
        }
        NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
        [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
    }

    NSURLConnection *conn = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (conn) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *k = _key(conn);
        NSData *data = [NSMutableData data]; 
        [self.connectionDict setObject:conn     forKey:k];
        [self.dataDict       setObject:data     forKey:k];
        [self.delegateDict   setObject:delegate forKey:k];
    }
    else {
        //TODO
    }
}


- (void)startHTTPConnectionWithURLString:(NSString *)urlString method:(WMHTTPAccessConnectionMethod)method parameters:(NSDictionary *)parameters delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSURL *url = [NSURL URLWithString:urlString];
    [self startHTTPConnectionWithURL:url method:method parameters:parameters delegate:delegate];
}


#pragma mark - WMHTTPAccess (metodi privati)
    

- (void)tearDownTerminatedConnection:(NSURLConnection *)conn {
    NSString *k = _key(conn);
    [self.connectionDict removeObjectForKey:k];
    [self.dataDict       removeObjectForKey:k];
    [self.delegateDict   removeObjectForKey:k];
    if ([self.connectionDict count] == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

@end


NSString *_key(NSURLConnection *conn) {
    return [NSString stringWithFormat:@"%p", conn];
}
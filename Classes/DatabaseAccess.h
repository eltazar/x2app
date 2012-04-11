//
//  DatabaseAccess.h
//  jobFinder
//
//  Created by mario greco on 25/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartaPerDue.h"

NSString* key(NSURLConnection* con);

@protocol DatabaseAccessDelegate;

@interface DatabaseAccess : NSObject <NSURLConnectionDelegate>{
    //NSMutableData *receivedData;
    id<DatabaseAccessDelegate> delegate;
    //NSMutableDictionary *connectionDictionary;
    NSMutableDictionary *dataDictionary;
    NSMutableArray *readConnections;
    NSMutableArray *writeConnections;
    
    NSMutableData *responseData;
    
}

@property(nonatomic,assign) id<DatabaseAccessDelegate> delegate;

- (void)getConnectionToURL:(NSString *)urlString;
- (void)postConnectionToURL:(NSString *)urlString withData:(NSString *)postString;
- (void)sendRetrievePswForUser:(NSString*)usr;
- (void)buyCouponRequest:(NSString*)string;
- (void)getCouponFromServerWithId:(NSInteger)idCoupon;
- (void)getCouponFromServer:(NSString*)prov;
- (void)getNewsFromServer:(int)indice;
- (void)getAltreOfferteFromServer:(NSString*)prov;

//metodi inapp purchase
- (void)sendReceipt:(NSData *)receipt userId:(NSInteger)userId transactionId:(NSString *)transactionId udid:(NSString *)udid;

//metodi per richiesta validtà tramite push
-(void)sendValidateRequest:(CartaPerDue*)card companyID:(NSInteger)companyID;

//metodi per login e registrazione
- (void)checkUserFields:(NSArray*)usr;
- (void)registerUserOnServer:(NSArray*)userData;

//metodi per in-app purchase
- (void)getCatalogIAP;

//metodi per controllo associazione carte
- (void)checkCardExistence:(CartaPerDue *)card;
- (void)cardDeviceAssociation:(NSString *)cardNumber request:(NSString *)r;

//-(void)jobDelRequest:(Job*)job;
//-(void)jobModRequest:(Job*)job;
//-(void)jobWriteRequest:(Job*)job;
//-(void)jobReadRequest:(MKCoordinateRegion)region field:(NSString*)field;
//-(void)jobReadRequestOldRegion:(MKCoordinateRegion)oldRegion newRegion:(MKCoordinateRegion)newRegion field:(NSString*)field;
//-(void)registerDevice:(NSString*)token typeRequest:(NSString*)type;

@end


@protocol DatabaseAccessDelegate <NSObject>
@optional
- (void)didReceiveResponsFromServer:(NSString *)receivedData;
@optional
- (void)didReceiveCoupon:(NSDictionary *)coupon;
@optional
- (void)didReceiveData:(NSMutableData *)data;
-(void)didReceiveError:(NSError*)error;
@end
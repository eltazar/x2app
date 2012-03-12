//
//  DatabaseAccess.h
//  jobFinder
//
//  Created by mario greco on 25/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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

-(void)getCouponFromServer:(NSString*)prov;
-(void)getNewsFromServer:(int)indice;

//-(void)jobDelRequest:(Job*)job;
//-(void)jobModRequest:(Job*)job;
//-(void)jobWriteRequest:(Job*)job;
//-(void)jobReadRequest:(MKCoordinateRegion)region field:(NSString*)field;
//-(void)jobReadRequestOldRegion:(MKCoordinateRegion)oldRegion newRegion:(MKCoordinateRegion)newRegion field:(NSString*)field;
//-(void)registerDevice:(NSString*)token typeRequest:(NSString*)type;

@end


@protocol DatabaseAccessDelegate <NSObject>
@optional
-(void)didReceiveResponsFromServer:(NSDictionary*) receivedData;
@optional
-(void)didReceiveCoupon:(NSDictionary*)coupon;
@end